`default_nettype none


module insn_fetcher #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst,

  input wire valid_i,
  output wire valid_o,
  input wire stall_i,
  output wire stall_o,

  output wire [LEN_INSN-1:0] insn_o,
  input wire [MEM_INSN_ADDR-1:0] addr_i
);

  reg valid_reg;
  assign valid_o = valid_reg;
  assign stall_o = valid_reg & stall_i;

  reg [MEM_INSN_ADDR-1:0] addr_prev;
  wire [MEM_INSN_ADDR-1:0] addr = stall_i ? addr_prev : addr_i;

  memory_insn mem (
    .clk(clk),
    .A(addr),
    .Q(insn_o)
  );

  always @(negedge rst) begin
    valid_reg <= 1'b0;
    addr_prev <= {MEM_INSN_ADDR{1'bx}};
  end

  always @(posedge clk) begin
    if (~stall_i) begin
      valid_reg <= valid_i;
      addr_prev <= addr_i;
    end
  end

endmodule


`default_nettype wire
