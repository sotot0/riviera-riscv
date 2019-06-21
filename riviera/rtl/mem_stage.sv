module mem_stage(

	input logic				clk,
	input logic				rst_n,
	
	output logic				o_mem_ready,

	input interconnection_struct 		i_ex2all,
	output interconnection_struct		o_mem2all
);

	logic					dm_stalled;
	interconnection_struct			to_output;
	interconnection_struct			to_dm;

	assign to_output = i_ex2all;

	data_mem data_mem_instance(

		.clk			(clk),
		.i_wr_data_bytes	(i_ex2all.mem_reg_unit),
		.i_addr			(i_ex2all.mem_addr),
		.i_wen			(i_ex2all.mem_wr),
		.i_wdata		(i_ex2all.mem_data),	// mem_data for both write and read data, mem_wr dependent
		.o_rdata		(i_ex2all.mem_data)
	);	

	// here we access the data memory for read or write
	// and miss-alignment is treated
	dm_controller dm_controller_instance(
	
		.clk			(clk),
		.rst_n			(rst_n),		

		.i_struct		(i_ex2all),

		.o_struct		(to_dm),
		.o_stall		(dm_stalled)
	);

	assign o_mem_ready = ~dm_stalled;


endmodule

