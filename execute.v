`default_nettype none


module execute #(
`include "defs_insn.v"
) (
  input wire [LEN_OPECODE-1:0] opecode,
  input wire [LEN_IMMF-1:0] immf,
  input wire [LEN_REG-1:0] data_rd,
  input wire [LEN_REG-1:0] data_rs,
  input wire [LEN_CC-1:0] cc,
  input wire [LEN_IMM_EX-1:0] imm_ex,
  output wire [LEN_REG-1:0] data_o
);

  wire [LEN_REG-1:0] data_div, data_mul, data_shift, data_logic, data_add;

  reg carry;
  wire carry_i, carry_o;
  assign carry_i = carry;
  assign carry_o = carry;

  execute_shift exec_shift (
    .opecode(opecode),
    .immf(immf),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .imm_ex(imm_ex),
    .data_o(data_shift)
  );

  execute_add exec_add (
    .opecode(opecode),
    .immf(immf),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .imm_ex(imm_ex),
    .carry_i(carry_i),
    .data_o(data_add),
    .carry_o(carry_o)
  );

  function [LEN_REG-1:0] select_data (
    input [LEN_OPECODE-1:0] opecode,
    input [LEN_REG-1:0] data_div,
    input [LEN_REG-1:0] data_mul,
    input [LEN_REG-1:0] data_shift,
    input [LEN_REG-1:0] data_logic,
    input [LEN_REG-1:0] data_add
  );
    casex (opecode)
      7'b000_000x: select_data = data_add; /* add, sub */
      7'b000_0010: select_data = data_mul; /* mul */
      7'b000_0011: select_data = data_div; /* div */
      7'b000_01xx: select_data = data_add; /* cmp, abs, adc, sbc */
      7'b000_1xxx: select_data = data_shift; /* shl, shr, ash, rol, ror */
      7'b001_0xxx: select_data = data_logic; /* and, or, not, xor, setl, seth */
      7'b001_1xxx: select_data = {LEN_REG{1'bx}}; /* ld, st, j, ja */ /* xxx */
      /* xxx: nop and hlt */
      default:     select_data = {LEN_REG{1'bx}};
    endcase
  endfunction

  assign data_o = select_data(opecode,
    data_div, data_mul, data_shift, data_logic, data_add);

endmodule


`default_nettype wire
