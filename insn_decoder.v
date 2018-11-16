`default_nettype none


module insn_decoder #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst,

  input wire valid_i,
  output wire valid_o,
  input wire stall_i,
  output wire stall_o,

  input wire [LEN_INSN-1:0] insn,
  output wire [LEN_OPECODE-1:0] opecode_o,
  output wire [LEN_IMMF-1:0] immf_o,
  output wire [LEN_REGNO-1:0] rd_o,
  output wire [LEN_REGNO-1:0] rs_o,
  output wire [LEN_CC-1:0] cc_o,
  output wire [LEN_IMM_EX-1:0] imm_ex_o,
  output wire [LEN_REG-1:0] data_rd,
  output wire [LEN_REG-1:0] data_rs
);

  /* opecode */

  reg [LEN_OPECODE-1:0] opecode_reg;
  wire [LEN_OPECODE-1:0] opecode;
  assign opecode = insn[LEN_OPECODE + SHIFT_OPECODE - 1 : SHIFT_OPECODE];
  assign opecode_o = opecode_reg;

  /* registers */

  reg [LEN_REGNO-1:0] rd_reg, rs_reg;
  wire [LEN_REGNO-1:0] rd, rs;
  assign rd = insn[LEN_REGNO + SHIFT_RD - 1 : SHIFT_RD];
  assign rs = insn[LEN_REGNO + SHIFT_RS - 1 : SHIFT_RS];
  assign rd_o = rd_reg;
  assign rs_o = rs_reg;

  /* cc */

  reg [LEN_CC-1:0] cc_reg;
  wire [LEN_CC-1:0] cc;
  assign cc = insn[LEN_CC + SHIFT_CC - 1 : SHIFT_CC];
  assign cc_o = cc_reg;


  /* imm */

  reg [LEN_IMM_EX-1:0] imm_ex_reg;
  reg [LEN_IMMF-1:0] immf_reg;
  wire [LEN_IMM_EX-1:0] imm_ex;
  wire [LEN_IMMF-1:0] immf;
  assign immf = insn[LEN_IMMF + SHIFT_IMMF - 1 : SHIFT_IMMF];
  assign imm_ex_o = imm_ex_reg;
  assign immf_o = immf_reg;

  function [LEN_IMM_EX-1:0] imm_extend_sign;
    input [LEN_IMM-1:0] imm;
    imm_extend_sign = {{(LEN_IMM_EX - LEN_IMM){imm[LEN_IMM-1]}}, imm};
  endfunction

  function [LEN_IMM_EX-1:0] decode_imm;
    input [LEN_OPECODE-1:0] opecode;
    input [LEN_IMMF-1:0] immf;
    input [LEN_IMM-1:0] imm;
    if (immf == 1'b0) begin
      decode_imm = {LEN_IMM_EX{1'bx}};
    end else begin
      casex (opecode)
        7'b000_0xxx: decode_imm = imm_extend_sign(imm);
        7'b000_1xxx: decode_imm = {{(LEN_IMM_EX - 5){1'b0}}, imm[5-1:0]};
        7'b001_1xxx: decode_imm = imm_extend_sign(imm);
        default:     decode_imm = {{(LEN_IMM_EX - LEN_IMM){1'b0}}, imm};
      endcase
    end
  endfunction

  wire [LEN_IMM-1:0] imm;
  assign imm = insn[LEN_IMM + SHIFT_IMM - 1 : SHIFT_IMM];
  assign imm_ex = decode_imm(opecode, immf, imm);


  reg valid_reg;
  assign valid_o = valid_reg;
  assign stall_o = valid_reg & stall_i;

  always @(negedge rst) begin
    valid_reg <= 1'b0;
  end

  always @(posedge clk) begin
    if (~stall_i) begin
      valid_reg <= valid_i;
      opecode_reg <= opecode;
      rd_reg <= rd;
      rs_reg <= rs;
      cc_reg <= cc;
      imm_ex_reg <= imm_ex;
      immf_reg <= immf;
    end
  end

endmodule

`default_nettype wire
