module ex_top
import e10_base_pkg::*;
(
    input logic [31:0] pc_x_i,
    input logic [31:0] imm_x_i,
    input logic [31:0] rs1_data_x_i,
    input logic [31:0] rs2_data_x_i,
    input logic [2:0]  funct3_x_i,
    input alu_subopcodes  alu_subopcode_x_i,
    input logic        lsu_funct_en_x_i,
    input result_mux   wb_target_x_i,
    input logic        alu_src_a_i,
    input logic        alu_src_b_i,

    input logic [31:0]  mem_data_i,

    output logic [31:0] pc_o,
    output logic [31:0] reg_data_o,
    output logic [31:0] mem_data_o,
    output logic [31:0] mem_addr_o,
    output logic        mem_wen_o,
    output logic        pc_wen_o,
    output logic        reg_wen_o,

    output logic        stall_o,
    output logic        branch_taken_o
);

    logic [31:0]    alu_operand_1;
    logic [31:0]    alu_operand_2;
    logic           alu_en;
    logic [31:0]    alu_result;
    logic           branch_valid;
    logic [31:0]    lsu_data_i;
    logic           data_source_sel;

    assign data_source_sel = (wb_target_x_i == RESULT_MUX_R) && (lsu_funct_en_x_i == 1'b1);

    alu_mux alu_mux (
        .pc_i           (pc_x_i),
        .imm_i          (imm_x_i),
        .rs1_i          (rs1_data_x_i),
        .rs2_i          (rs2_data_x_i),
        .alu_src_a_i    (alu_src_a_i),
        .alu_src_b_i    (alu_src_b_i),
        .alu_subopcode  (alu_subopcode_x_i),
        .alu_operand_1_o(alu_operand_1),
        .alu_operand_2_o(alu_operand_2),
        .alu_en_o       (alu_en)
    );

    alu_basic alu_basic (
        .operand_1(alu_operand_1),
        .operand_2(alu_operand_2),
        .subopcode(alu_subopcode_x_i),
        .alu_en_i (alu_en),
        .result_o (alu_result)
    );

    branch_comparator branch_comparator (
        .rs1_i         (rs1_data_x_i),
        .rs2_i         (rs2_data_x_i),
        .funct_3_i     (funct3_x_i),
        .wb_i          (wb_target_x_i),
        .branch_valid_o(branch_valid)
    );

    wb_mux_top wb_mux_top (
        .wb_i           (wb_target_x_i),
        .branch_valid_i (branch_valid),
        .alu_result_i   (alu_result),
        .lsu_data_i     (lsu_data_i),
        .pc_i           (pc_x_i),
        .data_source_sel(data_source_sel),
    //  .lsu_data_o     (lsu_data_o),
        .reg_data_o     (reg_data_o),
        .pc_o           (pc_o),
        .pc_wen_o       (pc_wen_o),
        .reg_wen_o      (reg_wen_o),
        .branch_stall   (branch_taken_o)
    );

    lsu_basic lsu_basic (
        .address_result_i(alu_result),
        .rs2_i           (rs2_data_x_i),
        .funct_3_i       (funct3_x_i),
        .lsu_en_i        (lsu_funct_en_x_i),
        .mem_data_i      (mem_data_i),
        .wb_i            (wb_target_x_i),
        .mem_data_o      (mem_data_o),
        .mem_addr_o      (mem_addr_o),
        .reg_data_o      (lsu_data_i),
        .mem_wen_o       (mem_wen_o),
        .stall_o         (stall_o)
    );

endmodule
