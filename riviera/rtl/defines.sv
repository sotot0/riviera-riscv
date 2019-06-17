 // File that includes all the defines of the Risc-V implementation

`ifndef DEFINES_SV
`define DEFINES_SV

`define W_64		64
`define W_32 		32

 // IF-relative defines
`define IM_DATA_BYTES	`W_32/8			// Total bytes of a IM word
`define IM_DEPTH	2048			// Total words of IM
`define IM_ADDR		$clog2(`IM_DEPTH)	// Address size of IM


`endif
