`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2025 22:18:54
// Design Name: 
// Module Name: ALU_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module ALU_Top (
    input wire [31:0] pc_ex,
    input wire [31:0] reg_1_in,
    input wire [31:0] reg_2_in,
    input wire [31:0] imm_data_in,
    input wire [1:0]  alu_mode_select,
    input wire [4:0]  alu_op,
    output wire [31:0] alu_result_out,
    output wire        alu_zero_out
);

    // Ara bağlantı kabloları (MUX çıkışı -> ALU girişi)
    wire [31:0] mux_out_1;
    wire [31:0] mux_out_2;

    // ALU MUX Modülünün Çağrılması
    ALU_MUX u_alu_mux (
        .pc_ex          (pc_ex),
        .reg_1_in       (reg_1_in),
        .reg_2_in       (reg_2_in),
        .imm_data_in    (imm_data_in),
        .alu_mode_select(alu_mode_select),
        .alu_data_1_out (mux_out_1),
        .alu_data_2_out (mux_out_2)
    );

    // ALU Modülünün Çağrılması
    ALU u_alu (
        .alu_op         (alu_op),
        .data_1_in      (mux_out_1),
        .data_2_in      (mux_out_2),
        .alu_result_out (alu_result_out),
        .alu_zero_out   (alu_zero_out)
    );

endmodule
