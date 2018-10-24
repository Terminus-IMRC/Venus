`default_nettype none
`timescale 1ns/100ps


module test #(
`include "defs_insn.v"
) ();
  parameter STEP = 10;

  reg clk;

  reg [LEN_OPECODE-1:0] opecode;
  reg immf;
  reg [LEN_REG-1:0] data_rd, data_rs, imm_ex;
  reg carry_i;
  wire [LEN_REG-1:0] data_o;
  wire carry_o;

  execute_add uut (
    .opecode(opecode),
    .immf(immf),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .imm_ex(imm_ex),
    .carry_i(carry_i),
    .data_o(data_o),
    .carry_o(carry_o)
  );

  always begin
    #(STEP/2) clk = ~clk;
  end

  initial begin
    clk = 1'b0;
    $display("-------------------------------");

    opecode = OPECODE_ADD;
    immf = 1'b0;
    data_rd = 32'h0000_0001;
    data_rs = 32'h0000_0003;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b0;
    #(STEP);
    opecode = OPECODE_SUB;
    immf = 1'b0;
    data_rd = 32'h0000_0003;
    data_rs = 32'h0000_0002;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b0;
    #(STEP);

    opecode = OPECODE_ADD;
    immf = 1'b0;
    data_rd = 32'hffff_ffff;
    data_rs = 32'h0000_0001;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b0;
    #(STEP);
    opecode = OPECODE_SUB;
    immf = 1'b0;
    data_rd = 32'h0000_0002;
    data_rs = 32'h0000_0003;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b0;
    #(STEP);

    opecode = OPECODE_ADC;
    immf = 1'b0;
    data_rd = 32'h0000_ffff;
    data_rs = 32'h0000_0001;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b0;
    #(STEP);
    opecode = OPECODE_SBC;
    immf = 1'b0;
    data_rd = 32'h0000_0003;
    data_rs = 32'h0000_0002;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b0;
    #(STEP);

    opecode = OPECODE_ADC;
    immf = 1'b0;
    data_rd = 32'h0000_ffff;
    data_rs = 32'h0000_0000;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b1;
    #(STEP);
    opecode = OPECODE_SBC;
    immf = 1'b0;
    data_rd = 32'h0000_0003;
    data_rs = 32'h0000_0002;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b1;
    #(STEP);

    opecode = OPECODE_ADC;
    immf = 1'b0;
    data_rd = 32'h0000_ffff;
    data_rs = 32'hffff_0000;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b1;
    #(STEP);
    opecode = OPECODE_SBC;
    immf = 1'b0;
    data_rd = 32'h0000_0003;
    data_rs = 32'h0000_0003;
    imm_ex = 32'hxxxx_xxxx;
    carry_i = 1'b1;
    #(STEP);

    $finish;
  end

  always @(posedge clk) begin
    $display("data_o = 0x%08x", data_o);
    $display("carry_o = %b", carry_o);
    $display("-------------------------------");
  end

endmodule


`default_nettype none
