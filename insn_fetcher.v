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

  input wire wb_reserved
);

  reg valid;

  reg [MEM_INSN_ADDR-1:0] addr_reg, addr_prev;
  wire [MEM_INSN_ADDR-1:0] addr, addr_next;
  assign addr_next = addr_reg + 1'b1;
  assign addr = stall_i ? addr_prev : addr_reg;

  wire [LEN_INSN-1:0] insn_cur;
  reg [LEN_INSN-1:0] insn_prev;
  assign insn_o = stall_i ? insn_prev : insn_cur;

  assign valid_o = valid;
  assign stall_o = valid & stall_i;

  memory_insn mem (
    .clk(clk),
    .A(addr),
    .Q(insn_cur)
  );

  always @(negedge rst) begin
    valid <= 1'b0;
    addr_reg  <= {MEM_INSN_ADDR{1'b0}};
    addr_prev <= {MEM_INSN_ADDR{1'b0}};
  end

  always @(posedge clk) begin
    if (~stall_i) begin
      valid <= valid_i;
      addr_reg <= addr_next;
      addr_prev <= addr_reg;
      insn_prev <= insn_cur;
    end
  end

endmodule


`default_nettype wire
