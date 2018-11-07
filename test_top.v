`default_nettype none
`timescale 1ns/100ps


module test #(
`include "defs_insn.v"
) ();
  parameter STEP = 10;

  reg clk, rst;

  top uut (
    .clk(clk),
    .rst(rst)
  );

  always begin
    #(STEP/2) clk = ~clk;
  end

  initial begin
    clk = 1'b0;
    rst = 1'b0;
    #(STEP);
    rst = 1'b1;

    #(STEP*10);

    #(STEP);
    $finish;
  end

  always @(posedge clk) begin
    if (~rst) begin
      $display("Being reset...");
    end else begin
      $display("uut.insn = 0x%08x", uut.insn);
      $display("uut.insnfetch.addr = 0x%08x", uut.insnfetch.addr);
    end
    $display("-------------------------------");
  end

endmodule


`default_nettype none
