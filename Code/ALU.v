`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:47:35 03/16/2021 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] PC,
	 input [31:0] InstCode,
    input [31:0] ImmData,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] Output,
	 output reg Taken
    );

parameter RR = 7'b0110011, JAL = 7'b1101111, Branch = 7'b1100011,
          Load = 7'b0000011, Store = 7'b0100011, Imm = 7'b0010011,
			 LUI = 7'b0110111, AUIPC = 7'b0010111, JALR = 7'b1100111;

always@(*)
begin
	case(InstCode[6:0])
		LUI: begin
			Output <= ImmData;
			Taken <= 0;
		end
		AUIPC: begin
			Output <= ImmData + PC;
			Taken <= 0;
		end
		JAL: begin
			Output <= $signed(ImmData) + $signed(PC);
			Taken <= 0;
		end
		JALR: begin
			Output <= $signed(ImmData) + $signed(A);
			Taken <= 0;
		end
		Branch: begin
			Output <= A - B;
			case(InstCode[14:12])
				3'b000: Taken <= (A == B); //BEQ
				3'b001: Taken <= (A != B); //BNE
				3'b100: Taken <= ($signed(A) < $signed(B)); //BLT
				3'b101: Taken <= ($signed(A) >= $signed(B)); //BGE
				3'b110: Taken <= ($unsigned(A) < $unsigned(B)); //BLTU
				3'b111: Taken <= ($unsigned(A) >= $unsigned(B)); //BGEU
			endcase
		end
		Load,Store: begin
			Output <= $signed(ImmData) + $signed(A);
			Taken <= 0;
		end
		Imm: begin
			Taken <= 0;
			case(InstCode[14:12])
				3'b000: Output <= $signed(ImmData) + $signed(A); //ADDI
				3'b010: Output <= ($signed(A) < $signed(ImmData)); //SLTI
				3'b011: Output <= (A < ImmData); //SLTIU
				3'b100: Output <= ImmData ^ A; //XORI
				3'b110: Output <= ImmData | A; //ORI
				3'b111: Output <= ImmData & A; //ANDI
				3'b001: Output <= A << ImmData[4:0]; //SLLI
				3'b101: begin 
					if(InstCode[30] == 0) Output <= A >> ImmData[4:0]; //SRLI
					else Output <= $signed(A) >>> ImmData[4:0]; //SRAI
				end
			endcase
		end
		RR: begin
			Taken <= 0;
			case(InstCode[14:12])
				3'b000: begin
					if(InstCode[30] == 0) Output <= $signed(A) + $signed(B); //ADD
					else Output <= $signed(A) - $signed(B); //SUB
				end
				3'b001: Output <= A << B[4:0]; //SLL
				3'b010: Output <= ($signed(A) < $signed(B)); //SLT
				3'b011: Output <= ($unsigned(A) < $unsigned(B)); //SLTU
				3'b100: Output <= A ^ B; //XOR
				3'b101: begin
					if(InstCode[30] == 0) Output <= A >> B[4:0]; //SRL
					else Output <= $signed(A) >>> B[4:0]; //SRA
				end
				3'b110: Output <= A | B; //OR
				3'b111: Output <= A & B; //AND
			endcase
		end
		
		default: begin
			Output <= 0;
			Taken <= 0;
		end
	endcase
end

endmodule
