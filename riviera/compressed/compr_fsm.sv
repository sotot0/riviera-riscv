`timescale 1ns/1ns

module compr_fsm (
	input logic clk,
	input logic rst_n,
	input logic [31:0] i_instr,
	output logic [31:0] o_instr,
	output logic incr_pc
);

parameter Normal_State = 2'b00;
parameter Unalligned_State = 2'b01;
parameter SecondCompr_State = 2'b10;


logic [1:0] state, next_state;
logic [15:0] temp_16bit_instr_buffer;
logic is_compr, is_2nd_compr;
logic [15:0] io_16bit_instr_buffer;



always_comb begin
	
    is_compr = 0;
    is_2nd_compr = 0;
    temp_16bit_instr_buffer = 16'b0;
    incr_pc = 1'b1 ;
    if (state == Normal_State) begin
	is_compr = !(i_instr[1:0]==2'b11);
	is_2nd_compr = !(i_instr[17:16]==2'b11);
	if (!is_compr) begin
	    next_state = Normal_State;
	    o_instr = i_instr;
	    temp_16bit_instr_buffer = 16'b0 ;
	    incr_pc = 1'b1 ;
	end
        else if (is_compr && !is_2nd_compr) begin
	    next_state = Unalligned_State;
	    o_instr = {16'b0, i_instr[15:0]};
	    temp_16bit_instr_buffer = i_instr[31:16];
	    incr_pc = 1'b1 ;
	end
	else if (is_compr && is_2nd_compr) begin
	    next_state = SecondCompr_State;
	    o_instr = {16'b0, i_instr[15:0]};
	    temp_16bit_instr_buffer = 16'b0;
	    incr_pc = 1'b0 ;
	end
    end 
    else if (state == Unalligned_State ) begin
	is_2nd_compr = !(i_instr[17:16]==2'b11);
	o_instr = {i_instr[15:0], io_16bit_instr_buffer};
	if (!is_2nd_compr) begin
            next_state = Unalligned_State;
	    temp_16bit_instr_buffer = i_instr[31:16];
	    incr_pc = 1'b1 ;
        end
	else begin
	    next_state = SecondCompr_State;
	    temp_16bit_instr_buffer = 16'b0;
	    incr_pc = 1'b0 ;
	end

    end
    else if (state == SecondCompr_State ) begin
	next_state = Normal_State;
	temp_16bit_instr_buffer = 16'b0;
	o_instr = {16'b0 , i_instr[31:16]};
	incr_pc = 1'b1 ;
    end
     

	 
end


always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state <= Normal_State;
	io_16bit_instr_buffer <= 16'b0;
    end
    else begin
        state <= next_state;
	io_16bit_instr_buffer <= temp_16bit_instr_buffer;
    end
end      	  
	

endmodule


