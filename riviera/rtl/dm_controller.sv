module dm_controller(

	input logic				clk,
	input logic				rst_n,

	input interconnection_struct		i_struct,

	output interconnection_struct		o_struct,
	output logic				dm_stall
);

	interconnection_struct			direct2mux;
	interconnection_struct			to_ff;
	interconnection_struct			from_ff;

	assign o_struct = i_struct;
	assign direct2mux = i_struct;
	assign to_ff = i_struct;
	assign dm_stall	= 1'b0;

	always_comb begin

		if( from_ff.dm_mux_sel ) begin
			stall = 1'b0;
		end

		if( i_struct.mem_wr ) begin		// STORE HANDLING

			unique case(i_struct.mem_req_unit)
		
				`B: begin

					dm_stall = 1'b0;
					direct2mux.mem_wr_en[direct2mux.mem_addr[2:0]] = 1'b1;
				end

				`HW: begin
					if(i_struct.mem_addr[2:0] == 3'b111) begin

						// first cycle
						dm_stall = 1'b1;
						direct2mux.mem_wr_en[7] = 1'b1;
						direct2mux.mem_data[63:56] = i_struct.mem_data[7:0];
						// -----
						to_ff.mem_we_en[0] = 1'b1;
						to_ff.mem_data = to_ff.mem_data[15:8];
						to_ff.dm_mux_sel = 1'b1;
					end
					else begin

						dm_stall = 1'b0;
						o_struct.mem_wr_en[(i_struct.mem_addr[2:0]+1):i_struct.mem_addr[2:0]] = 2'b11;	
					end
				end

				`W: begin

				end

				`DW: begin

				end

			endcase
		end
		else if( i_struct.mem_rd ) begin	// LOAD HANDLING


		end
	end

endmodule
