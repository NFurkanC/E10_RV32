//INCOMPLETE - NEEDS FULL REWRITE
//FIRST THING TO REWRITE FOR THE PIPELINED STRUCTURE
//WILL NOT ADD TO RTL FOLDER UNTIL COMPLETED

`include "../include/rv32_opcodes.vh"
//for now we'll use pc as our first fetch reg. on phase 2, we'll implement prefetch buffer.
module fetch (
  input clk_i,
  input rst_i,
  input [31:0]        instr_fetch_in,
  input wire          pc_w_en,
  input wire [31:0]   reg_pc_in,
  output reg [31:0]   reg_pc_out,
  output reg [31:0]   instr_decode_out
);
  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin // if reset is triggered zero out the program counter
        reg_pc_out <= 32'h00000000;
        instr_decode_out <= 32'b0;
    end

    if (pc_w_en) begin
      assign reg_pc_out = reg_pc_in;
    end
    else begin
      instr_decode_out <= instr_fetch_in;
      reg_pc_out <= reg_pc_out + 4; // add 4 for jumping to next 32 bit section aka next instruction
    end
  end
endmodule

module decode_1 (
  input wire clk_i,
  input wire rst_i,

  output wire regfile_write_en_out,
  output wire [4:0] write_reg_addr,

  input reg [31:0] instr_in,
  input reg [31:0] result_in,
  input wire [2:0] imm_ext_sel_in,
  output reg [31:0] imm_ext_out,
);
  
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
      
  
  
