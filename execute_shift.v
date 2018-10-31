`default_nettype none


module execute_shift #(
`include "defs_insn.v"
) (
  input wire [LEN_OPECODE-1:0] opecode,
  input wire [LEN_IMMF-1:0] immf,
  input wire [LEN_REG-1:0] data_rd,
  input wire [LEN_REG-1:0] data_rs,
  input wire [LEN_IMM_EX-1:0] imm_ex,
  output wire [LEN_REG-1:0] data_o
);

  wire [LEN_REG-1:0] in1;
  wire [4:0] in2;
  assign in1 = data_rd;
  assign in2 = (immf == 1'b0) ? data_rs[4:0] : imm_ex[4:0];

  function [LEN_REG-1:0] do_shift (
    input [LEN_OPECODE-1:0] opecode,
    input [LEN_REG-1:0] data,
    input [4:0] shift
  );
    if (opecode == OPECODE_SHL)
      do_shift = data << shift;
    else if (opecode == OPECODE_SHR)
      do_shift = data >> shift;
    else if (opecode == OPECODE_ASH) /* 阿修羅 */
      do_shift = data >>> shift;
    else
      do_shift = {LEN_REG{1'bx}};
    /* xxx: rol and ror */
  endfunction

  assign data_o = do_shift(opecode, in1, in2);

endmodule


`default_nettype wire
