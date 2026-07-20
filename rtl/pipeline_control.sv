module pipeline_controller
(
    input logic     stall_lsu_i,
    input logic     branch_in_pipe,
    input logic     branch_taken_i,
    
    output logic    stall_f,
    output logic    stall_d,
    output logic    stall_x,

    output logic    flush_f,
    output logic    flush_d,
    output logic    flush_x
);

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
        end
        else if (branch_in_pipe) begin
            stall_f = 1'b1;
            stall_d = 1'b1;
        end
    end
endmodule
