import e10_base_pkg::*;
module alu_mux
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
