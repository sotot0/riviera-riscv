clean:
	\rm -rf csrc simv* *.log *.vcd *.key

comp_if:
	vcs -sverilog defines.sv instr_mem.sv if_stage.sv -l comp.log

comp_id:
	vcs -sverilog defines.sv imm_gen.sv interconnection_struct.sv regfile_2r1w.sv id_stage.sv -l comp.log

comp_ex:
	vcs -sverilog defines.sv interconnection_struct.sv ex_alu.sv ex_branch.sv ex_sign_ext.sv ex_stage.sv -l comp.log

comp_top:
	vcs -sverilog defines.sv instr_mem.sv if_stage.sv imm_gen.sv interconnection_struct.sv regfile_2r1w.sv id_stage.sv ex_alu.sv ex_branch.sv ex_sign_ext.sv ex_stage.sv wb_stage.sv riviera_core.sv -l comp.log

