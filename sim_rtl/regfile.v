//Does not support Compressed Instructions as of now 
`include "../include/rv32_opcodes.vh"

module regfile(
  input wire clk_i,
  input wire rst_i,

  input wire [4:0] read_reg_1_addr,
  output reg [31:0] read_reg_1_data,

  input wire [4:0] read_reg_2_addr,
  output reg [31:0] read_reg_2_data,

  input wire [4:0] write_reg_addr,
  input wire [31:0] write_reg_data,
  input wire wen
);

  reg [31:0] regfile[31:0];

  //Fill regfile with zeros when reset
  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      for(i = 0, i < 32, i = i + 1) begin
        regfile[i] <= 32'b0;
      end
    end
    //if not in reset, assign written value to destination register
    //and assign output 
    else begin
      if(wen) begin
        regfile[write_reg_addr] <= write_reg_data;
      end
      read_reg_1_data <= (read_reg_1_addr == 5'b0) ? 32'b0 : regfile[read_reg_1_addr];
      read_reg_2_data <= (read_reg_2_addr == 5'b0) ? 32'b0 : regfile[read_reg_2_addr];
    end
  end
endmodule
