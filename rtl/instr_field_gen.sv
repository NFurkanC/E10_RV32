import e10_base_pkg::*;
module instr_field_gen
(
    input logic [31:0]  instr_i,

    output logic [6:0]  opcode,
    output logic [4:0]  rd_addr,
    output logic [2:0]  funct3,
    output logic [4:0]  rs1_addr,
    output logic [4:0]  rs2_addr,
    output logic [6:0]  funct7,
    output logic [31:0] imm
);

assign opcode = instr_i[6:0];

always_comb begin
    rd_addr = instr_i[11:7];
    funct3 = instr_i[14:12];
    rs1_addr = instr_i[19:15];
    rs2_addr = instr_i[24:20];
    funct7 = instr_i[31:25];
    imm = 32'b0;
    case(opcode)
        OPCODE_OP: begin
            rd_addr = instr_i[11:7];
            funct3 = instr_i[14:12];
            rs1_addr = instr_i[19:15];
            rs2_addr = instr_i[24:20];
            funct7 = instr_i[31:25];
        end 
        OPCODE_OP_IMM: begin
            imm = {{20{instr_i[31]}}, instr_i[31:20]};
        end
        OPCODE_LOAD: begin
            imm = {{20{instr_i[31]}}, instr_i[31:20]}; 
        end
        OPCODE_STORE: begin
            imm = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
        end
        OPCODE_BRANCH: begin
            imm = {{20{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0 };
        end
        OPCODE_LUI: begin
            rs1_addr = 5'b0;
            imm = {instr_i[31:12],12'b0};
        end
        OPCODE_AUIPC: begin
            imm = {instr_i[31:12],12'b0};
        end
        OPCODE_JAL: begin
            imm = {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0 };
        end
        OPCODE_JALR: begin
            imm = {{20{instr_i[31]}}, instr_i[31:20]};
        end
        default: imm = 32'b0;
    endcase
end
    
endmodule
