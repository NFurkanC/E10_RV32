`include "../include/rv32_opcodes.vh"

module decode (
  input wire clk_i,
  input wire rst_i,

  input wire [31:0] instr_in,
  input wire [31:0] result_in,

  output wire [3:0] alu_op_out,
  output reg [31:0] reg_1_data_out,
  output reg [31:0] reg_2_data_out,
  output reg [31:0] imm_data_out,
  output reg [31:0] pc_next_out,
  output wire [1:0] alu_mux_sel_out,
  output wire [4:0] reg_dest_addr_out,
  output wire       mem_write_en_out,
  output wire [2:0] result_mux_sel_out,
  output wire regfile_write_en_out
);
    wire [6:0] opcode;
    wire [4:0] field_1;
    wire [2:0] funct3;
    wire [4:0] field_2;
    wire [4:0] field_3;
    wire [6:0] funct7;

    decode_seperator seperator (
        .instr_in (instr_in),
        .opcode (opcode),
        .field_1 (field_1),
        .funct3 (funct3),
        .field_2 (field_2),
        .field_3 (field_3),
        .funct7 (funct7)
    );

    decode_controller dec_controller (
        .
    );

endmodule

module decode_seperator (
    input wire [31:0] instr_in,
    
    //field_1 -> rd position
    //field_2 -> rs1 position
    //field_3 -> rs2 position
    output wire [6:0] opcode,
    output wire [4:0] field_1,
    output wire [2:0] funct3,
    output wire [4:0] field_2,
    output wire [4:0] field_3,
    output wire [6:0] funct7
);
    assign opcode = instr_in[6:0];
    assign field_1 = instr_in[11:7];
    assign funct3 = instr_in[14:12];
    assign field_2 = instr_in[19:15];
    assign field_3 = instr_in[24:20];
    assign funct7 = instr_in[31:25];

endmodule

module decode_controller (
    input wire [31:0] instr_in,
    input wire [6:0] opcode,
    input wire [4:0] field_1,
    input wire [2:0] funct3,
    input wire [4:0] field_2,
    input wire [4:0] field_3,
    input wire [6:0] funct7,

    output wire [3:0] alu_op,
    output reg [31:0] imm_data,
    output wire [1:0] alu_mux,
    output reg [31:0] reg_1_data,
    output reg [31:0] reg_2_data,
    output wire       mem_write_en,
    output wire       regfile_write_en,
    output reg [31:0] branch_data,
    output reg [31:0] jump_addr,
    output w`RESULT_MUX_R:0] result_mux_sel,
    output wire [2:0] lsu_op
);

    //RESULT MUX 
    //000 -> register access
    //001 -> mem access
    //010 -> PC access
    //011 -> Branch access

    //LSU OP
    //
    //
    //

    always @(*) begin
        //Latch prevention
        regfile_write_en = 0;
        mem_write_en = 0;
        branch_data = 0;
        jump_addr = 0;
        alu_mux = 0;
        alu_op = 0;
        lsu_op = 0;
        result_mux_sel = 0;

        case(instr_in)
        //-----------------R-TYPE-----------------//
        `OP_ADD: begin
            regfile_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SUB: begin
            regfile_write_en = 1;
            alu_op = `ALU_SUB;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_AND: begin
            regfile_write_en = 1;
            alu_op = `ALU_AND;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_OR: begin
            regfile_write_en = 1;
            alu_op = `ALU_OR;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_XOR: begin
            regfile_write_en = 1;
            alu_op = `ALU_XOR;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SLL: begin
            regfile_write_en = 1;
            alu_op = `ALU_SLL;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SRL: begin
            regfile_write_en = 1;
            alu_op = `ALU_SRL;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SRA: begin
            regfile_write_en = 1;
            alu_op = `ALU_SRA;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SLT: begin
            regfile_write_en = 1;
            alu_op = `ALU_SLT;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SLTA: begin
            regfile_write_en = 1;
            alu_op = `ALU_SLTA;
            alu_mux = `ALU_MUX_R;
            result_mux_sel = `RESULT_MUX_R;
        end

        //-----------------I-TYPE-----------------//
        `OP_ADDI: begin
            regfile_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_I;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SLTI: begin
            regfile_write_en = 1;
            alu_op = `ALU_SLT;
            alu_mux = `ALU_MUX_I;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SLTIU: begin
            regfile_write_en = 1;
            alu_op = `ALU_SLTA;
            alu_mux = `ALU_MUX_I;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_XORI: begin
            regfile_write_en = 1;
            alu_op = `ALU_XOR;
            alu_mux = `ALU_MUX_I;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_ORI: begin
            regfile_write_en = 1;
            alu_op = `ALU_OR;
            alu_mux = `ALU_MUX_I;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_ANDI: begin
            regfile_write_en = 1;
            alu_op = `ALU_AND;
            alu_mux = `ALU_MUX_I;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SLLI: begin
            regfile_write_en = 1;
            alu_op = `ALU_SLL;
            alu_mux = `ALU_MUX_I;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SRLI: begin
            regfile_write_en = 1;
            alu_op = `ALU_SRL;
            alu_mux = `ALU_MUX_I;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
            result_mux_sel = `RESULT_MUX_R;
        end
        `OP_SRAI: begin
            regfile_write_en = 1;
            alu_op = `ALU_SRA;
            alu_mux = `ALU_MUX_I;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
            result_mux_sel = `RESULT_MUX_R;
        end

        //-----------------LOAD-INSTRUCTIONS-----------------//
        `OP_LB: begin
            mem_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_I;
            lsu_op = `LSU_LB;
            result_mux_sel = `RESULT_MUX_MEM;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
        end
        `OP_LH: begin
            mem_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_I;
            lsu_op = `LSU_LH;
            result_mux_sel = `RESULT_MUX_MEM;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
        end
        `OP_LW: begin
            mem_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_I;
            lsu_op = `LSU_LW;
            result_mux_sel = `RESULT_MUX_MEM;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
        end
        `OP_LBU: begin
            mem_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_I;
            lsu_op = `LSU_LBU;
            result_mux_sel = `RESULT_MUX_MEM;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
        end
        `OP_LHU: begin
            mem_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_I;
            lsu_op = `LSU_LHU;
            result_mux_sel = `RESULT_MUX_MEM;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
        end

        //-----------------STORE-INSTRUCTIONS-----------------//
        `OP_SB: begin
            mem_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_I;
            lsu_op = `LSU_SB;
            result_mux_sel = `RESULT_MUX_MEM;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
        end
        `OP_SH: begin
            mem_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_I;
            lsu_op = `LSU_SH;
            result_mux_sel = `RESULT_MUX_MEM;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
        end
        `OP_SW: begin
            mem_write_en = 1;
            alu_op = `ALU_ADD;
            alu_mux = `ALU_MUX_I;
            lsu_op = `LSU_SW;
            result_mux_sel = `RESULT_MUX_MEM;
            imm_data = {20{instr_in[31]}, instr_in[31:20]};
        end

        //-----------------BRANCH-INSTRUCTIONS-----------------//
        
        endcase 

    end

endmodule

      
  