module regfile
(
    input logic         clk_i,
    input logic         rst_i,

    input logic [4:0]   rs1_addr_i,
    input logic [4:0]   rs2_addr_i,
    input logic [4:0]   rd_addr_i,
    input logic [31:0]  rd_data_i,
    input logic         write_en_i,

    output logic [31:0] rs1_data_o,
    output logic [31:0] rs2_data_o
);

    reg [31:0] registers[31:0];
    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            registers <= '{default: '0};
        end
        else if (write_en_i && (rd_addr_i == 5'b0)) begin
            registers[rd_addr_i] <= rd_data_i;
        end
    end

    assign rs1_data_o = (rs1_addr_i == 5'b0) ? 32'b0 : registers[rs1_addr_i];
    assign rs2_data_o = (rs2_addr_i == 5'b0) ? 32'b0 : registers[rs2_addr_i];
endmodule
