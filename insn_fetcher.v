`default_nettype none


module insn_fetcher #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst,
  output wire [LEN_INSN-1:0] insn
);

  reg [MEM_INSN_ADDR-1:0] addr;

  memory_insn mem (
    .clk(clk),
    .A(addr),
    .Q(insn)
  );

  wire [MEM_INSN_ADDR-1:0] addr_next = addr + 1'b1;

  always @(negedge rst) begin
    addr <= {MEM_INSN_ADDR{1'b0}};
  end

  always @(posedge clk) begin
    addr <= addr_next;
  end

endmodule


`default_nettype wire
