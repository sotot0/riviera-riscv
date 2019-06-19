import struct_pckg :: interconnection_struct;

//TODO : INVALID INSTRUCTIONS BECAUSE OF REGS AND IMMEDIATES ( NOT ONLY FROM
//OPCODE , FUNCT3 AND FUNCT&

module id_stage(
	input logic			clk,
	input logic			rst_n,
	
	// IF-relative inputs
	input logic [`RNG_32]		i_if_instr,
	input logic [`RNG_64]		i_if_pc,

	// EX-relative input
	input logic			i_ex_ready,
	input logic			i_ex_flush_id,

	// WB-relative inputs
	input logic [`RNG_WR_ADDR_REG]	i_wb_wr_reg_addr,	// address of the register to write
	input logic [`RNG_WR_DATA_REG]	i_wb_wr_reg_data,	// data to write on register
	input logic 			i_wb_wr_reg_en,		// write enable to RF
	
	// to IF
	output logic			o_id_ready,

	// to EX
	output logic 			o_id_reg
	// Packed struct to all from now on	
	//output interconnection_struct	o_id2all
);

	logic				valid_id;	
	interconnection_struct 		o_id2all;

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
	
	logic [`RNG_64] imm_gen;	
	// make and connect an instance of immediate generator
	imm_gen imm_gen_instance
	(
		.i_format	(o_id2all.format),
		.i_instr	(i_if_instr),
		.o_imm		(o_id2all.imm_gend)
	);
	
	// decode the instruction
	always_comb begin
		
		unique case(i_if_instr[`RNG_OP])
		
			`LUI: begin
				
				o_id2all.format         = `JU_FORM;              // load instr is I format       
				o_id2all.alu_en         = 1'b1;
				o_id2all.alu_src        = 1'b1;                 // the second arg of ALU is an immediate
				o_id2all.pc             = i_if_pc;
				//o_id2all.imm_gend       = 1'b0;               // not needed
				o_id2all.is_branch      = 1'b0;                 // not branch
				o_id2all.mem_rd         = 1'b0;                 // not load from mem
				o_id2all.mem_wr         = 1'b0;                 // not store to mem
				o_id2all.mem_to_reg     = 1'b1;                 // write the result to RF
				o_id2all.rf_wr          = 1'b1;                 // enable write to RF
				o_id2all.rf_wr_addr     = i_if_instr[`RNG_RD];  // reg to write the result
				o_id2all.rf_wr_data     = 0;                    // unknown yet
				o_id2all.is_valid       = 1'b1;                 // assume that the instruction is valid
				o_id2all.is_64W         = 1'b1;
				o_id2all.alu_op         = `DO_LUI;	
			end
			
			`AUIPC: begin

				o_id2all.format         = `JU_FORM;              // load instr is I format       
 				o_id2all.alu_en         = 1'b1;
				o_id2all.alu_src        = 1'b1;                 // the second arg of ALU is an immediate
				o_id2all.pc             = i_if_pc;
				o_id2all.is_branch      = 1'b0;                 // not branch
				o_id2all.mem_rd         = 1'b0;                 // not load from mem
				o_id2all.mem_wr         = 1'b0;                 // not store to mem
				o_id2all.mem_to_reg     = 1'b1;                 // write the result to RF
				o_id2all.rf_wr          = 1'b1;                 // enable write to RF
				o_id2all.rf_wr_addr     = i_if_instr[`RNG_RD];  // reg to write the result
				o_id2all.rf_wr_data     = 0;                    // unknown yet
				o_id2all.is_valid       = 1'b1;                 // assume that the instruction is valid
				o_id2all.is_64W         = 1'b1;
				o_id2all.alu_op         = `DO_AUIPC;
			end
			
			`JAL: begin

				o_id2all.format		= `JU_FORM;
				o_id2all.alu_en		= 1'b1;
				o_id2all.alu_src	= 1'b1;
				o_id2all.pc		= i_if_pc;
				o_id2all.is_branch	= 1'b1;			// but unconditional 
				o_id2all.mem_rd		= 1'b0;
				o_id2all.mem_wr		= 1'b0;
				o_id2all.mem_to_reg	= 1'b1;
				o_id2all.rf_wr		= 1'b1;
				o_id2all.rf_wr_addr	= i_if_instr[`RNG_RD];
				o_id2all.rf_wr_data	= 0;			// unknown yet
				o_id2all.is_valid	= 1'b1;
				o_id2all.is_64W		= 1'b0;
				o_id2all.alu_op		= `DO_ADD;		// pc+4 or +2 TODO : dependent signal for comprs'd. The calc. of jump to br unit
			end
			
			`JALR: begin
				if( i_if_instr[`RNG_F3] != `F3_JALR ) begin
					o_id2all.is_valid = 1'b0;
				end
				else begin 
					o_id2all.format		= `I_FORM;
					o_id2all.alu_en		= 1'b1;
					o_id2all.alu_src	= 1'b1;
					o_id2all.pc		= i_if_pc;
					o_id2all.is_branch	= 1'b1;		// but unconditional
					o_id2all.mem_rd		= 1'b0;
					o_id2all.mem_wr		= 1'b0;
					o_id2all.rf_wr		= 1'b1;
					o_id2all.rf_wr_addr	= i_if_instr[`RNG_RD];
					o_id2all.rf_wr_data	= 0;		// unknown yet
					o_id2all.is_valid	= 1'b1;
					o_id2all.is_64W		= 1'b0;
					o_id2all.alu_op		= `DO_ADD;	// pc+4 or +2 TODO : dependent signal for comprs'd. The calc. of jump to br unit
				end
			end
			
			`BRANCH: begin
				o_id2all.format		= `BS_FORM;
				o_id2all.alu_en		= 1'b1;
				o_id2all.alu_src	= 1'b0;
				o_id2all.pc		= i_if_pc;
				o_id2all.is_branch	= 1'b1;
				o_id2all.mem_rd		= 1'b0;
				o_id2all.mem_wr		= 1'b0;
				o_id2all.rf_wr		= 1'b0;
				o_id2all.rf_wr_addr	= 0;
				o_id2all.rf_wr_data	= 0;
				o_id2all.is_valid	= 1'b1;
				o_id2all.is_64W		= 1'b0;

				unique case(i_if_instr[`RNG_F3])

					`F3_BEQ: begin
						o_id2all.alu_op	= `DO_SUB;
					end

					`F3_BNE: begin
						o_id2all.alu_op = `DO_SUB;
					end

					`F3_BLTU: begin
						o_id2all.alu_op = `DO_SUB;
					end

					`F3_BGEU: begin
						o_id2all.alu_op = `DO_SUB;
					end

					`F3_BGE: begin
						o_id2all.alu_op = `DO_BGE;
					end

					`F3_BLT: begin
						o_id2all.alu_op = `DO_BLT;
					end	

					default: o_id2all.is_valid = 1'b0;
				endcase
			end
			
			`LOAD: begin
				o_id2all.format		= `I_FORM;		// load instr is I format	
				o_id2all.alu_en         = 1'b1;   
				o_id2all.alu_src        = 1'b1;                 // the second arg of ALU is an immediate
				o_id2all.pc             = i_if_pc;
				o_id2all.is_branch      = 1'b0;                 // not branch
				o_id2all.mem_rd         = 1'b1;                 // not load from mem
				o_id2all.mem_wr         = 1'b0;                 // not store to mem
				o_id2all.mem_to_reg     = 1'b1;                 // write the result to RF
				o_id2all.rf_wr          = 1'b1;                 // enable write to RF
				o_id2all.rf_wr_addr     = i_if_instr[`RNG_RD];  // reg to write the result
				o_id2all.rf_wr_data     = 0;     	        // unknown yet
				o_id2all.is_valid       = 1'b1;                 // assume that the instruction is valid
				o_id2all.is_64W         = 1'b0;
				o_id2all.alu_op		= `DO_ADD;
				
				unique case(i_if_instr[`RNG_F3])

					`F3_LB: begin
						o_id2all.mem_req_unit = `B;
						o_id2all.mem_ext = `SIGNED;
					end

					`F3_LH: begin
						o_id2all.mem_req_unit = `HW;
						o_id2all.mem_ext = `SIGNED;
					end

					`F3_LW: begin
						o_id2all.mem_req_unit = `W;
						o_id2all.mem_ext = `SIGNED;
					end

					`F3_LBU: begin
						o_id2all.mem_req_unit = `B;
						o_id2all.mem_ext = `UNSIGNED;
					end

					`F3_LHU: begin
						o_id2all.mem_req_unit = `HW;
						o_id2all.mem_ext = `UNSIGNED;
					end

					default: o_id2all.is_valid = 1'b0;	// invalid instruction
					
				endcase
			
			end
			
			`STORE: begin
				o_id2all.format         = `BS_FORM;              // load instr is I format       
				o_id2all.alu_en         = 1'b1;
				o_id2all.alu_src        = 1'b1;                 // the second arg of ALU is an immediate
				o_id2all.pc             = i_if_pc;
				//o_id2all.imm_gend       = 1'b0;               // not needed
				o_id2all.is_branch      = 1'b0;                 // not branch
				o_id2all.mem_rd         = 1'b0;                 // not load from mem
				o_id2all.mem_wr         = 1'b1;                 // not store to mem
				o_id2all.mem_to_reg     = 1'b1;                 // write the result to RF
				o_id2all.rf_wr          = 1'b0;                 // enable write to RF
				o_id2all.rf_wr_addr     = 0;			// reg to write the result
				o_id2all.rf_wr_data     = 0;                    // unknown yet
				o_id2all.is_valid       = 1'b1;                 // assume that the instruction is valid
				o_id2all.is_64W         = 1'b0;
				o_id2all.alu_op         = `DO_ADD;
				o_id2all.mem_ext	= `SIGNED;

				unique case (i_if_instr[`RNG_F3])
				
					`F3_SB: begin
						o_id2all.mem_req_unit = `B;
					end
				
					`F3_SW: begin
						o_id2all.mem_req_unit = `W;
					end

					`F3_SH: begin
						o_id2all.mem_req_unit = `HW;
					end

					default: o_id2all.is_valid = 1'b0;	// invalid instruction
				endcase
						
			end

			`IMM: begin
				o_id2all.format		=`I_FORM;
				o_id2all.alu_en		= 1'b1;
				o_id2all.alu_src	= 1'b1;
				o_id2all.pc		= i_if_pc;
				o_id2all.is_branch	= 1'b0;
				o_id2all.mem_rd		= 1'b0;
				o_id2all.mem_wr		= 1'b0;
				o_id2all.mem_to_reg	= 1'b1;
				o_id2all.rf_wr		= 1'b1;
				o_id2all.rf_wr_addr	= i_if_instr[`RNG_RD];
				o_id2all.rf_wr_data	= 1'b0;			// unknown yet
				o_id2all.is_valid	= 1'b1;
				o_id2all.is_64W		= 1'b0;

				unique case(i_if_instr[`RNG_F3])

					`F3_ADDI: begin
						o_id2all.alu_op = `DO_ADD;
					end

					`F3_SLTI: begin
						o_id2all.alu_op = `DO_SLT;
					end

					`F3_SLTIU: begin
						o_id2all.alu_op = `DO_SLTU;
					end

					`F3_XORI: begin
						o_id2all.alu_op = `DO_XOR;
					end

					`F3_ORI: begin
						o_id2all.alu_op = `DO_OR;
					end

					`F3_ANDI: begin
						o_id2all.alu_op = `DO_AND;
					end

					`F3_SLLI: begin
						o_id2all.alu_op = `DO_SLL;
					end

					`F3_SR: begin
						unique case(i_if_instr[`RNG_F7])
							`F7_SRLI: begin
								o_id2all.alu_op = `DO_SRL;
							end

							`F7_SRAI: begin
								o_id2all.alu_op = `DO_SRA;
							end

							default: o_id2all.is_valid = 1'b0;
						endcase
					end
					
					default: o_id2all.is_valid = 1'b0;
				endcase
			end

			`ALU: begin
				o_id2all.format 	= `R_FORM;		
				o_id2all.alu_en		= 1'b1;
				o_id2all.alu_src	= 1'b0;			// the second arg of ALU is not immidiate
				o_id2all.pc		= i_if_pc;
				o_id2all.is_branch	= 1'b0;			// not branch
				o_id2all.mem_rd		= 1'b0;			// not load from mem
				o_id2all.mem_wr		= 1'b0;			// not store to mem
				o_id2all.mem_to_reg	= 1'b1;			// write the result to RF
				o_id2all.rf_wr		= 1'b1;			// enable write to RF
				o_id2all.rf_wr_addr	= i_if_instr[`RNG_RD];	// reg to write the result
				o_id2all.rf_wr_data	= 1'b0;			// unknown yet
				o_id2all.is_valid	= 1'b1;			// assume that the instruction is valid
				o_id2all.is_64W		= 1'b0;	

				unique case(i_if_instr[`RNG_F3])

					`F3_ADD_SUB: begin
						unique case(i_if_instr[`RNG_F7])

							`F7_ADD: begin
									o_id2all.alu_op = `DO_ADD;
							end

							`F7_SUB: begin
									o_id2all.alu_op = `DO_SUB;
							end

							default: o_id2all.is_valid = 1'b0;       // invalid instruction

						endcase
					end

					`F3_SLL: begin
						if(i_if_instr[`RNG_F7] != `F7_SLL) begin
							o_id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_SLL;
						end
					end

					`F3_SLT: begin
						if(i_if_instr[`RNG_F7] != `F7_SLT) begin
							o_id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_SLT;
						end
					end

					`F3_SLTU: begin
						if(i_if_instr[`RNG_F7] != `F7_SLTU) begin
							o_id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_SLTU;
						end
					end

					`F3_XOR: begin
						if(i_if_instr[`RNG_F7] != `F7_XOR) begin
							o_id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_XOR;
						end
					end

					`F3_SRL_SRA: begin
						unique case(i_if_instr[31:30])
							2'b00: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									o_id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_SRL;
								end
							end
 
							2'b01: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									o_id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_SRA;
								end
							end

							default: o_id2all.is_valid = 1'b0;       // invalid instruction

                                                endcase
					end

					`F3_OR: begin
						if(i_if_instr[`RNG_F7] != `F7_OR) begin
							o_id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_OR;
						end
					end

					`F3_AND: begin
						if(i_if_instr[`RNG_F7] != `F7_AND) begin
							o_id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_AND;
						end
					end
					default: o_id2all.is_valid = 1'b0;       // invalid instruction
				endcase

			end

			`LWU_LD_64: begin
				o_id2all.format		= `I_FORM;
				o_id2all.alu_en		= 1'b1;
				o_id2all.alu_src	= 1'b1;
				o_id2all.pc		= i_if_pc;
				o_id2all.is_branch	= 1'b0;
				o_id2all.mem_rd		= 1'b1;
				o_id2all.mem_wr		= 1'b0;
				o_id2all.mem_to_reg	= 1'b1;
				o_id2all.rf_wr		= 1'b1;
				o_id2all.rf_wr_addr	= i_if_instr[`RNG_RD];
				o_id2all.rf_wr_data	= 0;
				o_id2all.is_valid	= 1'b1;
				o_id2all.is_64W		= 1'b1;
				o_id2all.alu_op		= `DO_ADD;

				unique case(i_if_instr[`RNG_F3])

					`F3_LWU_64: begin
						o_id2all.mem_req_unit = `W;
						o_id2all.mem_ext = `UNSIGNED;						
					end

					`F3_LD_64: begin
						o_id2all.mem_req_unit = `DW;
						o_id2all.mem_ext = `SIGNED;
					end

					default: o_id2all.is_valid = 1'b0;
				endcase
			end

			`SD_64:	begin

				if(i_if_instr[`RNG_F3] != 3'b011) begin
					o_id2all.is_valid = 1'b0;
				end
				else begin
					o_id2all.format		= `BS_FORM;
					o_id2all.alu_en		= 1'b1;
					o_id2all.alu_src	= 1'b1;
					o_id2all.pc		= i_if_pc;
					o_id2all.is_branch	= 1'b0;
					o_id2all.mem_rd		= 1'b0;
					o_id2all.mem_wr		= 1'b1;
					o_id2all.rf_wr		= 1'b0;
					o_id2all.rf_wr_addr	= 0;
					o_id2all.rf_wr_data	= 0;
					o_id2all.is_valid	= 1'b1;
					o_id2all.is_64W		= 1'b1;
					o_id2all.alu_op		= `DO_ADD;
					o_id2all.mem_req_unit	= `DW;
					o_id2all.mem_ext	= `SIGNED;	
				end
			end

			`ADDIW_SLLIW_SRLIW_SRAIW_64: begin				

				o_id2all.format		= `I_FORM;
				o_id2all.alu_en		= 1'b1;
				o_id2all.alu_src	= 1'b1;
				o_id2all.pc		= i_if_pc;
				o_id2all.is_branch	= 1'b0;
				o_id2all.mem_rd		= 1'b0;
				o_id2all.mem_wr		= 1'b0;
				o_id2all.rf_wr		= 1'b1;
				o_id2all.rf_wr_addr	= i_if_instr[`RNG_RD];
				o_id2all.rf_wr_data	= 0;
				o_id2all.is_valid	= 1'b1;
				o_id2all.is_64W		= 1'b1;

				unique case(i_if_instr[`RNG_F3])

					`F3_ADDIW_64: begin

						o_id2all.alu_op = `DO_ADD;
					end

					`F3_SLLIW_64: begin

						if(i_if_instr[`RNG_F7]) begin

							o_id2all.is_valid = 1'b0;
						end
						else begin

							o_id2all.alu_op = `DO_SLL;
						end
					end

					`F3_SRLIW_SRAIW_64: begin

						unique case(i_if_instr[`RNG_F7])

							`F7_SRLIW_64: begin

								o_id2all.alu_op	= `DO_SRL;
							end

							`F7_SRAIW_64: begin

								o_id2all.alu_op = `DO_SRA;

							end

							default: o_id2all.is_valid = 1'b1;

						endcase
					end


					default: o_id2all.is_valid = 1'b0;
				endcase
			end

			`ALU_64: begin
				o_id2all.format		= `R_FORM;	
				o_id2all.alu_en         = 1'b1;
                                o_id2all.alu_src        = 1'b0;                 // the second arg of ALU is not immidiate
                                o_id2all.pc             = i_if_pc;
                                o_id2all.is_branch      = 1'b0;                 // not branch
                                o_id2all.mem_rd         = 1'b0;                 // not load from mem
                                o_id2all.mem_wr         = 1'b0;                 // not store to mem
                                o_id2all.mem_to_reg     = 1'b1;                 // write the result to RF
                                o_id2all.rf_wr          = 1'b1;                 // enable write to RF
                                o_id2all.rf_wr_addr     = i_if_instr[`RNG_RD];  // reg to write the result
                                o_id2all.rf_wr_data     = 0;                    // unknown yet
				o_id2all.is_valid 	= 1'b1;
				o_id2all.is_64W		= 1'b1;			

				unique case(i_if_instr[`RNG_F3])
				
					`F3_ADDW_SUBW_64: begin	
						unique case(i_if_instr[31:30])
						
							2'b00: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									o_id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_ADD;
								end
							end
		
							2'b01: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									o_id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_SUB;
								end
							end
							
							default: o_id2all.is_valid = 1'b0;       // invalid instruction

						endcase
					end
		
					`F3_SLLW_64: begin
						if(i_if_instr[`RNG_F7] != `F7_SLLW_64) begin
							o_id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							o_id2all.alu_op = `DO_SLL;
						end
					end
					
					`F3_SRLW_SRAW_64: begin
						unique case(i_if_instr[31:30])
						
							2'b00: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									o_id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_SRL;
								end
							end
						
							2'b01: begin
								if(i_if_instr[29:25] != 5'b00000) begin
									o_id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									o_id2all.alu_op = `DO_SRA;
								end
							end
						
							default: o_id2all.is_valid = 1'b0;       // invalid instruction

						endcase
					end					
					
					default: o_id2all.is_valid = 1'b0;       // invalid instruction
				endcase
			end	
			
			default: o_id2all.is_valid = 1'b0;       // invalid instruction
		endcase			
	end

	assign o_id_ready	= i_ex_ready; // && TODO stall control???
	assign valid_id		= o_id_ready;
	assign valid_instr	= o_id2all.is_valid;

	always_ff @(posedge clk, negedge rst_n) begin

		if(~rst_n) begin

			o_id_reg <= 0;
		end
		else begin
			if(valid_id) begin
	
				o_id_reg <= o_id2all;
			end

			if(i_ex_flush_id) begin

				o_id_reg <= 0;

			end
		end	
	end
endmodule
