module ex_top
(
    input logic [31:0] pc_x_i,
    input logic [31:0] imm_x_i,
    input logic [31:0] rs1_data_x_i,
    input logic [31:0] rs2_data_x_i,
    input logic [2:0]  funct3_x_i,
    input logic [3:0]  alu_subopcode_x_i,
    input logic        lsu_funct_en_x_i,
    input logic [1:0]  wb_target_x_i,
    input logic        alu_src_a_i,
    input logic        alu_src_b_i,

    output logic [31:0] result_o
);
    logic [31:0]    alu_operand_1;
    logic [31:0]    alu_operand_2;
    logic           alu_en;
    logic [31:0]    alu_result_o;

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
        .result_o (alu_result_o)
    );

endmodule
