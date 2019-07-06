`include "defines.sv";
//import struct_pckg :: interconnection_struct;

module riv_testbench;

	logic clk;
	logic rst_n;

	logic [`RNG_64] ex_branch_target;
	logic [`RNG_64] ex_jump_target;
	logic [`IM_DATA_BYTES-1 : 0] i_wen;
	logic [`RNG_32] i_wdata;

	logic [`RNG_32] instruction;
	logic [`RNG_64] pc;
	logic valid_instr;

	logic [`ALEN-1:0] rs1;
	logic [`ALEN-1:0] rs2;
	logic [1:0]	  check_regs;
	logic unstall;

	logic id_ready;
	interconnection_struct id2all;
	
	logic ex_ready;
	logic ex_jump_taken;
	logic ex_branch_taken;
	logic [`ALEN-1:0] mem_rd;
	logic is_mem_staller;
	interconnection_struct ex2all;
	
	logic mem_ready;
	logic st_miss_al;
	logic ld_miss_al;
	interconnection_struct mem2all;

	logic [`RNG_WR_ADDR_REG] wb_wr_reg_addr;
	logic [`RNG_WR_DATA_REG] wb_wr_reg_data;
	logic wb_wr_reg_en;
	logic wb_ready;

	if_stage if_test(

		.clk			(clk),
		.rst_n			(rst_n),
		.i_id_ready		(id_ready),
		.i_branch_in_ex		(ex_branch_taken),
		.i_branch_target	(ex_branch_target),
		.i_jump_in_ex		(ex_jump_taken),
		.i_jump_target		(ex_jump_target),
		.i_wen			(i_wen),
		.i_wdata		(i_wdata),
		
		.o_if_instr		(instruction),
		.o_if_pc		(pc),
		.o_if_valid_instr	(valid_instr)
	);

	id_stage id_test(
		
		.clk			(clk),
		.rst_n			(rst_n),
		.i_if_instr		(instruction),
		.i_if_valid_instr	(valid_instr),
		.i_if_pc		(pc),
		.i_ex_ready		(ex_ready),
		.i_ex_branch_taken	(ex_branch_taken),
		.i_ex_jump_taken	(ex_jump_taken),
		.i_wb_wr_reg_addr	(wb_wr_reg_addr),
		.i_wb_wr_reg_data	(wb_wr_reg_data),
		.i_wb_wr_reg_en		(wb_wr_reg_en),
		
		.o_id_ready		(id_ready),
		.o_id2all		(id2all),

        	.o_rs1                  (rs1),
	        .o_rs2                  (rs2),
        	.o_check_regs           (check_regs)

	);

	ex_stage ex_test(

		.clk			(clk),
		.rst_n			(rst_n),
		.i_id2all		(id2all),
		.i_mem_ready		(mem_ready),
	
	        .i_rs1                  (rs1),
        	.i_rs2                  (rs2),
  	      	.i_check_regs           (check_regs),
		.i_mem_rd		(mem_rd),
        	.i_unstall              (unstall),
	
		.o_ex_ready		(ex_ready),
		.o_is_mem_staller	(is_mem_staller),
		.o_ex_jump_taken	(ex_jump_taken),
		.o_ex_branch_taken	(ex_branch_taken),
		.o_ex_branch_target	(ex_branch_target),
		.o_ex_jump_target	(ex_jump_target),
		.o_ex2all		(ex2all)
		
	);

	mem_stage mem_test(
		
		.clk				(clk),
		.rst_n				(rst_n),
		.i_ex2all			(ex2all),
		.i_wb_ready			(1'b1),
		.i_is_mem_staller		(is_mem_staller),

		.o_mem_rd			(mem_rd),
		.o_mem_ready			(mem_ready),
		.o_mem2all			(mem2all),
		.o_store_miss_aligned_error	(st_miss_al),
		.o_load_miss_aligned_error	(ld_miss_al)
	);

	wb_stage wb_test(

		.clk				(clk),
		.rst_n				(rst_n),

		.i_mem2all			(mem2all),

		.o_wb_wr_reg_addr		(wb_wr_reg_addr),
		.o_wb_wr_reg_data		(wb_wr_reg_data),
		.o_wb_wr_reg_en			(wb_wr_reg_en),
		
		.o_unstall			(unstall),
		.o_wb_ready			(wb_ready)
	);

	initial begin
		start_core;
		@ (posedge clk);
		@ (posedge clk);
		@ (posedge clk);
		check_basic_funct;
	end

	task start_core;
		clk = 0;
		rst_n = 0;
	endtask

	task check_basic_funct;
		rst_n = 1;
	endtask
	
	always #20 clk = ~clk;

endmodule
