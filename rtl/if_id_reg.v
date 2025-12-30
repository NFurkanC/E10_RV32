`include "../include/rv32_opcodes.vh"

module if_id_reg (
    input wire clk_i,
    input wire rst_i,

    input wire stall_d,
    input wire flush_d,

    input reg [31:0] pc_f,
    input reg [31:0] instr_f,
    input reg [31:0] pc_next_f,

    output reg [31:0] pc_next_d,
    output reg [31:0] pc_d,
    output reg [31:0] instr_d
);

    always @(posedge(clk_i) or posedge(rst_i)) begin
        if (rst_i) begin
            pc_d <= 32'b0;
            instr_d <= OP_NOP;
            pc_next_d <= 32'b0;
        end
        else if(flush_d) begin
            //Reason for them being seperate is for synthesis purposes.
            pc_d <= 32'b0;
            instr_d <= OP_NOP;
            pc_next_d <= 32'b0;
        end
        else if (!stall) begin
            pc_d <= pc_f;
            instr_d <= instr_f;
            pc_next_d <= pc_next_f;
        end
    end

endmodule