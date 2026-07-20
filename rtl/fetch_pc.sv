module pc_reg_addr_mux #(
    parameter PC_BOOT_ADDR = 32'b0
)(
    input logic         clk_i,
    input logic         rst_i,

    input logic [31:0]  offset_add_i,
    input logic         pc_mux_i,

    output reg [31:0]   pc_o
);

    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            pc_o <= PC_BOOT_ADDR;
        end
        else begin
            unique case (pc_mux_i)
                1'b0: begin
                    pc_o <= pc_o + 4;
                end 
                1'b1: begin
                    pc_o <= offset_add_i;
                end
            endcase
        end
    end
endmodule

module fetch_top (
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
            instr_addr_o <= 32'b0;
        end
        else if(!stall_f) begin
            instr_addr_o <= pc_out;
            pc_fd_o <= pc_out;
            instr_fd_o <= instr_mem_i;
        end
    end

endmodule

