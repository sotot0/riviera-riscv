//import struct_pckg :: interconnection_struct;

module ex_alu ( 

	input interconnection_struct	i_struct,

	output interconnection_struct   o_struct

);

	always_comb begin
		
		o_struct = i_struct;

		if(i_struct.is_valid && i_struct.alu_en && !i_struct.is_branch) begin
    			
			unique case (i_struct.alu_op) 
				
				`DO_ADD: begin
                                	if(i_struct.format ==`R_FORM) begin
						o_struct.rf_wr_data = i_struct.rs1 + i_struct.rs2; 
					end
					else if(i_struct.format ==`I_FORM ) begin
						if (i_struct.mem_rd) begin //LOAD
							o_struct.mem_addr = i_struct.rs1 + i_struct.imm_gend;
						end
						else begin //ADDI
                                                	o_struct.rf_wr_data = i_struct.rs1 + i_struct.imm_gend;
						end
                                        end
                                        else if(i_struct.format == `JU_FORM) begin
                                        	;// error	
					end
                                        else begin
                                                o_struct.mem_addr = i_struct.rs1 + i_struct.imm_gend;  // STORE
						o_struct.mem_data = i_struct.rs2;
                                        end
				end
				
				`DO_SUB: begin

                                	o_struct.rf_wr_data = i_struct.rs1 - i_struct.rs2;
				end
			
				`DO_SLL: begin
					if(i_struct.format ==`R_FORM) begin
						if(i_struct.en_sign_ext) begin
	                                                o_struct.rf_wr_data = i_struct.rs1 << i_struct.rs2[4:0];
						end
						else begin
							o_struct.rf_wr_data = i_struct.rs1 << i_struct.rs2[5:0]; 
						end

                                        end
                                        else if(i_struct.format ==`I_FORM ) begin
						if(i_struct.en_sign_ext) begin
                                                        o_struct.rf_wr_data = i_struct.rs1 << i_struct.imm_gend[4:0];
                                                end
                                                else begin                                                                                
                                                        o_struct.rf_wr_data = i_struct.rs1 << i_struct.imm_gend[5:0];
                                                end

                                        end
				end
			
				`DO_SLT: begin
					if(i_struct.format ==`R_FORM) begin
						o_struct.rf_wr_data = $signed(i_struct.rs1) < $signed(i_struct.rs2);
					end
					else begin
						o_struct.rf_wr_data = $signed(i_struct.rs1) < $signed(i_struct.imm_gend);
					end
				end
		
				`DO_SLTU: begin
					if(i_struct.format ==`R_FORM) begin
						o_struct.rf_wr_data = i_struct.rs1 < i_struct.rs2;
					end
					else begin
						o_struct.rf_wr_data = i_struct.rs1 < i_struct.imm_gend;
					end
				end

				`DO_XOR: begin
					if(i_struct.format ==`R_FORM) begin
                                                o_struct.rf_wr_data = i_struct.rs1 ^ i_struct.rs2;
                                        end
                                        else begin
                                                o_struct.rf_wr_data = i_struct.rs1 ^ i_struct.imm_gend;
                                        end
				end
			
				`DO_SRL: begin
					if(i_struct.format ==`R_FORM) begin
                                                if(i_struct.en_sign_ext) begin
                                                        o_struct.rf_wr_data = i_struct.rs1 >> i_struct.rs2[4:0];
                                                end
                                                else begin
                                                        o_struct.rf_wr_data = i_struct.rs1 >> i_struct.rs2[5:0];
                                                end

                                        end
                                        else if(i_struct.format ==`I_FORM ) begin
                                                if(i_struct.en_sign_ext) begin
                                                        o_struct.rf_wr_data = i_struct.rs1 >> i_struct.imm_gend[4:0];
                                                end
                                                else begin
                                                        o_struct.rf_wr_data = i_struct.rs1 >> i_struct.imm_gend[5:0];
                                                end

                                        end
				end
			
				`DO_SRA: begin
				if(i_struct.format ==`R_FORM) begin
                                                if(i_struct.en_sign_ext) begin
                                                        o_struct.rf_wr_data = ({32 {i_struct.rs1[31]}} << {6'd32 -{1'b0, i_struct.rs2[4:0]}}) | (i_struct.rs1  >> i_struct.rs2[4:0]);
                                                end
                                                else begin
                                                        o_struct.rf_wr_data = ({64 {i_struct.rs1[63]}} << {7'd64 -{1'b0, i_struct.rs2[5:0]}}) | (i_struct.rs1  >> i_struct.rs2[5:0]); //temp?
                                                end

                                        end
                                        else if(i_struct.format ==`I_FORM ) begin
                                                if(i_struct.en_sign_ext) begin
							o_struct.rf_wr_data = ({32 {i_struct.rs1[31]}} << {6'd32 -{1'b0, i_struct.imm_gend[4:0]}}) | (i_struct.rs1  >> i_struct.imm_gend[4:0]);
                                                end
                                                else begin
                                                        o_struct.rf_wr_data = ({64 {i_struct.rs1[63]}} << {7'd64 -{1'b0, i_struct.imm_gend[5:0]}}) | (i_struct.rs1  >> i_struct.imm_gend[5:0]);
                                                end

                                        end
				end
			
				`DO_OR: begin
					if(i_struct.format ==`R_FORM) begin
                                                o_struct.rf_wr_data = i_struct.rs1 | i_struct.rs2;
                                        end
                                        else begin
                                                o_struct.rf_wr_data = i_struct.rs1 | i_struct.imm_gend;
                                        end	
				end

				`DO_AND: begin
					if(i_struct.format ==`R_FORM) begin
                                                o_struct.rf_wr_data = i_struct.rs1 & i_struct.rs2;
                                        end
                                        else begin
                                                o_struct.rf_wr_data = i_struct.rs1 & i_struct.imm_gend;
                                        end
				end
			
				`DO_LUI: begin
					o_struct.rf_wr_data = (64'(signed'( {i_struct.imm_gend[19:0], 12'b0})));
				end
			
				`DO_AUIPC: begin
					o_struct.rf_wr_data = (64'(signed'({i_struct.imm_gend[19:0], 12'b0}))) + i_struct.pc;
				end

				default: ;
       	
	
			endcase
	        end
	end
endmodule
