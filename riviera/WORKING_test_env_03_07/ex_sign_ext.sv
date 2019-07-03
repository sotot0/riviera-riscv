module ex_sign_ext (
	input interconnection_struct    i_struct,
	output interconnection_struct   o_struct
);

	always_comb begin
		o_struct = i_struct;
		if(i_struct.en_sign_ext) begin
			o_struct.rf_wr_data = 64'(signed'(i_struct.rf_wr_data));
		end
	end

endmodule
