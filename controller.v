module controller (input clk, 
input [3:0] Cond, ALUFlags, RD,
input [1:0] Op, input [5:0] Funct, 
output PCSrc, RegWrite, MemWrite, MemtoReg, ALUSrc, WDSrc,ALUSrcnew, shmux,
output [1:0] ImmSrc, 
output [2:0] RegSrc, 
output [3:0] ALUControl);

wire [1:0] FlagW;
wire PCS, RegW, MemW, NoWrite;

controller_decoder contdec(.RD(RD), .Op(Op), .Funct(Funct),
.PCS(PCS), .RegW(RegW), .MemW(MemW), .MemtoReg(MemtoReg),.ALUSrc(ALUSrc),
.ImmSrc(ImmSrc), .RegSrc(RegSrc), .ALUControl(ALUControl), .FlagW(FlagW), .WDSrc(WDSrc), .NoWrite(NoWrite), .ALUSrcnew(ALUSrcnew),.shmux(shmux) );

controller_conditional_logic cont_cond_log(.PCS(PCS), .RegW(RegW), .MemW(MemW), .clk(clk), .NoWrite(NoWrite),
.Cond(Cond), .ALUFlags(ALUFlags),
.FlagW(FlagW), 
.PCSrc(PCSrc), .RegWrite(RegWrite), .MemWrite(MemWrite));


endmodule