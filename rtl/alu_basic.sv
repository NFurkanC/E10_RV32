//ALU for RV32I - combinational
import e10_base_pkg::*;
module alu_basic 
(
    input logic [31:0]      operand_1,
    input logic [31:0]      operand_2,
    input alu_subopcodes    subopcode,
    input logic             alu_en_i,

    output logic [31:0]     result_o
);
    
    always_comb begin
        result_o = 32'b0;
        if(alu_en_i) begin
            case (subopcode)
                ALU_ADD: result_o = operand_1 + operand_2;
                ALU_SUB: result_o = operand_1 - operand_2;
                ALU_AND: result_o = operand_1 & operand_2;
                ALU_OR: result_o = operand_1 | operand_2;
                ALU_XOR: result_o = operand_1 ^ operand_2;
                ALU_SLL: result_o = operand_1 << operand_2[4:0];
                ALU_SRL: result_o = operand_1 >> operand_2[4:0];
                ALU_SRA: result_o = unsigned'(signed'(operand_1) >>> operand_2[4:0]);
                ALU_SLT: result_o = (signed'(operand_1) < signed'(operand_2)) ? 32'b1 : 32'b0; 
                ALU_SLTU: result_o = (operand_1 < operand_2) ? 32'b1 : 32'b0;
                ALU_NONE: result_o = 32'b0;
                default: result_o = 32'b0;
            endcase    
        end
    end
endmodule

