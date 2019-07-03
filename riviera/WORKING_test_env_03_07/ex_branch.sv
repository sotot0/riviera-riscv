//import struct_pckg :: interconnection_struct;


module ex_branch(
	
	input interconnection_struct	i_struct,

	output interconnection_struct	o_struct,
	output logic 			o_ex_jump_taken,
	output logic 			o_ex_branch_taken,
 	output logic[`RNG_64]		o_ex_jump_target,
	output logic[`RNG_64]           o_ex_branch_target,
	output logic			o_ex_mul_sel
);	

	always_comb begin
		o_struct = i_struct;
		o_ex_mul_sel = 1'b0;
		o_ex_branch_taken = 1'b0;
		o_ex_jump_taken = 1'b0;
		o_ex_branch_target = 0;
		o_ex_jump_target = 0;
		if(i_struct.is_valid && i_struct.alu_en && i_struct.is_branch) begin
			
			o_ex_mul_sel = 1'b1;
			
			unique case (i_struct.alu_op)
				
				`DO_ADD: begin
					if(i_struct.format==`JU_FORM) begin
						if (i_struct.is_compr) begin
							o_struct.rf_wr_data = i_struct.pc+2;
						end
						else begin
							o_struct.rf_wr_data = i_struct.pc+4;
						end
						o_ex_jump_taken = 1'b1;
						o_ex_branch_taken = 1'b0;
						o_ex_jump_target = i_struct.pc + (i_struct.imm_gend<<1); 	
					end
					else begin
						
						o_struct.rf_wr_data = i_struct.pc+4;
                                           	o_ex_jump_taken = 1'b1;
                                                o_ex_branch_taken = 1'b0;
                                                o_ex_jump_target = (i_struct.rs1 + i_struct.imm_gend) & ({{63 {1'b1}}, 1'b0}) ; 
					
					end 
				end

				`DO_SUB: begin
					o_ex_jump_taken = 1'b0;
					o_ex_branch_target = i_struct.pc + (i_struct.imm_gend << 1);

					if(i_struct.branch_type==`BEQ) begin
                                                o_ex_branch_taken = ((i_struct.rs1-i_struct.rs2)==1'b0);	
					end
					else if(i_struct.branch_type==`BNE) begin
                                                o_ex_branch_taken = ((i_struct.rs1-i_struct.rs2)!=1'b0);
                                        end
					else if(i_struct.branch_type==`BLTU) begin
                                                o_ex_branch_taken = (i_struct.rs1<i_struct.rs2);
                                        end
                                        else if(i_struct.branch_type==`BGEU) begin
                                                o_ex_branch_taken = (i_struct.rs1>=i_struct.rs2);
                                        end					
				end

				`DO_BGE: begin
					o_ex_jump_taken = 1'b0;
					o_ex_branch_target = i_struct.pc + (i_struct.imm_gend << 1);
                                        o_ex_branch_taken = $signed(i_struct.rs1) >= $signed(i_struct.rs2);
				end

                                `DO_BLT: begin
					o_ex_jump_taken = 1'b0;
					o_ex_branch_target = i_struct.pc + (i_struct.imm_gend << 1);
                                        o_ex_branch_taken = $signed(i_struct.rs1) < $signed(i_struct.rs2);
                                end

				default: begin
					o_ex_jump_taken = 1'b0;
					o_ex_branch_taken = 1'b0;
					o_ex_jump_target = 1'b0;
					o_ex_branch_target = 1'b0;
				end			
			endcase
		end
	end

endmodule
