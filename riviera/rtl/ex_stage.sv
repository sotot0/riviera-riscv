module ex_stage (

	input logic                     clk,
	input logic                     rst_n,

	// from ID
	input interconnection_struct    i_id2all,

	// from MEM
	input				i_mem_ready,
	input [`ALEN-1:0]		i_mem_rd,

	// from ID for Stall Controller
	input [`ALEN-1:0]		i_rs1,
	input [`ALEN-1:0]		i_rs2,
	input [1:0]			i_check_regs,
	
	// from WB stage
	input logic			i_unstall,

	// to ID
	output logic                    o_ex_ready,

	output logic			o_ex_jump_taken,
	output logic [`RNG_64]		o_ex_jump_target,
	output logic			o_ex_branch_taken,
	output logic [`RNG_64]		o_ex_branch_target,

	// to MEM/WB
	output logic			o_is_mem_staller,
	output interconnection_struct	o_ex2all
);

	interconnection_struct		alu2ext; 
	interconnection_struct		to_output_from_br;
	interconnection_struct		to_output_from_sign_ext;
	
	logic 				mul_sel;
	logic				stall;
	logic				pipeline_stalled;
	logic				is_staller;
	
	ex_alu ex_alu_instance(
		.i_struct		(i_id2all),
		.o_struct		(alu2ext)
	);

	ex_branch ex_branch_instance(
		.i_struct		(i_id2all),
		.i_stall		(stall),
		.i_is_staller		(is_staller),
		.o_struct		(to_output_from_br),
		.o_ex_jump_taken	(o_ex_jump_taken),
		.o_ex_jump_target	(o_ex_jump_target),
		.o_ex_branch_taken	(o_ex_branch_taken),
		.o_ex_branch_target	(o_ex_branch_target),
		.o_ex_mul_sel		(mul_sel)	
	);

	ex_sign_ext ex_sign_ext_instance(
		.i_struct		(alu2ext),
		.i_stall		(stall),
		.i_is_staller		(is_staller),
		.o_struct		(to_output_from_sign_ext)
	);
	
	stall_controller stall_controller_instance(
		.i_rs1			(i_rs1),
		.i_rs2			(i_rs2),
		.i_check_regs		(i_check_regs),
		.i_rd			(i_id2all.rf_wr_addr), //i_id2all
		.i_mem_rd		(i_mem_rd),
		.i_is_valid		(i_id2all.is_valid),   //i_id2all
		.i_pipeline_stalled	(pipeline_stalled),
		.o_stall		(stall),
		.o_is_mem_staller	(o_is_mem_staller),
		.o_is_staller		(is_staller)
	);

	assign o_ex_ready = ~stall || i_unstall; // i_mem_ready ??
	
	always_ff @(posedge clk, negedge rst_n) begin
		if(~rst_n) begin
			o_ex2all         <= 0;
			pipeline_stalled <= 0;
		end
		else begin
				o_ex2all   	 <= (mul_sel) ? to_output_from_br : to_output_from_sign_ext;
				pipeline_stalled <= ~o_ex_ready;
		end
	end
endmodule
