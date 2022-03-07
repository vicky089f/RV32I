`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:12:00 04/25/2021 
// Design Name: 
// Module Name:    ImmGen 
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
module ImmGen(
    input [31:0] Instr,
    output reg [31:0] ImmData
    );

parameter RR = 7'b0110011, JAL = 7'b1101111, Branch = 7'b1100011,
          Load = 7'b0000011, Store = 7'b0100011, Imm = 7'b0010011,
			 LUI = 7'b0110111, AUIPC = 7'b0010111, JALR = 7'b1100111;

always@(*)
begin
	case(Instr[6:0])
		Imm, Load, JALR: ImmData <= {{21{Instr[31]}},Instr[30:20]};
		Branch: ImmData <= {{20{Instr[31]}},Instr[7],Instr[30:25],Instr[11:8],1'b0};
		Store: ImmData <= {{21{Instr[31]}},Instr[30:25],Instr[11:7]};
		JAL: ImmData <= {{12{Instr[31]}},{Instr[19:12]},{Instr[20]},{Instr[30:21]},1'b0};
		LUI, AUIPC: ImmData <= {Instr[31:12],12'h000};
		default: ImmData <= 0;
	endcase
end

endmodule
