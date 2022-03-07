`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:37:37 04/03/2021 
// Design Name: 
// Module Name:    BHT 
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
module BHT(
    input reset,
	 input [31:0] PC, //current PC
	 input [31:0] Instr, //new instr from IMem
	 input EX_Outcome, //from ALU (Taken)
	 input EX_Predict, //from ID_EX reg
	 input [31:0] EX_PC, //from ID_EX reg
	 input [6:0] EX_type, //from ID_EX reg
	 input [31:0] EX_Result, //from ALU output
	 input [31:0] EX_Imm, //from ID_EX reg
    output reg [31:0] Target, 
    output reg Predict,
	 output reg Flush
    );

parameter RR = 7'b0110011, JAL = 7'b1101111, Branch = 7'b1100011,
          Load = 7'b0000011, Store = 7'b0100011, Imm = 7'b0010011,
			 LUI = 7'b0110111, AUIPC = 7'b0010111, JALR = 7'b1100111;

reg [1:0] BHT [7:0];
reg prevB;

always@(*)
begin
	if(!reset) begin
		prevB <= 0;
		BHT[0] <= 2'b00;
		BHT[1] <= 2'b00;
		BHT[2] <= 2'b00;
		BHT[3] <= 2'b00;
		BHT[4] <= 2'b00;
		BHT[5] <= 2'b00;
		BHT[6] <= 2'b00;
		BHT[7] <= 2'b00;
	end
	
	else if(EX_type == Branch)
	begin
		//Update BHT..................
		if(EX_Outcome == 0 && BHT[{prevB,EX_PC[3:2]}] != 2'b00)
			BHT[{prevB,{EX_PC[3:2]}}] <= BHT[{prevB,{EX_PC[3:2]}}] - 1;
		else if(EX_Outcome == 1 && BHT[{prevB,{EX_PC[3:2]}}] != 2'b11)
			BHT[{prevB,EX_PC[3:2]}] <= BHT[{prevB,EX_PC[3:2]}] + 1;
		
		//Mispredict - Flush & Transfer control.........
		if(EX_Predict != EX_Outcome) begin
			Flush <= 1;
			if(EX_Outcome == 0)
				Target <= EX_PC + 4;
			else
				Target <= EX_PC + EX_Imm;
		end
		//Correct Prediction - Continue execution......
		else begin
			Flush <= 0;
			Target <= PC + 4;
		end
	end
	
	else if(EX_type == JALR)
	begin
		Target <= EX_Result;
		Flush <= 1;
	end
	
	//Branch Prediction for the new incoming instruction
	if((EX_type == Branch && EX_Predict == EX_Outcome) || EX_type != Branch && EX_type != JALR) begin
		Flush <= 0;
		if(Instr[6:0] == Branch)
		begin
			if(BHT[{prevB,PC[3:2]}][1] == 1'b1)
			begin
				Target <= PC + {{20{Instr[31]}},{Instr[7]},{Instr[30:25]},{Instr[11:8]},1'b0};
				Predict <= 1;
			end
			else
			begin
				Target <= PC + 4;
				Predict <= 0;
			end
		end
	
		else if(Instr[6:0] == JAL) begin
			Target <= PC + {{12{Instr[31]}},{Instr[19:12]},{Instr[20]},{Instr[30:25]},{Instr[24:21]},1'b0};
			Predict <= 0;
		end
		else begin
			Target <= PC + 4;
			Predict <= 0;
		end
	end
end

endmodule
