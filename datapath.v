module datapath (input reset, 
						input clk, output [31:0] fetchPC, 
						input [3:0] debug_reg_select, output [31:0] debug_reg_out
						);


wire [31:0] SrcA, SrcB, ALUResult, ReadData, WD3;
wire [31:0] PC_next, Instr,PC; 
wire RegWrite;
wire [3:0] RA1, RA2,RA3, ALUControl;
wire [31:0] MemtoReg_out;
wire [31:0] PCPlus4, PCPlus8;
wire [31:0] RD2;
wire [31:0] ExtImm, shifter_out, preshifter;
wire PCSrc, ALUSrc, MemtoReg, WDSrc; 
wire [2:0] RegSrc;
wire [1:0] ImmSrc, sh_shifter;

wire shamtselect, ALUSrcnew;

wire [4:0] shamt_shifter, shamt_shifter_pre;

wire CO,OVF,N,Z, CI, MemWrite;

//controller controlll(.clk(clk), .Cond(Instr[31:28]), .ALUFlags({N,Z,CO,OVF}), .RD(Instr[15:12]),
//.Op(Instr[27:26]), .Funct(Instr[25:20]), 
//.PCSrc(PCSrc), .RegWrite(RegWrite), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .ALUSrc(ALUSrc),.ALUSrcnew(ALUSrcnew),.shmux(shamtselect),
//.ImmSrc(ImmSrc), .RegSrc(RegSrc), .ALUControl(ALUControl), .WDSrc(WDSrc));
//didnt work too complicated

Controllernew control(
	  .clk(clk),
	  .Cond(Instr[31:28]),		// Opcode Instr[31:28]
	  .Op(Instr[27:26]),			//	Opcode Instr[27:26]
	  .Funct(Instr[25:20]),		// Opcode Instr[25:20]
	  //.Rd(Instr[15:12]),			//	Opcode Instr[15:12]
	  
	  .Z_FLAG(Z),
	  
	  
	  .PCSrc(PCSrc),
	  .RegWrite(RegWrite), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .ALUSrc(ALUSrc),.ALUSrcnew(ALUSrcnew),.shmux(shamtselect),
.ImmSrc(ImmSrc), .RegSrc(RegSrc), .ALUControl(ALUControl), .WDSrc(WDSrc) ,.shamtselectforBX(shamtselectforBX));





assign fetchPC = PC;

Mux_2to1 #(32) PCSrc_mux(.select(PCSrc),.input_0(PCPlus4), .input_1(MemtoReg_out),.output_value(PC_next));

Register_reset #(32) pcreg(.clk(clk), .reset(reset),.DATA(PC_next),.OUT(PC));

Instruction_memory instructionmem (.ADDR(PC),.RD(Instr));

Adder #(32) PC_Plus4(.DATA_A(PC),.DATA_B(32'h4),.OUT(PCPlus4));

Adder #(32) PC_Plus8(.DATA_A(PCPlus4),.DATA_B(32'h4),.OUT(PCPlus8));

Mux_2to1 #(4) RegSrc_RA1(.select(RegSrc[0]),.input_0(Instr[19:16]), .input_1(4'b1111),.output_value(RA1));

Mux_2to1 #(4) RegSrc_RA2(.select(RegSrc[1]),.input_0(Instr[3:0]), .input_1(Instr[15:12]),.output_value(RA2));

Mux_2to1 #(4) RegSrc_RA3_forBL(.select(RegSrc[2]),.input_0(Instr[15:12]), .input_1(4'b1110),.output_value(RA3));

Mux_2to1 #(32) RegSrc_WD3_forBL(.select(WDSrc),.input_0(MemtoReg_out), .input_1(PCPlus4),.output_value(WD3));

Register_file #(32) regfile (.clk(clk), .write_enable(RegWrite), .reset(reset),
.Source_select_0(RA1), .Source_select_1(RA2), .Destination_select(RA3), .Debug_Source_select(debug_reg_select),
	  .DATA(WD3), .Reg_15(PCPlus8),
	  .out_0(SrcA), .out_1(RD2), .Debug_out(debug_reg_out)
    );

Extender extend(.Extended_data(ExtImm),.DATA(Instr[23:0]),.select(ImmSrc));

shifter #(5) shiftextra (.control(2'b00),.shamt(5'b00001),
 .DATA({1'b0,Instr[11:8]}), .OUT(shamt_shifter_pre) );
 
 wire [4:0] shamt_shifter_mid;
 wire shamtselectforBX;
 
Mux_2to1 #(5) shamtselectt(.select(shamtselect),.input_0(Instr[11:7]), .input_1(shamt_shifter_pre),.output_value(shamt_shifter_mid));

Mux_2to1 #(5) shamtselectt2forBX(.select(shamtselectforBX),.input_0(shamt_shifter_mid), .input_1(5'h0),.output_value(shamt_shifter));


Mux_2to1 #(32) ALUSrc_new(.select(ALUSrcnew),.input_0(RD2), .input_1(ExtImm),.output_value(preshifter));

Mux_2to1 #(2) sh_select(.select(shamtselect),.input_0(Instr[6:5]), .input_1(2'b11),.output_value(sh_shifter));


shifter #(32) shift (.control(sh_shifter),.shamt(shamt_shifter),
 .DATA(preshifter), .OUT(shifter_out) );

Mux_2to1 #(32) ALUSrc_mux(.select(ALUSrc),.input_0(shifter_out), .input_1(ExtImm),.output_value(SrcB));


ALU #(32)  ALUU(.control(ALUControl),.CI(CI),.DATA_A(SrcA),.DATA_B(SrcB),
      .OUT(ALUResult),.CO(CO),.OVF(OVF),.N(N), .Z(Z));

Memory mem(.clk(clk),.WE(MemWrite),.ADDR(ALUResult),.WD(RD2),.RD(ReadData));

Mux_2to1 #(32) MemtoReg_mux(.select(MemtoReg),.input_0(ALUResult), .input_1(ReadData),.output_value(MemtoReg_out));























endmodule