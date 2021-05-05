`timescale 1ns / 1ps


module program_counter(
    input clk,
    input rst,
    input signed [7:0] branch_off,
    input alu_zero,
    output reg [7:0] value
    );
    
    always @(posedge clk, posedge rst)
    begin
        if(rst) begin
            value <= 8'b0;
        end else if(clk)
        begin
            if(alu_zero)
                value = value + branch_off;
            else
                value = value + 1;
        end
   end
endmodule
