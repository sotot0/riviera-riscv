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

if_stage if_instance(

	.clk			(i_clk),
	.rst_n			(i_rst_n),

	.i_wen			(i_we_im),
	.i_wdata		(i_im_data),

	.i_id_ready		(id_ready),

	.o_if_instr		(instr),
	.o_if_pc		(instr_pc)
);

id_stage id_instance(

	.clk			(i_clk),
	.rst_n			(i_rst_n),

	.i_if_instr		(instr),
	.i_if_pc		(instr_pc),

	.o_id_ready		(id_ready)
);

endmodule
