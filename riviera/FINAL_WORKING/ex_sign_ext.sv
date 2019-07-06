module ex_sign_ext (
	input interconnection_struct    i_struct,
	input logic			i_stall,
	input logic			i_is_staller,

	output interconnection_struct   o_struct
);

	always_comb begin

		o_struct = i_struct;
		o_struct.staller = 1'b0;

		if(i_struct.is_valid) begin
			o_struct.staller = i_is_staller;
			if(i_struct.en_sign_ext) begin
				o_struct.rf_wr_data = 64'(signed'(i_struct.rf_wr_data));
			end
		end
	end

endmodule
