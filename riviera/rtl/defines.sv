 // File that includes all the defines of the Risc-V implementation

`ifndef DEFINES_SV
`define DEFINES_SV

`define W_64		64
`define W_32 		32
`define RNG_64		`W_64-1:0
`define RNG_32		`W_32-1:0

 // IF-relative defines
`define IM_DATA_BYTES	`W_32/8			// Total bytes of a IM word
`define IM_DEPTH	2048			// Total words of IM
`define IM_ADDR		$clog2(`IM_DEPTH)	// Address size of IM


 // ID-relative defines
`define ALEN		5			// Register address size
`define DLEN		64			// Register data size
`define RNG_WR_ADDR_REG	`ALEN-1:0
`define RNG_WR_DATA_REG	`DLEN-1:0


 // Instruction Field Ranges
`define RNG_OP		6:0
`define RNG_RD		11:7
`define RNG_RS1		19:15
`define RNG_RS2		24:20
`define RNG_IMM12_I	31:20
`define RNG_IMM12_BS	{31:25,11:7}
`define RNG_IMM20	31:12
`define RNG_F3		14:12
`define RNG_F7		31:25

 

 // OPCODES

 // RV32I Base Instruction Set
`define LUI		7'b0110111
`define AUIPC		7'b0010111
`define JAL		7'b1101111

`define JALR		7'b1100111
`define F3_JALR		3'b000
 
 //Branches
`define BRANCH		7'b1100011
`define F3_BEQ		3'b000
`define F3_BNE		3'b001
`define F3_BLT		3'b100
`define F3_BGE		3'b101
`define F3_BLTU		3'b110
`define F3_BGEU		3'b111

 // Loads
`define LOAD		7'b0000011
`define F3_LB		3'b000
`define F3_LH		3'b001
`define F3_LW		3'b010
`define F3_LBU		3'b100
`define F3_LHU		3'b101

 // Stores
`define STORE		7'b0100011
`define F3_SB		3'b000
`define F3_SH		3'b001
`define F3_SW		3'b010

 // Immidiates
`define IMM		7'b0010011
`define F3_ADDI		3'b000
`define F3_SLTI		3'b010
`define F3_SLTIU	3'b011
`define F3_XORI		3'b100
`define F3_ORI		3'b110
`define F3_ANDI		3'b111
`define F3_SLLI		3'b001

`define F3_SR		3'b101
`define F7_SLLI		7'b0000000
`define F7_SRLI		7'b0000000
`define F7_SRAI		7'b0100000

 // ALU
`define ALU		7'b0110011
`define F3_ADD_SUB	3'b000
`define F3_SLL		3'b001
`define F3_SLT		3'b010
`define F3_SLTU		3'b011
`define F3_XOR		3'b100
`define F3_SRL_SRA	3'b101
`define F3_OR		3'b110
`define F3_AND		3'b111
`define F7_ADD		7'b0000000
`define F7_SUB		7'b0100000
`define F7_SLL		7'b0000000
`define F7_SLT		7'b0000000
`define F7_SLTU		7'b0000000
`define F7_XOR		7'b0000000
`define F7_SRL		7'b0000000
`define F7_SRA		7'b0100000
`define F7_OR		7'b0000000
`define F7_AND		7'b0000000

 // RV64I Base Instruction Set
`define LWU_LD_64	7'b0000011
`define F3_LWU_64	3'b110
`define F3_LD_64	3'b011
`define SD_64		7'b0100011

`define ADDIW_SLLIW_SRLIW_SRAIW_64	7'b0011011
`define F3_ADDIW_64	3'b000
`define F3_SLLIW_64	3'b001
`define F3_SRLIW_SRAIW_64		3'b101
`define F7_SLLIW_64	7'b0000000
`define F7_SRLIW_64	7'b0000000
`define F7_SRAIW_64	7'b0100000

`define ALU_64		7'b0111011
`define F3_ADDW_SUBW_64	3'b000
`define F3_SLLW_64	3'b001
`define F3_SRLW_SRAW_64	3'b101
`define F7_ADDW_64	7'b0000000
`define F7_SUBW_64	7'b0100000
`define F7_SLLW_64	7'b0000000
`define F7_SRLW_64	7'b0000000
`define F7_SRAW_64	7'b0100000









`endif
