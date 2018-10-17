`default_nettype none


module register_cell #(
  parameter REG_LEN = 32
) (
  input wire clk,
  input wire rst,
  input wire [REG_LEN-1:0] data_i,
  output wire [REG_LEN-1:0] data_o,
  input wire w_reserve_i,
  output wire w_reserve_o,
  input wire wb_i
);

  reg [REG_LEN-1:0] data;
  reg w_reserve;

  assign data_o = data;
  assign w_reserve_o = w_reserve;


  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      w_reserve <= 1'b0;
      data <= {REG_LEN{1'b0}};
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
