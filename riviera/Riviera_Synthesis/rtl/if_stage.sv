`timescale 1ns/100fs

`include "defines.sv"
import struct_pckg :: interconnection_struct;

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
     output logic				o_if_valid_instr,

     // Compressed
     input logic                                i_incr_pc

);

	logic [`RNG_64]				if_pc;
/*
	instr_mem 
	#(
		.DEPTH		(`IM_DEPTH),
		.DATA_WIDTH 	(`W_32)
	)
	instr_mem_instance
	(
		.clk		(clk),
		.i_addr		(if_pc[12:2]),  //(if_pc[10:0]>>2) adamian: why only 10:0? and no more 12:0? 
		.i_wdata	(i_wdata),
		.i_wen		(i_wen),
		.o_rdata	(o_if_instr)
	);
*/

	mem_sync_sp_syn
	#(
		.DEPTH		(`IM_DEPTH),
		.DATA_WIDTH	(`W_32)
	)
	mem_sync_sp_instance
	(
		.clk		(clk),
		.i_addr		(if_pc[12:2]),
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
			if_pc = {i_branch_target[63:2], 2'b0};
		end
		else if (i_jump_in_ex) begin
			if_pc = {i_jump_target[63:2], 2'b0};
		end
		else if (~i_id_ready) begin
			if_pc = o_if_pc;
		end
		//Compressed
		else if (~i_incr_pc) begin
                        if_pc = o_if_pc;
                end
		else begin
			if_pc = o_if_pc + 4;
		end
	end

	assign o_if_valid_instr	= (rst_n && ~i_branch_in_ex && ~i_jump_in_ex); // valid instruction	

	always_ff @( posedge clk, negedge rst_n ) begin
		if(~rst_n) begin
			o_if_pc <= if_pc;
		end
		else begin
			o_if_pc <= if_pc;
		end
	end

endmodule	
