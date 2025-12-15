`include "../include/rv32_opcodes.vh"

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
            `ALU_MUX_R: begin //R type
                alu_data_1_out <= reg_1_in;
                alu_data_2_out <= reg_2_in;
            end
            `ALU_MUX_I: begin //I type
                alu_data_1_out <= reg_1_in;
                alu_data_2_out <= imm_data_in;
            end
            `ALU_MUX_AUIPC: begin //AUIPC
                alu_data_1_out <= pc_ex;
                alu_data_2_out <= imm_data_in;
            end
            `ALU_MUX_LUI: begin //LUI
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