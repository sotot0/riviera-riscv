`include "defines.sv"

module if_stage(
     input logic				clk,
     input logic				rst_n,

     // IM setup inputs
     input logic [`IM_DATA_BYTES-1:0]		i_wen,
     input logic [`RNG_32]			i_wdata,

     // ID-relative inputs
     input logic				i_id_ready,	// is ID stage ready	

     // EX-relative inputs
     input logic				i_branch_in_ex,	// branch taken in EX
     input logic [`RNG_64]			i_branch_target,// branch target	

     input logic				i_jump_in_ex,	// jump in ex
     input logic [`RNG_64]			i_jump_target,	// jump target

     // ID-relative outputs
     output logic [`RNG_32]			o_if_instr,	// instruction out
     output logic [`RNG_64]			o_if_pc,	// PC out	
     output logic				o_if_valid_instr
);

	logic [`RNG_64]				if_pc;

	instr_mem 
	#(
		.DEPTH		(`IM_DEPTH),
		.DATA_WIDTH 	(`W_32)
	)
	instr_mem_instance
	(
		.clk		(clk),
		.i_addr		(if_pc[10:0]>>2),
		.i_wdata	(i_wdata),
		.i_wen		(i_wen),
		.o_rdata	(o_if_instr)
	);

	always_comb begin

		if_pc	= 16'h100;

		if(~rst_n) begin
			if_pc = 16'h100;
		end
		else if (i_branch_in_ex) begin
			if_pc = i_branch_target;
		end
		else if (i_jump_in_ex) begin
			if_pc = i_jump_target;
		end
		else begin
			if_pc = o_if_pc + 4;
		end

	end


	assign o_if_valid_instr	= (rst_n && ~i_branch_in_ex && ~i_jump_in_ex); // valid instruction
	

	always_ff @( posedge clk, negedge rst_n ) begin

		if( i_id_ready ) begin
			o_if_pc <= if_pc;
		end
	end

endmodule	
