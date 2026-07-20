//ALU for RV32I - combinational
module alu_basic 
import e10_base_pkg::*;
(
    input logic [31:0]      operand_1,
    input logic [31:0]      operand_2,
    input alu_subopcodes    subopcode,
    input logic             alu_en_i,

    output logic [31:0]     result_o
);
    
    always_comb begin
        result_o = 32'b0;
        if(alu_en_i) begin
            unique case (subopcode)
                ALU_ADD: result_o = operand_1 + operand_2;
                ALU_SUB: result_o = operand_1 - operand_2;
                ALU_AND: result_o = operand_1 & operand_2;
                ALU_OR: result_o = operand_1 | operand_2;
                ALU_XOR: result_o = operand_1 ^ operand_2;
                ALU_SLL: result_o = operand_1 << operand_2[4:0];
                ALU_SRL: result_o = operand_1 >> operand_2[4:0];
                ALU_SRA: result_o = unsigned'($signed(operand_1) >>> operand_2[4:0]);
                ALU_SLT: result_o = ($signed(operand_1) < $signed(operand_2)) ? 32'b1 : 32'b0;
                ALU_SLTU: result_o = (operand_1 < operand_2) ? 32'b1 : 32'b0;
                ALU_NONE: result_o = 32'b0;
            endcase    
        end
    end

endmodule

module alu_mux
import e10_base_pkg::*;
(
    input logic [31:0]      pc_i,
    input logic [31:0]      imm_i,
    input logic [31:0]      rs1_i,
    input logic [31:0]      rs2_i,
    
    input logic             alu_src_a_i,
    input logic             alu_src_b_i,
    input alu_subopcodes    alu_subopcode,

    output logic [31:0]     alu_operand_1_o,
    output logic [31:0]     alu_operand_2_o,
    output logic            alu_en_o
);
    
    always_comb begin
        alu_operand_1_o = 32'b0;
        alu_operand_2_o = 32'b0;
        alu_en_o = 1'b0;
        if(!(alu_subopcode == ALU_NONE)) begin
            alu_operand_1_o = (alu_src_a_i) ? pc_i : rs1_i;
            alu_operand_2_o = (alu_src_b_i) ? imm_i : rs2_i;
            alu_en_o = 1'b1;
        end
    end
    
endmodule
