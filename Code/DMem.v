`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:35 03/10/2021 
// Design Name: 
// Module Name:    DMem 
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
module DMem(
	 input reset,
	 input [31:0] Addr,
    input [31:0] DataIn,
	 input [2:0] funct3,
    input wren,
    input rden,
    output reg [31:0] DataOut
    );

reg [7:0] Mem [255:0];

/*always@(negedge reset)
begin
	{Mem[3],Mem[2],Mem[1],Mem[0]} <= -543;
	{Mem[7],Mem[6],Mem[5],Mem[4]} <= 987;
	{Mem[11],Mem[10],Mem[9],Mem[8]} <= -5;
	{Mem[15],Mem[14],Mem[13],Mem[12]} <= 6352;
	{Mem[19],Mem[18],Mem[17],Mem[16]} <= 109;
	{Mem[23],Mem[22],Mem[21],Mem[20]} <= 92838;
	{Mem[27],Mem[26],Mem[25],Mem[24]} <= -652;
	
	{Mem[103],Mem[102],Mem[101],Mem[100]} <= 7;
end*/

always@(*)
begin
	if(rden) begin
		case(funct3)
			3'b000: DataOut <= {{24{Mem[Addr][7]}},Mem[Addr]};
			3'b001: DataOut <= {{16{Mem[Addr+1][7]}},Mem[Addr+1],Mem[Addr]};
			3'b010: DataOut <= {Mem[Addr+3],Mem[Addr+2],Mem[Addr+1],Mem[Addr]};
			3'b100: DataOut <= {24'h000000,Mem[Addr]};
			3'b101: DataOut <= {16'h0000,Mem[Addr+1],Mem[Addr]};
		endcase
	end
	
	else if(wren) begin
		case(funct3)
			3'b000: Mem[Addr] <= DataIn[7:0];
			3'b001: {Mem[Addr+1],Mem[Addr]} <= DataIn[15:0];
			3'b010: {Mem[Addr+3],Mem[Addr+2],Mem[Addr+1],Mem[Addr]} <= DataIn;
		endcase
	end
end

endmodule
