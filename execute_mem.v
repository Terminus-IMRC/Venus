`default_nettype none


module execute_mem #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire [LEN_OPECODE-1:0] opecode,
  input wire [LEN_REG-1:0] data_rd,
  input wire [LEN_REG-1:0] data_rs,
  input wire [LEN_IMM_EX-1:0] imm_ex,
  output wire [LEN_REG-1:0] data_o
);

  wire mem_w = (opecode == OPECODE_ST) ? 1'b1 : 1'b0;;
  /* xxx: Negative addr is invalid. */
  wire [MEM_DATA_ADDR-1:0] mem_addr =
      ((opecode == OPECODE_LD) ? data_rs : data_rd) + imm_ex;

  memory_data mem (
    .clk(clk),
    .A(mem_addr),
    .W(mem_w),
    .D(data_rs),
    .Q(data_o)
  );

endmodule


`default_nettype wire
