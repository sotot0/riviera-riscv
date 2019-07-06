//`include "defines.sv"
//import struct_pckg :: interconnection_struct;

module dm_load_controller(

	input interconnection_struct		i_struct, // this struct drived from the reg  
	input [`RNG_64] 			dm_data,  // this data drived from the Data Memory
	input logic				i_is_mem_staller,

	output interconnection_struct		o_struct, // final stuct of MEM stage
	output logic				o_miss_aligned_error
);


	always_comb begin

		o_struct = i_struct;
		//o_struct.staller = 1'b0;

		if( i_struct.is_valid && i_is_mem_staller ) begin
			o_struct.staller = 1'b1;
		end

		if( i_struct.mem_rd && i_struct.is_valid ) begin		// LOAD HANDLING
	
			unique case(i_struct.mem_req_unit)
		
				`B: begin
					o_struct.mem_data[`RNG_64] = {56'b0, dm_data[(i_struct.mem_addr[2:0]*8) +: 8]};
					o_miss_aligned_error = 1'b0;

				end

				`HW: begin
					if(i_struct.mem_addr[2:0] == 3'b111) begin
					
						// miss aligned error
						o_miss_aligned_error = 1'b1;
						o_struct.mem_data[`RNG_64] = 64'b0;
						
					end
					else begin
						
						o_miss_aligned_error = 1'b0;
						o_struct.mem_data[`RNG_64] = {48'b0, dm_data[(i_struct.mem_addr[2:0]*8) +: 16]};
					end
				end

				`W: begin
					if(i_struct.mem_addr[2:0] == 3'b101) begin

						// miss aligned error
                                                o_miss_aligned_error = 1'b1;
						o_struct.mem_data[`RNG_64] = 64'b0;

					end
					else if(i_struct.mem_addr[2:0] == 3'b110) begin

						// miss aligned error
                                                o_miss_aligned_error = 1'b1;
						o_struct.mem_data[`RNG_64] = 64'b0;

					end
					else if(i_struct.mem_addr[2:0] == 3'b111) begin

						// miss aligned error
                                                o_miss_aligned_error = 1'b1;
						o_struct.mem_data[`RNG_64] = 64'b0;

					end
					else begin
						
						o_miss_aligned_error = 1'b0;                                               
                                                o_struct.mem_data[`RNG_64] = {32'b0, dm_data[(i_struct.mem_addr[2:0]*8) +: 32]};
					end

				end

				`DW: begin
					
					if(i_struct.mem_addr[2:0] == 3'b000) begin
						
                                                o_miss_aligned_error = 1'b0;
                                                o_struct.mem_data[`RNG_64] = dm_data;
					end 
					else begin
						
						// miss aligned error
						o_miss_aligned_error = 1'b1;
						o_struct.mem_data[`RNG_64] = 64'b0;

					end

				end

			endcase
		end
	end

endmodule
