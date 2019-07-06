`timescale 1ns/1ns

module compr_fsm_tb();

logic [31:0] i_instr;
logic [31:0] o_instr;
logic clk = 0;
logic rst_n = 1;
logic incr_pc;


//16bit instructions
parameter C0_SD                 = 16'b111_010_001_01_011_00 ;
parameter C1_SUB                = 16'b100_0_11_100_00_101_01;
parameter C2_JALR               = 16'b100_1_01001_00000_10;

//32bit instructions
parameter FULL_32_1              = 32'hFFFF_FFFF ;   // 32bit instr
parameter FULL_32_2              = 32'h0000_0003 ;   // 32bit instr
parameter FULL_32_3              = 32'hCAFE_BEEF ;   // 32bit instr
parameter FULL_32_4              = 32'hB16B_00B7 ;   // 32bit instr
parameter FULL_32_5              = 32'hBABA_EEFF ;   // 32bit instr





always #10 begin
	clk=~clk;
end

compr_fsm fsm(clk, rst_n, i_instr, o_instr, incr_pc);

initial begin
	rst_n=0;
	i_instr=32'h0000_C11F;
	@(posedge clk);	
	$display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
	
	rst_n=1;
	i_instr=32'd3;
	@(posedge clk);
	$display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
	i_instr=32'hFFFF_FFFF;
	@(posedge clk);
        $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
	i_instr=32'd15;
        @(posedge clk);
        $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
	
	i_instr={16'hBEAF,C0_SD} ;
	@(posedge clk);
        $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
        i_instr={16'hBEEF, 16'hCAFE} ;
	@(posedge clk);
        $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
        i_instr={16'hEEFF, 16'hCAFE} ;
	@(posedge clk);
        $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);

        i_instr={C1_SUB , 16'hBABA} ;
 	@(posedge clk);
    	$display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
	if (!incr_pc) begin
                @(posedge clk);
                $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
        end


	i_instr=FULL_32_4 ;
        @(posedge clk);
        $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);

	i_instr=FULL_32_2 ;
        @(posedge clk);
        $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);

	i_instr={C1_SUB , C2_JALR } ;
        @(posedge clk);
        $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
	if (!incr_pc) begin
		@(posedge clk);
		$display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);
	end

	i_instr=FULL_32_1 ;
        @(posedge clk);
        $display("Input instruction:\t%8h\tOutput instruction:\t%8h\tIncrement PC?\t%1b\n",i_instr,o_instr, incr_pc);

	$finish;
	 
end


endmodule


