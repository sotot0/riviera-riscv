`timescale 1ns/1ns

module compr_tb();

//C0
parameter C0_ADDI4SPN 		= 16'b000_10001000_010_00 ;	// rd' = 2, nzuimm = 00101000		->	000010100000_00010_000_01010_0010011
parameter C0_ADDI4SPN_ILL 	= 16'b000_00000000_010_00 ;   	// rd' = 2, nzuimm = 00000000, RES	

parameter C0_SW			= 16'b110_010_001_01_011_00 ; 	// rs2' = 3, rs1' = 1, uimm = 10100	->	0000010_01011_01001_010_10000_0100011
parameter C0_SD			= 16'b111_010_001_01_011_00 ; 	// rs2' = 3, rs1' = 1, uimm = 01010	->	0000010_01011_01001_011_10000_0100011
parameter C0_LW			= 16'b010_010_001_01_011_00 ; 	// rd' = 3, rs1' = 1, uimm = 10100	->	000001010000_01001_010_01011_0000011 	
parameter C0_LD			= 16'b011_010_001_01_011_00 ; 	// rd' = 3, rs1' = 1, uimm = 01010	->	000001010000_01001_011_01011_0000011

parameter C0_ILL_1              = 16'b000_00000_0000_0000 ;   	// all zeros illegal insttruction	
parameter C0_ILL_2              = 16'b001_11111111111_00 ;   	// illegal funct3
parameter C0_ILL_3              = 16'b100_11111111111_00 ;   	// illegal funct3
parameter C0_ILL_4              = 16'b101_11111111111_00 ;   	// illegal funct3

//C1
parameter C1_ADDI         	= 16'b000_1_00110_01010_01;	// rs1/rd = 6, nzimm = 101010		->	111111101010_00110_000_00110_0010011
parameter C1_NOP                = 16'b000_0_00000_00000_01;	// NOP instr				->	000000000000_00000_000_00000_0010011
parameter C1_NOP_ILL		= 16'b000_1_00000_01010_01;	// nzimm!=0 -> HINT instr
parameter C1_ADDI_ILL		= 16'b000_0_00110_00000_01;     // nzimm==0 -> HINT instr

parameter C1_ADDIW        	= 16'b001_1_00110_01010_01;	// rs1/rd = 6, imm = 101010		->	111111101010_00110_000_00110_0011011
parameter C1_ADDIW_ILL          = 16'b001_1_00000_01010_01;	// rs1/rd = 0, RES 

parameter C1_LI           	= 16'b010_1_00110_01010_01;	// rd = 6, imm = 101010			->	111111101010_00000_000_00110_0010011
parameter C1_LI_ILL             = 16'b010_1_00000_01010_01;	// rd = 0, HINT

parameter C1_LUI  	  	= 16'b011_0_01110_01010_01;	// rd = 14, nzimm = 001010		->	00000000000000001010_01110_0110111
parameter C1_LUI_ILL1           = 16'b011_0_01110_00000_01;	// rd = 14, nzimm = 0, RES
parameter C1_LUI_ILL2           = 16'b011_0_00000_01010_01;     // rd = 0 , nzimm = 001010 , HINT

parameter C1_ADDI16SP	  	= 16'b011_0_00010_01010_01;	// rd = 2, nzimm = 001100		->	000011000000_00010_000_00010_0010011
parameter C1_ADDI16SP_ILL       = 16'b011_0_00010_00000_01;     // rd = 2, nzimm = 000000

parameter C1_SRLI               = 16'b100_0_00_100_10101_01;    // rs1'/rd'=4, nzuimm = 010101		->	000000_010101_01100_101_01100_0010011
parameter C1_SRAI               = 16'b100_0_01_100_10101_01;    // rs1'/rd'=4, nzuimm = 010101		->	010000_010101_01100_101_01100_0010011
parameter C1_SRLI_ILL           = 16'b100_0_00_100_00000_01;    // rs1'/rd'=4, nzuimm = 0 , HINT
parameter C1_SRAI_ILL           = 16'b100_0_01_100_00000_01;    // rs1'/rd'=4, nzuimm = 0 , HINT

parameter C1_ANDI	        = 16'b100_1_10_100_10101_01;	// rs1'/rd'=4, imm = 110101		->	111111110101_01100_111_01100_0010011

parameter C1_SUB        	= 16'b100_0_11_100_00_101_01;	// rs1'/rd'=4, rs2'=5			->	0100000_01101_01100_000_01100_0110011
parameter C1_XOR            	= 16'b100_0_11_100_01_101_01;	// rs1'/rd'=4, rs2'=5			->	0000000_01101_01100_100_01100_0110011
parameter C1_OR            	= 16'b100_0_11_100_10_101_01;	// rs1'/rd'=4, rs2'=5			->	0000000_01101_01100_110_01100_0110011
parameter C1_AND            	= 16'b100_0_11_100_11_101_01;	// rs1'/rd'=4, rs2'=5			->	0000000_01101_01100_111_01100_0110011

parameter C1_SUBW            	= 16'b100_1_11_100_00_101_01;	// rs1'/rd'=4, rs2'=5			->	0100000_01101_01100_000_01100_0111011
parameter C1_ADDW            	= 16'b100_1_11_100_01_101_01; 	// rs1'/rd'=4, rs2'=5			->	0000000_01101_01100_000_01100_0111011
parameter C1_ILL_1 	        = 16'b100_1_11_100_10_101_01;	// illegal funct3
parameter C1_ILL_2              = 16'b100_1_11_100_11_101_01;	// illegal funct3

parameter C1_J            	= 16'b101_11001010011_01;	// imm = 11001011001			->	11001011001111111111_00000_1101111
parameter C1_BEQZ         	= 16'b110_1_10_100_01010_01;	// imm = 10101001, rs1' = 4		->	1111010_00000_01100_000_10011_1100011	
parameter C1_BNEZ         	= 16'b111_1_10_100_01010_01;    // imm = 10101001, rs1' = 4		->	1111010_00000_01100_001_10011_1100011

//C2
parameter C2_SLLI         	= 16'b000_1_01001_10010_10;	// rd/rs1 = 9, nzuimm = 110010		->	000000_110010_01001_001_01001_0010011
parameter C2_SLLI_ILL1          = 16'b000_0_01001_00000_10;	// rd/rs1 = 9, nzuimm = 0, HINT
parameter C2_SLLI_ILL2          = 16'b000_1_00000_10010_10;	// rd/rs1 = 0, nzuimm = 110010, HINT

parameter C2_LWSP         	= 16'b010_1_01001_10010_10;	// rd/rs1 = 9, uimm = 101100 		->	000010110000_00010_010_01001_0000011
parameter C2_LWSP_ILL           = 16'b010_1_00000_10010_10;	// rd/rs1 = 0, uimm = 101100
parameter C2_LDSP         	= 16'b011_1_01001_10010_10;	// rd/rs1 = 9, uimm = 010110 		->	000010110000_00010_011_01001_0000011
parameter C2_LDSP_ILL           = 16'b011_1_00000_10010_10;	// rd/rs1 = 0, uimm = 101100

parameter C2_JR			= 16'b100_0_01001_00000_10;	// rs1 = 9				->	000000000000_01001_000_00000_1100111
parameter C2_JR_ILL             = 16'b100_0_00000_00000_10;     // rs1 = 0, RES 

parameter C2_MV		  	= 16'b100_0_01001_10001_10;	// rd = 9, rs2 = 17			->	0000000_10001_00000_000_01001_0110011
parameter C2_MV_ILL             = 16'b100_0_00000_10001_10;	// rd/rs1 = 0, HINT

parameter C2_JALR		= 16'b100_1_01001_00000_10;	// rs1 = 9 TODO "update pc properly"	->	000000000000_01001_000_00001_1100111
parameter C2_JALR_ILL           = 16'b100_1_00000_00000_10;     // rs1 = 0, C.EBREAK instruction

parameter C2_ADD		= 16'b100_1_01001_10001_10;	// rd/rs1 = 9, rs2 = 17			->	0000000_10001_01001_000_01001_0110011
parameter C2_ADD_ILL            = 16'b100_1_00000_10001_10;	// rd/rs1 = 0, HINT

parameter C2_SWSP         	= 16'b110_010010_01110_10;	// rs2 = 14, imm = 100100		->	0000100_011110_00010_010_10000_0100011
parameter C2_SDSP         	= 16'b111_010010_01110_10;	// rs2 = 14, imm = 010010		->	0000100_011110_00010_011_10000_0100011

parameter C2_ILL_1        	= 16'b001_11111111111_10 ;   	// illegal funct3
parameter C2_ILL_2		= 16'b101_11111111111_10 ;   	// illegal funct3


//32bit instructions
parameter FULL_32_1              = 32'hFFFF_FFFF ;   // 32bit instr
parameter FULL_32_2              = 32'h0000_0003 ;   // 32bit instr
parameter FULL_32_3              = 32'hCAFE_BEEF ;   // 32bit instr
parameter FULL_32_4              = 32'hB16B_00B7 ;   // 32bit instr 
parameter FULL_32_5              = 32'hBABA_EEFF ;   // 32bit instr 

logic [31:0] i_instr;
logic [31:0] o_instr;
logic o_is_compr;
logic o_ill_instr;
logic clk = 0;

always #10 begin
	clk=~clk;
end


compr_instr_unit unit( i_instr, o_instr, o_is_compr, o_ill_instr );


initial begin

	//C0
	@(posedge clk);
        $display("#########################	C0	###################################\n");
	i_instr = C0_ADDI4SPN ;
	@(posedge clk);
	$display("[C0_ADDI4SPN]\tInstruction:	%3b_%8b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C0_ADDI4SPN_ILL ;
        @(posedge clk);
        $display("[C0_ADDI4SPN_ILL]\tInstruction:	%3b_%8b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);

	@(posedge clk);
        i_instr = C0_SW ;
        @(posedge clk);
        $display("[C0_SW]\tInstruction:	%3b_%3b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C0_SD ;
        @(posedge clk);
        $display("[C0_SD]\tInstruction:	%3b_%3b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);

 	@(posedge clk);
        i_instr = C0_LW ;
        @(posedge clk);
        $display("[C0_LW]\tInstruction:	%3b_%3b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C0_LD ;
        @(posedge clk);
        $display("[C0_LD]\tInstruction:	%3b_%3b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);

	@(posedge clk);
        i_instr = C0_ILL_1 ;
        @(posedge clk);
        $display("[C0_ILL_1]\tInstruction:	%3b_%11b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %32b , Is Instruction illegal? %1b \n", i_instr[15:13], i_instr[12:2],  i_instr[1:0] , o_is_compr,  o_instr, o_ill_instr);
	@(posedge clk);
        i_instr = C0_ILL_2 ;
        @(posedge clk);
        $display("[C0_ILL_2]\tInstruction:	%3b_%11b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %32b , Is Instruction illegal? %1b \n", i_instr[15:13], i_instr[12:2],  i_instr[1:0] , o_is_compr,  o_instr, o_ill_instr);
	@(posedge clk);
        i_instr = C0_ILL_3 ;
        @(posedge clk);
        $display("[C0_ILL_3]\tInstruction:	%3b_%11b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %32b , Is Instruction illegal? %1b \n", i_instr[15:13], i_instr[12:2],  i_instr[1:0] , o_is_compr,  o_instr, o_ill_instr);
	@(posedge clk);
        i_instr = C0_ILL_4 ;
        @(posedge clk);
        $display("[C0_ILL_4]\tInstruction:	%3b_%11b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %32b , Is Instruction illegal? %1b \n", i_instr[15:13], i_instr[12:2],  i_instr[1:0] , o_is_compr,  o_instr, o_ill_instr);


	//C1
	@(posedge clk);
        $display("#########################     C1      ###################################\n");
 	@(posedge clk);
        i_instr = C1_ADDI;
        @(posedge clk);
        $display("[C1_ADDI]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
      	@(posedge clk);
        i_instr = C1_ADDI_ILL;
        @(posedge clk);
        $display("[C1_ADDI_ILL]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr); 
	@(posedge clk);
        i_instr = C1_NOP;
        @(posedge clk);
        $display("[C1_NOP]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C1_NOP_ILL;
        @(posedge clk);
        $display("[C1_NOP_ILL]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C1_ADDIW;
        @(posedge clk);
        $display("[C1_ADDIW]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C1_ADDIW_ILL;
        @(posedge clk);
        $display("[C1_ADDIW_ILL]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
	i_instr = C1_LI;
        @(posedge clk);
        $display("[C1_LI]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C1_LI_ILL;
        @(posedge clk);
        $display("[C1_LI_ILL]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
	i_instr = C1_LUI;
        @(posedge clk);
        $display("[C1_LUI]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %20b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_LUI_ILL1;
        @(posedge clk);
        $display("[C1_LUI_ILL1]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %20b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_LUI_ILL2;
        @(posedge clk);
        $display("[C1_LUI_ILL2]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %20b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C1_ADDI16SP;
        @(posedge clk);
        $display("[C1_ADDI16SP]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C1_ADDI16SP_ILL;
        @(posedge clk);
        $display("[C1_ADDI16SP_ILL]	Instruction:	%3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n", i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C1_SRLI ;
        @(posedge clk);
        $display("[C1_SRLI]	Instruction:	%3b_%1b_%2b_%3b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %6b_%6b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:2],i_instr[1:0], o_is_compr, o_instr[31:26], o_instr[25:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_SRLI_ILL ;
        @(posedge clk);
        $display("[C1_SRLI_ILL]	Instruction:	%3b_%1b_%2b_%3b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %6b_%6b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:2],i_instr[1:0], o_is_compr, o_instr[31:26], o_instr[25:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_SRAI ;
        @(posedge clk);
        $display("[C1_SRAI]	Instruction:	%3b_%1b_%2b_%3b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %6b_%6b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:2],i_instr[1:0], o_is_compr, o_instr[31:26], o_instr[25:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_SRAI_ILL ;
        @(posedge clk);
        $display("[C1_SRAI_ILL]	Instruction:	%3b_%1b_%2b_%3b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %6b_%6b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:2],i_instr[1:0], o_is_compr, o_instr[31:26], o_instr[25:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C1_ANDI ;
        @(posedge clk);
        $display("[C1_ANDI]	Instruction:	%3b_%1b_%2b_%3b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %12b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:2],i_instr[1:0], o_is_compr, o_instr[31:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C1_SUB ;
        @(posedge clk);
        $display("[C1_SUB]	Instruction:	%3b_%1b_%2b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C1_XOR ;
        @(posedge clk);
        $display("[C1_XOR]	Instruction:	%3b_%1b_%2b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_OR ;
        @(posedge clk);
        $display("[C1_OR]	Instruction:	%3b_%1b_%2b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_AND ;
        @(posedge clk);
        $display("[C1_AND]	Instruction:	%3b_%1b_%2b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_SUBW ;
        @(posedge clk);
        $display("[C1_SUBW]	Instruction:	%3b_%1b_%2b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_ADDW ;
        @(posedge clk);
        $display("[C1_ADDW]	Instruction:	%3b_%1b_%2b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_ILL_1 ;
        @(posedge clk);
        $display("[C1_ILL_1]	Instruction:	%3b_%1b_%2b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C1_ILL_2 ;
        @(posedge clk);
        $display("[C1_ILL_2]	Instruction:	%3b_%1b_%2b_%3b_%2b_%3b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:5],i_instr[4:2],i_instr[1:0], o_is_compr,  o_instr[31:25],o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);



	@(posedge clk);
        i_instr = C1_J ;
        @(posedge clk);
        $display("[C1_J]	Instruction:	%3b_%11b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %20b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12:2], i_instr[1:0], o_is_compr,o_instr[31:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C1_BEQZ ;
        @(posedge clk);
        $display("[C1_BEQZ]	Instruction:	%3b_%1b_%2b_%3b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:2],i_instr[1:0], o_is_compr, o_instr[31:25], o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C1_BNEZ ;
        @(posedge clk);
        $display("[C1_BNEZ]	Instruction:	%3b_%1b_%2b_%3b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction: %7b_%5b_%5b_%3b_%5b_%7b , Is Instruction illegal? %1b \n",i_instr[15:13],i_instr[12],i_instr[11:10],i_instr[9:7],i_instr[6:2],i_instr[1:0], o_is_compr, o_instr[31:25], o_instr[24:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);




	//C2
	@(posedge clk);
        $display("#########################     C2      ###################################\n");
        @(posedge clk);
        i_instr = C2_SLLI ;
        @(posedge clk);
        $display("[C2_SLLI]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %6b_%6b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:26],o_instr[25:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C2_SLLI_ILL1 ;
        @(posedge clk);
        $display("[C2_SLLI_ILL1]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %6b_%6b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:26],o_instr[25:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C2_SLLI_ILL2 ;
        @(posedge clk);
        $display("[C2_SLLI_ILL2]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %6b_%6b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:26],o_instr[25:20],o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C2_LWSP ;
	@(posedge clk);
        $display("[C2_LWSP]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %12b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C2_LWSP_ILL ;
        @(posedge clk);
        $display("[C2_LWSP_ILL]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %12b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C2_LDSP ;
        @(posedge clk);
        $display("[C2_LDSP]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %12b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C2_LDSP_ILL ;
        @(posedge clk);
        $display("[C2_LDSP_ILL]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %12b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C2_JR ;
        @(posedge clk);
        $display("[C2_JR]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %12b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C2_JR_ILL ;
        @(posedge clk);
        $display("[C2_JR_ILL]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %12b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C2_MV ;
        @(posedge clk);
        $display("[C2_MV]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:25], o_instr[24:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C2_MV_ILL ;
        @(posedge clk);
        $display("[C2_MV_ILL]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr, o_instr[31:25], o_instr[24:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C2_JALR ;
        @(posedge clk);
        $display("[C2_JALR]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %12b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C2_JALR_ILL ;
        @(posedge clk);
        $display("[C2_JALR_ILL]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %12b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


        @(posedge clk);
        i_instr = C2_ADD ;
        @(posedge clk);
        $display("[C2_ADD]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:25], o_instr[24:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
        @(posedge clk);
        i_instr = C2_ADD_ILL ;
        @(posedge clk);
        $display("[C2_ADD_ILL]	Instruction:	 %3b_%1b_%5b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12],i_instr[11:7],i_instr[6:2],i_instr[1:0], o_is_compr, o_instr[31:25], o_instr[24:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C2_SWSP ;
        @(posedge clk);
        $display("[C2_SWSP]	Instruction:	 %3b_%6b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:25], o_instr[24:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);
	@(posedge clk);
        i_instr = C2_SDSP ;
        @(posedge clk);
        $display("[C2_SDSP]	Instruction:	 %3b_%6b_%5b_%2b, Is instruction compressed? %1b ,Decompressed instruction:  %7b_%5b_%5b_%3b_%5b_%7b  , Is Instruction illegal? %1b \n",  i_instr[15:13],i_instr[12:7],i_instr[6:2],i_instr[1:0], o_is_compr,  o_instr[31:25], o_instr[24:20], o_instr[19:15],o_instr[14:12],o_instr[11:7],o_instr[6:0], o_ill_instr);


	@(posedge clk);
        i_instr = C2_ILL_1 ;
        @(posedge clk);
        $display("[C2_ILL_1]	Instruction:	 %3b_%11b_%2b , Is instruction compressed? %1b ,Decompressed instruction: %32b , Is Instruction illegal? %1b \n", i_instr[15:13], i_instr[12:2],  i_instr[1:0] ,o_is_compr,  o_instr, o_ill_instr);
        @(posedge clk);
        i_instr = C2_ILL_2 ;
        @(posedge clk);
        $display("[C2_ILL_2]	Instruction:	 %3b_%11b_%2b , Is instruction compressed? %1b ,Decompressed instruction: %32b , Is Instruction illegal? %1b \n", i_instr[15:13], i_instr[12:2],  i_instr[1:0] ,o_is_compr,  o_instr, o_ill_instr);


	//full 32bit instrutions
	@(posedge clk);
        i_instr = FULL_32_1 ;
        @(posedge clk);
        $display("[FULL_32_1]	Instruction:	 %8h , Is instruction compressed? %1b ,Decompressed instruction: %8h , Is Instruction illegal? %1b \n", i_instr ,o_is_compr,  o_instr, o_ill_instr);
	@(posedge clk);
        i_instr = FULL_32_2 ;
        @(posedge clk);
        $display("[FULL_32_2]	Instruction:	 %8h , Is instruction compressed? %1b ,Decompressed instruction: %8h , Is Instruction illegal? %1b \n", i_instr ,o_is_compr,  o_instr, o_ill_instr);
	@(posedge clk);
        i_instr = FULL_32_3 ;
        @(posedge clk);
        $display("[FULL_32_3]	Instruction:	 %8h , Is instruction compressed? %1b ,Decompressed instruction: %8h , Is Instruction illegal? %1b \n", i_instr ,o_is_compr,  o_instr, o_ill_instr);
	@(posedge clk);
        i_instr = FULL_32_4 ;
        @(posedge clk);
        $display("[FULL_32_4]	Instruction:	 %8h , Is instruction compressed? %1b ,Decompressed instruction: %8h , Is Instruction illegal? %1b \n", i_instr ,o_is_compr,  o_instr, o_ill_instr);
	@(posedge clk);
        i_instr = FULL_32_5 ;
        @(posedge clk);
        $display("[FULL_32_5]	Instruction:	 %8h , Is instruction compressed? %1b ,Decompressed instruction: %8h , Is Instruction illegal? %1b \n", i_instr ,o_is_compr,  o_instr, o_ill_instr);


        $finish;

end

endmodule
