//import struct_pckg :: interconnection_struct;

module mem_stage(

	input logic				clk,
	input logic				rst_n,
	input interconnection_struct		i_ex2all,	

	output interconnection_struct		o_mem2all,
	output logic				o_store_miss_aligned_error

);

	interconnection_struct			to_dm_and_reg;
	interconnection_struct			to_load_controller;
	interconnection_struct			to_sign_ext;

	logic [`RNG_64]				load_mem_data;



        dm_store_controller dm_store_controller_instance(

                .i_struct               (i_ex2all),
                .o_struct               (to_dm_and_reg),
		.o_miss_aligned_error	(o_store_miss_aligned_error)
       
	 );


	data_mem data_mem_instance(

		.clk			(clk),
		.i_addr			(to_dm_and_reg.mem_addr),
		.i_wen			(to_dm_and_reg.mem_wr_en),
		.i_wdata		(to_dm_and_reg.mem_data),	// mem_data for both write 
		.o_rdata		(load_mem_data)
	
	);	
	

	mem_struct_reg mem_struct_reg_instance(
		
		.clk			(clk),
		.rst_n			(rst_n),
		.i_struct		(to_dm_and_reg),
		.o_struct		(to_load_controller)
	
	);

	
	dm_load_controller dm_load_controller_instance(

		.i_struct		(to_load_controller),
		.dm_data		(load_mem_data),
		.o_struct		(to_sign_ext),
		.o_miss_aligned_error	(o_load_miss_aligned_error)
	
	);

	mem_sign_ext mem_sign_ext_instance(
	
		.i_struct		(to_sign_ext),
		.o_struct		(o_mem2all)
	
	);

endmodule