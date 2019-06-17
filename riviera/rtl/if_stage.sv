

`include "defines.sv"

module if_stage(
	input logic			clk,
	input logic			rst_n,

	// IM setup inputs
	input logic [`IM_DATA_BYTES-1:0]i_wen,
	input logic [`W_32-1:0]		i_wdata,

	// ID-relative inputs
	input logic 			i_id_ready,	// is ID stage ready?	
	input logic			i_is_jump,	// jump instr. in ID
	input logic [`W_64-1:0]		i_id_PC,	// jump target

	// EX-relative inputs
	input logic			i_PCsrc,	// branch taken in EX
	input logic [`W_64-1:0]		i_ex_PC,	// branch target	

	// ID-relative outputs
	output logic [`W_32-1:0]	o_if_instr,	// instruction out
	output logic [`W_64-1:0]	o_if_pc		// PC out	
);

	logic [`W_64-1:0]		if_pc;		// local pc
	logic [`W_32-1:0]		if_instr;	// local instr
	logic				if_stg_valid;   // validity of IF stage
	logic [`W_64-1:0]		fetch_addr;	// address to fetch
	logic [3:0]			fetch_selector; // select addr to fetch

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

		fetch_selector = {!rst_n, !i_id_ready, i_PCsrc, i_is_jump};

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
					if_stg_valid = 1'b1; 	// taken branch higher priority over simple jump
					fetch_addr = i_ex_PC;	// pc <- branch target
				 end
			4'b0001: begin
					if_stg_valid = 1'b1;	// jump instr. in ID
					fetch_addr = i_id_PC;	// pc <- jump target
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

		if( !rst_n ) begin
			o_if_pc <= if_pc;	// 0
			//o_if_instr <= 0;
		end

		if( if_stg_valid ) begin
			o_if_pc <= if_pc;
			//o_if_instr <= if_instr;
		end
	end

endmodule	
