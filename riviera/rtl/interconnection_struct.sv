`include "defines.sv"

package struct_pckg;

// Packed Struct for internal connection between ID -> EX -> MEM -> WB
typedef struct packed {
	
	logic [`RNG_64] 		rs1;
	logic [`RNG_64] 		rs2;
	
	logic [3:0]			alu_op;
	logic 				alu_en;
	logic 				alu_src;
	
	logic [`RNG_64]			pc;
	
	logic [`RNG_64]			imm_gend;
	logic 				is_branch;
	
	logic				mem_rd;
	logic				mem_wr;			
	logic 				mem_to_reg;
	
	logic				rf_wr;
	logic [`RNG_WR_ADDR_REG]	rf_wr_addr;
	logic [`RNG_64]			rf_wr_data;
	
} interconnection_struct;

endpackage
