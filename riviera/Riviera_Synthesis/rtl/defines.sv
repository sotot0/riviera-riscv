`timescale 1ns/100fs
 
// File that includes all the defines of the Risc-V implementation
`ifndef DEFINES_SV
`define DEFINES_SV
 
 //
`define W_64				64
`define W_32 				32
`define RNG_64				`W_64-1:0
`define RNG_32				`W_32-1:0

 // IF-relative defines
`define IM_DATA_BYTES			`W_32/8			// Total bytes of a IM word
`define IM_DEPTH			2048			// Total words of IM
//`define IM_DEPTH			4096
`define IM_ADDR				$clog2(`IM_DEPTH)	// Address size of IM

 // ID-relative defines
`define ALEN				5			// Register address size
`define DLEN				64			// Register data size
`define RNG_WR_ADDR_REG			`ALEN-1:0
`define RNG_WR_DATA_REG			`DLEN-1:0

 // Instruction format relative
`define R_FORM				2'b00			// R Format
`define JU_FORM				2'b01			// J, U Format
`define I_FORM				2'b10			// I Format
`define BS_FORM				2'b11			// B, S Format

 // Instruction Field Ranges
`define RNG_OP				6:0			// opcode field
`define RNG_RD				11:7			// rd reg field
`define RNG_RS1				19:15			// rs1 reg field
`define RNG_RS2				24:20			// rs2 reg field
`define RNG_IMM12_I			31:20			// imm12 field on I format instructions
`define RNG_IMM12_BS			{31:25,11:7}		// imm12 field on B, S format instructions
`define RNG_IMM20			31:12			// imm20 field on J, U format instructions
`define RNG_F3				14:12			// funct3 field on I, R, B, S format instructions
`define RNG_F7				31:25			// funct7 filed on R format instructions

 // MEM-relative defines
 // extention							// defines formem_ext on interconnection struct
`define SIGNED				0			
`define UNSIGNED			1

 // size							// values for mem_req_unit on interconnection struct
`define B				4'b0001			// byte
`define HW				4'b0010			// half word
`define W				4'b0100			// word
`define DW				4'b1000			// double word

 // ALU OP
 // 32bit
`define DO_ADD				4'b0000
`define DO_SUB				4'b0001
`define DO_SLL				4'b0010
`define DO_SLT				4'b0011
`define DO_SLTU				4'b0100
`define DO_XOR				4'b0101
`define DO_SRL				4'b0110
`define DO_SRA				4'b0111
`define DO_OR				4'b1000
`define DO_AND				4'b1001
`define DO_LUI				4'b1010
`define DO_AUIPC			4'b1011
`define DO_BGE				4'b1100
`define DO_BLT				4'b1101
 
// OPCODES
 
 // RV32I Base OPCODES
`define LUI				7'b0110111
`define AUIPC				7'b0010111
`define JAL				7'b1101111

`define JALR				7'b1100111
`define F3_JALR				3'b000
 
 //Branches
`define BRANCH				7'b1100011
`define F3_BEQ				3'b000
`define F3_BNE				3'b001
`define F3_BLT				3'b100
`define F3_BGE				3'b101
`define F3_BLTU				3'b110
`define F3_BGEU				3'b111
`define BEQ				2'b00
`define BNE				2'b01
`define BLTU				2'b10
`define BGEU				2'b11

 // Loads
`define LOAD				7'b0000011
`define F3_LB				3'b000
`define F3_LH				3'b001
`define F3_LW				3'b010
`define F3_LBU				3'b100
`define F3_LHU				3'b101

 // Stores
`define STORE				7'b0100011
`define F3_SB				3'b000
`define F3_SH				3'b001
`define F3_SW				3'b010
`define F3_SD				3'b011

 // Immediate
`define IMM				7'b0010011
`define F3_ADDI				3'b000
`define F3_SLTI				3'b010
`define F3_SLTIU			3'b011
`define F3_XORI				3'b100
`define F3_ORI				3'b110
`define F3_ANDI				3'b111
`define F3_SLLI				3'b001

`define F3_SR				3'b101
`define F7_SLLI				7'b0000000
`define F7_SRLI				7'b0000000
`define F7_SRAI				7'b0100000

 // ALU
`define ALU				7'b0110011
`define F3_ADD_SUB			3'b000
`define F3_SLL				3'b001
`define F3_SLT				3'b010
`define F3_SLTU				3'b011
`define F3_XOR				3'b100
`define F3_SRL_SRA			3'b101
`define F3_OR				3'b110
`define F3_AND				3'b111
`define F7_ADD				7'b0000000
`define F7_SUB				7'b0100000
`define F7_SLL				7'b0000000
`define F7_SLT				7'b0000000
`define F7_SLTU				7'b0000000
`define F7_XOR				7'b0000000
`define F7_SRL				7'b0000000
`define F7_SRA				7'b0100000
`define F7_OR				7'b0000000
`define F7_AND				7'b0000000

 // RV64I Base OPCODES
`define LWU_LD_64			7'b0000011
`define F3_LWU_64			3'b110
`define F3_LD_64			3'b011
`define SD_64				7'b0100011

`define ADDIW_SLLIW_SRLIW_SRAIW_64	7'b0011011
`define F3_ADDIW_64			3'b000
`define F3_SLLIW_64			3'b001
`define F3_SRLIW_SRAIW_64		3'b101
`define F7_SLLIW_64			7'b0000000
`define F7_SRLIW_64			7'b0000000
`define F7_SRAIW_64			7'b0100000

`define ALU_64				7'b0111011
`define F3_ADDW_SUBW_64			3'b000
`define F3_SLLW_64			3'b001
`define F3_SRLW_SRAW_64			3'b101
`define F7_ADDW_64			7'b0000000
`define F7_SUBW_64			7'b0100000
`define F7_SLLW_64			7'b0000000
`define F7_SRLW_64			7'b0000000
`define F7_SRAW_64			7'b0100000

 // Stall Controller
`define RS1				2'b10
`define RS2				2'b01
`define RS1_RS2				2'b11
`define NONE				2'b00

`endif
