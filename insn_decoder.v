`default_nettype none


module insn_decoder #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst,
  input wire [LEN_INSN-1:0] insn,
  output wire [LEN_OPECODE-1:0] opecode_o,
  output wire [LEN_IMMF-1:0] immf_o,
  output wire [LEN_REGNO-1:0] rd_o,
  output wire [LEN_REGNO-1:0] rs_o,
  output wire [LEN_CC-1:0] cc_o,
  output wire [LEN_IMM_EX-1:0] imm_o
);

  /* opecode */

  function [1:0] decode_opecode;
    input [LEN_OPECODE-1:0] opecode;
    case (opecode)
      7'b000_0000: decode_opecode = 1'b0;
      default: decode_opecode = 1'b1;
    endcase
  endfunction

  assign opecode_o = decode_opecode(
    insn[LEN_OPECODE + SHIFT_OPECODE - 1 : SHIFT_OPECODE]);


  /* registers */

  assign rd_o = insn[LEN_REGNO + SHIFT_RD - 1 : SHIFT_RD];
  assign rs_o = insn[LEN_REGNO + SHIFT_RS - 1 : SHIFT_RS];

  register_general register (
    .clk(clk),
    .rst(rst),
    .w_reserved_i(1'b0),
    .r0_i(rd_o),
    .r1_i(rs_o),
    .r_opr0_o(),
    .r_opr1_o(),
    .reserved_o(),
    .wb_i(1'b0),
    .wb_r_i(4'b0000),
    .result_i() /* Data*/
  );


  /* cc */

  assign cc_o = insn[LEN_CC + SHIFT_CC - 1 : SHIFT_CC];


  /* imm */

  assign immf_o = insn[LEN_IMMF + SHIFT_IMMF - 1 : SHIFT_IMMF];

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
  assign imm_o = decode_imm(opecode_o, immf_o, imm);


endmodule

`default_nettype wire
