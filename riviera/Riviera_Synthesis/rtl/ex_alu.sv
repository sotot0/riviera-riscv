`timescale 1ns/100fs

`include "defines.sv"
import struct_pckg :: interconnection_struct;

module ex_alu ( 

	input interconnection_struct	i_struct,

	output interconnection_struct   o_struct

);

	logic [63:0] tmp_value;

	always_comb begin
		
		tmp_value = 0;

		o_struct = i_struct;
		o_struct.rf_wr_data = 0;
		o_struct.mem_addr = 0;
		o_struct.en_sign_ext = 0;

		if(i_struct.is_valid && i_struct.alu_en && !i_struct.is_branch) begin
    			
			unique case (i_struct.alu_op) 
				
				`DO_ADD: begin
                                	if(i_struct.format ==`R_FORM) begin
						if(i_struct.en_sign_ext) begin
	                                                tmp_value = i_struct.rs1[31:0] + i_struct.rs2[31:0];
	                                                o_struct.rf_wr_data = {{32{tmp_value[31]}}, tmp_value[31:0]};
        	                                        o_struct.en_sign_ext = 1'b0;			
						end
						else begin
							o_struct.rf_wr_data = i_struct.rs1 + i_struct.rs2; 
						end
					end
					else if(i_struct.format ==`I_FORM ) begin
						if (i_struct.mem_rd) begin //LOAD
							o_struct.mem_addr = i_struct.rs1 + i_struct.imm_gend;
						end
						else begin //ADDI
							if(i_struct.en_sign_ext) begin
								tmp_value = i_struct.rs1 + i_struct.imm_gend;
								o_struct.rf_wr_data = {{32{tmp_value[31]}}, tmp_value[31:0]};
								o_struct.en_sign_ext = 1'b0;
							end
							else begin
                                                		o_struct.rf_wr_data = i_struct.rs1 + i_struct.imm_gend;
							end
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

                                	if(i_struct.en_sign_ext) begin
						tmp_value = i_struct.rs1[31:0] - i_struct.rs2[31:0];
						o_struct.rf_wr_data = {{32{tmp_value[31]}}, tmp_value[31:0]};
						o_struct.en_sign_ext = 1'b0;
					end
					else begin
						o_struct.rf_wr_data = i_struct.rs1 - i_struct.rs2;
					end
				end
			
				`DO_SLL: begin
					if(i_struct.format ==`R_FORM) begin
						if(i_struct.en_sign_ext) begin
	                                                tmp_value = i_struct.rs1 << i_struct.rs2[4:0];
							o_struct.rf_wr_data = {{32{tmp_value[31]}}, tmp_value[31:0]};
							o_struct.en_sign_ext = 1'b0;
						end
						else begin
							o_struct.rf_wr_data = i_struct.rs1 << i_struct.rs2[5:0]; 
						end

                                        end
                                        else if(i_struct.format ==`I_FORM ) begin
						if(i_struct.en_sign_ext) begin
                                                        tmp_value = i_struct.rs1 << i_struct.imm_gend[4:0];
							o_struct.rf_wr_data = {{32{tmp_value[31]}}, tmp_value[31:0]};
							o_struct.en_sign_ext = 1'b0;
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
                                                        tmp_value = i_struct.rs1[31:0] >> i_struct.rs2[4:0];
							o_struct.rf_wr_data = {{32{tmp_value[31]}}, tmp_value[31:0]};
							o_struct.en_sign_ext = 1'b0;
                                                end
                                                else begin
                                                        o_struct.rf_wr_data = i_struct.rs1 >> i_struct.rs2[5:0];
                                                end

                                        end
                                        else if(i_struct.format ==`I_FORM ) begin
                                                if(i_struct.en_sign_ext) begin
                                                       tmp_value = i_struct.rs1[31:0] >> i_struct.imm_gend[4:0];
                                                       o_struct.rf_wr_data = {{32{tmp_value[31]}}, tmp_value[31:0]};
                                                       o_struct.en_sign_ext = 1'b0;
                                                end
                                                else begin
                                                        o_struct.rf_wr_data = i_struct.rs1 >> i_struct.imm_gend[5:0];
                                                end

                                        end
				end
			
				`DO_SRA: begin
				if(i_struct.format ==`R_FORM) begin
                                                if(i_struct.en_sign_ext) begin
                                                        tmp_value = $signed(i_struct.rs1[31:0]) >>> i_struct.rs2[4:0];
                                                        o_struct.rf_wr_data = {{32{tmp_value[31]}},tmp_value[31:0]};
                                                        o_struct.en_sign_ext = 1'b0;
						end
                                                else begin
                                                        o_struct.rf_wr_data = ({64{i_struct.rs1[63]}}<<{7'd64 -{1'b0, i_struct.rs2[5:0]}}) | (i_struct.rs1>>i_struct.rs2[5:0]);
                                                end

                                        end
                                        else if(i_struct.format ==`I_FORM ) begin
                                                if(i_struct.en_sign_ext) begin
							tmp_value = $signed(i_struct.rs1[31:0]) >>> i_struct.imm_gend[5:0];
							o_struct.rf_wr_data = {{32{tmp_value[31]}},tmp_value[31:0]};
							o_struct.en_sign_ext = 1'b0;
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
