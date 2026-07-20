module core_top
import e10_base_pkg::*;
(
    input logic             clk_i,
    input logic             rst_i,

    input logic [31:0]      mem_data_i,
    input logic [31:0]      instr_data_i,
    
    output logic [31:0]     mem_data_o,
    output logic [31:0]     mem_addr_o,
    output logic [31:0]     instr_addr_o,
    output logic            mem_wen_o
);
    //FETCH SIGNALS
    logic                   pc_mux_sel;
    logic [31:0]            pc_offset;
    logic [31:0]            pc_fd;
    logic [31:0]            instr_fd;

    //DECODE SIGNALS
    logic [31:0]            instr_dd;
    logic [31:0]            pc_dx;
    logic [31:0]            imm_dx;
    logic [2:0]             funct3_dx;
    alu_subopcodes          alu_subopcode_dx;
    logic                   lsu_funct_en_dx;
    result_mux              wb_target_dx;
    logic                   alu_src_a_dx;
    logic                   alu_src_b_dx;
    logic [4:0]             rs1_addr_regfile;
    logic [4:0]             rs2_addr_regfile;
    logic [4:0]             rd_addr_regfile;
    logic                   branch_in_pipe;
    
    //REGFILE SIGNALS
    logic [31:0]            rd_data;
    logic                   reg_wen;
    logic [31:0]            rs1_data;
    logic [31:0]            rs2_data;

    //EXECUTE SIGNALS
    logic [31:0]            pc_ex;
    logic [31:0]            imm_ex;
    logic [31:0]            rs1_data_ex;
    logic [31:0]            rs2_data_ex;
    logic [2:0]             funct3_ex;
    alu_subopcodes          alu_subopcode_ex;
    logic                   lsu_funct_en_ex;
    result_mux              wb_target_ex;
    logic                   alu_src_a_ex;
    logic                   alu_src_b_ex;

    //PIPELINE SIGNALS
    logic                   stall_lsu;
    logic                   branch_taken;

    fetch_top fetch_top (
        .clk_i       (clk_i),
        .rst_i       (rst_i),
        .stall_f     (stall_f),
        .flush_f     (flush_f),
        .pc_mux_sel_i(pc_mux_sel),
        .instr_mem_i (instr_data_i),
        .pc_offset_i (pc_offset),
        .instr_addr_o(instr_addr_o),
        .pc_fd_o     (pc_fd),
        .instr_fd_o  (instr_fd)
    );

    if_id_registers if_id_registers (
        .clk_i    (clk_i),
        .rst_i    (rst_i),
        .stall_d  (stall_d),
        .flush_d  (flush_d),
        .instr_f_i(instr_fd),
        .pc_d_i   (pc_fd),
        .instr_d_o(instr_dd),
        .pc_d_o   (pc_dx)
    );

    id_top id_top (
        .instr_d_i        (instr_dd),
        .imm_x_o          (imm_dx),
        .funct3_x_o       (funct3_dx),
        .alu_subopcode_x_o(alu_subopcode_dx),
        .lsu_funct_en_x_o (lsu_funct_en_dx),
        .wb_target_x_o    (wb_target_dx),
        .alu_src_a_x_o    (alu_src_a_dx),
        .alu_src_b_x_o    (alu_src_b_dx),
        .rs1_addr_regfile (rs1_addr_regfile),
        .rs2_addr_regfile (rs2_addr_regfile),
        .rd_addr_regfile  (rd_addr_regfile),
        .branch_in_pipe_o (branch_in_pipe)
    );

    regfile regfile (
        .clk_i     (clk_i),
        .rst_i     (rst_i),
        .rs1_addr_i(rs1_addr_regfile),
        .rs2_addr_i(rs2_addr_regfile),
        .rd_addr_i (rd_addr_regfile),
        .rd_data_i (rd_data),
        .write_en_i(reg_wen),
        .rs1_data_o(rs1_data),
        .rs2_data_o(rs2_data)
    );

    id_ex_registers id_ex_registers (
        .clk_i            (clk_i),
        .rst_i            (rst_i),
        .stall_x          (stall_x),
        .flush_x          (flush_x),
        .pc_x_i           (pc_dx),
        .imm_x_i          (imm_dx),
        .rs1_data_i       (rs1_data),
        .rs2_data_i       (rs2_data),
        .funct3_x_i       (funct3_dx),
        .alu_subopcode_x_i(alu_subopcode_dx),
        .lsu_funct_en_x_i (lsu_funct_en_dx),
        .wb_target_x_i    (wb_target_dx),
        .alu_src_a_x_i    (alu_src_a_dx),
        .alu_src_b_x_i    (alu_src_b_dx),
        .pc_x_o           (pc_ex),
        .imm_x_o          (imm_ex),
        .rs1_data_x_o     (rs1_data_ex),
        .rs2_data_x_o     (rs2_data_ex),
        .funct3_x_o       (funct3_ex),
        .alu_subopcode_x_o(alu_subopcode_ex),
        .lsu_funct_en_x_o (lsu_funct_en_ex),
        .wb_target_x_o    (wb_target_ex),
        .alu_src_a_o      (alu_src_a_ex),
        .alu_src_b_o      (alu_src_b_ex)
    );

    ex_top ex_top (
        .pc_x_i           (pc_ex),
        .imm_x_i          (imm_ex),
        .rs1_data_x_i     (rs1_data_ex),
        .rs2_data_x_i     (rs2_data_ex),
        .funct3_x_i       (funct3_ex),
        .alu_subopcode_x_i(alu_subopcode_ex),
        .lsu_funct_en_x_i (lsu_funct_en_ex),
        .wb_target_x_i    (wb_target_ex),
        .alu_src_a_i      (alu_src_a_ex),
        .alu_src_b_i      (alu_src_b_ex),
        .mem_data_i       (mem_data_i),
        .pc_o             (pc_offset),
        .reg_data_o       (rd_data),
        .mem_data_o       (mem_data_o),
        .mem_addr_o       (mem_addr_o),
        .mem_wen_o        (mem_wen_o),
        .pc_wen_o         (pc_mux_sel),
        .reg_wen_o        (reg_wen),
        .stall_o          (stall_lsu),
        .branch_taken_o   (branch_taken)
    );

    pipeline_controller pipeline_controller (
        .stall_lsu_i   (stall_lsu),
        .branch_in_pipe(branch_in_pipe),
        .branch_taken_i(branch_taken),
        .stall_f       (stall_f),
        .stall_d       (stall_d),
        .stall_x       (stall_x),
        .flush_f       (flush_f),
        .flush_d       (flush_d),
        .flush_x       (flush_x)
    );

endmodule
