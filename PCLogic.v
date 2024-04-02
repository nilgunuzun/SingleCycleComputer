module PCLogic (input Branch, RegW, BranchX, input [3:0] RD, output PCS);

assign PCS = ((RD == 15) & RegW) | Branch | BranchX; //BX is added BL is already here
endmodule