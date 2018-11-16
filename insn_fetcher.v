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

  output wire [LEN_INSN-1:0] insn
);

  reg valid;
  reg [MEM_INSN_ADDR-1:0] addr;

  assign valid_o = valid;
  assign stall_o = valid & stall_i;

  memory_insn mem (
    .clk(clk),
    .A(addr),
    .Q(insn)
  );

  wire [MEM_INSN_ADDR-1:0] addr_next = addr + 1'b1;

  always @(negedge rst) begin
    valid <= 1'b0;
    addr <= {MEM_INSN_ADDR{1'b0}};
  end

  always @(posedge clk) begin
    if (~stall_i) begin
      valid <= valid_i;
      addr <= addr_next;
    end
  end

endmodule


`default_nettype wire
