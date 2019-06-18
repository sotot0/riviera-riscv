import struct_pckg :: interconnection_struct;
//`include "interconnection_struct.sv"

module id_stage(
	input logic			clk,
	input logic			rst_n,
	
	// IF-relative inputs
	input logic [`RNG_32]		i_if_instr,
	input logic [`RNG_64]		i_if_pc,

	// WB-relative inputs
	input logic [`RNG_WR_ADDR_REG]	i_wb_wr_reg_addr,	// address of the register to write
	input logic [`RNG_WR_DATA_REG]	i_wb_wr_reg_data,	// data to write on register
	input logic 			i_wb_wr_reg_en,		// write enable to RF
	
	// Packed struct to all from now on	
	output interconnection_struct	o_id2all
);

	// make and connect an instance of IR
	regfile_2r1w
	#(
		.DLEN	(`DLEN),
		.ALEN	(`ALEN)
	)
	rf_instance
	(
		.clk		(clk),
		.i_raddr_a	(i_if_instr[`RNG_RS1]),
		.i_raddr_b	(i_if_instr[`RNG_RS2]),
		.i_wen		(i_wb_wr_reg_en),
		.i_waddr	(i_wb_wr_reg_addr),
		.i_wdata	(i_wb_wr_reg_data),
		.o_rdata_a	(o_id2all.rs1),
		.o_rdata_b	(o_id2all.rs2)	
	);
	
	// decode the instruction
	always_comb begin
		
		unique case(i_if_instr[`RNG_OP])
		
			`LUI:				begin
			
			end
			
			`AUIPC:				begin
			
			end
			
			`JAL:				begin
				
			end
			
			`JALR:				begin
			
			end
			
			`BRANCH:			begin
			
			end
			
			`LOAD: 				begin
			
			end
			
			`STORE: 			begin
			
			end

			`IMM: 				begin
			
			end

			`ALU: begin

				o_id2all.alu_en		= 1'b1;
				o_id2all.alu_src	= 1'b0;
				o_id2all.pc		= i_if_pc;
				o_id2all.imm_gend	= 0;			// not needed
				o_id2all.is_branch	= 1'b0;
				o_id2all.mem_rd		= 1'b0;
				o_id2all.mem_wr		= 1'b0;
				o_id2all.mem_to_reg	= 1'b1;
				o_id2all.rf_wr		= 1'b1;
				o_id2all.rf_wr_addr	= i_if_instr[`RNG_RD];
				o_id2all.rf_wr_data	= 0; 			// unknown yet
				
				unique case(i_if_instr[`RNG_F3])

					`F3_ADD_SUB: begin
						unique case(i_if_instr[31:30])

							2'b00: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									// invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_ADD;
								end
							end

							2'b01: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									// invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_SUB;
								end
							end

							default:; // invalid instruction

						endcase
					end

					`F3_SLL: begin
						if(i_if_instr[`RNG_F7] != `F7_SLL) begin
							// invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_SLL;
						end
					end

					`F3_SLT: begin
						if(i_if_instr[`RNG_F7] != `F7_SLT) begin
							// invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_SLT;
						end
					end

					`F3_SLTU: begin
						if(i_if_instr[`RNG_F7] != `F7_SLTU) begin
							// invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_SLTU;
						end
					end

					`F3_XOR: begin
						if(i_if_instr[`RNG_F7] != `F7_XOR) begin
							// invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_XOR;
						end
					end

					`F3_SRL_SRA: begin
						unique case(i_if_instr[31:30])
							2'b00: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									// invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_SRL;
								end
							end
 
							2'b01: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									// invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_SRA;
								end
							end

							default:; // invalid instruction

                                                endcase
					end

					`F3_OR: begin
						if(i_if_instr[`RNG_F7] != `F7_OR) begin
							// invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_OR;
						end
					end

					`F3_AND: begin
						if(i_if_instr[`RNG_F7] != `F7_AND) begin
							// invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_AND;
						end
					end
					default:; // invalid instruction
				endcase

			end

			`LWU_LD_64: 			begin

			end

			`SD_64:				begin
			
			end

			`ADDIW_SLLIW_SRLIW_SRAIW_64: 	begin

			end

			`ALU_64:			begin
			
			end

			default:; // invalid instruction
		endcase	

	end

endmodule
