`timescale 1ns/100fs

`include "defines.sv";
import struct_pckg :: interconnection_struct;

module riviera_core(

	input logic				clk,
	input logic 				rst_n,

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
logic				if_valid_instr;
logic				ex_ready;

logic [`ALEN-1:0]		rs1;
logic [`ALEN-1:0]		rs2;
logic [1:0]			check_regs;
logic				unstall;
logic				late_unstall;
logic				double_late_unstall;

interconnection_struct		ex2mem;
logic [`ALEN-1:0]		mem_rd;
logic				is_mem_staller;

interconnection_struct		mem2wb;
logic [4:0]			wb_addr;
logic [`RNG_64]			wb_data;
logic				wb_en;
logic				wb_ready;
logic [`ALEN-1:0]		wb_rd;
logic				is_wb_staller;

logic				incr_pc;

logic				mem_ready;
logic 				str_miss_al_err;
logic				ld_miss_al_err;

if_stage if_instance(

	.clk			(clk),
	.rst_n			(rst_n),

	.i_wen			(i_we_im),
	.i_wdata		(i_im_data),

	.i_id_ready		(id_ready),

	.i_jump_in_ex		(jump_taken),
	.i_jump_target		(jump_target),

	.i_branch_in_ex		(branch_taken),
	.i_branch_target	(branch_target),

	.i_incr_pc		(incr_pc),

	.o_if_instr		(instr),
	.o_if_pc		(instr_pc),
	.o_if_valid_instr	(if_valid_instr)
);

id_stage id_instance(

	.clk			(clk),
	.rst_n			(rst_n),

	.i_wb_wr_reg_addr	(wb_addr),
	.i_wb_wr_reg_data	(wb_data),
	.i_wb_wr_reg_en		(wb_en),

	.i_if_valid_instr	(if_valid_instr),

	.i_if_instr		(instr),
	.i_if_pc		(instr_pc),

	.i_ex_branch_taken	(branch_taken),
	.i_ex_jump_taken	(jump_taken),

	.i_ex_ready		(ex_ready),

	.i_branch_target	(branch_target),
	.i_jumb_target		(jump_target),

	.o_id_ready		(id_ready),
	.o_id2all		(id2ex),

	.o_incr_pc		(incr_pc),

	.o_rs1			(rs1),
	.o_rs2			(rs2),
	.o_check_regs		(check_regs)
);

ex_stage ex_instance(

	.clk			(clk),
	.rst_n			(rst_n),

	.i_id2all		(id2ex),

	.i_mem_ready		(mem_ready),
	.i_mem_rd		(mem_rd),
	.i_wb_rd		(wb_rd),

	.i_rs1			(rs1),
	.i_rs2			(rs2),
	.i_check_regs		(check_regs),
	.i_unstall		(unstall),
	.i_late_unstall		(late_unstall),
	.i_double_late_unstall	(double_late_unstall),
	
	.o_is_mem_staller	(is_mem_staller),	
	.o_is_wb_staller	(is_wb_staller),
	
	.o_ex_branch_taken	(branch_taken),
	.o_ex_branch_target	(branch_target),
	.o_ex_jump_taken	(jump_taken),
	.o_ex_jump_target	(jump_target),

	.o_ex_ready		(ex_ready),
	.o_ex2all		(ex2mem)
	
);

mem_stage mem_instance(

	.clk				(clk),
	.rst_n				(rst_n),

	.i_ex2all			(ex2mem),

	.i_is_mem_staller		(is_mem_staller),

	.i_wb_ready			(wb_ready),

	.o_mem2all			(mem2wb),

	.o_mem_rd			(mem_rd),

	.o_mem_ready			(mem_ready),

	.o_store_miss_aligned_error	(str_miss_al_err),
	.o_load_miss_aligned_error	(ld_miss_al_err)
);

wb_stage wb_instance(

	.clk			(clk),
	.rst_n			(rst_n),

	.i_mem2all		(mem2wb),

	.i_is_wb_staller	(is_wb_staller),

	.o_wb_rd		(wb_rd),
	.o_wb_wr_reg_addr	(wb_addr),
	.o_wb_wr_reg_data	(wb_data),
	.o_wb_wr_reg_en		(wb_en),

	.o_unstall		(unstall),
	.o_late_unstall		(late_unstall),
	.o_double_late_unstall	(double_late_unstall),
	.o_wb_ready		(wb_ready)

);
endmodule
