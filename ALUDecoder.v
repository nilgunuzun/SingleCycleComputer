module ALUDecoder (input ALUOp, input [4:0] Funct, 
output [3:0] ALUControl, 
output [1:0] FlagW, 
output NoWrite
);

assign FlagW = (ALUOp & ((Funct == 5'b01001) | (Funct == 5'b00101) | (Funct[4:1] == 4'b1010) )) ? 2'b11 : //cmp added
			(ALUOp & ((Funct == 5'b00001)| (Funct == 5'b11001) | (Funct == 5'b00011)) ) ? 2'b10 : 2'b00; //exor added
			
assign ALUControl = (ALUOp & ((Funct[4:0] != 5'b10010) | (Funct[4:1] != 4'b1010))) ? Funct[4:1] :
 ALUOp & (Funct[4:1] == 4'b1010) ? 4'b0010 : 
 ~ALUOp ? 4'b0100 : 4'b1101; //BX and MOV included

assign NoWrite = (ALUOp & (Funct[4:0] == 5'b10101))? 1'b1 : 1'b0; //CMP


endmodule