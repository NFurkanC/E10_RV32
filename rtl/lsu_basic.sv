module lsu_basic
import e10_base_pkg::*;
(
    input logic [31:0]  address_result_i,
    input logic [31:0]  rs2_i,
    input logic [2:0]   funct_3_i,
    input logic         lsu_en_i,
    input logic [31:0]  mem_data_i,
    input result_mux    wb_i,

    output logic [31:0] mem_data_o,
    output logic [31:0] mem_addr_o,
    output logic [31:0] reg_data_o,

    output logic        mem_wen_o,
    output logic        stall_o
);

    always_comb begin
        reg_data_o = 32'b0;
        mem_data_o = 32'b0;
        mem_wen_o = 1'b0;
        mem_addr_o = address_result_i;
        case(wb_i)
            RESULT_MUX_R: begin
                unique case(funct_3_i)
                    3'b000: reg_data_o = {{24{mem_data_i[7]}}, mem_data_i[7:0]};
                    3'b001: reg_data_o = {{16{mem_data_i[15]}}, mem_data_i[15:0]};
                    3'b010: reg_data_o = mem_data_i;
                    3'b100: reg_data_o = {{24{1'b0}},mem_data_i[7:0]};
                    3'b101: reg_data_o = {{16{1'b0}},mem_data_i[15:0]};
                endcase
            end
            RESULT_MUX_MEM: begin
                unique case(funct_3_i)
                    3'b000: begin
                        mem_data_o = rs2_i[7:0];
                        mem_wen_o = lsu_en_i;
                    end
                    3'b001: begin
                        mem_data_o = rs2_i[15:0];
                        mem_wen_o = lsu_en_i;
                    end
                    3'b010: begin
                        mem_data_o = rs2_i;
                        mem_wen_o = lsu_en_i;
                    end
                endcase
            end
            RESULT_MUX_J: ;
            RESULT_MUX_PC: ;
            default:;
        endcase
    end

endmodule
