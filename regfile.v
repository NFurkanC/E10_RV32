module regfile(
  input clk_i,
  input rst_i,
  input [31:0] reg_a_in,
  input [31:0] reg_b_in,
  input [31:0] reg_c_in,
  input [4:0] reg_a_addr_in,
  input [4:0] reg_b_addr_in,
  input [4:0] reg_c_addr_in,
  output [31:0] reg_a_out,
  output [31:0] reg_b_out,
  output [31:0] reg_c_out,
);
  reg [31:0] regfile[31:0];
  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      for(i = 0, i < 32, i = i + 1) begin
        regfile[i] <= 32'b0;
      end
    end
    else begin
      assign regfile[reg_a_addr_in] = reg_a_in;
      assign regfile[reg_b_addr_in] = reg_b_in;
      assign regfile[reg_c_addr_in] = reg_c_in;
      assign reg_a_out = (reg_a_addr_in == 5'b0) ? 32'b0 : regfile[reg_a_addr_in];
      assign reg_b_out = (reg_b_addr_in == 5'b0) ? 32'b0 : regfile[reg_b_addr_in];
      assign reg_c_out = (reg_c_addr_in == 5'b0) ? 32'b0 : regfile[reg_c_addr_in];
    end
  end
endmodule
