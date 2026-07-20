module if_id_registers (

    input logic         clk_i,
    input logic         rst_i,

    input logic         stall_d,
    input logic         flush_d,

    input logic [31:0]  instr_f_i,
    input logic [31:0]  pc_d_i,

    output logic [31:0] instr_d_o,
    output logic [31:0] pc_d_o

);

    always_ff @(posedge clk_i or posedge rst_i) begin 
        if(rst_i) begin
            instr_d_o <= 32'b0;
            pc_d_o <= 32'b0;
        end
        else if(flush_d) begin
            instr_d_o <= 32'b0;
            pc_d_o <= 32'b0;
        end
        else if (!stall_d) begin
            instr_d_o <= instr_f_i;
            pc_d_o <= pc_d_i;
        end
    end
endmodule
