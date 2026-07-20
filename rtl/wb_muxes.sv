module wb_mux_top 
import e10_base_pkg::*;
(
    input result_mux    wb_i,
    input logic         branch_valid_i,
    input logic [31:0]  alu_result_i,
    input logic [31:0]  lsu_data_i,
    input logic [31:0]  pc_i,
    input logic         data_source_sel,

//  output logic [31:0] lsu_data_o,
    output logic [31:0] reg_data_o,
    output logic [31:0] pc_o,
    output logic        pc_wen_o,
    output logic        reg_wen_o,
    output logic        branch_stall
);
    
    logic [31:0] data_i; 
    always_comb begin
        data_i = (data_source_sel) ? lsu_data_i : alu_result_i;
        //lsu_data_o = 32'b0;
        reg_data_o = 32'b0;
        pc_o = 32'b0;
        pc_wen_o = 1'b0;
        reg_wen_o = 1'b0;
        branch_stall = 1'b0;
        unique case(wb_i)
            RESULT_MUX_R: begin
                reg_data_o = data_i;
                reg_wen_o = 1'b1;
            end
            RESULT_MUX_MEM: ;
            RESULT_MUX_PC: begin
                if(branch_valid_i) begin
                    pc_wen_o = 1'b1;
                    pc_o = data_i;
                    branch_stall = 1'b1;
                end
            end
            RESULT_MUX_J: begin
                reg_data_o = pc_i + 4;
                pc_o = data_i;
                pc_wen_o = 1'b1;
                reg_wen_o = 1'b1;
            end
        endcase
    end

endmodule
