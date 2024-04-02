module controller_conditional_logic (input PCS, RegW, MemW, clk, NoWrite, input [3:0] Cond, ALUFlags,
input [1:0] FlagW, 
output PCSrc, RegWrite, MemWrite);

wire CondEx;

wire [1:0] FlagWrite;
wire [3:0] Flags;

assign PCSrc = CondEx & PCS;
assign RegWrite = CondEx & RegW & ~NoWrite;


assign MemWrite = CondEx & MemW;

assign FlagWrite[1] = CondEx & FlagW[1];
assign FlagWrite[0] = CondEx & FlagW[0];

Register_en #(2) flags_NZ (.clk(clk),.en(FlagWrite[1]),.DATA(ALUFlags[3:2]),.OUT(Flags[3:2]));
Register_en #(2) flags_CV (.clk(clk),.en(FlagWrite[0]),.DATA(ALUFlags[1:0]),.OUT(Flags[1:0]));

condition_check checkcond(.NZ(Flags[3:2]), .CV((Flags[1:0])),.Cond(Cond),.CondEx(CondEx));


endmodule