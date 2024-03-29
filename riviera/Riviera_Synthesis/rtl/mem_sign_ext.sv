`timescale 1ns/100fs

`include "defines.sv"
import struct_pckg :: interconnection_struct;

module mem_sign_ext (

	input interconnection_struct    i_struct,
	output interconnection_struct   o_struct

);

	always_comb begin
	
		o_struct = i_struct;
		
		if(i_struct.mem_ext==`SIGNED) begin
		
			unique case (i_struct.mem_req_unit)
			
				`B: begin

					o_struct.mem_data = {{56{i_struct.mem_data[7]}},i_struct.mem_data[7:0]};

				end
			
				`HW: begin
			
					o_struct.mem_data = {{48{i_struct.mem_data[15]}},i_struct.mem_data[15:0]};
				end
			
				`W: begin

					o_struct.mem_data = {{32{i_struct.mem_data[31]}},i_struct.mem_data[31:0]};

				end
			
				`DW: begin
					;
				end
				
				default: ; 

			endcase	
			
		//	o_struct.mem_data = 64'(signed'(i_struct.mem_data));
		end
		else begin
			
			unique case (i_struct.mem_req_unit)
			
                                `B: begin

					o_struct.mem_data = {56'b0,i_struct.mem_data[7:0]};
                               
				 end

                                `HW: begin
			
					o_struct.mem_data = {48'b0,i_struct.mem_data[15:0]};

                                end

                                `W: begin

					o_struct.mem_data = {32'b0,i_struct.mem_data[31:0]};
                                end

                                `DW: begin
					;
                                end

				default: ;
				
                        endcase
 
		end
	end

endmodule


