# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Tue Jul 9 23:40:24 2019
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 91 signals
# End_DVE_Session_Save_Info

# DVE version: N-2017.12-1_Full64
# DVE build date: Jan 18 2018 21:17:37


#<Session mode="View" path="/home/imast/graviera/final_implementation/session.inter.vpd.tcl" type="Debug">

#<Database>

gui_set_time_units 1s
#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Tue Jul 9 23:40:24 2019
# 91 signals
# End_DVE_Session_Save_Info

# DVE version: N-2017.12-1_Full64
# DVE build date: Jan 18 2018 21:17:37


#Add ncecessay scopes
gui_load_child_values {riv_testbench.mem_test}
gui_load_child_values {riv_testbench.id_test}
gui_load_child_values {riv_testbench.ex_test}
gui_load_child_values {riv_testbench.if_test}
gui_load_child_values {riv_testbench.id_test.rf_instance}

gui_set_time_units 1s

set _wave_session_group_1 if_test
if {[gui_sg_is_group -name "$_wave_session_group_1"]} {
    set _wave_session_group_1 [gui_sg_generate_new_name]
}
set Group1 "$_wave_session_group_1"

gui_sg_addsignal -group "$_wave_session_group_1" { {Sim:riv_testbench.if_test.clk} {Sim:riv_testbench.if_test.i_branch_in_ex} {Sim:riv_testbench.if_test.i_branch_target} {Sim:riv_testbench.if_test.i_jump_in_ex} {Sim:riv_testbench.if_test.i_jump_target} {Sim:riv_testbench.if_test.i_id_ready} {Sim:riv_testbench.if_test.o_if_valid_instr} {Sim:riv_testbench.if_test.o_if_pc} {Sim:riv_testbench.if_test.o_if_instr} {Sim:riv_testbench.if_test.rst_n} }

set _wave_session_group_2 id_test
if {[gui_sg_is_group -name "$_wave_session_group_2"]} {
    set _wave_session_group_2 [gui_sg_generate_new_name]
}
set Group2 "$_wave_session_group_2"

gui_sg_addsignal -group "$_wave_session_group_2" { {Sim:riv_testbench.id_test.clk} {Sim:riv_testbench.id_test.i_ex_jump_taken} {Sim:riv_testbench.id_test.i_ex_branch_taken} {Sim:riv_testbench.id_test.i_wb_wr_reg_en} {Sim:riv_testbench.id_test.i_wb_wr_reg_addr} {Sim:riv_testbench.id_test.i_wb_wr_reg_data} {Sim:riv_testbench.id_test.i_ex_ready} {Sim:riv_testbench.id_test.id2all} {Sim:riv_testbench.id_test.o_id2all} {Sim:riv_testbench.id_test.o_id_ready} {Sim:riv_testbench.id_test.o_check_regs} {Sim:riv_testbench.id_test.o_rs1} {Sim:riv_testbench.id_test.o_rs2} }

set _wave_session_group_3 ex_test
if {[gui_sg_is_group -name "$_wave_session_group_3"]} {
    set _wave_session_group_3 [gui_sg_generate_new_name]
}
set Group3 "$_wave_session_group_3"

gui_sg_addsignal -group "$_wave_session_group_3" { {Sim:riv_testbench.ex_test.clk} {Sim:riv_testbench.ex_test.o_ex_branch_taken} {Sim:riv_testbench.ex_test.o_ex_branch_target} {Sim:riv_testbench.ex_test.o_ex_jump_taken} {Sim:riv_testbench.ex_test.o_ex_jump_target} {Sim:riv_testbench.ex_test.stall} {Sim:riv_testbench.ex_test.i_unstall} {Sim:riv_testbench.ex_test.o_ex_ready} {Sim:riv_testbench.ex_test.is_staller} {Sim:riv_testbench.ex_test.o_is_wb_staller} {Sim:riv_testbench.ex_test.o_is_mem_staller} {Sim:riv_testbench.ex_test.i_id2all} {Sim:riv_testbench.ex_test.o_ex2all} {Sim:riv_testbench.ex_test.i_mem_rd} {Sim:riv_testbench.ex_test.i_wb_rd} {Sim:riv_testbench.ex_test.pipeline_stalled} {Sim:riv_testbench.ex_test.i_check_regs} {Sim:riv_testbench.ex_test.i_rs1} {Sim:riv_testbench.ex_test.i_rs2} }

set _wave_session_group_4 mem_test
if {[gui_sg_is_group -name "$_wave_session_group_4"]} {
    set _wave_session_group_4 [gui_sg_generate_new_name]
}
set Group4 "$_wave_session_group_4"

gui_sg_addsignal -group "$_wave_session_group_4" { {Sim:riv_testbench.mem_test.clk} {Sim:riv_testbench.mem_test.to_dm_and_reg} {Sim:riv_testbench.mem_test.i_ex2all} {Sim:riv_testbench.mem_test.o_mem2all} {Sim:riv_testbench.mem_test.i_is_mem_staller} {Sim:riv_testbench.mem_test.o_mem_rd} }

set _wave_session_group_5 wb_test
if {[gui_sg_is_group -name "$_wave_session_group_5"]} {
    set _wave_session_group_5 [gui_sg_generate_new_name]
}
set Group5 "$_wave_session_group_5"

gui_sg_addsignal -group "$_wave_session_group_5" { {Sim:riv_testbench.wb_test.clk} {Sim:riv_testbench.wb_test.i_is_wb_staller} {Sim:riv_testbench.wb_test.i_mem2all} {Sim:riv_testbench.wb_test.o_wb_rd} {Sim:riv_testbench.wb_test.o_unstall} {Sim:riv_testbench.wb_test.o_wb_wr_reg_en} {Sim:riv_testbench.wb_test.o_wb_wr_reg_addr} {Sim:riv_testbench.wb_test.o_wb_wr_reg_data} }

set _wave_session_group_6 rf_instance
if {[gui_sg_is_group -name "$_wave_session_group_6"]} {
    set _wave_session_group_6 [gui_sg_generate_new_name]
}
set Group6 "$_wave_session_group_6"

gui_sg_addsignal -group "$_wave_session_group_6" { {Sim:riv_testbench.id_test.rf_instance.ALEN} {Sim:riv_testbench.id_test.rf_instance.o_rdata_b} {Sim:riv_testbench.id_test.rf_instance.i_waddr} {Sim:riv_testbench.id_test.rf_instance.DH} {Sim:riv_testbench.id_test.rf_instance.DLEN} {Sim:riv_testbench.id_test.rf_instance.rf} {Sim:riv_testbench.id_test.rf_instance.wen} {Sim:riv_testbench.id_test.rf_instance.i_raddr_a} {Sim:riv_testbench.id_test.rf_instance.i_raddr_b} {Sim:riv_testbench.id_test.rf_instance.clk} {Sim:riv_testbench.id_test.rf_instance.i_wen} {Sim:riv_testbench.id_test.rf_instance.RF_WORDS} {Sim:riv_testbench.id_test.rf_instance.i_wdata} {Sim:riv_testbench.id_test.rf_instance.o_rdata_a} }
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.id_test.rf_instance.ALEN}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.id_test.rf_instance.ALEN}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.id_test.rf_instance.DH}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.id_test.rf_instance.DH}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.id_test.rf_instance.DLEN}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.id_test.rf_instance.DLEN}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.id_test.rf_instance.RF_WORDS}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.id_test.rf_instance.RF_WORDS}

set _wave_session_group_7 Group1
if {[gui_sg_is_group -name "$_wave_session_group_7"]} {
    set _wave_session_group_7 [gui_sg_generate_new_name]
}
set Group7 "$_wave_session_group_7"

gui_sg_addsignal -group "$_wave_session_group_7" { {Sim:riv_testbench.mem_test.o_store_miss_aligned_error} {Sim:riv_testbench.mem_test.o_load_miss_aligned_error} }

set _wave_session_group_8 $_wave_session_group_7|
append _wave_session_group_8 data_mem_instance
set Group1|data_mem_instance "$_wave_session_group_8"

gui_sg_addsignal -group "$_wave_session_group_8" { {Sim:riv_testbench.mem_test.data_mem_instance.INIT_END} {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_LOW} {Sim:riv_testbench.mem_test.data_mem_instance.DATA_BYTES} {Sim:riv_testbench.mem_test.data_mem_instance.o_rdata} {Sim:riv_testbench.mem_test.data_mem_instance.INIT_START} {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_HIGH} {Sim:riv_testbench.mem_test.data_mem_instance.INIT_FILE} {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_WIDTH} {Sim:riv_testbench.mem_test.data_mem_instance.INIT_ZERO} {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_SIZE} {Sim:riv_testbench.mem_test.data_mem_instance.DEPTH} {Sim:riv_testbench.mem_test.data_mem_instance.addr} {Sim:riv_testbench.mem_test.data_mem_instance.i_addr} {Sim:riv_testbench.mem_test.data_mem_instance.DATA_WIDTH} {Sim:riv_testbench.mem_test.data_mem_instance.clk} {Sim:riv_testbench.mem_test.data_mem_instance.i_wen} {Sim:riv_testbench.mem_test.data_mem_instance.cycle} {Sim:riv_testbench.mem_test.data_mem_instance.i_wdata} {Sim:riv_testbench.mem_test.data_mem_instance.mem} }
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.INIT_END}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.INIT_END}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_LOW}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_LOW}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.DATA_BYTES}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.DATA_BYTES}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.INIT_START}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.INIT_START}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_HIGH}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_HIGH}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_WIDTH}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_WIDTH}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.INIT_ZERO}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.INIT_ZERO}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_SIZE}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.ADDR_SIZE}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.DEPTH}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.DEPTH}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.mem_test.data_mem_instance.DATA_WIDTH}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.mem_test.data_mem_instance.DATA_WIDTH}
if {![info exists useOldWindow]} { 
	set useOldWindow true
}
if {$useOldWindow && [string first "Wave" [gui_get_current_window -view]]==0} { 
	set Wave.1 [gui_get_current_window -view] 
} else {
	set Wave.1 [lindex [gui_get_window_ids -type Wave] 0]
if {[string first "Wave" ${Wave.1}]!=0} {
gui_open_window Wave
set Wave.1 [ gui_get_current_window -view ]
}
}

set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_create -id ${Wave.1} C2 88740
gui_marker_select -id ${Wave.1} {  C2 }
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 626 1071
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group1}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group2}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group3}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group4}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group5}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group6}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group7}]
gui_list_add_group -id ${Wave.1}  -after riv_testbench.mem_test.o_load_miss_aligned_error [list ${Group1|data_mem_instance}]
gui_list_collapse -id ${Wave.1} ${Group1}
gui_list_collapse -id ${Wave.1} ${Group2}
gui_list_collapse -id ${Wave.1} ${Group3}
gui_list_collapse -id ${Wave.1} ${Group4}
gui_list_collapse -id ${Wave.1} ${Group5}
gui_seek_criteria -id ${Wave.1} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group ${Group1|data_mem_instance}  -item {riv_testbench.mem_test.data_mem_instance.mem[0:2047][63:0]} -position below

gui_marker_move -id ${Wave.1} {C1} 4820
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

