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

    #(STEP*6);

    #(STEP);
    $finish;
  end

  always @(posedge clk) begin
    if (~rst) begin
      $display("Being reset...");
    end else begin
      $display("insn = 0x%08x", uut.insn);
      $display("insnfetch.addr = 0x%08x", uut.insnfetch.addr);
      $display("stall_insnfetch = 0x%08x", uut.stall_insnfetch);
      $display("wb_regno = 0x%08x", uut.wb_regno);
      $display("data_o = 0x%08x", uut.data_o);
      $display("register.r0.data = 0x%08x", uut.register.r0.data);
      $display("register.r1.data = 0x%08x", uut.register.r1.data);
      $display("register.r2.data = 0x%08x", uut.register.r2.data);
      $display("register.r3.data = 0x%08x", uut.register.r3.data);
    end
    $display("-------------------------------");
  end

endmodule


`default_nettype none
