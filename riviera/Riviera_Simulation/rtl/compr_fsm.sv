`timescale 1ns/1ns

module compr_fsm (
	input logic clk,
	input logic rst_n,
	
	// from IF
	input logic [31:0] i_instr,
	input logic [63:0] i_if_pc,

	// from EX
	// used for branches and stalls
	input logic i_jumb_taken,		
	input logic i_branch_taken,
	input logic [63:0] i_jumb_target,
        input logic [63:0] i_branch_target,
	input logic i_ex_ready,

	// to compr_instr_unit
	output logic [31:0] o_instr,

	// to IF
	output logic incr_pc,

	// to EX
	output logic [63:0] o_pc
);

parameter 	Normal_State 		= 2'b00;
parameter 	Unalligned_State	= 2'b01;
parameter 	SecondCompr_State 	= 2'b10;
parameter 	Jumb2HalfAddr_State	= 2'b11;

logic [1:0] 	state, next_state;
logic [15:0] 	temp_16bit_instr_buffer;
logic 		is_compr, is_2nd_compr;
logic [15:0] 	io_16bit_instr_buffer;



always_comb begin
	
    is_compr = 0;
    is_2nd_compr = 0;
    temp_16bit_instr_buffer = 16'b0;
    incr_pc = 1'b1 ;
    o_pc = i_if_pc ;
    
    if((!i_branch_taken) && (!i_jumb_taken)) begin 
	// Alligned Instructions   
        if (state == Normal_State) begin
	    is_compr = !(i_instr[1:0]==2'b11);
	    is_2nd_compr = !(i_instr[17:16]==2'b11);
	    o_pc = i_if_pc ;	
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
	// Broken Allignment
        else if (state == Unalligned_State ) begin
	    o_pc = i_if_pc - 2;
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
	// Half left 16bits are a compressed instruction
        else if (state == SecondCompr_State ) begin
	    next_state = Normal_State;
	    temp_16bit_instr_buffer = 16'b0;
	    o_instr = {16'b0 , i_instr[31:16]};
	    incr_pc = 1'b1 ;
	    o_pc =i_if_pc + 2;
        end
	// Jumb in the middle of an instruction line
	// 1)
	// check if not compresed
	// then move to 16bit buff, feed a c.nop instr
	// and go to unalligned state
	// 2)
	// else build instr and go to normal state
	else if (state == Jumb2HalfAddr_State ) begin
	    
	    is_2nd_compr = !(i_instr[17:16]==2'b11);
	    if (!is_2nd_compr) begin
	    	next_state = Unalligned_State;
                temp_16bit_instr_buffer = i_instr[31:16];
		o_instr = {31'b0, 1'b1};			// c.nop ;D
		incr_pc = 1'b1 ;
		o_pc =i_if_pc ;
	    end
	    else begin
            	next_state = Normal_State;
            	temp_16bit_instr_buffer = 16'b0;
            	o_instr = {16'b0 , i_instr[31:16]};
            	incr_pc = 1'b1 ;
		o_pc =i_if_pc + 2;
	    end
        end
   end

   // in these cases we stay IDLE, the instruction fetched is marked as
   // invalid
   else if(i_branch_taken) begin
	o_instr = {31'b0, 1'b1};                        // c.nop ;D	
	if(!i_branch_target[1]) begin //mul of 4 
		next_state = Normal_State ;
		temp_16bit_instr_buffer = 16'b0;
            	incr_pc = 1'b0 ;
		o_pc =i_if_pc ;	
		
	end
	else begin
		next_state = Jumb2HalfAddr_State;
                temp_16bit_instr_buffer = 16'b0;
                incr_pc = 1'b0 ;
		o_pc =i_if_pc;
	end   

    end
    else if (i_jumb_taken) begin
	o_instr = {31'b0, 1'b1};                        // c.nop ;D
	if(!i_jumb_target[1]) begin //mul of 4
                next_state = Normal_State ;
                temp_16bit_instr_buffer = 16'b0;
                incr_pc = 1'b0 ;
		o_pc =i_if_pc ;
        end
        else begin
                next_state = Jumb2HalfAddr_State;
                temp_16bit_instr_buffer = 16'b0;
                incr_pc = 1'b0 ;
		o_pc =i_if_pc ;
        end

    end



	 
end


always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n ) begin
        state <= Normal_State;
	io_16bit_instr_buffer <= 16'b0;
    end
    else if (!i_ex_ready) begin
        state <= state;
	io_16bit_instr_buffer <= io_16bit_instr_buffer;
    end
    else begin 	
	state <= next_state;
        io_16bit_instr_buffer <= temp_16bit_instr_buffer;
    end 
end      	  
	

endmodule


