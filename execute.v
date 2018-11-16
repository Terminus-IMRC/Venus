`default_nettype none


module execute #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst,

  input wire valid_i,
  input wire valid_o,
  input wire stall_i,
  input wire stall_o,

  input wire [LEN_OPECODE-1:0] opecode,
  input wire [LEN_IMMF-1:0] immf,
  input wire [LEN_REG-1:0] data_rd,
  input wire [LEN_REG-1:0] data_rs,
  input wire [LEN_CC-1:0] cc,
  input wire [LEN_IMM_EX-1:0] imm_ex,
  output wire [LEN_REG-1:0] data_o,
  output wire [LEN_REG-1:0] data_o_forward
);

  reg valid_reg;
  assign valid_o = valid_reg;
  assign stall_o = valid_reg & stall_i;

  wire [LEN_REG-1:0] data_div, data_mul, data_shift, data_logic, data_add, data;
  reg [LEN_REG-1:0] data_reg;
  assign data_o = data_reg;

  reg carry;
  wire carry_i = carry, carry_o = carry;

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

  assign data = select_data(opecode,
      data_div, data_mul, data_shift, data_logic, data_add);

  always @(negedge rst) begin
    valid_reg <= 1'b0;
    data_reg <= {LEN_REG{1'bx}};
    carry <= 1'b0;
  end

  always @(posedge clk) begin
    if (~stall_i) begin
      valid_reg <= valid_i;
      data_reg <= data;
    end
  end

endmodule


`default_nettype wire
