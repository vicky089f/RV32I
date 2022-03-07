`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:05:14 03/10/2021 
// Design Name: 
// Module Name:    IMem 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IMem(
    input reset,
	 input [31:0] PC,
    output [31:0] Instr
    );

reg [7:0] Mem [255:0];

/*always@(negedge reset)
begin
	$readmemh("sort_asc.mem",Mem);
end*/

assign Instr = {Mem[PC+3],Mem[PC+2],Mem[PC+1],Mem[PC]};

endmodule
