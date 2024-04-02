module MainDecoder (input [1:0] Op, input [5:0] Funct,
output Branch, RegW, MemW, MemtoReg, ALUSrc, ALUOp, BranchX, WDSrc, ALUSrcnew, shmux,
output [1:0] ImmSrc, 
output [2:0] RegSrc);

assign Branch = (Op == 2'b10) ? 1'b1 : 1'b0; //BL was already here, add BX

assign BranchX = (Op == 2'b00) & (Funct == 6'b010010) ? 1'b1 : 1'b0; //BX added here

assign RegW = (((Op == 2'b00) & (Funct != 6'b010010))| ((Op == 2'b01) & Funct[0] ) | ((Op == 2'b10) & Funct[4] ))? 1'b1 : 1'b0; //BL is also added. BX is also arranged to make it stay 0

assign MemW = ((Op == 2'b01) & ~Funct[0] ) ? 1'b1 : 1'b0;

assign MemtoReg = ((Op == 2'b01) & Funct[0] ) ? 1'b1 : 1'b0;

assign ALUSrc = ((Op == 2'b00) & ~Funct[5] ) ? 1'b0 : 1'b1; //BX is already here

assign ALUSrcnew = ((Op == 2'b01) | ((Op == 2'b00) & Funct[5]))? 1'b1 : 1'b0; //immediate mov + str + ldr

assign ALUOp = ((Op == 2'b00)) ? 1'b1 : 1'b0; //BX is already here, we need MOV operation from ALU

assign ImmSrc = ((Op == 2'b01)) ? 2'b01 : ((Op == 2'b10)) ? 2'b10 : 2'b00;

assign RegSrc[1:0] = ((Op == 2'b01)) ? 2'b10 : ((Op == 2'b10)) ? 2'b11 :2'b00; //BX is already here added

assign RegSrc[2] =((Op == 2'b10) & Funct[4]) ? 1'b1: 1'b0; //if BL, then 1, ow 0 for R14 selection for A3

assign WDSrc = ((Op == 2'b10) & Funct[4]) ? 1'b1: 1'b0; //if BL, then 1, for PC+4 selection to datawrite

assign shmux = ((Op == 2'b00) & Funct[5]) ? 1'b1: 1'b0; // imm mov

endmodule 

