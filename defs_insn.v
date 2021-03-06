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
parameter OPECODE_ADD  = 7'b000_0000,
parameter OPECODE_SUB  = 7'b000_0001,
parameter OPECODE_MUL  = 7'b000_0010,
parameter OPECODE_DIV  = 7'b000_0011,
parameter OPECODE_CMP  = 7'b000_0100,
parameter OPECODE_ABS  = 7'b000_0101,
parameter OPECODE_ADC  = 7'b000_0110,
parameter OPECODE_SBC  = 7'b000_0111,

parameter OPECODE_SHL  = 7'b000_1000,
parameter OPECODE_SHR  = 7'b000_1001,
parameter OPECODE_ASH  = 7'b000_1010,
parameter OPECODE_ROL  = 7'b000_1100,
parameter OPECODE_ROR  = 7'b000_1101,

parameter OPECODE_AND  = 7'b001_0000,
parameter OPECODE_OR   = 7'b001_0001,
parameter OPECODE_NOT  = 7'b001_0010,
parameter OPECODE_XOR  = 7'b001_0011,
parameter OPECODE_SETL = 7'b001_0110,
parameter OPECODE_SETH = 7'b001_0111,

parameter OPECODE_LD   = 7'b001_1000,
parameter OPECODE_ST   = 7'b001_1001,

parameter OPECODE_J    = 7'b001_1100,
parameter OPECODE_JA   = 7'b001_1101,
parameter OPECODE_NOP  = 7'b001_1110,
parameter OPECODE_HLT  = 7'b001_1111,

/* Memory */
parameter MEM_DATA_ADDR = 16,
parameter MEM_DATA_LEN = 65536,
parameter MEM_DATA_FILE = "mem_data.dathex",

parameter MEM_INSN_ADDR = 16,
parameter MEM_INSN_LEN = 65536,
parameter MEM_INSN_FILE = "mem_insn.dathex",

/* Misc */
parameter LEN_INSN = 32,
parameter BITS_REG = 5,
parameter LEN_REG = 1 << BITS_REG,
parameter NUM_REGS = 1 << LEN_REGNO,

/* Flags */
parameter LEN_FLAGS = 8,
parameter FLAG_SHIFT_ZERO = 1,
parameter FLAG_SHIFT_POS = 2,
parameter FLAG_SHIFT_NEG = 3,
parameter FLAG_SHIFT_CARRY = 4,
parameter FLAG_SHIFT_OVERFLOW = 5
