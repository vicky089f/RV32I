`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:56 01/26/2021 
// Design Name: 
// Module Name:    P2 
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
module Processor(
    input clk,
	 input reset
    );

reg [31:0] PC;
//IF_ID
reg [31:0] IF_ID_IR, IF_ID_PC;
reg IF_ID_Predict;
//ID_EX
reg [31:0] ID_EX_IR, ID_EX_PC, ID_EX_A, ID_EX_B, ID_EX_Imm;
reg ID_EX_Predict;
//EX_MEM
reg [31:0] EX_MEM_IR, EX_MEM_PC, EX_MEM_AluOut, EX_MEM_B;
//MEM_WB
reg [31:0] MEM_WB_IR, MEM_WB_PC, MEM_WB_Out;


wire [31:0] Instr, OP_A, OP_B, FWD_A, FWD_B, AluOP, Target, Load_Data, ImmData;
wire RegWrite, MemRead, MemWrite, Taken, Flush, BHT_Predict, LoadStallA, LoadStallB;

parameter RR = 7'b0110011, JAL = 7'b1101111, Branch = 7'b1100011,
          Load = 7'b0000011, Store = 7'b0100011, Imm = 7'b0010011,
			 LUI = 7'b0110111, AUIPC = 7'b0010111, JALR = 7'b1100111;

parameter NOP = 32'h00000013;

IMem IM(
	.reset(reset),
	.PC(PC),
	.Instr(Instr)
	);

BHT H(
	.reset(reset),
	.PC(PC),
	.Instr(Instr),
	.EX_Predict(ID_EX_Predict),
	.EX_Outcome(Taken),
	.EX_PC(ID_EX_PC),
	.EX_type(ID_EX_IR[6:0]),
	.EX_Result(AluOP),
	.EX_Imm(ID_EX_Imm),
   .Target(Target), 
   .Predict(BHT_Predict),
	.Flush(Flush)
	);

ImmGen IG(
	.Instr(IF_ID_IR),
	.ImmData(ImmData));

RegFile X(
	.reset(reset),
	.ReadAddr1(IF_ID_IR[19:15]),
	.ReadAddr2(IF_ID_IR[24:20]),
	.WriteAddr(MEM_WB_IR[11:7]),
	.WriteData(MEM_WB_Out),
	.RegWrite(RegWrite),
	.Data1(OP_A),
	.Data2(OP_B)
	);

fwd_logic A(
    .ID_rs(ID_EX_IR[19:15]),
    .EX_rd(EX_MEM_IR[11:7]),
    .MEM_rd(MEM_WB_IR[11:7]),
	 .ID_type(ID_EX_IR[6:0]),
	 .EX_type(EX_MEM_IR[6:0]),
	 .MEM_type(MEM_WB_IR[6:0]),
    .ID_reg(ID_EX_A),
    .EX_Alu(EX_MEM_AluOut),
	 .EX_PC(EX_MEM_PC),
    .MEM_Out(MEM_WB_Out),
    .FWD(FWD_A),
	 .LoadStall(LoadStallA)
    );

fwd_logic2 B(
    .ID_rs(ID_EX_IR[24:20]),
    .EX_rd(EX_MEM_IR[11:7]),
    .MEM_rd(MEM_WB_IR[11:7]),
	 .ID_type(ID_EX_IR[6:0]),
	 .EX_type(EX_MEM_IR[6:0]),
	 .MEM_type(MEM_WB_IR[6:0]),
    .ID_reg(ID_EX_B),
    .EX_Alu(EX_MEM_AluOut),
	 .EX_PC(EX_MEM_PC),
    .MEM_Out(MEM_WB_Out),
    .FWD(FWD_B),
	 .LoadStall(LoadStallB)
    );


ALU P(
	.PC(ID_EX_PC),
	.InstCode(ID_EX_IR),
	.ImmData(ID_EX_Imm),
	.A(FWD_A),
	.B(FWD_B),
	.Output(AluOP),
	.Taken(Taken)
	);
			 
DMem DM(
	.reset(reset),
	.Addr(EX_MEM_AluOut),
	.DataIn(EX_MEM_B),
	.funct3(EX_MEM_IR[14:12]),
	.wren(MemWrite),
	.rden(MemRead),
	.DataOut(Load_Data)
	);

assign RegWrite = (MEM_WB_IR[6:0] == Load || MEM_WB_IR[6:0] == Imm 
						|| MEM_WB_IR[6:0] == RR || MEM_WB_IR[6:0] == JAL
						|| MEM_WB_IR[6:0] == LUI || MEM_WB_IR[6:0] == JALR
						|| MEM_WB_IR[6:0] == AUIPC);

assign MemRead = (EX_MEM_IR[6:0] == Load);
assign MemWrite = (EX_MEM_IR[6:0] == Store);

//PC change logic.................
always@(posedge clk, negedge reset)
begin
	if(reset == 0)
		PC <= 0;
	else if(LoadStallA || LoadStallB);
	else
		PC <= Target;
end

//Instruction Fetch............................
always@(posedge clk, negedge reset)
begin
	if(Flush == 1 || reset == 0) begin
		//Flush all registers with data related to add x0,x0,x0
		IF_ID_IR <= NOP;
		IF_ID_PC <= 0;
		IF_ID_Predict <= 0;
	end
	else if(LoadStallA || LoadStallB);
	else begin
		IF_ID_IR <= Instr;
		IF_ID_PC <= PC;
		IF_ID_Predict <= BHT_Predict;
	end
end

//Instruction Decode and Register Read...........
always@(posedge clk, negedge reset)
begin
	if(Flush == 1 || reset == 0) begin
		ID_EX_A <= 0;
		ID_EX_B <= 0;
		ID_EX_IR <= NOP;
		ID_EX_PC <= 0;
		ID_EX_Predict <= 0;
		ID_EX_Imm <= 0;
	end
	else if(LoadStallA || LoadStallB);
	else begin
		ID_EX_A <= OP_A;
		ID_EX_B <= OP_B;
		ID_EX_IR <= IF_ID_IR;
		ID_EX_PC <= IF_ID_PC;
		ID_EX_Predict <= IF_ID_Predict;
		ID_EX_Imm <= ImmData;		
	end
end

//Execute Stage.....................
always@(posedge clk, negedge reset)
begin
	if(reset == 0 || LoadStallA || LoadStallB) begin
		EX_MEM_IR <= NOP;
		EX_MEM_PC <= 0;
		EX_MEM_B <= 0;
		EX_MEM_AluOut <= 0;
	end
	else begin
		EX_MEM_IR <= ID_EX_IR;
		EX_MEM_PC <= ID_EX_PC;
		EX_MEM_B <= FWD_B;
		EX_MEM_AluOut <= AluOP;
	end
end

//Mem Stage.........................
always@(posedge clk, negedge reset)
begin
	if(reset == 0) begin
		MEM_WB_Out <= 0;
		MEM_WB_IR <= NOP;
		MEM_WB_PC <= 0;
	end
	else begin
		/*if(EX_MEM_IR[6:0] == Load)
			MEM_WB_Out <= Load_Data;
		else if(EX_MEM_IR[6:0] == JAL || EX_MEM_IR[6:0] == JALR)
			MEM_WB_Out <= EX_MEM_PC + 4;
		else
			MEM_WB_Out <= EX_MEM_AluOut;*/
		
		case(EX_MEM_IR[6:0])
			Load: MEM_WB_Out <= Load_Data;
			JAL, JALR: MEM_WB_Out <= EX_MEM_PC + 4;
			default: MEM_WB_Out <= EX_MEM_AluOut;
		endcase
		
		MEM_WB_IR <= EX_MEM_IR;
		MEM_WB_PC <= EX_MEM_PC;
	end
end

endmodule
