`default_nettype none


module execute_logic #(
`include "defs_insn.v"
) (
  input wire [LEN_OPECODE-1:0] opecode,
  input wire [LEN_REG-1:0] data_rd,
  input wire [LEN_REG-1:0] data_rs,
  input wire [LEN_IMM_EX-1:0] imm_ex,
  output wire [LEN_REG-1:0] data_o
);

  function [LEN_REG-1:0] do_logic (
    input [LEN_OPECODE-1:0] opecode,
    input [LEN_REG-1:0] data_rd,
    input [LEN_REG-1:0] data_rs,
    input [LEN_IMM_EX-1:0] imm_ex
  );
    case (opecode)
      OPECODE_AND:  do_logic = data_rd & data_rs;
      OPECODE_OR:   do_logic = data_rd | data_rs;
      OPECODE_NOT:  do_logic = ~data_rs;
      OPECODE_XOR:  do_logic = data_rd ^ data_rs;
      OPECODE_SETL: do_logic =
          {data_rs[LEN_REG-1:LEN_IMM], imm_ex[LEN_IMM-1:0]};
      OPECODE_SETH: do_logic =
          {imm_ex[LEN_IMM-1:0], data_rs[LEN_REG-LEN_IMM-1:0]};
      default:      do_logic = {LEN_REG{1'bx}};
    endcase
  endfunction

  assign data_o = do_logic(
    .opecode(opecode),
    .data_rd(data_rd),
    .data_rs(data_rs),
    .imm_ex(imm_ex)
  );

endmodule


`default_nettype wire
