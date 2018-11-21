`default_nettype none


module register_cell #(
`include "defs_insn.v"
  ,
  parameter INITIAL_DATA = {LEN_REG{1'bx}}
) (
  input wire clk,
  input wire rst,
  input wire [LEN_REG-1:0] data_i,
  output wire [LEN_REG-1:0] data_o,
  input wire w_reserve_i,
  output wire w_reserve_o,
  input wire wb_i
);

  reg [LEN_REG-1:0] data;
  /* 0: Register is not being written.
   * 1: Register is being written, so not to be read by following insn.
   */
  reg w_reserve;

  assign data_o = data;
  assign w_reserve_o = w_reserve;


  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      w_reserve <= 1'b0;
      //data <= {LEN_REG{1'bx}};
      data <= INITIAL_DATA;
    end else begin
      if (wb_i) begin
        data <= data_i;
        w_reserve <= 1'b0;
      end else if (w_reserve_i) begin
        w_reserve <= 1'b1;
      end
    end
  end

endmodule


`default_nettype wire
