`default_nettype none


/*
 * This module just holds opecode and rd_regno while their insn is executed by
 * the execute module.
 */

module writeback #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst,

  input wire [LEN_OPECODE-1:0] opecode,
  input wire [LEN_REGNO-1:0] rd_regno,
  input wire [LEN_REG-1:0] data_o,
  input wire [LEN_REG-1:0] data_o_forward,
  output wire is_wb,
  output wire [LEN_REGNO-1:0] wb_regno,
  output wire [LEN_REG-1:0] wb_data
);

  reg [LEN_OPECODE-1:0] opecode_reg;
  reg [LEN_REGNO-1:0] rd_regno_reg;

  assign is_wb = (opecode_reg == OPECODE_CMP || opecode_reg == OPECODE_ST) ?
      1'b0 : 1'b1;
  assign wb_regno = rd_regno_reg;
  assign wb_data = (opecode_reg == OPECODE_LD) ? data_o_forward : data_o;

  always @(posedge clk) begin
    opecode_reg <= opecode;
    rd_regno_reg <= rd_regno;
  end


endmodule


`default_nettype wire
