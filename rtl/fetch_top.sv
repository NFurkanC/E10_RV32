/* module fetch_top (
    input logic         clk_i,
    input logic         rst_i,
    
    input logic         stall_f,
    input logic         flush_f,

    input logic         pc_mux_sel_i,
    input logic [31:0]  instr_mem_i,
    input logic [31:0]  pc_offset_i,

    output logic [31:0] instr_addr_o,   //memory side
    output reg [31:0] pc_fd_o,        //pipeline side
    output reg [31:0] instr_fd_o
);

    logic [31:0] pc_out;

    pc_reg_addr_mux pc (clk_i,
    rst_i,
    //flush_f,
    stall_f,
    pc_offset_i,
    pc_mux_sel_i,
    pc_out
    );

    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            instr_fd_o <= 32'b0;
            pc_fd_o <= 32'b0;
            instr_addr_o <= 32'b0;
        end
        else if(flush_f) begin
            instr_fd_o <= 32'b0;
            pc_fd_o <= 32'b0;
           // instr_addr_o <= pc_out;
        end
        else if(!stall_f) begin
            instr_addr_o <= pc_out;
            pc_fd_o <= instr_addr_o;
            instr_fd_o <= instr_mem_i;
        end
    end

endmodule */

module fetch_top (
    input logic         clk_i,
    input logic         rst_i,
    
    input logic         stall_f,
    input logic         stall_d, // Yeni eklendi: Decode stall
    input logic         flush_f, // flush_f yerine flush_d kullanılmalı

    input logic         pc_mux_sel_i,
    input logic [31:0]  instr_mem_i,
    input logic [31:0]  pc_offset_i,

    output logic [31:0] instr_addr_o,   // memory side (PC)
    output reg [31:0]   pc_fd_o,        // pipeline side
    output reg [31:0]   instr_fd_o      // pipeline side
);

    logic [31:0] pc_out;

    pc_reg_addr_mux pc (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .stall_pc(stall_f),
        .offset_add_i(pc_offset_i),
        .pc_mux_i(pc_mux_sel_i),
        .pc_o(pc_out)
    );

    assign instr_addr_o = pc_out;

    // 2. BLOK: Sadece IF/ID Pipeline Registerlarını kontrol eder
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            instr_fd_o <= 32'b0;
            pc_fd_o    <= 32'b0;
        end
        else if (flush_f) begin
            // Branch alındığında bozuk buyruk NOP ile temizlenir
            instr_fd_o <= 32'h00000013; // RISC-V NOP
            pc_fd_o    <= 32'b0;
        end
        else if (!stall_d) begin
            pc_fd_o    <= instr_addr_o;
            instr_fd_o <= instr_mem_i;
        end
    end

endmodule

