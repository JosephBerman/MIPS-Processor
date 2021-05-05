`timescale 1ns / 1ps


module eightbit_alu(
    input [7:0] a,
    input [7:0] b,
    input [2:0] s,
    
    output [7:0] f,
    output ovf,
    output take_branch
    );
    
    wire [8:0] tmp;
    reg [7:0] result;
    reg [7:0] compResult;
    
    assign f = result;
    assign tmp = {1'b0,a} + {1'b0,b};
    assign ovf = tmp[8];
    
    assign take_branch = compResult;
    
    always @(*)
        
        begin
            case(s)
            3'b000:
                result = a + b;
            3'b001:
                result = ~b;
            3'b010:
                result = a&b;
            3'b011:
                result = a|b;
            3'b100:
                result = a >>> 1;
            3'b101:
                result = a << 1;
            3'b110:
                compResult = (a==b)?8'd1:8'd0;
            3'b111:
                compResult = (a!=b)?8'd1:8'd0; 
            default: result = a + b;
        endcase
    end
endmodule
