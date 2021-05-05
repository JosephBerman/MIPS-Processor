# MIPS-Processor

Hi!

This is a repo for our semester long project in EECE2322, Fundamentals of Digital Design and Computer Organization, which ws to create a MIPS Processor using Verilog. 

There was some provided code by our professor to help intergrate the buttons on the PYNQ-Z board that we were using.

The code in this repo will not function without the code that the professor provided. This is purposely excluded to prevent any cheating in future classes.

## eightbit_alu.v
This verilog file was our ALU or the brains of the processor. It takes in two 8-bit Buses and a 3-bit mux for the instruction. It features an add, not, and, or, arithmetic shift right, logic shift left, equal, and a not equal function. 

## inst_decorder.v
This verilog file took a 16-bit instruction and divided the bus according to the 4-bit opt code.

## mux.v
This verilog file was a mux for the mux leading from the register and a 0 register.

## mux_2.v 
This verilog file was a basic mux

## pdatapath_top_lab6.v
This verilog file connects all of the verilog IPs together and sends it to the VIO to read the values.

## program_counter.v
This verilog files keeps track of the number of instructions that has occurred as well as having the ability to jump to a previous instruction.

## reg_file.v
This verilog file holds 4, 9-bit values as a register for the ALU. 
