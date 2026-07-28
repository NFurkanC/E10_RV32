module decode_controller
import e10_base_pkg::*;
(
    input logic [6:0]   opcode_i,
    input logic [2:0]   funct3_i,
    input logic [6:0]   funct7_i,

    output alu_subopcodes  alu_subopcode_o,
    output logic        lsu_funct_en_o,
    output result_mux   wb_target_o,
    output logic        alu_src_a,
    output logic        alu_src_b,
    output logic        branch_in_pipe_o
);
    
    always_comb begin
        alu_subopcode_o = ALU_NONE;
        lsu_funct_en_o = 1'b0;
        wb_target_o = RESULT_MUX_R;
        alu_src_a = 1'b0; // 0 = rs1, 1 = pc
        alu_src_b = 1'b0; // 0 = rs2, 1 = imm
        branch_in_pipe_o = 1'b0;
        case (opcode_i)
            OPCODE_AUIPC: begin
                alu_subopcode_o = ALU_ADD;
                wb_target_o = RESULT_MUX_R;
                alu_src_a = 1'b1;
            end
            OPCODE_LUI: begin
                alu_subopcode_o = ALU_ADD;
                wb_target_o = RESULT_MUX_R;
                alu_src_b = 1'b1;
            end
            OPCODE_OP: begin
                wb_target_o = RESULT_MUX_R;
                unique case(funct3_i)
                    3'b000: alu_subopcode_o = (funct7_i == 7'b0110000) ? ALU_SUB : ALU_ADD;
                    3'b001: alu_subopcode_o = ALU_SLL;
                    3'b010: alu_subopcode_o = ALU_SLT;
                    3'b011: alu_subopcode_o = ALU_SLTU;
                    3'b100: alu_subopcode_o = ALU_XOR;
                    3'b101: alu_subopcode_o = (funct7_i == 7'b0100000) ? ALU_SRA : ALU_SRL;
                    3'b110: alu_subopcode_o = ALU_OR;
                    3'b111: alu_subopcode_o = ALU_AND; 
                endcase
            end
            OPCODE_OP_IMM: begin
                wb_target_o = RESULT_MUX_R;
                alu_src_b = 1'b1;
                unique case(funct3_i)
                    3'b000: alu_subopcode_o = ALU_ADD;
                    3'b010: alu_subopcode_o = ALU_SLT;
                    3'b011: alu_subopcode_o = ALU_SLTU;
                    3'b100: alu_subopcode_o = ALU_XOR;
                    3'b110: alu_subopcode_o = ALU_OR;
                    3'b111: alu_subopcode_o = ALU_AND;
                    3'b001: begin
                     alu_subopcode_o = ALU_SLL;
                        alu_src_b = 1'b0;
                    end
                    3'b101: begin
                     alu_subopcode_o = (funct7_i == 7'b0100000) ? ALU_SRA : ALU_SRL;
                        alu_src_b = 1'b0;
                    end 
                endcase
            end
            OPCODE_LOAD: begin
                wb_target_o = RESULT_MUX_R;
                alu_src_a = 1'b0;
                alu_src_b = 1'b1;
                alu_subopcode_o = ALU_ADD;
                lsu_funct_en_o = 1'b1; // pass funct3 to LSU
            end
            OPCODE_STORE: begin
                wb_target_o = RESULT_MUX_MEM;
                alu_src_a = 1'b0;
                alu_src_b = 1'b1;
                lsu_funct_en_o = 1'b1; //pass funct3 to LSU 
            end
            OPCODE_BRANCH: begin
                wb_target_o = RESULT_MUX_PC; //pass funct3 to BRCOMP
                alu_subopcode_o = ALU_ADD;
                alu_src_a = 1'b1;
                alu_src_b = 1'b1;
                branch_in_pipe_o = 1'b1;
            end 
            OPCODE_JAL: begin
                wb_target_o = RESULT_MUX_J;
                alu_subopcode_o = ALU_ADD;
                alu_src_a = 1'b1;
                alu_src_b = 1'b1;
                branch_in_pipe_o = 1'b1;
            end
            OPCODE_JALR: begin
                wb_target_o = RESULT_MUX_J;
                alu_subopcode_o = ALU_ADD;
                alu_src_a = 1'b0;
                alu_src_b = 1'b1;
                branch_in_pipe_o = 1'b1;
            end
            default: ;
        endcase
    end
/*
    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
         alu_subopcode_o <= ALU_NONE;
            lsu_funct_en_o <= 1'b0;
            wb_target_o <= RESULT_MUX_NONE;
            alu_src_a <= 1'b0;
            alu_src_b <= 1'b0;
            imm_flag_o <= 1'b0;
        end
        else begin
            case(opcode_i)
            OPCODE_AUIPC: begin
             alu_subopcode_o <= ALU_ADD;
                wb_target_o <= RESULT_MUX_R;
                pc_flag_ex_o <= 1'b1;
            end
            OPCODE_LUI: begin
             alu_subopcode_o <= ALU_NONE;
                wb_target_o <= RESULT_MUX_R;
            end
            OPCODE_OP: begin
                unique case(funct3_i)
                    3'b000: begin //ADD/SUB
                        unique case(funct7_i)
                            7'b0000000: begin //ADD
                             alu_subopcode_o <= ALU_ADD;
                                wb_target_o <= RESULT_MUX_R;
                            end
                            7'b0110000: begin //SUB
                             alu_subopcode_o <= ALU_SUB;
                                wb_target_o <= RESULT_MUX_R;
                            end
                        endcase
                    end 
                    3'b001: begin //SLL
                     alu_subopcode_o <= ALU_SLL;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b010: begin //SLT
                     alu_subopcode_o <= ALU_SLT;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b011: begin //SLTU
                     alu_subopcode_o <= ALU_SLTU;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b100: begin //XOR
                     alu_subopcode_o <= ALU_XOR;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b101: begin //SRL/SRA
                        unique case(funct7_i)
                            7'b0000000: begin //SRL
                             alu_subopcode_o <= ALU_SRL;
                                wb_target_o <= RESULT_MUX_R;
                            end
                            7'b0100000: begin //SRA
                             alu_subopcode_o <= ALU_SRA;
                                wb_target_o <= RESULT_MUX_R;
                            end
                        endcase
                    end
                    3'b110: begin //OR
                     alu_subopcode_o <= ALU_OR;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b111: begin //AND
                     alu_subopcode_o <= ALU_AND;
                        wb_target_o <= RESULT_MUX_R;
                    end
                endcase
            end
            OPCODE_OP_IMM: begin
                unique case(funct3_i)
                    3'b000: begin
                     alu_subopcode_o <= ALU_ADD;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b010: begin
                     alu_subopcode_o <= ALU_SLT;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b011: begin
                     alu_subopcode_o <= ALU_SLTU;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b100: begin
                     alu_subopcode_o <= ALU_XOR;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b110: begin
                     alu_subopcode_o <= ALU_OR;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b111: begin
                     alu_subopcode_o <= ALU_AND;
                        wb_target_o <= RESULT_MUX_R;
                    end
                    3'b001: begin
                     alu_subopcode_o <= ALU_SLL;
                        wb_target_o <= RESULT_MUX_R;
                        shamt_flag_ex_o <= 1'b1;
                    end
                    3'b101: begin
                        unique case(funct7_i)
                            7'b0000000: begin
                             alu_subopcode_o <= ALU_SRL;
                                wb_target_o <= RESULT_MUX_R;
                                shamt_flag_ex_o <= 1'b1;
                            end
                            7'b0100000: begin
                             alu_subopcode_o <= ALU_SRA;
                                wb_target_o <= RESULT_MUX_R;
                                shamt_flag_ex_o <= 1'b1;
                            end 
                        endcase
                    end
                endcase
            end
            OPCODE_LOAD: begin
                
            end
            default: begin
             alu_subopcode_o <= ALU_NONE;
                lsu_funct_en_o <= 1'b0;
                wb_target_o <= RESULT_MUX_NONE;
            end
            endcase
        end
    end
*/
endmodule
