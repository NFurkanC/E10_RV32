module pc_reg_addr_mux #(
    parameter PC_BOOT_ADDR = 32'b0
)(
    input logic         clk_i,
    input logic         rst_i,

    //input logic         flush_pc,
    input logic         stall_pc,

    input logic [31:0]  offset_add_i,
    input logic         pc_mux_i,

    output reg [31:0]   pc_o
);

    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            pc_o <= PC_BOOT_ADDR;
        end
        /*else if (flush_pc) begin
            pc_o <= PC_BOOT_ADDR;
        end*/
        else if (!stall_pc) begin
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

