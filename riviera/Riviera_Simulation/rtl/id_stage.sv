`include "defines.sv"
//import struct_pckg :: interconnection_struct;

//TODO : INVALID INSTRUCTIONS BECAUSE OF REGS AND IMMEDIATES ( NOT ONLY FROM
//OPCODE , FUNCT3 AND FUNCT&

module id_stage(
	input logic			clk,
	input logic			rst_n,
	
	// IF-relative inputs
	input logic [`RNG_32]		i_if_instr,
	input logic			i_if_valid_instr,
	input logic [`RNG_64]		i_if_pc,

	// EX-relative input
	input logic			i_ex_ready,
	input logic			i_ex_branch_taken,
	input logic			i_ex_jump_taken,

	// WB-relative inputs
	input logic [`RNG_WR_ADDR_REG]	i_wb_wr_reg_addr,	// address of the register to write
	input logic [`RNG_WR_DATA_REG]	i_wb_wr_reg_data,	// data to write on register
	input logic 			i_wb_wr_reg_en,		// write enable to RF
	
	// to IF
	output logic			o_id_ready,

	// for stalling purposes
	output logic [`ALEN-1:0]	o_rs1,
	output logic [`ALEN-1:0]	o_rs2,
	output logic [1:0]		o_check_regs,

	// to EX
	output interconnection_struct   o_id2all,
	// Packed struct to all from now on	
	//output interconnection_struct	id2all
	

	// Compressed
	input logic [63:0]		i_branch_target,	// branch address
	input logic [63:0]		i_jumb_target,		// jumb address
	output logic                    o_incr_pc              // increment pc flag
	
);


	// Compressed

        logic [`RNG_32]                 fsm_instr;              // fsm output instruction
        logic [`RNG_32]                 compr_unit_instr;       // decompressed instruction
	logic                  		is_compr;               // is instruction compressed flag
        logic                  		ill_instr;
	logic [`RNG_64]			o_pc;			// invalid instruction flag

        compr_fsm compr_fsm_instance(

                .clk            	(clk),
                .rst_n          	(rst_n),
                .i_instr        	(i_if_instr),
                .o_instr        	(fsm_instr),
                .incr_pc        	(o_incr_pc),
                .i_jumb_taken   	(i_ex_jump_taken),
                .i_branch_taken 	(i_ex_branch_taken),
		.i_jumb_target		(i_jumb_target),
		.i_branch_target	(i_branch_target),
                .i_ex_ready     	(i_ex_ready),

		.i_if_pc		(i_if_pc),
		.o_pc			(o_pc)

        );

        compr_instr_unit compr_instr_unit_instance(

                .i_instr        (fsm_instr),
                .o_instr        (compr_unit_instr),
                .o_is_compr     (is_compr),
                .o_ill_instr    (ill_instr)


        );


	interconnection_struct          id2all;

	// make and connect an instance of IR
	regfile_2r1w
	#(
		.DLEN	(`DLEN),
		.ALEN	(`ALEN)
	)
	rf_instance
	(
		.clk		(clk),
		.i_raddr_a	(compr_unit_instr[`RNG_RS1]),
		.i_raddr_b	(compr_unit_instr[`RNG_RS2]),
		.i_wen		(i_wb_wr_reg_en),
		.i_waddr	(i_wb_wr_reg_addr),
		.i_wdata	(i_wb_wr_reg_data),
		.o_rdata_a	(id2all.rs1),
		.o_rdata_b	(id2all.rs2)	
	);
	
	logic [`RNG_64] imm_gen;	
	// make and connect an instance of immediate generator
	imm_gen imm_gen_instance
	(
		.i_format	(id2all.format),
		.i_instr	(compr_unit_instr),
		.o_imm		(id2all.imm_gend)
	);
	
	// decode the instruction
	always_comb begin
		
		id2all.format		= `I_FORM;
		// rs1 is given but we don't care
		// rs2 is given but we don't care
		id2all.alu_op		= 0;
		id2all.alu_en		= 0;
		id2all.alu_src		= 0;
		id2all.pc		= 0;
		id2all.staller		= 0;
		// imm_gend is given -- we don't care
		id2all.is_branch	= 0;
		id2all.is_compr		= is_compr;		// Compressed
		id2all.branch_type	= 0;
		id2all.mem_rd		= 0;
		id2all.mem_wr		= 0;
		id2all.mem_wr_en	= 0;
		id2all.mem_addr		= 0;
		id2all.mem_data		= 0;
		id2all.mem_to_reg	= 0;
		id2all.rf_wr		= 0;
		id2all.rf_wr_addr	= 0;
		id2all.rf_wr_data	= 0;
		id2all.is_valid		= 0;
		id2all.en_sign_ext	= 0;
		id2all.mem_req_unit	= 0;
		id2all.mem_ext		= 0;
		
		if(i_if_valid_instr & ~i_ex_branch_taken & ~i_ex_jump_taken & i_ex_ready) begin  // iff instr is valid then decode.
					    									    // else forward the
					                                                                            // pre-initialized structure

		unique case(compr_unit_instr[`RNG_OP])
		
			`LUI: begin
				
				o_check_regs	      = `NONE;				

				id2all.format         = `JU_FORM;             // load instr is I format       
				id2all.alu_en         = 1'b1;
				id2all.alu_src        = 1'b1;                 // the second arg of ALU is an immediate
				id2all.pc             = o_pc;
				id2all.is_branch      = 1'b0;                 // not branch
				id2all.mem_rd         = 1'b0;                 // not load from mem
				id2all.mem_wr         = 1'b0;                 // not store to mem
				id2all.mem_to_reg     = 1'b0;                 // write the result to RF
				id2all.rf_wr          = 1'b1;                 // enable write to RF
				id2all.rf_wr_addr     = compr_unit_instr[`RNG_RD];  // reg to write the result
				id2all.rf_wr_data     = 0;                    // unknown yet
				id2all.is_valid       = 1'b1;                 // assume that the instruction is valid
				id2all.en_sign_ext    = 1'b1;
				id2all.alu_op         = `DO_LUI;	
			end
			
			`AUIPC: begin
				
				o_check_regs  	      = `NONE;
				
				id2all.format         = `JU_FORM;             // load instr is I format       
 				id2all.alu_en         = 1'b1;
				id2all.alu_src        = 1'b1;                 // the second arg of ALU is an immediate
				id2all.pc             = o_pc;
				id2all.is_branch      = 1'b0;                 // not branch
				id2all.mem_rd         = 1'b0;                 // not load from mem
				id2all.mem_wr         = 1'b0;                 // not store to mem
				id2all.mem_to_reg     = 1'b0;                 // write the result to RF
				id2all.rf_wr          = 1'b1;                 // enable write to RF
				id2all.rf_wr_addr     = compr_unit_instr[`RNG_RD];  // reg to write the result
				id2all.rf_wr_data     = 0;                    // unknown yet
				id2all.is_valid       = 1'b1;                 // assume that the instruction is valid
				id2all.en_sign_ext    = 1'b0;
				id2all.alu_op         = `DO_AUIPC;
			end
			
			`JAL: begin

				o_check_regs 		= `NONE;
				
				id2all.format		= `JU_FORM;
				id2all.alu_en		= 1'b1;
				id2all.alu_src		= 1'b1;
				id2all.pc		= o_pc;
				id2all.is_branch	= 1'b1;			// but unconditional 
				id2all.mem_rd		= 1'b0;
				id2all.mem_wr		= 1'b0;
				id2all.mem_to_reg	= 1'b0;
				id2all.rf_wr		= 1'b1;
				id2all.rf_wr_addr	= compr_unit_instr[`RNG_RD];
				id2all.rf_wr_data	= 0;			// unknown yet
				id2all.is_valid		= 1'b1;
				id2all.en_sign_ext	= 1'b0;
				id2all.alu_op		= `DO_ADD;		// pc+4 or +2 TODO : dependent signal for comprs'd. The calc. of jump to br unit. Update: DONE with is_compr signal above
			end
			
			`JALR: begin
				if( compr_unit_instr[`RNG_F3] != `F3_JALR ) begin
					id2all.is_valid = 1'b0;
				end
				else begin 
					
					o_check_regs		= `RS1;	
				
					id2all.format		= `I_FORM;
					id2all.alu_en		= 1'b1;
					id2all.alu_src		= 1'b1;
					id2all.pc		= o_pc;
					id2all.is_branch	= 1'b1;		// but unconditional
					id2all.mem_rd		= 1'b0;
					id2all.mem_wr		= 1'b0;
					id2all.rf_wr		= 1'b1;
					id2all.rf_wr_addr	= compr_unit_instr[`RNG_RD];
					id2all.rf_wr_data	= 0;		// unknown yet
					id2all.is_valid		= 1'b1;
					id2all.en_sign_ext	= 1'b0;
					id2all.alu_op		= `DO_ADD;	// pc+4 or +2 TODO : dependent signal for comprs'd. The calc. of jump to br unit. Update: DONE with is_compr signal above
				end
			end
			
			`BRANCH: begin
				
				o_check_regs		= `RS1_RS2;			
			
				id2all.format		= `BS_FORM;
				id2all.alu_en		= 1'b1;
				id2all.alu_src		= 1'b0;
				id2all.pc		= o_pc;
				id2all.is_branch	= 1'b1;
				id2all.mem_rd		= 1'b0;
				id2all.mem_wr		= 1'b0;
				id2all.rf_wr		= 1'b0;
				id2all.rf_wr_addr	= 0;
				id2all.rf_wr_data	= 0;
				id2all.is_valid		= 1'b1;
				id2all.en_sign_ext	= 1'b0;

				unique case(compr_unit_instr[`RNG_F3])

					`F3_BEQ: begin
						id2all.alu_op	= `DO_SUB;
						id2all.branch_type = `BEQ;
					end

					`F3_BNE: begin
						id2all.alu_op = `DO_SUB;
						id2all.branch_type = `BNE;
					end

					`F3_BLTU: begin
						id2all.alu_op = `DO_SUB;
						id2all.branch_type = `BLTU;
					end

					`F3_BGEU: begin
						id2all.alu_op = `DO_SUB;
						id2all.branch_type = `BGEU;
					end

					`F3_BGE: begin
						id2all.alu_op = `DO_BGE;
					end

					`F3_BLT: begin
						id2all.alu_op = `DO_BLT;
					end	

					default: id2all.is_valid = 1'b0;
				endcase
			end
			
			`IMM: begin
				
				o_check_regs		= `RS1;
				
				id2all.format		= `I_FORM;
				id2all.alu_en		= 1'b1;
				id2all.alu_src		= 1'b1;
				id2all.pc		= o_pc;
				id2all.is_branch	= 1'b0;
				id2all.mem_rd		= 1'b0;
				id2all.mem_wr		= 1'b0;
				id2all.mem_to_reg	= 1'b0;
				id2all.rf_wr		= 1'b1;
				id2all.rf_wr_addr	= compr_unit_instr[`RNG_RD];
				id2all.rf_wr_data	= 1'b0;			// unknown yet
				id2all.is_valid	= 1'b1;
				id2all.en_sign_ext		= 1'b0;

				unique case(compr_unit_instr[`RNG_F3])

					`F3_ADDI: begin
						id2all.alu_op = `DO_ADD;
					end

					`F3_SLTI: begin
						id2all.alu_op = `DO_SLT;
					end

					`F3_SLTIU: begin
						id2all.alu_op = `DO_SLTU;
					end

					`F3_XORI: begin
						id2all.alu_op = `DO_XOR;
					end

					`F3_ORI: begin
						id2all.alu_op = `DO_OR;
					end

					`F3_ANDI: begin
						id2all.alu_op = `DO_AND;
					end

					`F3_SLLI: begin
						id2all.alu_op = `DO_SLL;
					end

					`F3_SR: begin
						unique case(compr_unit_instr[`RNG_F7])
							`F7_SRLI: begin
								id2all.alu_op = `DO_SRL;
							end

							`F7_SRAI: begin 
								
								//id2all.en_sign_ext = 1'b1;
								id2all.alu_op = `DO_SRA;
							end

							default: id2all.is_valid = 1'b0;
						endcase
					end
					
					default: id2all.is_valid = 1'b0;
				endcase
			end

			`ALU: begin
				
				o_check_regs		= `RS1_RS2;
			
				id2all.format 		= `R_FORM;		
				id2all.alu_en		= 1'b1;
				id2all.alu_src		= 1'b0;			// the second arg of ALU is not immidiate
				id2all.pc		= o_pc;
				id2all.is_branch	= 1'b0;			// not branch
				id2all.mem_rd		= 1'b0;			// not load from mem
				id2all.mem_wr		= 1'b0;			// not store to mem
				id2all.mem_to_reg	= 1'b0;			// write the result to RF
				id2all.rf_wr		= 1'b1;			// enable write to RF
				id2all.rf_wr_addr	= compr_unit_instr[`RNG_RD];	// reg to write the result
				id2all.rf_wr_data	= 1'b0;			// unknown yet
				id2all.is_valid		= 1'b1;			// assume that the instruction is valid
				id2all.en_sign_ext	= 1'b0;	

				unique case(compr_unit_instr[`RNG_F3])

					`F3_ADD_SUB: begin
						unique case(compr_unit_instr[`RNG_F7])

							`F7_ADD: begin
									id2all.alu_op = `DO_ADD;
							end

							`F7_SUB: begin
									id2all.alu_op = `DO_SUB;
							end

							default: id2all.is_valid = 1'b0;        // invalid instruction

						endcase
					end

					`F3_SLL: begin
						if(compr_unit_instr[`RNG_F7] != `F7_SLL) begin
							id2all.is_valid = 1'b0;       		// invalid instruction
						end
						else begin
							id2all.alu_op = `DO_SLL;
						end
					end

					`F3_SLT: begin
						if(compr_unit_instr[`RNG_F7] != `F7_SLT) begin
							id2all.is_valid = 1'b0;       		// invalid instruction
						end
						else begin
							id2all.alu_op = `DO_SLT;
						end
					end

					`F3_SLTU: begin
						if(compr_unit_instr[`RNG_F7] != `F7_SLTU) begin
							id2all.is_valid = 1'b0;       		// invalid instruction
						end
						else begin
							id2all.alu_op = `DO_SLTU;
						end
					end

					`F3_XOR: begin
						if(compr_unit_instr[`RNG_F7] != `F7_XOR) begin
							id2all.is_valid = 1'b0;       		// invalid instruction
						end
						else begin
							id2all.alu_op = `DO_XOR;
						end
					end

					`F3_SRL_SRA: begin
						unique case(compr_unit_instr[31:30])
							2'b00: begin
								if(compr_unit_instr[29:25] != 5'b00000) begin
									id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									id2all.alu_op = `DO_SRL;
								end
							end
 
							2'b01: begin
								if(compr_unit_instr[29:25] != 5'b00000) begin
									id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									id2all.alu_op = `DO_SRA;
								end
							end

							default: id2all.is_valid = 1'b0;       // invalid instruction

                                                endcase
					end

					`F3_OR: begin
						if(compr_unit_instr[`RNG_F7] != `F7_OR) begin
							id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							id2all.alu_op = `DO_OR;
						end
					end

					`F3_AND: begin
						if(compr_unit_instr[`RNG_F7] != `F7_AND) begin
							id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							id2all.alu_op = `DO_AND;
						end
					end
					default: id2all.is_valid = 1'b0;       // invalid instruction
				endcase

			end

			`LWU_LD_64: begin
				
				o_check_regs		= `RS1;
				
				id2all.format		= `I_FORM;
				id2all.alu_en		= 1'b1;
				id2all.alu_src		= 1'b1;
				id2all.pc		= o_pc;
				id2all.is_branch	= 1'b0;
				id2all.mem_rd		= 1'b1;
				id2all.mem_wr		= 1'b0;
				id2all.mem_to_reg	= 1'b1;
				id2all.rf_wr		= 1'b1;
				id2all.rf_wr_addr	= compr_unit_instr[`RNG_RD];
				id2all.rf_wr_data	= 0;
				id2all.is_valid		= 1'b1;
				id2all.en_sign_ext	= 1'b0;
				id2all.alu_op		= `DO_ADD;

				unique case(compr_unit_instr[`RNG_F3])

                                        `F3_LB: begin
                                                id2all.mem_req_unit = `B;
                                                id2all.mem_ext = `SIGNED;
                                        end

                                        `F3_LH: begin
                                                id2all.mem_req_unit = `HW;
                                                id2all.mem_ext = `SIGNED;
                                        end

                                        `F3_LW: begin
                                                id2all.mem_req_unit = `W;
                                                id2all.mem_ext = `SIGNED;
                                        end

                                        `F3_LBU: begin
                                                id2all.mem_req_unit = `B;
                                                id2all.mem_ext = `UNSIGNED;
                                        end

                                        `F3_LHU: begin
                                                id2all.mem_req_unit = `HW;
                                                id2all.mem_ext = `UNSIGNED;
                                        end

					`F3_LWU_64: begin
						id2all.mem_req_unit = `W;
						id2all.mem_ext = `UNSIGNED;						
						id2all.en_sign_ext = 1'b1;
					end

					`F3_LD_64: begin
						id2all.mem_req_unit = `DW;
						id2all.mem_ext = `SIGNED;
						id2all.en_sign_ext = 1'b0;
					end

					default: id2all.is_valid = 1'b0;
				endcase
			end

			`SD_64:	begin

					o_check_regs		= `RS1_RS2;

					id2all.format		= `BS_FORM;
					id2all.alu_en		= 1'b1;
					id2all.alu_src		= 1'b1;
					id2all.pc		= o_pc;
					id2all.is_branch	= 1'b0;
					id2all.mem_rd		= 1'b0;
					id2all.mem_to_reg	= 1'b0;
					id2all.mem_wr		= 1'b1;
					id2all.rf_wr		= 1'b0;
					id2all.rf_wr_addr	= 0;
					id2all.rf_wr_data	= 0;
					id2all.is_valid		= 1'b1;
					id2all.en_sign_ext	= 1'b0;
					id2all.alu_op		= `DO_ADD;
					id2all.mem_ext		= `SIGNED;	

					unique case(compr_unit_instr[`RNG_F3])

                                        	`F3_SB: begin
                                                	id2all.mem_req_unit = `B;
                                        	end

                                        	`F3_SW: begin
                                                	id2all.mem_req_unit = `W;
                                        	end

                                        	`F3_SH: begin
                                                	id2all.mem_req_unit = `HW;
                                       		end
					
						`F3_SD: begin
							id2all.mem_req_unit = `DW;
						end

						default: id2all.is_valid = 1'b0;
					endcase
			end

			`ADDIW_SLLIW_SRLIW_SRAIW_64: begin				

				o_check_regs		= `RS1;

				id2all.format		= `I_FORM;
				id2all.alu_en		= 1'b1;
				id2all.alu_src		= 1'b1;
				id2all.pc		= o_pc;
				id2all.is_branch	= 1'b0;
				id2all.mem_rd		= 1'b0;
				id2all.mem_wr		= 1'b0;
				id2all.rf_wr		= 1'b1;
				id2all.rf_wr_addr	= compr_unit_instr[`RNG_RD];
				id2all.rf_wr_data	= 0;
				id2all.is_valid		= 1'b1;
				id2all.en_sign_ext	= 1'b1;

				unique case(compr_unit_instr[`RNG_F3])

					`F3_ADDIW_64: begin

						id2all.alu_op = `DO_ADD;
					end

					`F3_SLLIW_64: begin

						if(compr_unit_instr[`RNG_F7]) begin

							id2all.is_valid = 1'b0;
						end
						else begin

							id2all.alu_op = `DO_SLL;
						end
					end

					`F3_SRLIW_SRAIW_64: begin

						unique case(compr_unit_instr[`RNG_F7])

							`F7_SRLIW_64: begin

								id2all.alu_op	= `DO_SRL;
							end

							`F7_SRAIW_64: begin

								id2all.alu_op = `DO_SRA;

							end

							default: id2all.is_valid = 1'b0;

						endcase
					end


					default: id2all.is_valid = 1'b0;
				endcase
			end

			`ALU_64: begin
				
				o_check_regs	      = `RS1_RS2;
			
				id2all.format         = `R_FORM;	
				id2all.alu_en         = 1'b1;
                                id2all.alu_src        = 1'b0;                 // the second arg of ALU is not immidiate
                                id2all.pc             = o_pc;
                                id2all.is_branch      = 1'b0;                 // not branch
                                id2all.mem_rd         = 1'b0;                 // not load from mem
                                id2all.mem_wr         = 1'b0;                 // not store to mem
                                id2all.mem_to_reg     = 1'b0;                 // write the result to RF
                                id2all.rf_wr          = 1'b1;                 // enable write to RF
                                id2all.rf_wr_addr     = compr_unit_instr[`RNG_RD];  // reg to write the result
                                id2all.rf_wr_data     = 0;                    // unknown yet
				id2all.is_valid       = 1'b1;
				id2all.en_sign_ext    = 1'b1;			

				unique case(compr_unit_instr[`RNG_F3])
				
					`F3_ADDW_SUBW_64: begin	
						unique case(compr_unit_instr[31:30])
						
							2'b00: begin
								if(compr_unit_instr[29:25] != 5'b00000) begin
									id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									id2all.alu_op = `DO_ADD;
								end
							end
		
							2'b01: begin
								if(compr_unit_instr[29:25] != 5'b00000) begin
									id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									id2all.alu_op = `DO_SUB;
								end
							end
							
							default: id2all.is_valid = 1'b0;       // invalid instruction

						endcase
					end
		
					`F3_SLLW_64: begin
						if(compr_unit_instr[`RNG_F7] != `F7_SLLW_64) begin
							id2all.is_valid = 1'b0;       // invalid instruction
						end
						else begin
							id2all.alu_op = `DO_SLL;
						end
					end
					
					`F3_SRLW_SRAW_64: begin
						unique case(compr_unit_instr[31:30])
						
							2'b00: begin
								if(compr_unit_instr[29:25] != 5'b00000) begin
									id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									id2all.alu_op = `DO_SRL;
								end
							end
						
							2'b01: begin
								if(compr_unit_instr[29:25] != 5'b00000) begin
									id2all.is_valid = 1'b0;       // invalid instruction
								end
								else begin
									id2all.alu_op = `DO_SRA;
								end
							end
						
							default: id2all.is_valid = 1'b0;       // invalid instruction

						endcase
					end					
					
					default: id2all.is_valid = 1'b0;       // invalid instruction
				endcase
			end	
			
			default: begin
					id2all.is_valid = 1'b0;       // invalid instruction
					o_check_regs = `NONE;
				end
		endcase
	
		end			
	end

	assign o_rs1 = compr_unit_instr[`RNG_RS1];
	assign o_rs2 = compr_unit_instr[`RNG_RS2];
	assign o_id_ready = i_ex_ready; // stall control
	
	always_ff @(posedge clk, negedge rst_n) begin
		if( ~rst_n ) begin
			o_id2all <= 0;
		end
		else begin
			o_id2all <= id2all;
		end	
	end
endmodule
