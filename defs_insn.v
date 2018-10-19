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

/* Misc */
parameter LEN_INSN = 32,
parameter LEN_REG = 32,
parameter NUM_REGS = 1 << LEN_REGNO
