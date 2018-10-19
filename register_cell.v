`default_nettype none


module register_cell #(
`include "defs_insn.v"
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
  reg w_reserve;

  assign data_o = data;
  assign w_reserve_o = w_reserve;


  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      w_reserve <= 1'b0;
      data <= {LEN_REG{1'bx}};
    end else begin
      if (w_reserve_i) begin
        w_reserve <= 1'b1;
      end else if (wb_i) begin
        w_reserve <= 1'b0;
      end
      if (wb_i) begin
        data <= data_i;
      end
    end
  end

endmodule


`default_nettype wire
