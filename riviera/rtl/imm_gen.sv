`include "defines.sv"

module imm_gen (
	input  logic [1:0]	i_format,
	input  logic [`RNG_32]	i_instr,
	output logic [`RNG_64]  o_imm 
);

	always_comb begin
		unique case(i_format)
			`R_FORM: begin		// ERROR
				o_imm = 64'bx;	// not imm12
			end
			
			`JU_FORM: begin		// ERROR
				o_imm = 64'bx;		// not used
			end
		
			`I_FORM: begin
				o_imm = 64'(signed'(i_instr[`RNG_IMM12_I]));
			end

			`BS_FORM: begin
				o_imm = 64'(signed'( {i_instr[31:25],i_instr[11:7]} ));
			end
			
			default: o_imm = 64'bx; //error
		endcase
	end
endmodule
