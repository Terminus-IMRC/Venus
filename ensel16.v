function [15:0] decode16 (
  input [3:0] d
);
  case (d)
    4'b0000: decode16 = 16'b0000000000000001;
    4'b0001: decode16 = 16'b0000000000000010;
    4'b0010: decode16 = 16'b0000000000000100;
    4'b0011: decode16 = 16'b0000000000001000;
    4'b0100: decode16 = 16'b0000000000010000;
    4'b0101: decode16 = 16'b0000000000100000;
    4'b0110: decode16 = 16'b0000000001000000;
    4'b0111: decode16 = 16'b0000000010000000;
    4'b1000: decode16 = 16'b0000000100000000;
    4'b1001: decode16 = 16'b0000001000000000;
    4'b1010: decode16 = 16'b0000010000000000;
    4'b1011: decode16 = 16'b0000100000000000;
    4'b1100: decode16 = 16'b0001000000000000;
    4'b1101: decode16 = 16'b0010000000000000;
    4'b1110: decode16 = 16'b0100000000000000;
    4'b1111: decode16 = 16'b1000000000000000;
    default: decode16 = {16{1'bx}};
  endcase
endfunction

function [31:0] select16_32 (
  input [3:0] select,
  input [31:0] data0, data1, data2, data3, data4, data5, data6, data7,
      data8, data9, dataa, datab, datac, datad, datae, dataf
);

  case (select)
    4'b0000: select16_32 = data0;
    4'b0001: select16_32 = data1;
    4'b0010: select16_32 = data2;
    4'b0011: select16_32 = data3;
    4'b0100: select16_32 = data4;
    4'b0101: select16_32 = data5;
    4'b0110: select16_32 = data6;
    4'b0111: select16_32 = data7;
    4'b1000: select16_32 = data8;
    4'b1001: select16_32 = data9;
    4'b1010: select16_32 = dataa;
    4'b1011: select16_32 = datab;
    4'b1100: select16_32 = datac;
    4'b1101: select16_32 = datad;
    4'b1110: select16_32 = datae;
    4'b1111: select16_32 = dataf;
    default: select16_32 = {32{1'bx}};
  endcase

endfunction
