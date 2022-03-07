`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:49:55 01/30/2021
// Design Name:   Processor
// Module Name:   F:/BITS/Year 3 Sem 1/ADV VLSI Arch/Assignment 2/RISC V/gcd.v
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

module gcd;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	Processor uut (
		.clk(clk),
		.reset(reset)
	);
	
	always #10 clk = ~clk;

	initial begin
		clk = 0;
		reset = 1; #1 reset = 0; #2 reset = 1;
		
		$monitor({uut.DM.Mem[3],uut.DM.Mem[2],uut.DM.Mem[1],uut.DM.Mem[0]});
		$monitor({uut.DM.Mem[7],uut.DM.Mem[6],uut.DM.Mem[5],uut.DM.Mem[4]});
		$monitor({uut.DM.Mem[11],uut.DM.Mem[10],uut.DM.Mem[9],uut.DM.Mem[8]});
		$monitor({uut.DM.Mem[15],uut.DM.Mem[14],uut.DM.Mem[13],uut.DM.Mem[12]});
		$monitor({uut.DM.Mem[19],uut.DM.Mem[18],uut.DM.Mem[17],uut.DM.Mem[16]});
		$monitor({uut.DM.Mem[23],uut.DM.Mem[22],uut.DM.Mem[21],uut.DM.Mem[20]});
		$monitor({uut.DM.Mem[27],uut.DM.Mem[26],uut.DM.Mem[25],uut.DM.Mem[24]});
	end
      
endmodule

