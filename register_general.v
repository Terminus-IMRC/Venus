`default_nettype none


module register_general #(
`include "defs_insn.v"
) (
  input wire clk,
  input wire rst,

  input wire w_reserved_i,
  input wire [LEN_REGNO-1:0] rd_regno_i, /* Reg. no. of rd. */
  input wire [LEN_REGNO-1:0] rs_regno_i, /* Reg. no. of rs. */
  output wire [LEN_REG-1:0] rd_data_o, /* Data from reg 0. */
  output wire [LEN_REG-1:0] rs_data_o, /* Data from reg 1. */
  output wire reserved_o, /* Is write is reserved? */
  input wire [LEN_REGNO-1:0] wb_regno_i, /* Reg. no. to write data to. */
  input wire [LEN_REG-1:0] wb_data_i, /* Data to be written. */
  input wire do_wb
);

`include "ensel16.v"

  wire [NUM_REGS-1:0] wb_r;
  wire [LEN_REG-1:0] data0, data1, data2, data3, data4, data5, data6, data7,
                     data8, data9, dataa, datab, datac, datad, datae, dataf;

  assign rd_data_o = select16_32(rd_regno_i,
      data0, data1, data2, data3, data4, data5, data6, data7,
      data8, data9, dataa, datab, datac, datad, datae, dataf);
  assign rs_data_o = select16_32(rs_regno_i,
      data0, data1, data2, data3, data4, data5, data6, data7,
      data8, data9, dataa, datab, datac, datad, datae, dataf);

  wire [NUM_REGS-1:0] rd_exp, rs_exp, wb_exp;
  assign rd_exp = decode16(rd_regno_i);
  assign rs_exp = decode16(rs_regno_i);
  assign wb_exp = decode16(wb_regno_i);

  wire [NUM_REGS-1:0] w_reserve, w_reserved;
  /* If write is reserved, rd should not be written. */
  assign w_reserve = rd_exp & {NUM_REGS{w_reserved_i}};

  /* If trying to read/write from/to register which is being written, genrate
   * stall.
   */
  assign reserved_o = |((rd_exp | rs_exp) & w_reserved);
  assign wb_r = wb_exp & {NUM_REGS{do_wb}};


  /* Generated by gen_regs.py script. */

  register_cell #(
    .INITIAL_DATA(32'h00010100)
  ) r0 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data0),
    .w_reserve_i(w_reserve[0]),
    .w_reserve_o(w_reserved[0]),
    .wb_i(wb_r[0])
  );

  register_cell #(
    .INITIAL_DATA(32'h00020101)
  ) r1 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data1),
    .w_reserve_i(w_reserve[1]),
    .w_reserve_o(w_reserved[1]),
    .wb_i(wb_r[1])
  );

  register_cell #(
    .INITIAL_DATA(32'h00040102)
  ) r2 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data2),
    .w_reserve_i(w_reserve[2]),
    .w_reserve_o(w_reserved[2]),
    .wb_i(wb_r[2])
  );

  register_cell #(
    .INITIAL_DATA(32'h00080103)
  ) r3 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data3),
    .w_reserve_i(w_reserve[3]),
    .w_reserve_o(w_reserved[3]),
    .wb_i(wb_r[3])
  );

  register_cell #(
    .INITIAL_DATA(32'h00100104)
  ) r4 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data4),
    .w_reserve_i(w_reserve[4]),
    .w_reserve_o(w_reserved[4]),
    .wb_i(wb_r[4])
  );

  register_cell #(
    .INITIAL_DATA(32'h00200105)
  ) r5 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data5),
    .w_reserve_i(w_reserve[5]),
    .w_reserve_o(w_reserved[5]),
    .wb_i(wb_r[5])
  );

  register_cell #(
    .INITIAL_DATA(32'h00400106)
  ) r6 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data6),
    .w_reserve_i(w_reserve[6]),
    .w_reserve_o(w_reserved[6]),
    .wb_i(wb_r[6])
  );

  register_cell #(
    .INITIAL_DATA(32'h00800107)
  ) r7 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data7),
    .w_reserve_i(w_reserve[7]),
    .w_reserve_o(w_reserved[7]),
    .wb_i(wb_r[7])
  );

  register_cell #(
    .INITIAL_DATA(32'h01000108)
  ) r8 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data8),
    .w_reserve_i(w_reserve[8]),
    .w_reserve_o(w_reserved[8]),
    .wb_i(wb_r[8])
  );

  register_cell #(
    .INITIAL_DATA(32'h02000109)
  ) r9 (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(data9),
    .w_reserve_i(w_reserve[9]),
    .w_reserve_o(w_reserved[9]),
    .wb_i(wb_r[9])
  );

  register_cell #(
    .INITIAL_DATA(32'h0400010a)
  ) ra (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(dataa),
    .w_reserve_i(w_reserve[10]),
    .w_reserve_o(w_reserved[10]),
    .wb_i(wb_r[10])
  );

  register_cell #(
    .INITIAL_DATA(32'h0800010b)
  ) rb (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(datab),
    .w_reserve_i(w_reserve[11]),
    .w_reserve_o(w_reserved[11]),
    .wb_i(wb_r[11])
  );

  register_cell #(
    .INITIAL_DATA(32'h1000010c)
  ) rc (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(datac),
    .w_reserve_i(w_reserve[12]),
    .w_reserve_o(w_reserved[12]),
    .wb_i(wb_r[12])
  );

  register_cell #(
    .INITIAL_DATA(32'h2000010d)
  ) rd (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(datad),
    .w_reserve_i(w_reserve[13]),
    .w_reserve_o(w_reserved[13]),
    .wb_i(wb_r[13])
  );

  register_cell #(
    .INITIAL_DATA(32'h4000010e)
  ) re (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(datae),
    .w_reserve_i(w_reserve[14]),
    .w_reserve_o(w_reserved[14]),
    .wb_i(wb_r[14])
  );

  register_cell #(
    .INITIAL_DATA(32'h8000010f)
  ) rf (
    .clk(clk),
    .rst(rst),
    .data_i(wb_data_i),
    .data_o(dataf),
    .w_reserve_i(w_reserve[15]),
    .w_reserve_o(w_reserved[15]),
    .wb_i(wb_r[15])
  );


endmodule


`default_nettype wire
