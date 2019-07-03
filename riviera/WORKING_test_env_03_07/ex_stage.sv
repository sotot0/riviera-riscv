module ex_stage (

	input logic                     clk,
	input logic                     rst_n,

	// from ID
	input interconnection_struct    i_id2all,

	// from MEM
	input				i_mem_ready,

	// to IF & ID
	output logic                    o_ex_ready,

	output logic			o_ex_jump_taken,
	output logic [`RNG_64]		o_ex_jump_target,
	output logic			o_ex_branch_taken,
	output logic [`RNG_64]		o_ex_branch_target,
	
	// to MEM/WB
	output interconnection_struct	o_ex2all
);

	interconnection_struct		alu2ext; 
	interconnection_struct		to_output_from_br;
	interconnection_struct		to_output_from_sign_ext;
	
	logic 				mul_sel;

	ex_alu ex_alu_instance(
		.i_struct		(i_id2all),
		.o_struct		(alu2ext)
	);

	ex_branch ex_branch_instance(
		.i_struct		(i_id2all),
		.o_struct		(to_output_from_br),
		.o_ex_jump_taken	(o_ex_jump_taken),
		.o_ex_jump_target	(o_ex_jump_target),
		.o_ex_branch_taken	(o_ex_branch_taken),
		.o_ex_branch_target	(o_ex_branch_target),
		.o_ex_mul_sel		(mul_sel)	
	);

	ex_sign_ext ex_sign_ext_instance(
		.i_struct		(alu2ext),
		.o_struct		(to_output_from_sign_ext)
	);
	
	assign o_ex_ready = i_mem_ready; // ??

	always_ff @(posedge clk, negedge rst_n) begin
		if(~rst_n) begin
			o_ex2all <= 0;
		end
		else begin
			if(o_ex_ready) begin
				o_ex2all <= (mul_sel) ? to_output_from_br : to_output_from_sign_ext;
			end
		end
	end
endmodule
