module id_ex_registers 
import e10_base_pkg::*;
(

    input logic         clk_i,
    input logic         rst_i,

    input logic         stall_x,
    input logic         flush_x,

    input logic [31:0]  pc_x_i,
    
    input logic [31:0]  imm_x_i,
    input logic [31:0]  rs1_data_i,
    input logic [31:0]  rs2_data_i,
    
    input logic [2:0]   funct3_x_i,
    input alu_subopcodes   alu_subopcode_x_i,
    input logic         lsu_funct_en_x_i,
    input result_mux    wb_target_x_i,
    input logic         alu_src_a_x_i,
    input logic         alu_src_b_x_i,

    output logic [31:0] pc_x_o,
    output logic [31:0] imm_x_o,
    output logic [31:0] rs1_data_x_o,
    output logic [31:0] rs2_data_x_o,
    output logic [2:0]  funct3_x_o,
    output alu_subopcodes  alu_subopcode_x_o,
    output logic        lsu_funct_en_x_o,
    output result_mux   wb_target_x_o,
    output logic        alu_src_a_o,
    output logic        alu_src_b_o
);

    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            pc_x_o <= 32'b0;
            imm_x_o <= 32'b0;
            rs1_data_x_o <= 32'b0;
            rs2_data_x_o <= 32'b0;
            funct3_x_o <= 3'b0;
            alu_subopcode_x_o <= ALU_ADD;
            lsu_funct_en_x_o <= 1'b0;
            wb_target_x_o <= RESULT_MUX_R;
            alu_src_a_o <= 1'b0;
            alu_src_b_o <= 1'b0;
        end
        else if (flush_x) begin
            pc_x_o <= 32'b0;
            imm_x_o <= 32'b0;
            rs1_data_x_o <= 32'b0;
            rs2_data_x_o <= 32'b0;
            funct3_x_o <= 3'b0;
            alu_subopcode_x_o <= ALU_ADD;
            lsu_funct_en_x_o <= 1'b0;
            wb_target_x_o <= RESULT_MUX_R;
            alu_src_a_o <= 1'b0;
            alu_src_b_o <= 1'b0;
        end
        else if (!stall_x) begin
            pc_x_o <= pc_x_i;
            imm_x_o <= imm_x_i;
            rs1_data_x_o <= rs1_data_i;
            rs2_data_x_o <= rs2_data_i;
            funct3_x_o <= funct3_x_i;
            alu_subopcode_x_o <= alu_subopcode_x_i;
            lsu_funct_en_x_o <= lsu_funct_en_x_i;
            wb_target_x_o <= wb_target_x_i;
            alu_src_a_o <= alu_src_a_x_i;
            alu_src_b_o <= alu_src_b_x_i;
        end
    end
    
endmodule
