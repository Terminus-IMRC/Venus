`default_nettype none
`timescale 1ns/100ps


module test #(
`include "defs_insn.v"
) ();
  parameter STEP = 10;

  reg clk;
  reg rst;
  reg [LEN_INSN-1:0] insn;
  wire [LEN_OPECODE-1:0] opecode_o;
  wire [LEN_IMMF-1:0] immf_o;
  wire [LEN_REGNO-1:0] rd_o;
  wire [LEN_REGNO-1:0] rs_o;
  wire [LEN_CC-1:0] cc_o;
  wire [LEN_IMM_EX-1:0] imm_o;

  insn_decoder uut (
    .clk(clk),
    .rst(rst),
    .insn(insn),
    .opecode_o(opecode_o),
    .immf_o(immf_o),
    .rd_o(rd_o),
    .rs_o(rs_o),
    .cc_o(cc_o),
    .imm_o(imm_o)
  );

  always begin
    #(STEP/2) clk = ~clk;
  end

  initial begin
    $display("-------------------------------");
    clk = 1'b0;
    rst = 1'b0;
    #(STEP * 2);
    rst = 1'b1;

    insn = 32'b_000_0010__0_0001_0010__0101_0101_0101_0101;
    #(STEP);
    insn = 32'b_000_0010__1_0001_0010__0101_0101_0101_0101;
    #(STEP);
    insn = 32'b_000_0010__1_0001_0010__1111_1111_1111_1111;
    #(STEP);
    insn = 32'b_000_1000__1_0001_0010__1111_1111_1111_1111;
    #(STEP);

    $finish;
  end

  always @(posedge clk) begin
    $display("opecode_o=0b%07b", opecode_o);
    $display("rd_o=0b%04b", rd_o);
    $display("rs_o=0b%04b", rs_o);
    $display("cc_o=0b%01b", cc_o);
    $display("immf_o=0b%01b", immf_o);
    $display("imm_o=0b%032b", imm_o);
    $display("-------------------------------");
  end

endmodule


`default_nettype none
