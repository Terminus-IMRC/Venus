`default_nettype none


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
