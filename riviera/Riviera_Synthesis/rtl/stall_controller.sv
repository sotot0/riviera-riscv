`timescale 1ns/100fs

`include "defines.sv"
import struct_pckg :: interconnection_struct;

module stall_controller(
	
	// from ID stage
	input logic [`ALEN-1:0]		i_rs1,
	input logic [`ALEN-1:0]		i_rs2,
	input logic [1:0]		i_check_regs,

	// from EXE stage
	input logic [`ALEN-1:0] 	i_rd,
	// adamian from MEM stage
	input logic [`ALEN-1:0]		i_mem_rd,

	input logic [`ALEN-1:0]		i_wb_rd,

	input logic			i_is_valid,
	input logic			i_pipeline_stalled,
	
	output logic			o_stall,
	// to EXE stage
	output logic			o_is_staller,
	// adamian to MEM stage
	output logic			o_is_mem_staller,

	output logic			o_is_wb_staller

);

	always_comb begin

		o_stall = 1'b0;		

		o_is_staller = 1'b0;
		o_is_mem_staller = 1'b0;
		o_is_wb_staller = 1'b0;

		if(~i_is_valid && i_pipeline_stalled) begin
			o_stall = 1'b1;
			o_is_staller = 1'b0; 
			o_is_mem_staller = 1'b0;
			o_is_wb_staller = 1'b0;
		end
		else begin
	
		unique case (i_check_regs)
			
			`NONE: begin
				o_stall = 1'b0;
				o_is_staller = 1'b0;
				o_is_mem_staller = 1'b0;
				o_is_wb_staller = 1'b0;
			end

			`RS1: begin

				if ( (i_rs1 == i_rd) && (i_rd != 0) ) begin // RAW Hazard with rs1
					o_stall = 1'b1;
					o_is_staller = 1'b1;					
				end

				//adamian
				else if ( (i_rs1 == i_mem_rd) && (i_mem_rd != 0)) begin
					o_stall = 1'b1;
					o_is_mem_staller = 1'b1;
				end

				else if ( (i_rs1 == i_wb_rd) && (i_wb_rd != 0)) begin
					o_stall = 1'b1;
					o_is_wb_staller = 1'b1;
				end
	
				else begin
					o_stall = 1'b0;
					o_is_staller = 1'b0;
					o_is_mem_staller = 1'b0;
					o_is_wb_staller = 1'b0;
				end
			end

			`RS2: begin

				if ( (i_rs2 == i_rd) && (i_rd != 0) ) begin // RAW Hazard with rs2
					o_stall = 1'b1;
					o_is_staller = 1'b1;
				end
				
				//adamian
				else if ( (i_rs2 == i_mem_rd) && (i_mem_rd != 0)) begin
                                        o_stall = 1'b1;
                                        o_is_mem_staller = 1'b1;
                                end

				else if ( (i_rs2 == i_wb_rd) && (i_wb_rd != 0)) begin
					o_stall = 1'b1;
					o_is_wb_staller = 1'b1;
				end

				else begin
					o_stall = 1'b0;
					o_is_staller = 1'b0;
					o_is_mem_staller = 1'b0;
					o_is_wb_staller = 1'b0;
				end
			end

			`RS1_RS2: begin 
				
				if ( (i_rs1 == i_rd || i_rs2 == i_rd) && (i_rd != 0) ) begin //RAW Hazard with rs1 or rs2 or both
					o_stall = 1'b1;
					o_is_staller = 1'b1;
				end
				// adamian
				else if( (i_rs1 == i_mem_rd || i_rs2 == i_mem_rd) && (i_mem_rd != 0) ) begin
					o_stall = 1'b1;
                                        o_is_mem_staller = 1'b1;
				end

				else if( (i_rs1 == i_wb_rd || i_rs2 == i_wb_rd) && (i_wb_rd != 0) ) begin
					o_stall = 1'b1;
					o_is_wb_staller = 1'b1;
				end
				
				else begin
					o_stall = 1'b0;
					o_is_staller = 1'b0;
					o_is_mem_staller = 1'b0;
					o_is_wb_staller = 1'b0;
				end
			end
			
			default: begin
				o_stall = 1'b0;
				o_is_staller = 1'b0;
				o_is_mem_staller = 1'b0;
				o_is_wb_staller = 1'b0;
			end
		endcase
		end
	end

endmodule
