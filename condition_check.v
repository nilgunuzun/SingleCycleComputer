module condition_check (input [1:0] NZ, CV, input [3:0] Cond, output CondEx);

assign CondEx = ((Cond == 4'b0000) & NZ[0]) | ((Cond == 4'b0001) & ~NZ[0]) | ((Cond == 4'b1110)) ;

endmodule