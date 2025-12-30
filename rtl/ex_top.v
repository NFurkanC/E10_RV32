//PARTLY INCOMPLETE - MIGHT WORK WITH ALU BUT NO LSU INTEGRATED
`include "../include/rv32_opcodes.vh"

module ex_top (
    input wire [3:0]    alu_op_ex,
    input wire [31:0]   reg_1_ex,
    input wire [31:0]   reg_2_ex,
    input wire [31:0]   imm_data_ex,
    input wire [31:0]   pc_ex,
    input wire [31:0]   pc_next_ex,

    input wire [1:0]    alu_mux_sel_ex,
    input wire [4:0]    reg_dest_addr_ex,
    input wire          mem_write_sel_ex,
    input wire [2:0]    result_mux_sel_ex,
    input wire          reg_write_ex,
    input wire [31:0]   branch_data_ex,
    input wire [31:0]   jump_addr_ex,
    input wire [2:0]    lsu_op_ex,

    output reg [2:0]    result_mux_control,
    output reg [31:0]   result_data_control,

    //result_data_control can store register data, 
    //branch data or jump address. This signal will
    //get assigned depending on result_mux_sel_ex.
    //result_mux_sel_ex gets passed to result_mux_control.
    //_control signals go to core_control.

    output wire [31:0]  mem_wb_data,
    output wire [31:0]  mem_wb_addr
);

    wire [31:0] alu_result;
    wire alu_zero;

    ALU_Top alu_top(
        .pc_ex (pc_ex),
        .reg_1_in (reg_1_ex),
        .reg_2_in (reg_2_ex),
        .imm_data_in (imm_data_ex),
        .alu_mode_select (alu_mux_sel_ex),
        .alu_op (alu_op_ex),
        .alu_result_out (alu_result),
        .alu_zero_out (alu_zero)
    );

endmodule