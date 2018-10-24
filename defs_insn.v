/* Num. of bits of a field.  Total 32 bits. */
parameter LEN_OPECODE = 7,
parameter LEN_IMMF = 1,
parameter LEN_REGNO = 4,
parameter LEN_CC = 3,
parameter LEN_IMM = 16,

parameter LEN_IMM_EX = 32,

/* Num. of shifts of a field. */
parameter SHIFT_OPECODE = 25,
parameter SHIFT_IMMF = 24,
parameter SHIFT_RD = 20,
parameter SHIFT_CC = 20,
parameter SHIFT_RS = 16,
parameter SHIFT_IMM = 0,

/* Insn */
parameter OPECODE_ADD = 7'b000_0000,
parameter OPECODE_SUB = 7'b000_0001,
parameter OPECODE_MUL = 7'b000_0010,
parameter OPECODE_DIV = 7'b000_0011,
parameter OPECODE_CMP = 7'b000_0100,
parameter OPECODE_ABS = 7'b000_0101,
parameter OPECODE_ADC = 7'b000_0110,
parameter OPECODE_SBC = 7'b000_0111,

parameter OPECODE_SHL = 7'b000_1000,
parameter OPECODE_SHR = 7'b000_1001,
parameter OPECODE_ASH = 7'b000_1010,
parameter OPECODE_ROL = 7'b000_1100,
parameter OPECODE_ROR = 7'b000_1101,

/* Misc */
parameter LEN_INSN = 32,
parameter LEN_REG = 32,
parameter NUM_REGS = 1 << LEN_REGNO
