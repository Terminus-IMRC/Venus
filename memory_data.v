`default_nettype none


module memory_data #(
`include "defs_insn.v"
,
  parameter MEM_ADDR = MEM_DATA_ADDR,
  parameter MEM_LEN = MEM_DATA_LEN,
  parameter MEM_FILE = MEM_DATA_FILE
) (
  input wire clk,
  input wire [MEM_ADDR-1:0] A,
  input wire W,
  input wire [LEN_REG-1:0] D,
  input wire [LEN_REG-1:0] Q
);

  reg [LEN_REG-1:0] mem_bank [0:MEM_LEN];
  reg [LEN_REG-1:0] o_reg;

  assign Q = o_reg;

  always @(posedge clk) begin
    if (W == 1'b1) begin
      mem_bank[A] <= D;
    end else begin
      o_reg <= mem_bank[A];
    end
  end

  initial begin
    $readmemh(MEM_FILE, mem_bank);
  end

endmodule


`default_nettype wire
