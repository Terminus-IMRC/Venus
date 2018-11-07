`default_nettype none


module memory_insn #(
`include "defs_insn.v"
,
  parameter MEM_ADDR = MEM_INSN_ADDR,
  parameter MEM_LEN = MEM_INSN_LEN,
  parameter MEM_FILE = MEM_INSN_FILE
) (
  input wire clk,
  input wire [MEM_ADDR-1:0] A,
  input wire [LEN_REG-1:0] Q
);

  reg [LEN_REG-1:0] mem_bank [0:MEM_LEN];
  reg [LEN_REG-1:0] o_reg;

  assign Q = o_reg;

  always @(posedge clk) begin
    o_reg <= mem_bank[A];
  end

  initial begin
    $readmemh(MEM_FILE, mem_bank);
  end

endmodule


`default_nettype wire
