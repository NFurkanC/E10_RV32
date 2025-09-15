//for now we'll use pc as our first fetch reg. on phase 2, we'll implement prefetch buffer.
module fetch (
  input clk_i,
  input rst_i,
  input [31:0]        instr_fetch_in,
  output reg [31:0]   reg_pc_out,
  output reg [31:0]   instr_decode_out
);
  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin // if reset is triggered zero out the program counter
        reg_pc_out <= 32'h00000000;
        instr_decode_out <= 32'b0;
    end
    else begin
      instr_decode_out <= instr_fetch_in;
      reg_pc_out <= reg_pc_out + 4; // add 4 for jumping to next 32 bit section aka next instruction
    end
  end
endmodule

module decode_1 (
  input clk_i,
  output regfile_write_en_out,
  output [4:0] reg_a_addr_out,
  output [4:0] reg_b_addr_out,
  output [4:0] reg_c_addr_out,
  input [31:0] instr_in,
  input [31:0] result_in,
  input [2:0] imm_ext_sel_in,
  output reg [31:0] imm_ext_out,
);
  
//given register addresses will be given out by DA, DB, DC for execution
//rA, rB, rC will be used for writeback and such
//We'll add 3 addr selection inputs for register file. 
  
  assign reg_a_addr_out = instr_in[19:15];
  assign reg_b_addr_out = instr_in[24:20];
  assign reg_c_addr_out = instr_in[11:7];
  
  always @(*) begin
    case (imm_ext_sel_in)
      3'b0000 : imm_ext_out = {{20{instr_in[31]}}, instr_in[31:20]};
      default : imm_ext_out = 32'b0;
    endcase
  end
endmodule
      
  
  
