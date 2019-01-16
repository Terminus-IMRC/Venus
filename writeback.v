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

  input wire valid_i,
  output wire valid_o,
  input wire stall_i,
  output wire stall_o,

  input wire [LEN_OPECODE-1:0] opecode,
  input wire [LEN_REGNO-1:0] rd_regno,
  input wire [LEN_REG-1:0] data_o,
  input wire [LEN_REG-1:0] data_o_forward,
  output wire [LEN_REGNO-1:0] wb_regno,
  output wire [LEN_REG-1:0] wb_data,
  input wire is_wb,
  output wire do_wb
);

  reg [LEN_OPECODE-1:0] opecode_reg;
  reg [LEN_REGNO-1:0] rd_regno_reg;
  reg wb_reg;

  reg valid;
  assign valid_o = valid;
  assign stall_o = valid & stall_i;

  assign wb_regno = rd_regno_reg;
  assign wb_data = (opecode_reg == OPECODE_LD) ? data_o_forward : data_o;
  assign do_wb = wb_reg;

  always @(negedge rst) begin
    opecode_reg <= OPECODE_CMP;
    wb_reg <= 1'b0;
  end

  always @(posedge clk) begin
    if (~stall_i) begin
      valid <= valid_i;
      opecode_reg <= opecode;
      rd_regno_reg <= rd_regno;
      wb_reg <= is_wb;
    end
  end


endmodule


`default_nettype wire
