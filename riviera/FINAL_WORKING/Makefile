all: clean comp run-graphic

clean:
	\rm -rf DVEfiles inter.vpd simv csrc simv* comp.log sim.log ucli.key

comp:
	vcs -sverilog defines.sv interconnection_struct.sv imm_gen.sv regfile_2r1w.sv instr_mem.sv if_stage.sv id_stage.sv ex_alu.sv ex_branch.sv ex_sign_ext.sv stall_controller.sv ex_stage.sv dm_load_controller.sv dm_store_controller.sv mem_struct_reg.sv mem_sign_ext.sv data_mem.sv mem_stage.sv riv_testbench.sv wb_stage.sv -debug_all -l comp.log

run:
	./simv -l sim.log

run-graphic:
	./simv -gui -l sim.log

