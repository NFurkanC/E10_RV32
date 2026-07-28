module id_top 
import e10_base_pkg::*;
(
    //input logic [31:0]  pc_d_i,
    input logic [31:0]  instr_d_i,
    
    output logic [31:0] imm_x_o,
    output logic [2:0]  funct3_x_o,
    output alu_subopcodes  alu_subopcode_x_o,
    output logic        lsu_funct_en_x_o,
    output result_mux  wb_target_x_o,
    output logic        alu_src_a_x_o,
    output logic        alu_src_b_x_o,
    
    output logic [4:0]  rs1_addr_regfile,
    output logic [4:0]  rs2_addr_regfile,
    output logic [4:0]  rd_addr_regfile,

    output logic        branch_in_pipe_o
);
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    
    instr_field_gen instr_field_gen (
        .instr_i (instr_d_i),
        .opcode  (opcode),
        .rd_addr (rd_addr_regfile),
        .funct3  (funct3),
        .rs1_addr(rs1_addr_regfile),
        .rs2_addr(rs2_addr_regfile),
        .funct7  (funct7),
        .imm     (imm_x_o)
    );

    decode_controller decode_controller (
        .opcode_i       (opcode),
        .funct3_i       (funct3),
        .funct7_i       (funct7),
        .alu_subopcode_o(alu_subopcode_x_o),
        .lsu_funct_en_o (lsu_funct_en_x_o),
        .wb_target_o    (wb_target_x_o),
        .alu_src_a      (alu_src_a_x_o),
        .alu_src_b      (alu_src_b_x_o),
        .branch_in_pipe_o(branch_in_pipe_o)
    );

    assign funct3_x_o = funct3;
endmodule
