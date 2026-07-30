module pipeline_controller
(
    input logic     stall_lsu_i,
    input logic     branch_taken_i,

    input logic [4:0] rs1_addr_d,
    input logic [4:0] rs2_addr_d,
    input logic [4:0] rd_addr_x,
    input logic       reg_wen_en,
    
    output logic    stall_f,
    output logic    stall_d,
    output logic    stall_x,

    output logic    flush_f,
    output logic    flush_d,
    output logic    flush_x
);

    logic raw_hazard;
    
    always_comb begin
        raw_hazard = 1'b0;
        if(reg_wen_en && (rd_addr_x != 5'b0)) begin
            if((rd_addr_x == rs1_addr_d) || (rd_addr_x == rs2_addr_d)) begin
                raw_hazard = 1'b1;
            end
        end    
    end

    always_comb begin
        stall_f = 1'b0;
        stall_d = 1'b0;
        stall_x = 1'b0;
        flush_f = 1'b0;
        flush_d = 1'b0;
        flush_x = 1'b0;
        if (stall_lsu_i) begin
            stall_f = 1'b1;
            stall_d = 1'b1;
            stall_x = 1'b1;
        end
        else if (branch_taken_i) begin
            flush_d = 1'b1;
            flush_f = 1'b1;
            flush_x = 1'b1;
        end
        else if (raw_hazard) begin
            stall_f = 1'b1;
            stall_d = 1'b1;
            flush_x = 1'b1;
        end
    end
endmodule
