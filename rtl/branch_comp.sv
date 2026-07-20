module branch_comparator 
import e10_base_pkg::*;
(
    input logic [31:0]      rs1_i,
    input logic [31:0]      rs2_i,
    input logic [2:0]       funct_3_i,
    input result_mux        wb_i,

    output logic            branch_valid_o              
);
    
    always_comb begin
        branch_valid_o = 1'b0;
        if(wb_i == RESULT_MUX_PC) begin
            unique case(funct_3_i)
                3'b000: branch_valid_o = rs1_i == rs2_i; 
                3'b001: branch_valid_o = rs1_i != rs2_i;
                3'b100: branch_valid_o = signed'(rs1_i) < signed'(rs2_i);
                3'b101: branch_valid_o = signed'(rs1_i) >= signed'(rs2_i);
                3'b110: branch_valid_o = rs1_i < rs2_i;
                3'b111: branch_valid_o = rs1_i >= rs2_i;
            endcase
        end
    end

endmodule
