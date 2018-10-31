`default_nettype none
`timescale 1ns/100ps


module test #(
`include "defs_insn.v"
) ();
  parameter STEP = 10;

  reg clk, rst;
  reg [LEN_OPECODE-1:0] opecode;
  reg [LEN_IMMF-1:0] immf;
  reg [LEN_REG-1:0] data_rd;
  reg [LEN_REG-1:0] data_rs;
  reg [LEN_CC-1:0] cc;
  reg [LEN_IMM_EX-1:0] imm_ex;
  wire [LEN_REG-1:0] data_o;
  wire [LEN_REG-1:0] data_o_forward;

  execute uut (
    .clk(clk),
    .rst(rst),
    .opecode(opecode),
    .immf(immf),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .cc(cc),
    .imm_ex(imm_ex),
    .data_o(data_o),
    .data_o_forward(data_o_forward)
  );

  always begin
    #(STEP/2) clk = ~clk;
  end

  initial begin
    clk = 1'b0;
    rst = 1'b0;
    #(STEP);
    rst = 1'b1;

    opecode = OPECODE_ADD;
    immf = 1'b0;
    data_rd = 32'h1234_0000;
    data_rs = 32'h0000_5678;
    imm_ex = 32'hxxxx_xxxx;
    #(STEP);

    opecode = OPECODE_SHL;
    immf = 1'b0;
    data_rd = 32'h0000_1234;
    data_rs = 32'h0000_0008;
    imm_ex = 32'hxxxx_xxxx;
    #(STEP);

    #(STEP);
    $finish;
  end

  always @(posedge clk) begin
    if (~rst) begin
      $display("Being reset...");
    end else begin
      $display("data_o = 0x%08x", data_o);
    end
    $display("-------------------------------");
  end

endmodule


`default_nettype none
