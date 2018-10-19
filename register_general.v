`default_nettype none


module register_general #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst,
  input wire w_reserved_i, /* 1'b1 if write is prohibited. */
  input wire [LEN_REGNO-1:0] r0_i, /* Reg. no. of rd. */
  input wire [LEN_REGNO-1:0] r1_i, /* Reg. no. of rs. */
  output wire [LEN_REG-1:0] r_opr0_o, /* Data from reg 0. */
  output wire [LEN_REG-1:0] r_opr1_o, /* Data from reg 1. */
  output wire reserved_o,
  input wire wb_i, /* 1'b1 if data is to be written to somewhere. */
  input wire [LEN_REGNO-1:0] wb_r_i, /* Reg. no. to write data to. */
  input wire [LEN_REG-1:0] result_i /* Data to be written. */
);

`include "ensel16.v"

  wire [NUM_REGS-1:0] w_reserved;
  wire [NUM_REGS-1:0] wb_r;
  wire [LEN_REG-1:0] data0, data1, data2, data3, data4, data5, data6, data7,
                     data8, data9, dataa, datab, datac, datad, datae, dataf;

  assign r_opr0_o = select16_32(r0_i,
      data0, data1, data2, data3, data4, data5, data6, data7,
      data8, data9, dataa, datab, datac, datad, datae, dataf);
  assign r_opr1_o = select16_32(r1_i,
      data0, data1, data2, data3, data4, data5, data6, data7,
      data8, data9, dataa, datab, datac, datad, datae, dataf);

  wire [NUM_REGS-1:0] opr_req0, opr_req1;

  assign opr_req0 = decode16(r0_i);
  assign opr_req1 = decode16(r1_i);

  /* If write is reserved, rd should not be written. */
  assign w_reserved = opr_req0 & {NUM_REGS{w_reserved_i}};
  /* ??? */
  assign reserved_o = |((opr_req0 | opr_req1) & w_reserved);

  assign wb_r = decode16(wb_r_i) & {16{wb_i}};


  register_cell r0 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data0),
    .w_reserve_i(w_reserved[0]),
    .w_reserve_o(w_reserved[0]),
    .wb_i(wb_r[0])
  );

  register_cell r1 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data1),
    .w_reserve_i(w_reserved[1]),
    .w_reserve_o(w_reserved[1]),
    .wb_i(wb_r[1])
  );

  register_cell r2 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data2),
    .w_reserve_i(w_reserved[2]),
    .w_reserve_o(w_reserved[2]),
    .wb_i(wb_r[2])
  );

  register_cell r3 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data3),
    .w_reserve_i(w_reserved[3]),
    .w_reserve_o(w_reserved[3]),
    .wb_i(wb_r[3])
  );

  register_cell r4 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data4),
    .w_reserve_i(w_reserved[4]),
    .w_reserve_o(w_reserved[4]),
    .wb_i(wb_r[4])
  );

  register_cell r5 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data5),
    .w_reserve_i(w_reserved[5]),
    .w_reserve_o(w_reserved[5]),
    .wb_i(wb_r[5])
  );

  register_cell r6 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data6),
    .w_reserve_i(w_reserved[6]),
    .w_reserve_o(w_reserved[6]),
    .wb_i(wb_r[6])
  );

  register_cell r7 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data7),
    .w_reserve_i(w_reserved[7]),
    .w_reserve_o(w_reserved[7]),
    .wb_i(wb_r[7])
  );

  register_cell r8 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data8),
    .w_reserve_i(w_reserved[8]),
    .w_reserve_o(w_reserved[8]),
    .wb_i(wb_r[8])
  );

  register_cell r9 (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(data9),
    .w_reserve_i(w_reserved[9]),
    .w_reserve_o(w_reserved[9]),
    .wb_i(wb_r[9])
  );

  register_cell ra (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(dataa),
    .w_reserve_i(w_reserved[10]),
    .w_reserve_o(w_reserved[10]),
    .wb_i(wb_r[10])
  );

  register_cell rb (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(datab),
    .w_reserve_i(w_reserved[11]),
    .w_reserve_o(w_reserved[11]),
    .wb_i(wb_r[11])
  );

  register_cell rc (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(datac),
    .w_reserve_i(w_reserved[12]),
    .w_reserve_o(w_reserved[12]),
    .wb_i(wb_r[12])
  );

  register_cell rd (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(datad),
    .w_reserve_i(w_reserved[13]),
    .w_reserve_o(w_reserved[13]),
    .wb_i(wb_r[13])
  );

  register_cell re (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(datae),
    .w_reserve_i(w_reserved[14]),
    .w_reserve_o(w_reserved[14]),
    .wb_i(wb_r[14])
  );

  register_cell rf (
    .clk(clk),
    .rst(rst),
    .data_i(result_i),
    .data_o(dataf),
    .w_reserve_i(w_reserved[15]),
    .w_reserve_o(w_reserved[15]),
    .wb_i(wb_r[15])
  );


endmodule


`default_nettype wire
