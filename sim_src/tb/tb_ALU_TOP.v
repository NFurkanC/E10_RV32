`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2025 22:20:38
// Design Name: 
// Module Name: tb_ALU_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module tb_ALU_Top;

    // Inputs
    reg [31:0] pc_ex;
    reg [31:0] reg_1_in;
    reg [31:0] reg_2_in;
    reg [31:0] imm_data_in;
    reg [1:0]  alu_mode_select;
    reg [4:0]  alu_op;

    // Outputs
    wire [31:0] alu_result_out;
    wire        alu_zero_out;

    // Opcodes (Header dosyana göre burayı düzenleyebilirsin)
    // Örnek değerler atıyorum:
    localparam ALU_ADD  = 5'd0;
    localparam ALU_SUB  = 5'd1;
    localparam ALU_AND  = 5'd2;
    localparam ALU_OR   = 5'd3;
    localparam ALU_XOR  = 5'd4;
    localparam ALU_SLL  = 5'd5;
    localparam ALU_SRL  = 5'd6;
    localparam ALU_SRA  = 5'd7;
    localparam ALU_SLT  = 5'd8; // Signed Less Than

    // Mux Mode Parametreleri
    localparam MODE_R_TYPE = 2'b00;
    localparam MODE_I_TYPE = 2'b01;
    localparam MODE_AUIPC  = 2'b10;
    localparam MODE_LUI    = 2'b11;

    // Unit Under Test (UUT)
    ALU_Top uut (
        .pc_ex(pc_ex), 
        .reg_1_in(reg_1_in), 
        .reg_2_in(reg_2_in), 
        .imm_data_in(imm_data_in), 
        .alu_mode_select(alu_mode_select), 
        .alu_op(alu_op), 
        .alu_result_out(alu_result_out), 
        .alu_zero_out(alu_zero_out)
    );

    initial begin
        // Simülasyon izleme
        $monitor("Time=%0t | Mode=%b Op=%d | In1=%h In2=%h PC=%h Imm=%h | Res=%h Zero=%b", 
                 $time, alu_mode_select, alu_op, reg_1_in, reg_2_in, pc_ex, imm_data_in, alu_result_out, alu_zero_out);

        // Başlangıç Değerleri
        pc_ex = 0;
        reg_1_in = 0;
        reg_2_in = 0;
        imm_data_in = 0;
        alu_mode_select = 0;
        alu_op = 0;

        #10;
        
        // ------------------------------------------
        // TEST 1: R-Type (ADD) -> Reg1 + Reg2
        // ------------------------------------------
        $display("--- Test 1: R-Type ADD (10 + 20) ---");
        alu_mode_select = MODE_R_TYPE; // Reg1 ve Reg2 seçili
        reg_1_in = 32'd10;
        reg_2_in = 32'd20;
        alu_op   = ALU_ADD;
        #10;
        // Beklenen: 30 (0x1E)

        // ------------------------------------------
        // TEST 2: I-Type (SUB) -> Reg1 - Imm (Negatif sonuç testi)
        // Not: I-Type genelde ADDI olur ama MUX mantığını test ediyoruz.
        // ------------------------------------------
        $display("--- Test 2: I-Type SUB (10 - 5) ---");
        alu_mode_select = MODE_I_TYPE; // Reg1 ve Imm seçili
        reg_1_in = 32'd10;
        imm_data_in = 32'd5;
        alu_op   = ALU_SUB;
        #10;
        // Beklenen: 5

        // ------------------------------------------
        // TEST 3: Logic Operations (AND/OR)
        // ------------------------------------------
        $display("--- Test 3: AND Operation (0xAA & 0x0F) ---");
        alu_mode_select = MODE_R_TYPE;
        reg_1_in = 32'h000000AA; 
        reg_2_in = 32'h0000000F;
        alu_op   = ALU_AND;
        #10;
        // Beklenen: 0x0A

        // ------------------------------------------
        // TEST 4: AUIPC (PC + Imm)
        // ------------------------------------------
        $display("--- Test 4: AUIPC (PC=1000 + Imm=4) ---");
        alu_mode_select = MODE_AUIPC; // PC ve Imm seçili
        pc_ex = 32'd1000;
        imm_data_in = 32'd4;
        alu_op = ALU_ADD; // Genelde AUIPC bir toplama işlemidir
        #10;
        // Beklenen: 1004

        // ------------------------------------------
        // TEST 5: Zero Flag Testi (Sub -> 0)
        // ------------------------------------------
        $display("--- Test 5: Zero Flag (50 - 50) ---");
        alu_mode_select = MODE_R_TYPE;
        reg_1_in = 32'd50;
        reg_2_in = 32'd50;
        alu_op   = ALU_SUB;
        #10;
        // Beklenen: Result=0, Zero=1

        // ------------------------------------------
        // TEST 6: SLT (Signed Less Than)
        // -10 < 5 ? Evet (1)
        // ------------------------------------------
        $display("--- Test 6: SLT (-10 < 5) ---");
        alu_mode_select = MODE_R_TYPE;
        reg_1_in = -32'd10; // 0xFFFFFFF6
        reg_2_in = 32'd5;
        alu_op   = ALU_SLT;
        #10;
        // Beklenen: 1

        $display("Test tamamlandi.");
        $finish;
    end

endmodule
