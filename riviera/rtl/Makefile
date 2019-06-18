clean:
	\rm -rf csrc simv* *.log *.vcd *.key

comp_if:
	vcs -sverilog defines.sv instr_mem.sv if_stage.sv -l comp.log

comp_id:
	vcs -sverilog defines.sv imm_gen.sv interconnection_struct.sv regfile_2r1w.sv id_stage.sv -l comp.log
