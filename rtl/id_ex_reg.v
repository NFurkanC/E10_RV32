`include "../include/rv32_opcodes.vh"

module id_ex_reg (
    input wire       clk_i,
    input wire       rst_i,

    input wire       flush_ex,

    input wire [3:0] alu_op_d,
    input wire [31:0] reg_1_d,
    input wire [31:0] reg_2_d,
    input wire [31:0] imm_data_d,
    input wire [31:0] pc_d,
    input wire [31:0] pc_next_d,

    input wire [1:0] alu_mux_sel_d,
    input wire [4:0] reg_dest_addr_d,
    input wire       mem_write_sel_d,
    input wire [2:0] result_mux_sel_d,
    input wire       reg_write_d,
    input wire [31:0] branch_data_d,
    input wire [31:0] jump_addr_d,
    input wire [2:0] lsu_op_d, 

    //OUTPUTS
    
    output reg [3:0]    alu_op_ex,
    output reg [31:0]   reg_1_ex,
    output reg [31:0]   reg_2_ex,
    output reg [31:0]   imm_data_ex,
    output reg [31:0]   pc_ex,
    output reg [31:0]   pc_next_ex,

    output wire [1:0]   alu_mux_sel_ex,
    output wire [4:0]   reg_dest_addr_ex,
    output wire         mem_write_sel_ex,
    output wire [2:0]   result_mux_sel_ex,
    output wire         reg_write_ex,
    output wire [31:0]  branch_data_ex,
    output wire [31:0]  jump_addr_ex,
    output wire [2:0]   lsu_op_ex
);

    always *(posedge(clk_i) or posedge(rst_i)) begin
        if (rst_i || flush_ex) begin
            alu_op_ex <= 4'b0;
            reg_1_ex <= 32'b0;
            reg_2_ex <= 32'b0;
            imm_data_ex <= 32'b0;
            pc_ex <= 32'b0;
            pc_next_ex <= 32'b0;

            alu_mux_sel_ex <= 2'b0;
            reg_dest_addr_ex <= 5'b0;
            mem_write_sel_ex <= 1'b0;
            result_mux_sel_ex <= 3'b0;
            reg_write_ex <= 1'b0;
            branch_data_ex <= 32'b0;
            jump_addr_ex <= 32'b0;
            lsu_op_ex <= 3'b0;
        end
        else begin
            alu_op_ex <= alu_op_d;
            reg_1_ex <= reg_1_d;
            reg_2_ex <= reg_2_d;
            imm_data_ex <= imm_data_d;
            pc_ex <= pc_d;
            pc_next_ex <= pc_next_d;

            alu_mux_sel_ex <= alu_mux_sel_d;
            reg_dest_addr_ex <= reg_dest_addr_d;
            mem_write_sel_ex <= mem_write_sel_d;
            result_mux_sel_ex <= result_mux_sel_d;
            reg_write_ex <= reg_write_d;
            branch_data_ex <= branch_data_d;
            jump_addr_ex <= jump_addr_d;
            lsu_op_ex <= lsu_op_d;  

        end
    end

endmodule 