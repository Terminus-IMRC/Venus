`default_nettype none


module execute #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst,

  input wire valid_i,
  output wire valid_o,
  input wire stall_i,
  output wire stall_o,

  input wire [LEN_OPECODE-1:0] opecode,
  input wire [LEN_IMMF-1:0] immf,
  input wire [LEN_REG-1:0] data_rd,
  input wire [LEN_REG-1:0] data_rs,
  input wire [LEN_CC-1:0] cc,
  input wire [LEN_IMM_EX-1:0] imm_ex,
  output wire [LEN_REG-1:0] data_o,
  output wire [LEN_REG-1:0] data_o_forward,
  output wire [LEN_FLAGS-1:0] flags_o
);

  reg valid_reg;
  assign valid_o = valid_reg;
  assign stall_o = valid_reg & stall_i;

  wire [LEN_REG-1:0] data_div, data_mul, data_shift, data_logic, data_add;
  reg [LEN_REG-1:0] data_reg;
  assign data_o = data_reg;

  reg carry_reg, overflow_reg;
  wire is_zero, is_pos, is_neg, is_carry, is_overflow;
  assign is_zero = (data_reg == {LEN_REG{1'b0}});
  assign is_pos = ~data_reg[LEN_REG-1];
  assign is_neg = data_reg[LEN_REG-1];
  /* carry and overflow depend on the input data. */
  assign is_carry = carry_reg;
  assign is_overflow = overflow_reg;
  assign flags_o =
      {1'b0, 1'b0, is_overflow, is_carry, is_neg, is_pos, is_zero, 1'b1};
  wire carry_add;


  execute_shift exec_shift (
    .opecode(opecode),
    .immf(immf),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .imm_ex(imm_ex),
    .data_o(data_shift)
  );

  execute_logic exec_logic (
    .opecode(opecode),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .imm_ex(imm_ex),
    .data_o(data_logic)
  );

  execute_add exec_add (
    .opecode(opecode),
    .immf(immf),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .imm_ex(imm_ex),
    .carry_i(carry_reg),
    .data_o(data_add),
    .carry_o(carry_add)
  );

  execute_mem exec_mem (
    .clk(clk),
    .opecode(opecode),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .imm_ex(imm_ex),
    .data_o(data_o_forward)
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

  wire [LEN_REG-1:0] data = select_data(opecode,
      data_div, data_mul, data_shift, data_logic, data_add);

  wire overflow_add = (data_rd[LEN_REG-1] == data_rs[LEN_REG-1]
      && data_rd[LEN_REG-1] != data[LEN_REG-1]);

  always @(negedge rst) begin
    valid_reg <= 1'b0;
    data_reg <= {LEN_REG{1'bx}};
    carry_reg <= 1'b0;
    overflow_reg <= 1'b0;
  end

  always @(posedge clk) begin
    if (~stall_i) begin
      valid_reg <= valid_i;
      data_reg <= data;
      if (valid_i) begin
        carry_reg <= carry_add;
        overflow_reg <= overflow_add;
      end
    end
  end

endmodule


`default_nettype wire
