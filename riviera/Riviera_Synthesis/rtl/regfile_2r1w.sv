`timescale 1ns/100fs

module regfile_2r1w #(
  parameter DLEN          = 32,
  parameter ALEN          = 5
) (
  input  wire                   clk,

  // Data Access Interface
  input  logic [ALEN-1:0]       i_raddr_a,
  input  logic [ALEN-1:0]       i_raddr_b,

  input  logic                  i_wen,
  input  logic [ALEN-1:0]       i_waddr,
  input  logic [DLEN-1:0]       i_wdata,

  output logic [DLEN-1:0]       o_rdata_a,
  output logic [DLEN-1:0]       o_rdata_b
);

localparam DH = 1;
localparam RF_WORDS = 1 << 5;

logic [DLEN-1:0] rf [0 : RF_WORDS-1];
logic wen;

assign wen = i_wen & ~(i_waddr == 0);

always @(posedge clk) begin
    if ( wen ) begin
       rf[i_waddr] <= i_wdata;
    end
end

assign #DH o_rdata_a = rf[i_raddr_a];
assign #DH o_rdata_b = rf[i_raddr_b];

initial begin
 for (int i=0 ; i<RF_WORDS; i++) begin
   rf[i] = 0;
 end
end

endmodule
