module wb_stage(

	input logic			clk,
	input logic			rst_n,

	input interconnection_struct	i_mem2all,

	input logic			i_is_wb_staller,
	
	output logic [`RNG_WR_ADDR_REG]	o_wb_wr_reg_addr,
	output logic [`RNG_WR_DATA_REG] o_wb_wr_reg_data,
	output logic 			o_wb_wr_reg_en,

	output logic [`ALEN-1:0]	o_wb_rd,

	output logic			o_unstall,
	output logic			o_late_unstall,
	output logic			o_double_late_unstall,
	output logic			o_wb_ready
);
	
	always_comb begin
		if(rst_n) begin
			o_wb_wr_reg_addr	= 	i_mem2all.rf_wr_addr;
			o_wb_wr_reg_data	= 	(i_mem2all.mem_to_reg) ? i_mem2all.mem_data : i_mem2all.rf_wr_data;
			o_wb_wr_reg_en		= 	i_mem2all.rf_wr;
			o_wb_rd			=	o_wb_wr_reg_addr;
			o_wb_ready		=	1'b1;
		end
	end

	always_ff @(posedge clk) begin
		o_unstall <= i_mem2all.staller || i_is_wb_staller;
		o_late_unstall <= o_unstall;
		o_double_late_unstall <= o_late_unstall;
	end

endmodule
