module compr_instr_unit (

  input logic [31:0] i_instr, 
  output logic [31:0] o_instr,
  output logic o_is_compr,
  output logic o_ill_instr 
                     
);


parameter OpImm     = 7'b00_100_11;
parameter Load      = 7'b00_000_11;
parameter Store	    = 7'b01_000_11;
parameter OpImm32   = 7'b00_110_11;
parameter Lui       = 7'b01_101_11;
parameter Op        = 7'b01_100_11;
parameter Op32      = 7'b01_110_11;
parameter Jal       = 7'b11_011_11;
parameter Jalr      = 7'b11_001_11;
parameter Branch    = 7'b11_000_11;

// Quadrant 0
parameter c0             = 2'b00;
parameter c0Addi4spn     = 3'b000;
parameter c0Lw           = 3'b010;
parameter c0Ld           = 3'b011;
parameter c0Sw           = 3'b110;
parameter c0Sd           = 3'b111;

// Quadrant 1
parameter c1             = 2'b01;
parameter c1Addi         = 3'b000;
parameter c1Addiw        = 3'b001;
parameter c1Li           = 3'b010;
parameter c1LuiAddi16sp  = 3'b011;
parameter c1MiscAlu      = 3'b100;
parameter c1J            = 3'b101;
parameter c1Beqz         = 3'b110;
parameter c1Bnez         = 3'b111;

// Quadrant 2
parameter c2             = 2'b10;
parameter c2Slli         = 3'b000;
parameter c2Lwsp         = 3'b010;
parameter c2Ldsp         = 3'b011;
parameter c2JalrMvAdd    = 3'b100;
parameter c2Swsp         = 3'b110;
parameter c2Sdsp         = 3'b111;


always_comb begin
  o_ill_instr = 1'b0;
  o_is_compr= 1'b1;
  unique case(i_instr[1:0])

    //c0
    c0: begin
           unique case (i_instr[15:13])
               
               c0Addi4spn: begin
                 //addi rd ′, x2, nzuimm[9:2]
                 o_instr = {2'b0,i_instr[10:7],i_instr[12:11],i_instr[5],i_instr[6],2'b00, 5'h02, 3'b000, 2'b01, i_instr[4:2], OpImm }; 
                 if (i_instr[12:5] == 8'b0) begin
                   o_ill_instr = 1'b1;
                 end
               end
               
               c0Lw: begin
                 //lw rd ′, offset[6:2](rs1 ′).
                 o_instr = {5'b0,i_instr[5], i_instr[12:10], i_instr[6], 2'b00, 2'b01 , i_instr[9:7], 3'b010, 2'b01, i_instr[4:2] ,Load};
               end  
               
               c0Ld: begin
                 //ld rd ′, offset[7:3](rs1 ′)
                 o_instr = {4'b0,i_instr[6:5], i_instr[12:10],3'b000, 2'b01 , i_instr[9:7], 3'b011, 2'b01, i_instr[4:2] ,Load};
               end
               
               c0Sw: begin
                 //sw rs2 ′, offset[6:2](rs1 ′)
                 o_instr = {5'b0, i_instr[5],i_instr[12],2'b01, i_instr[4:2], 2'b01, i_instr[9:7], 3'b010,i_instr[11:10],i_instr[6],2'b00, Store};
               end
               
               c0Sd: begin
                 //sd rs2 ′, offset[7:3](rs1 ′)
                 o_instr = {4'b0, i_instr[6:5],i_instr[12],2'b01, i_instr[4:2], 2'b01, i_instr[9:7], 3'b011,i_instr[11:10],3'b000, Store};
               end
               default: begin
                 o_ill_instr = 1'b1;
               end
           endcase
    end


    //c1
    c1: begin
           unique case (i_instr[15:13])
           
               c1Addi: begin
                 //addi rd, rd, nzimm[5:0]
                 //nop addi 0,0,0 
                 o_instr = {{6 {i_instr[12]}} , i_instr[12], i_instr[6:2], i_instr[11:7], 3'b000 ,i_instr[11:7],OpImm};
                 if ( (i_instr[11:7]==5'b0) && ({i_instr[12],i_instr[6:2]}!=6'b0) ) begin
                   o_ill_instr = 1'b1;
                 end
                 if  ( (i_instr[11:7]!=5'b0) && ({i_instr[12],i_instr[6:2]}==6'b0) ) begin
                   o_ill_instr = 1'b1;
                 end                
               end
               
               c1Addiw: begin
                 //addiw rd, rd, nzimm[5:0]
                 o_instr =  {{6 {i_instr[12]}} , i_instr[12], i_instr[6:2], i_instr[11:7], 3'b000 ,i_instr[11:7],OpImm32};
                 if (i_instr[11:7]==5'b0) begin
                   o_ill_instr = 1'b1;
                 end
               end

               c1Li: begin
                 //addi rd, x0, imm[5:0]
                 o_instr = { {6 {i_instr[12]}}  , i_instr[12], i_instr[6:2], 5'b0,  3'b000 , i_instr[11:7],OpImm};
                 if (i_instr[11:7]==5'b0) begin
                   o_ill_instr = 1'b1;
                 end
               end

               c1LuiAddi16sp: begin
                 if (i_instr[11:7]==5'h02) begin
                   //addi x2, x2,nzimm[9:4]
                   o_instr = { {2 {i_instr[12]}}  , i_instr[12], i_instr[4:3] , i_instr[5],  i_instr[2],i_instr[6], 4'b0000,  5'h02,  3'b000 , 5'h02 ,OpImm};
                 end
                 else begin
                   //lui rd, nzimm[17:12]
                   o_instr = { {14 {i_instr[12]}}  , i_instr[12], i_instr[6:2] , i_instr[11:7]  ,Lui };
                 end
                 if ( (i_instr[11:7]==5'b0) || ({i_instr[12],i_instr[6:2]}==6'b0) ) begin
                   o_ill_instr = 1'b1;  
                 end
               end


               c1MiscAlu: begin
                 unique case (i_instr[11:10])
                  
                   2'b00,2'b01: begin
                     //srli rd ′,rd ′, shamt[5:0]
                     //srai rd ′, rd ′, shamt[5:0]
                     o_instr = { 1'b0, i_instr[10]  ,4'b0,  i_instr[12], i_instr[6:2] , 2'b01, i_instr[9:7], 3'b101, 2'b01, i_instr[9:7]  ,OpImm };
                   end   


                   2'b10: begin
                     //andi rd ′,rd ′, imm[5:0]
                     o_instr = {  {6 {i_instr[12]}}  , i_instr[12]  , i_instr[6:2] , 2'b01, i_instr[9:7], 3'b111, 2'b01, i_instr[9:7]  ,OpImm }; 
                   end
 
                   2'b11: begin 
                     unique case ({i_instr[12], i_instr[6:5]})

                       3'b000: begin
                         //sub rd ′, rd ′, rs2 ′
                         o_instr = {  7'b0100000,  2'b01, i_instr[4:2], 2'b01, i_instr[9:7], 3'b000, 2'b01, i_instr[9:7]  ,Op };      
                       end

                       3'b001: begin
                         //xor rd ′, rd ′, rs2 ′
                         o_instr = {  7'b0000000,  2'b01, i_instr[4:2], 2'b01, i_instr[9:7], 3'b100, 2'b01, i_instr[9:7]  ,Op };
                       end

                       3'b010: begin
                         //or rd ′, rd ′, rs2 ′
                         o_instr = {  7'b0000000,  2'b01, i_instr[4:2], 2'b01, i_instr[9:7], 3'b110, 2'b01, i_instr[9:7]  ,Op };
                       end

                       3'b011: begin
                         //and rd ′, rd ′, rs2 ′
                         o_instr = {  7'b0000000,  2'b01, i_instr[4:2], 2'b01, i_instr[9:7], 3'b111, 2'b01, i_instr[9:7]  ,Op };
                       end
                      
                       3'b100: begin
                         //subw rd ′, rd ′, rs2 ′
                         o_instr = {  7'b0100000,  2'b01, i_instr[4:2], 2'b01, i_instr[9:7], 3'b000, 2'b01, i_instr[9:7]  ,Op32 };
                       end

                       3'b101: begin
                         //addw rd ′, rd ′, rs2 ′
                         o_instr = {  7'b0000000,  2'b01, i_instr[4:2], 2'b01, i_instr[9:7], 3'b000, 2'b01, i_instr[9:7]  ,Op32 };
                       end

                       3'b110, 3'b111: begin
                         o_ill_instr = 1'b1;
                       end
                     endcase
                   end
                 endcase 
               end


               c1J: begin
                 //jal x0, offset[11:1]
                 o_instr = {i_instr[12], i_instr[8], i_instr[10:9], i_instr[6], i_instr[7], i_instr[2],i_instr[11], i_instr[5:3], i_instr[12], {8 {i_instr[12]}}, 5'b0, Jal  };
               end
               c1Beqz, c1Bnez: begin
                 //beq rs1 ′, x0, offset[8:1]
                 //bne rs1 ′, x0, offset[8:1]
                 o_instr = {{4 {i_instr[12]}}, i_instr[6:5], i_instr[2], 5'b0,  2'b01, i_instr[9:7], 2'b00, i_instr[13], i_instr[11:10], i_instr[4:3],i_instr[12], Branch };
               end


           endcase

    end
    
    //c2
    c2: begin
           unique case (i_instr[15:13])

               c2Slli: begin
                 //slli rd, rd, shamt[5:0]
                 o_instr = {6'b0,i_instr[12] ,i_instr[6:2],i_instr[11:7] ,3'b001, i_instr[11:7] ,OpImm};
                 
                 if ( (i_instr[11:7]==5'b0) || ({i_instr[12],i_instr[6:2]}==6'b0) ) begin
                   o_ill_instr = 1'b1;
                 end
               end

               c2Lwsp: begin
                 //lw rd, offset[7:2](x2)
                 o_instr = {4'b0 , i_instr[3:2] , i_instr[12] , i_instr[6:4], 2'b00, 5'h02, 3'b010 ,i_instr[11:7], Load};
                 if  (i_instr[11:7]==5'b0)  begin
                   o_ill_instr = 1'b1;
                 end

               end

               c2Ldsp: begin
                 //ld rd, offset[8:3](x2)
                 o_instr = {3'b0 , i_instr[4:2] , i_instr[12] , i_instr[6:5], 3'b0, 5'h02 , 3'b011 ,i_instr[11:7], Load};
                 if  (i_instr[11:7]==5'b0)  begin
                   o_ill_instr = 1'b1;
                 end  
               end

               c2JalrMvAdd: begin
                 unique case (i_instr[12])
                   1'b0: begin
                     if(i_instr[6:2]==5'b0) begin
                       //jalr x0, 0(rs1)
                       o_instr = {12'b0, i_instr[11:7],3'b000, 5'b0, Jalr};
                       if  (i_instr[11:7]==5'b0)  begin
                         o_ill_instr = 1'b1;
                       end
                     end
                     else begin
                       //add rd, x0, rs2 (mv)
                       o_instr = {7'b0, i_instr[6:2], 5'b0, 3'b000, i_instr[11:7], Op};
                       if  (i_instr[11:7]==5'b0)  begin
                         o_ill_instr = 1'b1;
                       end
                     end                  
                   end
                   
                   1'b1: begin
                     if(i_instr[6:2]==5'b0) begin
                       //jalr x1, 0(rs1)
                       o_instr = {12'b0, i_instr[11:7],3'b000, 5'h01, Jalr};
                       if  (i_instr[11:7]==5'b0)  begin
                         o_ill_instr = 1'b1;
                       end
                     end
                     
                     else begin
                       //add rd, rd, rs2
                       o_instr = {7'b0, i_instr[6:2], i_instr[11:7], 3'b000, i_instr[11:7], Op};
                       if  (i_instr[11:7]==5'b0)  begin
                          o_ill_instr = 1'b1;
                       end
                     end
                      
                   end
                 endcase

               end

               c2Swsp: begin
                 //sw rs2, offset[7:2](x2)
                 o_instr = {4'b0, i_instr[8:7],i_instr[12], i_instr[6:2] ,5'h02, 3'b010, i_instr[11:9], 2'b00  ,Store};
               end

               c2Sdsp: begin
                 //sd rs2, offset[8:3](x2)
                 o_instr = {3'b0, i_instr[9:7],i_instr[12], i_instr[6:2] ,5'h02, 3'b011, i_instr[11:10], 2'b00  ,Store};
               end

               default: begin
                 o_ill_instr = 1'b1;
               end

           endcase

    end    
    
    //not compressed instrtruction
    default: begin
               o_instr = i_instr;
               o_is_compr = 1'b0;
    end

  endcase

end
endmodule
