module dm_load_controller(

	input interconnection_struct		i_struct,  
	input [`RNG_64] 			i_dm_data,  // this data drived from the Data Memory

	output interconnection_struct		o_struct, // final stuct of MEM stage
	output logic				o_miss_aligned_error
);


	always_comb begin

		o_struct = i_struct;
		o_miss_aligned_error = 1'b0;

		if( i_struct.mem_rd && i_struct.is_valid ) begin
	
			unique case(i_struct.mem_req_unit)
		
				`B: begin

					o_miss_aligned_error = 1'b0;
					
					unique case(i_struct.mem_addr[2:0])

                                                3'b000: begin
                                                        o_struct.mem_data[7:0]= i_dm_data[7:0];
                                                end
                                                3'b001: begin
                                                        o_struct.mem_data[7:0]= i_dm_data[15:8];
                                                end
                                                3'b010: begin
                                                        o_struct.mem_data[7:0]= i_dm_data[23:16];
                                                end
                                                3'b011: begin
                                                        o_struct.mem_data[7:0]= i_dm_data[31:24];
                                                end
                                                3'b100: begin
                                                        o_struct.mem_data[7:0]= i_dm_data[39:32];
                                                end
                                                3'b101: begin
                                                        o_struct.mem_data[7:0]= i_dm_data[47:40];
                                                end
                                                3'b110: begin
                                                        o_struct.mem_data[7:0]= i_dm_data[55:48];
                                                end
                                                3'b111: begin
                                                        o_struct.mem_data[7:0]= i_dm_data[63:56];
                                                end
                                                default: begin
                                                        o_struct.mem_data  = 0;
                                                        o_miss_aligned_error = 1'b1;
                                                end

                                        endcase
				end

				`HW: begin

                                        o_miss_aligned_error = 1'b0;

                                        unique case(i_struct.mem_addr[2:0])

                                                3'b000: begin
                                                        o_struct.mem_data[15:0]= i_dm_data[15:0];
                                                end
                                                3'b010: begin
                                                        o_struct.mem_data[15:0]= i_dm_data[31:16];
                                                end
                                                3'b100: begin
                                                        o_struct.mem_data[15:0]= i_dm_data[47:32];
                                                end
                                                3'b110: begin
                                                        o_struct.mem_data[15:0]= i_dm_data[63:48];
                                                end
                                                default: begin
                                                        o_struct.mem_data  = 0;
                                                        o_miss_aligned_error = 1'b1;
                                                end

                                        endcase
				end

				`W: begin
        
					o_miss_aligned_error = 1'b0;

                                       	unique case(i_struct.mem_addr[2:0])

                                        	3'b000: begin
                                                        o_struct.mem_data[31:0]= i_dm_data[31:0];
                                                end

                                                3'b100: begin
                                                        o_struct.mem_data[31:0]= i_dm_data[63:32];
                                                end

                                                default: begin
                                                        o_struct.mem_data  = 0;
                                                        o_miss_aligned_error = 1'b1;
                                                end

                                        endcase
				end

				`DW: begin
         
	                               o_miss_aligned_error = 1'b0;

 	                                unique case(i_struct.mem_addr[2:0])

                                                3'b000: begin
                                                        o_struct.mem_data[63:0]= i_dm_data[63:0];
                                                end

                                                default: begin
                                                        o_struct.mem_data = 0;
							o_miss_aligned_error = 1'b1;
                                                end

                                        endcase

	
				end
				
				default: ; 

			endcase
		end
		else begin
			;
		end
	end

endmodule
