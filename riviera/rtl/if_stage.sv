`include "defines.sv"

module if_stage(
	input logic				clk,
	input logic				rst_n,

	// IM setup inputs
	input logic [`IM_DATA_BYTES-1:0]	i_wen,
	input logic [`RNG_32]			i_wdata,

	// ID-relative inputs
	input logic 				i_id_ready,	// is ID stage ready	

	// EX-relative inputs
	input logic				branch_in_ex,	// branch taken in EX
	input logic [`RNG_64]			branch_target,	// branch target	

	input logic				jump_in_ex,	// jump in ex
	input logic				jump_target,	// jump target

	input logic				i_ex_flush_if,

	// ID-relative outputs
	output logic [`RNG_32]			o_if_instr,	// instruction out
	output logic [`RNG_64]			o_if_pc		// PC out	
);

	logic [`RNG_64]				if_pc;		// local pc
	logic [`RNG_32]				if_instr;	// local instr
	logic					if_stg_valid;   // validity of IF stage
	logic [`RNG_64]				fetch_addr;	// address to fetch
	logic [3:0]				fetch_selector; // select addr to fetch

	instr_mem 
	#(
		.DEPTH		(`IM_DEPTH),
		.DATA_WIDTH 	(`W_32)
	)
	instr_mem_instance
	(
		.clk		(clk),
		.i_addr		(fetch_addr[`IM_ADDR-1:0]),
		.i_wdata	(i_wdata),
		.i_wen		(i_wen),
		.o_rdata	(if_instr)
	);

	always_comb begin

		fetch_selector = {~rst_n, ~i_id_ready, branch_in_ex, jump_in_ex};

		unique casex(fetch_selector)

			4'b1xxx: begin
					if_stg_valid = 1'b0;	// simple reset
					fetch_addr = 0;		// pc <- zero
			end
			4'b01xx: begin
					if_stg_valid = 1'b0;	// stall because of ID readiness
					fetch_addr = if_pc;	// pc <- same_old
			end
			4'b001x: begin
					if_stg_valid = 1'b1; 		// taken branch higher priority over simple jump
					fetch_addr = branch_target;	// pc <- branch target
			end
			4'b0001: begin
					if_stg_valid = 1'b1;		// jump instr. in ID
					fetch_addr = jump_target;;	// pc <- jump target
			end
			default: begin
					if_stg_valid = 1'b1;	// continue
					fetch_addr = if_pc + 4; // pc <- +4
			end
		endcase
	end

	assign if_pc = fetch_addr;
	assign o_if_instr = if_instr;

	always_ff @( posedge clk, negedge rst_n ) begin

		if( ~rst_n ) begin
			o_if_pc <= if_pc;	// 0
		end

		if( if_stg_valid ) begin
			o_if_pc <= if_pc;
		end
	end

endmodule	
