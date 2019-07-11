`timescale 1ns/100fs

`include "defines.sv"
import struct_pckg :: interconnection_struct;

module imm_gen (
	input  logic [1:0]	i_format,
	input  logic [`RNG_32]	i_instr,
	output logic [`RNG_64]  o_imm 
);

	always_comb begin

		o_imm	= 0;

		unique case(i_format)
			`R_FORM: begin	
				o_imm = 64'b0;	// not used
			end
			
			`JU_FORM: begin		        	
			
				if( i_instr[`RNG_OP] == `AUIPC ) begin 
					o_imm = i_instr[`RNG_IMM20];	// pass the imm20
				end
				else if ( i_instr[`RNG_OP] == `JAL ) begin
					o_imm = 64'(signed'({i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:21]}));
				end
				else if ( i_instr[`RNG_OP] == `JALR) begin
					o_imm = 64'(signed'(i_instr[11:0]));
				end
				else if ( i_instr[`RNG_OP] == `LUI) begin
					o_imm = i_instr[`RNG_IMM20];
				end
				else begin
					;
				end
			end
		
			`I_FORM: begin
				if((i_instr[`RNG_OP]==`IMM) && (i_instr[`RNG_F3]==`F3_SLLI || i_instr[`RNG_F3]==`F3_SR)) begin
					o_imm = 64'(signed'({i_instr[25] ,i_instr[`RNG_IMM12_I]})); //SLLI, SRLI, SRAI shamt=6bits	
				end
				else begin
					o_imm = { {52{i_instr[31]}}, i_instr[`RNG_IMM12_I] };
				end
			end

			`BS_FORM: begin
				if(i_instr[`RNG_OP] == `BRANCH) begin
					o_imm = 64'(signed'({i_instr[31], i_instr[7], i_instr[30:25], i_instr[11:8]}));
				end
				else begin
					o_imm = 64'(signed'({i_instr[31:25], i_instr[11:7]})); // store
				end
			end
			
			default: o_imm = 64'b0; // not used
		endcase
	end
endmodule
