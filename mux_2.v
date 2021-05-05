`timescale 1ns / 1ps

module mux2( 
    input [8:0] ReadData2,
    input [7:0] instr_i,
    input ALUSrc2,
    output [7:0] input2
    );
    
    assign input2 = ALUSrc2 ? instr_i : ReadData2;
endmodule
