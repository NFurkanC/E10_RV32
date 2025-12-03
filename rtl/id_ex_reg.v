module id_ex_reg (
    input wire       clk_i,
    input wire       rst_i,

    input wire       flush_ex,

    input      [4:0] alu_op_d,
    input reg [31:0] reg_1_d,
    input reg [31:0] reg_2_d,
    input reg [31:0] imm_data_d,
    input reg [31:0] pc_d,
    input reg [31:0] pc_next_d,
    input wire [1:0] alu_mux_sel_d,
    input wire [4:0] reg_dest_addr_d,
    input wire       wb_sel_d,
    input wire [2:0] result_mux_sel_d,
    
    output 
);