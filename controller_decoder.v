module controller_decoder(input [3:0] RD, output [3:0] ALUControl, input [1:0] Op, input [5:0] Funct,
output PCS, RegW, MemW, MemtoReg,ALUSrc, WDSrc, NoWrite, shmux, ALUSrcnew,
output [1:0] ImmSrc, FlagW,
output [2:0] RegSrc);

wire Branch, ALUOp, BranchX;

MainDecoder maindec(.Op(Op), .Funct(Funct),.Branch(Branch), 
.RegW(RegW), .MemW(MemW), .MemtoReg(MemtoReg), .ALUSrc(ALUSrc), .ALUOp(ALUOp), .shmux(shmux), .ALUSrcnew(ALUSrcnew),
.ImmSrc(ImmSrc), .RegSrc(RegSrc), .WDSrc(WDSrc));

ALUDecoder aludec(.ALUOp(ALUOp), .Funct(Funct[4:0]), 
.ALUControl(ALUControl), .FlagW(FlagW),.NoWrite(NoWrite));

PCLogic pclog(.Branch(Branch),.BranchX(BranchX), .RegW(RegW), .RD(RD), .PCS(PCS));


endmodule