`include "defines.sv"

package struct_pckg;

// Packed Struct for internal connection between ID -> EX -> MEM -> WB
typedef struct packed {
	
	logic [1:0]			format;	
	
	logic [`RNG_64] 		rs1;
	logic [`RNG_64] 		rs2;
	
	logic [3:0]			alu_op;
	logic 				alu_en;
	logic 				alu_src;
	
	logic [`RNG_64]			pc;
	
	logic [`RNG_64]			imm_gend;
	logic 				is_branch;
	logic 				is_compr;
	logic [1:0]                     branch_type;

	logic				mem_rd;
	logic				mem_wr;			
	logic                           mem_addr;
	logic [`RNG_64]			mem_data;
	
	logic 				mem_to_reg;
	logic				rf_wr;
	logic [`RNG_WR_ADDR_REG]	rf_wr_addr;
	logic [`RNG_64]			rf_wr_data;
	
	logic 				is_valid;
	logic 				en_sign_ext;	// take the 32bit result of ALU and sign-extend it with 32bit
	logic [1:0]			mem_req_unit;	// byte, halfword, word, double word
	logic 				mem_ext;	// signed or unsigned

        
     
} interconnection_struct;

endpackage
