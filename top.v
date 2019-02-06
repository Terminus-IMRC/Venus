`default_nettype none


module top #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst
);

  wire valid_insnfetch_insndec, valid_insndec_exec;
  wire stall_insnfetch;
  wire stall_insndec_insnfetch, stall_exec_insndec;

  wire [LEN_INSN-1:0] insn;
  wire wb_reserved;


  wire [LEN_OPECODE-1:0] opecode;
  wire [LEN_IMMF-1:0] immf;
  wire [LEN_CC-1:0] cc;
  wire [LEN_REG-1:0] data_rd, data_rs;
  wire [LEN_IMM_EX-1:0] imm_ex;
  wire [LEN_REGNO-1:0] rd_regno, rs_regno;

  wire [LEN_FLAGS-1:0] flags;


  reg [MEM_INSN_ADDR-1:0] iaddr_reg, iaddr_prev_reg;
  wire [MEM_INSN_ADDR-1:0] iaddr_next = iaddr_reg + 1'b1;
  wire [MEM_INSN_ADDR-1:0] iaddr_next_bra =
      (opecode == OPECODE_J) ? (iaddr_prev_reg + imm_ex) : imm_ex[LEN_IMM-1:0];
  wire is_taken_branch =
         (opecode == OPECODE_J || opecode == OPECODE_JA)
      && (flags & (1'b1 << cc));

  always @(negedge rst) begin
    iaddr_reg <= {MEM_INSN_ADDR{1'b0}};
    iaddr_prev_reg <= {MEM_INSN_ADDR{1'b0}};
  end

  always @(posedge clk) begin
    if (~stall_insnfetch) begin
      if (valid_insndec_exec && is_taken_branch) begin
        iaddr_reg <= iaddr_next_bra;
      end else begin
        iaddr_reg <= iaddr_next;
      end
      iaddr_prev_reg <= iaddr_reg;
    end
  end

  insn_fetcher insnfetch (
    .clk(clk),
    .rst(rst),
    .valid_i(valid_insndec_exec ? !is_taken_branch : 1'b1),
    .valid_o(valid_insnfetch_insndec),
    .stall_i(stall_insndec_insnfetch),
    .stall_o(stall_insnfetch),
    .insn_o(insn),
    .addr_i(iaddr_reg)
  );


  insn_decoder insndec (
    .clk(clk),
    .rst(rst),
    .valid_i(
        valid_insnfetch_insndec
        && (valid_insndec_exec ? !is_taken_branch : 1'b1)
    ),
    .valid_o(valid_insndec_exec),
    .stall_i(stall_exec_insndec | wb_reserved),
    .stall_o(stall_insndec_insnfetch),

    .insn(insn),
    .opecode_o(opecode),
    .immf_o(immf),
    .rd_o(rd_regno),
    .rs_o(rs_regno),
    .cc_o(cc),
    .imm_ex_o(imm_ex)
  );


  wire [LEN_REG-1:0] wb_data, data_o, data_o_forward;
  wire [LEN_REGNO-1:0] wb_regno, wb_regno_reserved;
  wire is_wb, do_wb;

  assign is_wb = !(
         (opecode == OPECODE_CMP)
      || (opecode == OPECODE_ST)
      || (opecode == OPECODE_J)
      || (opecode == OPECODE_JA)
      || (opecode == OPECODE_NOP)
      || (opecode == OPECODE_HLT)
  );


  register_general register (
    .clk(clk),
    .rst(rst),

    .rd_regno_i(rd_regno),
    .rs_regno_i(rs_regno),
    .rd_data_o(data_rd),
    .rs_data_o(data_rs),

    .do_wb(do_wb),
    /* XXX: This also means "this insn writes" I suspect. */
    .w_reserved_i(!stall_exec_insndec && valid_insndec_exec && is_wb),
    .wb_regno_i(wb_regno),
    .wb_data_i(wb_data),
    .reserved_o(wb_reserved)
  );


  execute exec (
    .clk(clk),
    .rst(rst),

    .valid_i(valid_insndec_exec && is_wb),
    .valid_o(),
    .stall_i(wb_reserved),
    .stall_o(stall_exec_insndec),

    .opecode(opecode),
    .immf(immf),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .cc(cc),
    .imm_ex(imm_ex),
    .data_o(data_o),
    .data_o_forward(data_o_forward),
    .flags_o(flags)
  );


  writeback wb (
    .clk(clk),
    .rst(rst),

    .valid_i(valid_insndec_exec),
    .valid_o(),
    .stall_i(wb_reserved),
    .stall_o(),

    .opecode(opecode),
    .rd_regno(rd_regno),
    .data_o(data_o),
    .data_o_forward(data_o_forward),
    .wb_regno(wb_regno),
    .wb_data(wb_data),
    .is_wb(is_wb),
    .do_wb(do_wb)
  );


endmodule


`default_nettype wire
