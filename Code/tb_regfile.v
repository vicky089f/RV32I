`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:08:31 03/16/2021
// Design Name:   RegFile
// Module Name:   F:/BITS/Year 3 Sem 1/ADV VLSI Arch/Assignment 2/RISC V/tb_regfile.v
// Project Name:  RISC_V
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RegFile
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_regfile;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] ReadAddr1;
	reg [31:0] ReadAddr2;
	reg [31:0] WriteAddr;
	reg [31:0] WriteData;
	reg wr_en;

	// Outputs
	wire [31:0] Data1;
	wire [31:0] Data2;

	// Instantiate the Unit Under Test (UUT)
	RegFile uut (
		.clk(clk), 
		.reset(reset), 
		.ReadAddr1(ReadAddr1), 
		.ReadAddr2(ReadAddr2), 
		.WriteAddr(WriteAddr), 
		.WriteData(WriteData), 
		.wr_en(wr_en), 
		.Data1(Data1), 
		.Data2(Data2)
	);
	
	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		/*ReadAddr1 = 0;
		ReadAddr2 = 0;
		WriteAddr = 0;
		WriteData = 0;
		wr_en = 0;*/
		#20 reset = 0;
	end
	
	initial begin
		#10 ReadAddr1 = 0; ReadAddr2 = 0;
		#15 ReadAddr1 = 0; ReadAddr2 = 1;
		#10 ReadAddr1 = 1; ReadAddr2 = 2;
	end
	
	initial begin
		wr_en = 0;
		#15 wr_en = 1; WriteData = 20; WriteAddr = 0;
		#10 wr_en = 1; WriteData = 30; WriteAddr = 1;
		#10 wr_en = 1; WriteData = 40; WriteAddr = 2;
		#30 $finish;
	end
      
endmodule

