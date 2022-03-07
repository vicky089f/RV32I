`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:41:50 04/21/2021 
// Design Name: 
// Module Name:    fwd_logic2 
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
module fwd_logic2(
    input [4:0] ID_rs,
    input [4:0] EX_rd,
    input [4:0] MEM_rd,
	 input [6:0] ID_type,
	 input [6:0] EX_type,
	 input [6:0] MEM_type,
    input [31:0] ID_reg,
    input [31:0] EX_Alu,
	 input [31:0] EX_PC,
    input [31:0] MEM_Out,
    output reg [31:0] FWD,
	 output reg LoadStall
	 );

parameter RR = 7'b0110011, JAL = 7'b1101111, Branch = 7'b1100011,
          Load = 7'b0000011, Store = 7'b0100011, Imm = 7'b0010011,
			 LUI = 7'b0110111, AUIPC = 7'b0010111, JALR = 7'b1100111;

assign EX_NPC = EX_PC+4;

always@(*)
begin
	if(ID_type == Branch || ID_type == Store || ID_type == RR)
	begin //dependent instruction should have rs2 field
		if(ID_rs == EX_rd && EX_rd != 0) //EX Hazard Condition
		begin
			case(EX_type)
				Imm, RR, LUI, AUIPC: begin
					FWD <= EX_Alu;
					LoadStall <= 0;
				end
				JAL, JALR: begin
					FWD <= EX_PC + 4;
					LoadStall <= 0;
				end
				Load: begin
					FWD <= ID_reg;
					LoadStall <= 1;
				end
				default: begin
					FWD <= ID_reg;
					LoadStall <= 0;
				end
			endcase
		end
		else if(ID_rs == MEM_rd && MEM_rd != 0) //MEM Hazard Condition
		begin
			LoadStall <= 0;
			case(MEM_type)
				Load, JAL, JALR, Imm, RR, AUIPC, LUI: FWD <= MEM_Out;
				default: FWD <= ID_reg;
			endcase
		end
		else begin
			FWD <= ID_reg;
			LoadStall <= 0;
		end
	end
	else begin
		FWD <= ID_reg;
		LoadStall <= 0;
	end
end

endmodule
