`default_nettype none

/*
 * -a = ~a + 1
 * a - b = a + ~b + 1
 * a - b - c = a + ~b + 1 - c
 *           = a + ~b + ~c for c = 0,1
 * abs(b) = b      if b[31] = 0
 *        = -b     if b[31] = 1
 *        = ~b + 1 if b[31] = 1
 *
 * | opcode          | in1 | in2 |  c |
 * +-----------------+-----+-----+----+
 * | add             |  rd |  rs |  0 |
 * | sub, cmp        |  rd | ~rs |  1 |
 * | abs (rd[31]==0) |   0 |  rs |  0 |
 * | abs (rd[31]==1) |   0 | ~rs |  1 |
 * | adc             |  rd |  rs |  c |
 * | sbc             |  rd | ~rs | ~c |
 */


module execute_add #(
`include "defs_insn.v"
) (
  input wire [LEN_OPECODE-1:0] opecode,
  input wire [LEN_IMMF-1:0] immf,
  input wire [LEN_REG-1:0] data_rd,
  input wire [LEN_REG-1:0] data_rs,
  input wire [LEN_IMM_EX-1:0] imm_ex,
  input wire carry_i,
  output wire [LEN_REG-1:0] data_o,
  output wire carry_o
);

  wire [LEN_REG-1:0] in1, in2;
  assign in1 = data_rd;
  assign in2 = (immf == 1'b0) ?
    ((opecode == OPECODE_SUB || opecode == OPECODE_SBC) ?  ~data_rs : data_rs)
    : imm_ex;

  function decide_carry (
    input [LEN_OPECODE-1:0] opecode,
    input carry
  );
    if (opecode == OPECODE_ADC)
      decide_carry = carry;
    else if (opecode == OPECODE_SUB)
      decide_carry = 1'b1; /* For complement */
    else if (opecode == OPECODE_SBC)
      decide_carry = ~carry;
    else
      decide_carry = 1'b0;
  endfunction

  wire c_i, c_o;
  assign c_i = decide_carry(opecode, carry_i);

  /* a's complement = ~a + 1 */
  assign {c_o, data_o} = in1 + in2 + c_i;

  assign carry_o = (opecode == OPECODE_SUB || opecode == OPECODE_SBC) ?
    ~c_o : c_o;

endmodule


`default_nettype wire
