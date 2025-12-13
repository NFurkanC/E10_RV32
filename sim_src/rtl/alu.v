`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2025 22:09:44
// Design Name: 
// Module Name: alu
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
`include "rv32_opcodes.vh"

module ALU_MUX (
    input wire [31:0] pc_ex,
    input wire [31:0] reg_1_in,
    input wire [31:0] reg_2_in,
    input wire [31:0] imm_data_in,
    input wire [1:0] alu_mode_select,
    output reg [31:0] alu_data_1_out,
    output reg [31:0] alu_data_2_out
);

    always @(*) begin
        case (alu_mode_select)
            2'b00: begin //R type
                alu_data_1_out <= reg_1_in;
                alu_data_2_out <= reg_2_in;
            end
            2'b01: begin //I type
                alu_data_1_out <= reg_1_in;
                alu_data_2_out <= imm_data_in;
            end
            2'b10: begin //AUIPC
                alu_data_1_out <= pc_ex;
                alu_data_2_out <= imm_data_in;
            end
            2'b11: begin //LUI
                alu_data_1_out <= pc_ex;
                alu_data_2_out <= reg_1_in;
            end
        endcase;
    end

endmodule

module ALU (
    input wire [4:0] alu_op,
    input wire [31:0] data_1_in,
    input wire [31:0] data_2_in,
    output reg [31:0] alu_result_out,
    output reg alu_zero_out
);
    always @(*) begin
        case (alu_op)
            `ALU_ADD: alu_result_out = data_1_in + data_2_in;
            `ALU_SUB: alu_result_out = data_1_in - data_2_in;
            `ALU_AND: alu_result_out = data_1_in & data_2_in;
            `ALU_OR : alu_result_out = data_1_in | data_2_in;
            `ALU_XOR: alu_result_out = data_1_in ^ data_2_in;
            `ALU_SLL: alu_result_out = data_1_in << data_2_in[4:0];
            `ALU_SRL: alu_result_out = data_1_in >> data_2_in[4:0];
            `ALU_SRA: alu_result_out = $signed(data_1_in) >>> data_2_in[4:0];
            `ALU_SLT: alu_result_out = ($signed(data_1_in) < $signed(data_2_in)) ? 32'b1 : 32'b0;
            `ALU_SLTA: alu_result_out = (data_1_in < data_2_in) ? 32'b1 : 32'b0;
            default: alu_result_out = 32'b0;
        endcase;
        alu_zero_out = (alu_result_out == 32'b0);
    end 

endmodule
