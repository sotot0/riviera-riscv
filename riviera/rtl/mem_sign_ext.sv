module mem_sign_ext (
	input interconnection_struct    i_struct,
	output interconnection_struct   o_struct
);

	always_comb begin
		o_struct = i_struct;
		if(i_struct.mem_ext==`SIGNED) begin
			o_struct.mem_data = 64'(signed'(i_struct.mem_data));
		end
	end

endmodule

{{64 - i_struct.mem_req_unit * 8} 1'b0 , }
