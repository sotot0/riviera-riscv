//import struct_pckg :: interconnection_struct;

module mem_struct_reg(
	
	input logic				clk,
	input logic				rst_n,
	input interconnection_struct		i_struct,

	output interconnection_struct 		o_struct

);
	
	always_ff @(posedge clk, negedge clk) begin
		
		if(~rst_n) begin
		
			o_struct <= 0;
		end	
		else begin
		
			o_struct <= i_struct;
		end
	end

endmodule
