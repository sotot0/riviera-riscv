`include "defines.sv"

module riviera_core(

	input logic				i_clk,
	input logic 				i_rst_n,

	input logic [`IM_DATA_BYTES-1:0]	i_we_im,
	input logic [`RNG_32]			i_im_data
	
	// here can be put some inputs and outputs so we can debug easier from
	// testbench with probably an interface???
);   

logic [`RNG_32]			instr;
logic [`RNG_64]			instr_pc;
logic				id_ready;

interconnection_struct		id2ex;
logic 				branch_taken;
logic [`RNG_64]			branch_target;
logic				jump_taken;
logic [`RNG_64]			jump_target;
logic				flush_if;
logic				flush_id;
logic				ex_ready;

interconnection_struct		ex2mem;

if_stage if_instance(

	.clk			(i_clk),
	.rst_n			(i_rst_n),

	.i_wen			(i_we_im),
	.i_wdata		(i_im_data),

	.i_ex_flush_if		(flush_if),
	.i_id_ready		(id_ready),

	.i_jump_in_ex		(jump_taken),
	.i_jump_target		(jump_target),

	.i_branch_in_ex		(branch_taken),
	.i_branch_target	(branch_target),

	.o_if_instr		(instr),
	.o_if_pc		(instr_pc)
);

id_stage id_instance(

	.clk			(i_clk),
	.rst_n			(i_rst_n),

	.i_if_instr		(instr),
	.i_if_pc		(instr_pc),
	.i_ex_flush_id		(flush_id),

	.i_ex_ready		(ex_ready),

	.o_id_ready		(id_ready),
	.o_id2all		(id2ex)
);

ex_stage ex_instance(

	.clk			(i_clk),
	.rst_n			(i_rst_n),

	.i_id2all		(id2ex),

	.o_ex_branch_taken	(branch_taken),
	.o_ex_branch_target	(branch_target),
	.o_ex_jump_taken	(jump_taken),
	.o_ex_jump_target	(jump_target),
	.o_ex_flush_if		(flush_if),
	.o_ex_flush_id		(flush_id),

	.o_ex_ready		(ex_ready),
	.o_ex2all		(ex2mem)
);
endmodule
