
module Controllernew(

	  input clk,
	  
	  input [3:0] Cond,		
	  input [1:0] Op,			
	  input [5:0] Funct,		
	  //input [3:0] Rd,			
	  
	  input  Z_FLAG,
	  
	  output reg PCSrc,
	  output reg RegWrite,
	  output reg MemWrite,
	  
	  output reg MemtoReg,
	  output reg ALUSrc,
	  output reg ALUSrcnew,
	  output reg shmux,
	  output reg WDSrc,
	  output reg [1:0] ImmSrc,
	  output reg [2:0] RegSrc,
	  output reg [3:0] ALUControl,
	  output reg shamtselectforBX
	  
    );
	 
reg Condition;

reg FlagWrite;
wire Z;

Register_en #(1) flags_Z (.clk(clk),.en(FlagWrite),.DATA(Z_FLAG),.OUT(Z));


// Conditional Logic

always @(*) begin

Condition = 1;

	case(Cond)
	
		// EQ
		4'b0000: 
					if(Z == 1)
						Condition = 1;
					else
						Condition = 0;
						
		// NE
		4'b0001:	
					if(Z == 0)
						Condition = 1;
					else 
						Condition = 0;
		
		// AL
		4'b1110:  
					Condition = 1;
		
		default: Condition = 1;
					
		
endcase		
	 
end

 

always @(*) begin

					shamtselectforBX = 0;
					FlagWrite = 0;
					PCSrc			= 1'b0;
					RegWrite		= 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000; 
					ALUControl	= 4'b1101;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					
// First Look at Opcode to detect Instruction Type
	case(Op) 
	
// Data-Processing Instruction (Opcode = 00) or BX

		2'b00:				
			case(Funct[4:1]) 	// Determine the instruction
			
				
				4'b0000:			// AND
					
					begin
					
					PCSrc			= 1'b0;
					RegWrite		= Condition ? 1'b1 : 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000;
					ALUControl	= 4'b0000;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					
					end
				
				4'b0010:			// SUB 
					
					begin
					
					PCSrc			= 1'b0;
					RegWrite		= Condition ? 1'b1 : 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000;
					ALUControl	= 4'b0010;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					
					end
					
				4'b0100:			// ADD 
					
					begin

					PCSrc			= 1'b0;
					RegWrite		= Condition ? 1'b1 : 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000;
					ALUControl	= 4'b0100;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					
					end
								
				4'b1010:			// CMP
					
					begin
					
					PCSrc			= 1'b0;
					RegWrite		= 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00; 
					RegSrc		= 3'b000; 
					ALUControl	= 4'b0010;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					FlagWrite	= 1'b1;
					end				
						
				4'b1100:			// ORR
					
					begin
					
					PCSrc			= 1'b0;
					RegWrite		= Condition ? 1'b1 : 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000;
					ALUControl	= 4'b1100;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					
					end
					
				4'b1101:			// MOV
					
					begin
					
					PCSrc			= 1'b0;
					RegWrite		= Condition ? 1'b1 : 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000; 
					ALUControl	= 4'b1101;
					ALUSrcnew	= Funct[5] ? 1'b1 : 1'b0;
					shmux			= Funct[5] ? 1'b1 : 1'b0;
					WDSrc			= 1'b0;
					
					end
					
				4'b1001:			// BX
					
					begin
					shamtselectforBX = 1'b1;
					PCSrc			= Condition ? 1'b1 : 1'b0;
					RegWrite		= 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000; 
					ALUControl	= 4'b1101;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					
					end
					
				default:
					begin
					PCSrc			= 1'b0;
					RegWrite		= 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000; 
					ALUControl	= 4'b1101;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					end
			endcase
			
// Memory Instruction (Opcode = 01)	

		2'b01:	
		
		case(Funct[0]) 
			
				1'b0:				// STR
					
					begin
				
					PCSrc			= 1'b0;
					RegWrite		= 1'b0;
					MemWrite		= Condition ? 1'b1 : 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b1;
					ImmSrc		= 2'b01;
					RegSrc		= 3'b010;
					ALUControl	= 4'b0100;
					
					ALUSrcnew	= 1'b1;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					
					end
					
				1'b1:				// LDR
					
					begin
					
					PCSrc			= 1'b0;
					RegWrite		= Condition ? 1'b1 : 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b1;
					ALUSrc		= 1'b1;
					ImmSrc		= 2'b01;
					RegSrc		= 3'b010; 
					ALUControl	= 4'b0100;
					
					ALUSrcnew	= 1'b1;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					
					end
					
				default:
					begin
					PCSrc			= 1'b0;
					RegWrite		= 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000; 
					ALUControl	= 4'b1101;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					end
					
				endcase
				
// Branch Instruction (Opcode = 10)	

		2'b10:
		
			case(Funct[5:4]) 
			
				2'b10: 			// B
					begin
				
					PCSrc			= Condition ? 1'b1 : 1'b0;
					RegWrite		= 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b1;
					ImmSrc		= 2'b10;
					RegSrc		= 3'b001; 
					ALUControl	= 4'b0100;
					
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					end

				
				2'b11: 			// BL
				
					begin
					
					PCSrc			= Condition ? 1'b1 : 1'b0;
					RegWrite		= Condition ? 1'b1 : 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b1;
					ImmSrc		= 2'b10;
					RegSrc		= 3'b101; 
					ALUControl	= 4'b0100;
					
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b1;
					
					end
				
				default:
					begin
					PCSrc			= 1'b0;
					RegWrite		= 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000; 
					ALUControl	= 4'b1101;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					end
					
			endcase
			
		default:
					begin
					PCSrc			= 1'b0;
					RegWrite		= 1'b0;
					MemWrite		= 1'b0;
					MemtoReg		= 1'b0;
					ALUSrc		= 1'b0;
					ImmSrc		= 2'b00;
					RegSrc		= 3'b000; 
					ALUControl	= 4'b1101;
					ALUSrcnew	= 1'b0;
					shmux			= 1'b0;
					WDSrc			= 1'b0;
					end
		
		endcase
		
end
 
endmodule