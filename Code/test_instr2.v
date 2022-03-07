`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:07:30 05/06/2021
// Design Name:   Processor
// Module Name:   F:/BITS/Year 3 Sem 1/ADV VLSI Arch/Assignment 2/RISC V/test_instr2.v
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

module test_instr2;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	Processor uut (
		.clk(clk), 
		.reset(reset)
	);
	
	integer file,i;
	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		
		file = $fopen("F:\\BITS\\Year 3 Sem 1\\ADV VLSI Arch\\Assignment 2\\test_instr2.txt","r");
		for(i = 0; ! $feof(file); i=i+4) begin
			$fscanf(file,"%h\n",{uut.IM.Mem[i+3],uut.IM.Mem[i+2],uut.IM.Mem[i+1],uut.IM.Mem[i]});
		end
		$fclose(file);
		
		{uut.DM.Mem[3],uut.DM.Mem[2],uut.DM.Mem[1],uut.DM.Mem[0]} = -8;
	end
	
	initial begin
		reset = 1; #1 reset = 0; #2 reset = 1;
	end
      
endmodule

