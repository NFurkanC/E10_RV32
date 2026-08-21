package e10_mult_pkg;

//OP DEFINITIONS - OPCODE_OP
//funct3
typedef enum logic[2:0] {
    MUL_MUL = 3'b000,
    MUL_MULH = 3'b001,
    MUL_MULHSU = 3'b010,
    MUL_MULHU = 3'b011,
    MUL_DIV = 3'b100,
    MUL_DIVU = 3'b101,
    MUL_REM = 3'b110,
    MUL_REMU = 3'b111
} mul_subopcodes;

typedef struct packed {
    logic       valid;
    mul_subopcodes op;
    logic [31:0] operand_a;
    logic [31:0] operand_b;
} mul_in_t;

typedef struct packed {
    logic           ready;
    logic [31:0]    result;
} mul_o_t;

endpackage