module ALU_MUX (
    input reg [31:0] pc_ex,
    input reg [31:0] reg_1_in,
    input reg [31:0] reg_2_in,
    input reg [31:0] imm_data_in,
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
        endcase
    end

endmodule

module ALU (
    input wire [4:0] alu_op,
    input reg [31:0] data_1_in,
    input reg [31:0] data_2_in,
    output reg [31:0] alu_result_out,
    output wire alu_zero_out
);
    always @(*) begin
        case (alu_op)
            5'b00000: 
endmodule