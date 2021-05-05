`timescale 1ns / 1ps

module pdatapath_top(
		input wire clk,				// General clock input
		input wire top_pb_clk,		// PBN1 clock input
        input wire rst_general,		// PBN0 clock reset for memory blocks
		output [7:0] led,			// add-on board led[5:0], + LD0, LD1
		output wire ovf_ctrl,    	// LD3 for overflow
		output [3:0] disp_en,		// 7-Segment display enable
		output [6:0] seg7_output	// 7-segment display output
    );
    
    wire [7:0] alu_input1, alu_input2;
    wire [7:0] alu_output;
    wire [2:0] ALUOp;
    wire       alu_ovf;
    wire       take_branch;
    
    wire [15:0] instruction;
    //insturction fields
    wire [3:0] opcode;
    wire [1:0] rs_addr;
    wire [1:0] rt_addr;
    wire [1:0] rd_addr;
    wire [7:0] immediate;
    //control signals
    wire RegDst;
    wire RegWrite;
    wire ALUSrc1;
    wire ALUSrc2;
    wire MemWrite;
    wire MemToReg;

    wire [1:0] regfile_WriteAddress; //destination register address
    wire [8:0] regfile_WriteData;	//result data
    wire [8:0] regfile_ReadData1;	//source register1 data
    wire [8:0] regfile_ReadData2;	//source register2 data

    wire [8:0] alu_result;
    wire [8:0] Data_Mem_Out;
	reg [7:0] zero_register = 0;	//ZERO constant

    wire pb_clk_debounced;

	assign alu_result = {alu_ovf, alu_output};
	
	// Assign LEDs
    assign led = alu_output;
	assign ovf_ctrl = alu_ovf;

	
	// Push button debounce
    debounce debounce_clk(
        .clk_in(clk),
        .rst_in(rst_general),
        .sig_in(top_pb_clk),
        .sig_debounced_out(pb_clk_debounced)
    );
	
	// 7-Segment display module
	Adaptor_display display(
		.clk(clk), 					// system clock
		.input_value(alu_output),	// 8-bit input [7:0] value to display
		.disp_en(disp_en),			// output [3:0] 7 segment display enable
		.seg7_output(seg7_output)	// output [6:0] 7 segment signals
	);
    
    
   reg_file register(
	   .rst(rst_general),
	   .clk(pb_clk_debounced),
	   .wr_en(RegWrite),
	   .rd0_addr(rs_addr),
	   .rd1_addr(rt_addr),
	   .wr_addr(regfile_WriteAddress),
	   .wr_data(regfile_WriteData),
	   .rd0_data(regfile_ReadData1),
	   .rd1_data(regfile_ReadData2)
	);
	
	mux1 muxOne(
	   .ReadData1(regfile_ReadData1),
	   .ALUSrc1(ALUSrc1),
	   .input1(alu_input1)
	);
	mux2 muxTwo(
	   .ReadData2(regfile_ReadData2),
	   .instr_i(immediate),
	   .ALUSrc2(ALUSrc2),
	   .input2(alu_input2)
	);
	
	mux2 muxThree( 
	   .ReadData2(alu_output),
	   .instr_i(Data_Mem_Out),
	   .ALUSrc2(MemtoReg),
	   .input2(regfile_WriteData)	   
	); 
	
	eightbit_alu ALU(
	   .a(alu_input1),
	   .b(alu_input2),
	   .s(ALUOp),
	   .f(alu_output),
	   .ovf(alu_ovf),
	   .take_branch(take_branch)
	);
	
	   data_memory DATAMEM(
   
        .a(alu_output),
        .d(regfile_ReadData2),
        .clk(pb_clk_debounced),
        .we(MemWrite),
        .spo(Data_Mem_Out)
    );	
	
	
	//Mux for RegDST
	mux2 muxFour(
	   .ReadData2(rd_addr),
	   .instr_i(rt_addr),
	   .ALUSrc2(RegDst),
	   .input2(regfile_WriteAddress)	   
	); 
	
	inst_decoder decoder(
        .instruction(instruction),
        .opcode(opcode),
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        .immediate(immediate),
        .RegDst(RegDst), 
        .RegWrite(RegWrite),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg)
	);
	
    
    vio_0 VIO(
        .probe_in0(regfile_WriteData),
        .probe_in1(regfile_ReadData1),
        .probe_in2(regfile_ReadData2),
        .probe_in3(alu_input1),
        .probe_in4(alu_input2),
        .probe_in5(take_branch),
        .probe_in6(ovf_ctrl),
        .probe_in7(opcode),
        .probe_in8(alu_output),
        .probe_in9(Data_Mem_Out),
        .probe_out0(instruction),
        .clk(clk)
    );
    
endmodule

//****************** End Top Module *********************************
