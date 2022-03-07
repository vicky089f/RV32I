`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:59:04 03/10/2021 
// Design Name: 
// Module Name:    RegFile 
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
module RegFile(
	 input reset,
    input [4:0] ReadAddr1,
    input [4:0] ReadAddr2,
    input [4:0] WriteAddr,
    input [31:0] WriteData,
    input RegWrite,
    output [31:0] Data1,
    output [31:0] Data2
    );

reg [31:0] x [31:0];
integer i;

assign Data1 = x[ReadAddr1];
assign Data2 = x[ReadAddr2];

always@(negedge reset)
begin
	for(i=0;i<32;i=i+1)
		x[i] <= 0;
end

always@(*)
begin
	if(RegWrite == 1 && WriteAddr != 0)
		x[WriteAddr] <= WriteData;
end

endmodule
