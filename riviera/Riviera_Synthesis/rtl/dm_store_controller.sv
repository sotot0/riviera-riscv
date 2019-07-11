`timescale 1ns/100fs

`include "defines.sv"
import struct_pckg :: interconnection_struct;

module dm_store_controller(

	input interconnection_struct		i_struct,
	input logic				i_is_mem_staller,

	output interconnection_struct		o_struct,
	output logic				o_miss_aligned_error
);

	always_comb begin
		
		o_struct = i_struct;
		o_miss_aligned_error = 1'b0;

		if( i_struct.is_valid && i_is_mem_staller) begin
			o_struct.staller = 1'b1;
		end
		else begin
			;
		end
		
		if( i_struct.mem_wr && i_struct.is_valid ) begin		// STORE HANDLING

			unique case(i_struct.mem_req_unit)
		
				`B: begin

					o_struct.mem_wr_en[i_struct.mem_addr[2:0] +: 1] = 1'b1;
					o_struct.mem_data [i_struct.mem_addr[2:0]*8 +: 8] = i_struct.mem_data[7:0];
					o_miss_aligned_error = 1'b0;
				end

				`HW: begin
					if(i_struct.mem_addr[2:0] == 3'b111) begin
						// miss aligned error
						o_miss_aligned_error = 1'b1;
						
					end
					else begin
						// all write operation will completed on one cycle (we will write on one line of DM)
						o_miss_aligned_error = 1'b0;
						o_struct.mem_wr_en[i_struct.mem_addr[2:0] +: 2] = 2'b11;
						o_struct.mem_data [(i_struct.mem_addr[2:0]*8) +: 16] = i_struct.mem_data[15:0];
					end
				end

				`W: begin
					if(i_struct.mem_addr[2:0] == 3'b101) begin

						// miss aligned error
                                                o_miss_aligned_error = 1'b1;
					
					end
					else if(i_struct.mem_addr[2:0] == 3'b110) begin

						// miss aligned error
                                                o_miss_aligned_error = 1'b1;

					end
					else if(i_struct.mem_addr[2:0] == 3'b111) begin

						// miss aligned error
                                                o_miss_aligned_error = 1'b1;

					end
					else begin
						
					        // all write operation will completed on one cycle (we will write on one line of DM)
						o_miss_aligned_error = 1'b0;                                               
                                                o_struct.mem_wr_en[i_struct.mem_addr[2:0] +: 4] = 4'b1111;
                                                o_struct.mem_data [(i_struct.mem_addr[2:0]*8) +: 32] = i_struct.mem_data[31:0];

					end

				end

				`DW: begin
					
					if(i_struct.mem_addr[2:0] == 3'b000) begin
						
						// all write operation will completed on one cycle (we will write on one line of DM)
                                                o_miss_aligned_error = 1'b0;
                                                o_struct.mem_wr_en[7:0] = 8'b11111111;
                                                o_struct.mem_data[63:0] = i_struct.mem_data[63:0];
					
					end 
					else begin
						
						// miss aligned error
						o_miss_aligned_error = 1'b1;
					end

				end

				default: ;

			endcase
		end
		else begin
			;
		end
	end

endmodule
