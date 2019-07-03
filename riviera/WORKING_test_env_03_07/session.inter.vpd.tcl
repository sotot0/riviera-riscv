# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Wed Jul 3 13:41:46 2019
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 70 signals
# End_DVE_Session_Save_Info

# DVE version: N-2017.12-1_Full64
# DVE build date: Jan 18 2018 21:17:37


#<Session mode="View" path="/home/sototo/graviera/test_env/session.inter.vpd.tcl" type="Debug">

#<Database>

gui_set_time_units 1s
#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Wed Jul 3 13:41:46 2019
# 70 signals
# End_DVE_Session_Save_Info

# DVE version: N-2017.12-1_Full64
# DVE build date: Jan 18 2018 21:17:37


#Add ncecessay scopes
gui_load_child_values {riv_testbench.mem_test}
gui_load_child_values {riv_testbench.id_test}
gui_load_child_values {riv_testbench}
gui_load_child_values {riv_testbench.wb_test}
gui_load_child_values {riv_testbench.ex_test}
gui_load_child_values {riv_testbench.if_test}
gui_load_child_values {riv_testbench.id_test.rf_instance}

gui_set_time_units 1s

set _wave_session_group_1 riv_testbench
if {[gui_sg_is_group -name "$_wave_session_group_1"]} {
    set _wave_session_group_1 [gui_sg_generate_new_name]
}
set Group1 "$_wave_session_group_1"

gui_sg_addsignal -group "$_wave_session_group_1" { {Sim:riv_testbench.wb_wr_reg_en} {Sim:riv_testbench.pc} {Sim:riv_testbench.ex2all} {Sim:riv_testbench.wb_wr_reg_data} {Sim:riv_testbench.wb_wr_reg_addr} {Sim:riv_testbench.mem2all} {Sim:riv_testbench.id2all} {Sim:riv_testbench.ex_branch_taken} {Sim:riv_testbench.wb_ready} {Sim:riv_testbench.ex_jump_taken} {Sim:riv_testbench.ex_ready} {Sim:riv_testbench.instruction} {Sim:riv_testbench.mem_ready} {Sim:riv_testbench.id_ready} {Sim:riv_testbench.ex_jump_target} {Sim:riv_testbench.clk} {Sim:riv_testbench.valid_instr} {Sim:riv_testbench.rst_n} {Sim:riv_testbench.ex_branch_target} }

set _wave_session_group_2 if_test
if {[gui_sg_is_group -name "$_wave_session_group_2"]} {
    set _wave_session_group_2 [gui_sg_generate_new_name]
}
set Group2 "$_wave_session_group_2"

gui_sg_addsignal -group "$_wave_session_group_2" { {Sim:riv_testbench.if_test.clk} {Sim:riv_testbench.if_test.o_if_pc} {Sim:riv_testbench.if_test.o_if_instr} {Sim:riv_testbench.if_test.o_if_valid_instr} {Sim:riv_testbench.if_test.i_jump_in_ex} {Sim:riv_testbench.if_test.i_jump_target} }

set _wave_session_group_3 id_test
if {[gui_sg_is_group -name "$_wave_session_group_3"]} {
    set _wave_session_group_3 [gui_sg_generate_new_name]
}
set Group3 "$_wave_session_group_3"

gui_sg_addsignal -group "$_wave_session_group_3" { {Sim:riv_testbench.id_test.clk} {Sim:riv_testbench.id_test.i_if_pc} {Sim:riv_testbench.id_test.i_if_instr} {Sim:riv_testbench.id_test.id2all} {Sim:riv_testbench.id_test.i_wb_wr_reg_en} {Sim:riv_testbench.id_test.i_wb_wr_reg_addr} {Sim:riv_testbench.id_test.i_wb_wr_reg_data} {Sim:riv_testbench.id_test.o_id2all} {Sim:riv_testbench.id_test.i_ex_jump_taken} }

set _wave_session_group_4 rf_instance
if {[gui_sg_is_group -name "$_wave_session_group_4"]} {
    set _wave_session_group_4 [gui_sg_generate_new_name]
}
set Group4 "$_wave_session_group_4"

gui_sg_addsignal -group "$_wave_session_group_4" { {Sim:riv_testbench.id_test.rf_instance.ALEN} {Sim:riv_testbench.id_test.rf_instance.o_rdata_b} {Sim:riv_testbench.id_test.rf_instance.i_waddr} {Sim:riv_testbench.id_test.rf_instance.DH} {Sim:riv_testbench.id_test.rf_instance.DLEN} {Sim:riv_testbench.id_test.rf_instance.rf} {Sim:riv_testbench.id_test.rf_instance.wen} {Sim:riv_testbench.id_test.rf_instance.i_raddr_a} {Sim:riv_testbench.id_test.rf_instance.i_raddr_b} {Sim:riv_testbench.id_test.rf_instance.clk} {Sim:riv_testbench.id_test.rf_instance.i_wen} {Sim:riv_testbench.id_test.rf_instance.RF_WORDS} {Sim:riv_testbench.id_test.rf_instance.i_wdata} {Sim:riv_testbench.id_test.rf_instance.o_rdata_a} }
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.id_test.rf_instance.ALEN}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.id_test.rf_instance.ALEN}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.id_test.rf_instance.DH}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.id_test.rf_instance.DH}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.id_test.rf_instance.DLEN}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.id_test.rf_instance.DLEN}
gui_set_radix -radix {decimal} -signals {Sim:riv_testbench.id_test.rf_instance.RF_WORDS}
gui_set_radix -radix {twosComplement} -signals {Sim:riv_testbench.id_test.rf_instance.RF_WORDS}

set _wave_session_group_5 ex_test
if {[gui_sg_is_group -name "$_wave_session_group_5"]} {
    set _wave_session_group_5 [gui_sg_generate_new_name]
}
set Group5 "$_wave_session_group_5"

gui_sg_addsignal -group "$_wave_session_group_5" { {Sim:riv_testbench.ex_test.clk} {Sim:riv_testbench.ex_test.i_id2all} {Sim:riv_testbench.ex_test.ex_branch_instance.o_ex_branch_taken} {Sim:riv_testbench.ex_test.ex_branch_instance.o_ex_branch_target} {Sim:riv_testbench.ex_test.o_ex_jump_taken} {Sim:riv_testbench.ex_test.o_ex_jump_target} {Sim:riv_testbench.ex_test.alu2ext} {Sim:riv_testbench.ex_test.mul_sel} {Sim:riv_testbench.ex_test.o_ex_ready} {Sim:riv_testbench.ex_test.o_ex2all} }

set _wave_session_group_6 mem_test
if {[gui_sg_is_group -name "$_wave_session_group_6"]} {
    set _wave_session_group_6 [gui_sg_generate_new_name]
}
set Group6 "$_wave_session_group_6"

gui_sg_addsignal -group "$_wave_session_group_6" { {Sim:riv_testbench.mem_test.clk} {Sim:riv_testbench.mem_test.i_ex2all} {Sim:riv_testbench.mem_test.to_dm_and_reg} {Sim:riv_testbench.mem_test.load_mem_data} {Sim:riv_testbench.mem_test.to_load_controller} {Sim:riv_testbench.mem_test.to_sign_ext} {Sim:riv_testbench.mem_test.o_mem2all} }

set _wave_session_group_7 wb_test
if {[gui_sg_is_group -name "$_wave_session_group_7"]} {
    set _wave_session_group_7 [gui_sg_generate_new_name]
}
set Group7 "$_wave_session_group_7"

gui_sg_addsignal -group "$_wave_session_group_7" { {Sim:riv_testbench.wb_test.clk} {Sim:riv_testbench.wb_test.i_mem2all} {Sim:riv_testbench.wb_test.o_wb_wr_reg_en} {Sim:riv_testbench.wb_test.o_wb_wr_reg_addr} {Sim:riv_testbench.wb_test.o_wb_wr_reg_data} }
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
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 389
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group1}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group2}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group3}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group4}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group5}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group6}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group7}]
gui_list_collapse -id ${Wave.1} ${Group1}
gui_list_collapse -id ${Wave.1} ${Group2}
gui_list_collapse -id ${Wave.1} ${Group3}
gui_list_collapse -id ${Wave.1} ${Group4}
gui_list_collapse -id ${Wave.1} ${Group5}
gui_list_collapse -id ${Wave.1} ${Group6}
gui_list_collapse -id ${Wave.1} ${Group7}
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
gui_list_set_insertion_bar  -id ${Wave.1} -group ${Group5}  -position in

gui_marker_move -id ${Wave.1} {C1} 477
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

