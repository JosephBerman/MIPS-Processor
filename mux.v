`timescale 1ns / 1ps

module mux1( 
    input [8:0] ReadData1,
    input ALUSrc1,
    output [7:0] input1 
    );
    
    reg zeroRegister = 8'b0;
    
    assign input1 = ALUSrc1 ? zeroRegister : ReadData1;
endmodule
