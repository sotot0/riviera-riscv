`include "interconnection_struct.sv"

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
	
	
	output id2all_struct		o_id2all
 
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
		.i_raddr_a	(i_if_instr[RNG_RS1]),
		.i_raddr_b	(i_if_instr[RNG_RS2]),
		.i_wen		(i_wb_wr_reg_en),
		.i_waddr	(i_wb_wr_reg_addr),
		.i_wdata	(i_wb_wr_reg_data),
		.o_rdata_a	(o_id_reg_data_a),
		.o_rdata_b	(o_id_reg_data_b)	
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

			`ALU: 				begin
				o_id_aluSrc = 1'b0; 			// for all ALU operations pick both regs

			
			end

			`LWU_LD_64: 			begin

			end

			`SD_64:				begin
			
			end

			`ADDIW_SLLIW_SRLIW_SRAIW_64: 	begin

			end

			`ALU_64:			begin
			
			end

		endcase	

	end

endmodule
