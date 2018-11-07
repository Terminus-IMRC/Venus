`default_nettype none


module top #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst
);

  wire [LEN_INSN-1:0] insn;

  insn_fetcher insnfetch (
    .clk(clk),
    .rst(rst),
    .insn(insn)
  );

  wire [LEN_REG-1:0] wb_result, data_o, data_o_forward;
  wire [LEN_REGNO-1:0] rd_regno, rs_regno;

  wire [LEN_OPECODE-1:0] opecode;
  wire [LEN_IMMF-1:0] immf;
  wire [LEN_CC-1:0] cc;
  wire [LEN_REG-1:0] data_rd, data_rs;
  wire [LEN_IMM_EX-1:0] imm_ex;

  insn_decoder insndec (
    .clk(clk),
    .rst(rst),
    .insn(insn),
    .wb_result(wb_result),
    .opecode_o(opecode),
    .immf_o(immf),
    .rd_o(rd_regno),
    .rs_o(rs_regno),
    .cc_o(cc),
    .imm_o(imm_ex),
    .data_rd(data_rd),
    .data_rs(data_rs)
  );

  assign wb_result = (opecode == OPECODE_LD) ? data_o_forward : data_o;

  execute exec (
    .clk(clk),
    .rst(rst),
    .opecode(opecode),
    .immf(immf),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .cc(cc),
    .imm_ex(imm_ex),
    .data_o(data_o),
    .data_o_forward(data_o_forward)
  );


endmodule


`default_nettype wire
