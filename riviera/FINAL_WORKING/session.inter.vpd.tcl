# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Sun Jul 7 20:02:29 2019
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 56 signals
# End_DVE_Session_Save_Info

# DVE version: N-2017.12-1_Full64
# DVE build date: Jan 18 2018 21:17:37


#<Session mode="View" path="/home/sototo/graviera/FINAL_WORKING/session.inter.vpd.tcl" type="Debug">

#<Database>

gui_set_time_units 1s
#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Sun Jul 7 20:02:29 2019
# 56 signals
# End_DVE_Session_Save_Info

# DVE version: N-2017.12-1_Full64
# DVE build date: Jan 18 2018 21:17:37


#Add ncecessay scopes
gui_load_child_values {riv_testbench.mem_test}
gui_load_child_values {riv_testbench.id_test}
gui_load_child_values {riv_testbench.if_test}

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
gui_wv_zoom_timerange -id ${Wave.1} 0 389
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group1}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group2}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group3}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group4}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group5}]
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
gui_list_set_insertion_bar  -id ${Wave.1} -group ${Group5}  -position in

gui_marker_move -id ${Wave.1} {C1} 0
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

