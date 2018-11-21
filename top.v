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

  insn_fetcher insnfetch (
    .clk(clk),
    .rst(rst),
    .valid_i(1'b1),
    .valid_o(valid_insnfetch_insndec),
    .stall_i(stall_insndec_insnfetch | wb_reserved),
    .stall_o(stall_insnfetch),
    .insn_o(insn),
    .wb_reserved(wb_reserved)
  );

  wire [LEN_OPECODE-1:0] opecode;
  wire [LEN_IMMF-1:0] immf;
  wire [LEN_CC-1:0] cc;
  wire [LEN_REG-1:0] data_rd, data_rs;
  wire [LEN_IMM_EX-1:0] imm_ex;
  wire [LEN_REGNO-1:0] rd_regno, rs_regno;

  wire is_wb;
  wire [LEN_REG-1:0] wb_data, data_o, data_o_forward;
  wire [LEN_REGNO-1:0] wb_regno;



  register_general register (
    .clk(clk),
    .rst(rst),
    .w_reserved_i(1'b1), /* xxx */
    .rd_regno_i(rd_regno),
    .rs_regno_i(rs_regno),
    .rd_data_o(data_rd),
    .rs_data_o(data_rs),
    .reserved_o(wb_reserved),
    .wb_i(is_wb),
    .wb_regno_i(wb_regno),
    .wb_data_i(wb_data)
  );


  insn_decoder insndec (
    .clk(clk),
    .rst(rst),

    .valid_i(valid_insnfetch_insndec),
    .valid_o(valid_insndec_exec),
    .stall_i(stall_exec_insndec),
    .stall_o(stall_insndec_insnfetch),

    .insn(insn),
    .opecode_o(opecode),
    .immf_o(immf),
    .rd_o(rd_regno),
    .rs_o(rs_regno),
    .cc_o(cc),
    .imm_ex_o(imm_ex),
    .data_rd(data_rd),
    .data_rs(data_rs)
  );


  execute exec (
    .clk(clk),
    .rst(rst),

    .valid_i(valid_insndec_exec),
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
    .data_o_forward(data_o_forward)
  );


  writeback wb (
    .clk(clk),
    .rst(rst),

    .opecode(opecode),
    .rd_regno(rd_regno),
    .data_o(data_o),
    .data_o_forward(data_o_forward),
    .is_wb(is_wb),
    .wb_regno(wb_regno),
    .wb_data(wb_data)
  );


endmodule


`default_nettype wire
