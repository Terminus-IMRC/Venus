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

    #(STEP*8);

    #(STEP);
    $finish;
  end

  reg [31:0] step;
  wire [31:0] step_next = step + 1;
  always @(posedge clk) begin
    if (~rst) begin
      $display("Being reset...");
      step <= 32'b0;
    end else begin
      $display("step = %d", step);
      $display("insn = 0x%08x", uut.insn);
      $display("insnfetch.addr = 0x%08x", uut.insnfetch.addr);
      $display("stall_insnfetch = 0x%08x", uut.stall_insnfetch);
      $display("is_wb = 0x%x", uut.is_wb);
      $display("wb_reserved = 0x%x", uut.wb_reserved);
      $display("wb_regno = 0x%08x", uut.wb_regno);
      $display("register.rd_exp    = 0b%b", uut.register.rd_exp);
      $display("register.rs_exp    = 0b%b", uut.register.rs_exp);
      $display("register.wb_exp    = 0b%b", uut.register.wb_exp);
      $display("register.w_reserve = 0b%b", uut.register.w_reserve);
      $display("register.r1.w_reserve = 0b%b", uut.register.r1.w_reserve);
      $display("register.r1.data = 0x%x", uut.register.r1.w_reserve);
      $display("data_o = 0x%08x", uut.data_o);
      $display("register.r[0123].data = 0x%08x 0x%08x 0x%08x 0x%08x",
          uut.register.r0.data,
          uut.register.r1.data,
          uut.register.r2.data,
          uut.register.r3.data
      );
      step <= step_next;
    end
    $display("-------------------------------");
  end

endmodule


`default_nettype none
