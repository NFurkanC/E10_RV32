package e10_base_pkg;

//OPCODE DEFINITIONS

localparam logic [6:0] OPCODE_LUI = 7'h37;
localparam logic [6:0] OPCODE_AUIPC = 7'h17;
localparam logic [6:0] OPCODE_OP = 7'h33;
localparam logic [6:0] OPCODE_OP_IMM = 7'h13;
localparam logic [6:0] OPCODE_LOAD = 7'h03;
localparam logic [6:0] OPCODE_STORE = 7'h23;
localparam logic [6:0] OPCODE_BRANCH = 7'h63;
localparam logic [6:0] OPCODE_JALR = 7'h67;
localparam logic [6:0] OPCODE_JAL = 7'h6f;

//unused as of this release
localparam logic [6:0] OPCODE_SYSTEM = 7'h73;
localparam logic [6:0] OPCODE_FENCE = 7'h0f;

typedef enum logic[3:0] { 
    ALU_ADD = 4'b0000,
    ALU_SUB = 4'b0001,
    ALU_SLL = 4'b0010,
    ALU_SLT = 4'b0011,
    ALU_SLTU = 4'b0100,
    ALU_XOR = 4'b0101,
    ALU_SRL = 4'b0110,
    ALU_SRA = 4'b0111,
    ALU_OR = 4'b1000,
    ALU_AND = 4'b1001,
    //Shut-off/NOP
    ALU_NONE = 4'b1111
} alu_subopcodes;

typedef enum logic[1:0]{
    RESULT_MUX_R = 2'b00,
    RESULT_MUX_MEM = 2'b01,
    RESULT_MUX_PC = 2'b10,
    RESULT_MUX_J = 2'b11
} result_mux; 

endpackage
