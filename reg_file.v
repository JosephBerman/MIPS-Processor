`timescale 1ns / 1ps


module reg_file(

    input rst,
    input clk,
    input wr_en,
    input [1:0] rd0_addr,
    input [1:0] rd1_addr,
    input [1:0] wr_addr,
    input [8:0] wr_data,
    
    output [8:0] rd0_data,
    output [8:0] rd1_data
    );
    
    reg [8:0] regis [0:3];
    
    assign rd0_data = regis [rd0_addr];
    assign rd1_data = regis [rd1_addr];
    
    always @(posedge  clk)
        if(rst) begin
            regis[0] <= 0;
            regis[1] <= 0;
            regis[2] <= 0;
            regis[3] <= 0;
        end else begin
            if(wr_en) regis[wr_addr] <= wr_data;
        end
endmodule
