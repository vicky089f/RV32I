`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:54:12 02/07/2021
// Design Name:   Processor
// Module Name:   F:/BITS/Year 3 Sem 1/ADV VLSI Arch/Assignment 2/RISC V/sort.v
// Project Name:  RISC_V
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sort;

	// Inputs
	reg clk;

	// Instantiate the Unit Under Test (UUT)
	Processor uut (
		.clk(clk)
	);
	
	parameter NOP = 32'h00000013;
	integer i,file;
	reg [31:0] temp;
	
	always #5 clk=~clk;

	initial begin
		clk = 0;
	end
      
endmodule

