set qsDebug { lint_gui_mode } 
# 
# Questa Static Verification System
# Version 2021.1 4558100 win64 28-Jan-2021

clear settings -all
clear directives
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
clear settings  -lib
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
lint on clk_port_conn_complex 
lint on clock_gated 
lint on clock_internal 
lint on clock_path_buffer 
lint on clock_signal_as_non_clock 
lint on flop_with_inverted_clock 
lint on bus_bit_as_clk 
lint on clock_in_wait_stmt 
lint on clock_with_both_edges 
lint on seq_block_has_multi_clks 
lint on unsynth_clk_in_concurrent_stmt 
lint on unsynth_clocking_style 
lint on unsynth_else_after_clk_event 
lint on unsynth_multi_wait_with_same_clk 
lint on async_reset_active_high 
lint on bus_conn_to_prim_gate 
lint on feedthrough_path 
lint on flop_clock_reset_loop 
lint on flop_output_as_clock 
lint on flop_redundant 
lint on long_combinational_path 
lint on module_has_blackbox_instance 
lint on re_entrant_output 
lint on tristate_multi_driven 
lint on unconnected_inst 
lint on unconnected_inst_input 
lint on unconnected_inst_output 
lint on undriven_latch_data 
lint on undriven_latch_enable 
lint on undriven_reg_clock 
lint on undriven_reg_data 
lint on undriven_signal 
lint on unloaded_input_port 
lint on const_latch_data 
lint on const_output 
lint on const_reg_clock 
lint on const_reg_data 
lint on const_signal 
lint on mux_select_const 
lint on blackbox_input_conn_inconsistent 
lint on blackbox_output_control_signal 
lint on bus_conn_to_inst_reversed 
lint on combo_path_input_to_output 
lint on generic_map_ordered 
lint on inout_port_exists 
lint on inout_port_not_set 
lint on inout_port_unused 
lint on input_port_set 
lint on module_without_ports 
lint on ordered_port_connection 
lint on port_conn_is_expression 
lint on comment_has_control_char 
lint on comment_not_in_english 
lint on identifier_with_error_warning 
lint on parameter_name_duplicate 
lint on reserved_keyword 
lint on var_name_duplicate 
lint on async_block_top_stmt_not_if 
lint on async_control_is_gated 
lint on async_control_is_internal 
lint on flop_async_reset_const 
lint on flop_without_control 
lint on reset_port_connection_static 
lint on signal_sync_async 
lint on always_has_inconsistent_async_control 
lint on always_has_multiple_async_control 
lint on func_as_reset_condition 
lint on process_has_inconsistent_async_control 
lint on process_has_multiple_async_control 
lint on reset_polarity_mismatch 
lint on reset_pragma_mismatch 
lint on reset_set_non_const_assign 
lint on reset_set_with_both_polarity 
lint on seq_block_first_stmt_not_if 
lint on seq_block_has_complex_cond 
lint on assign_chain 
lint on assign_int_to_reg 
lint on assign_others_to_slice 
lint on assign_real_to_bit 
lint on assign_real_to_int 
lint on assign_real_to_reg 
lint on assign_reg_to_int 
lint on assign_reg_to_real 
lint on assign_to_supply_net 
lint on signal_with_negative_value 
lint on var_assign_without_deassign 
lint on var_deassign_without_assign 
lint on var_forced_without_release 
lint on var_released_without_force 
lint on case_default_redundant 
lint on case_item_invalid 
lint on case_item_not_const 
lint on case_large 
lint on case_nested 
lint on case_others_null 
lint on case_select_const 
lint on case_select_has_expr 
lint on data_event_has_edge 
lint on delay_in_non_flop_expr 
lint on arith_expr_with_conditional_operator 
lint on comparison_has_real_operand 
lint on complex_expression 
lint on condition_const 
lint on condition_has_assign 
lint on condition_is_multi_bit 
lint on conditional_operator_nested 
lint on data_type_bit_select_invalid 
lint on div_mod_rhs_var 
lint on div_mod_rhs_zero 
lint on exponent_negative 
lint on logical_not_on_multi_bit 
lint on logical_operator_on_multi_bit 
lint on multiplication_operator 
lint on operand_redundant 
lint on qualified_expression 
lint on reduction_operator_on_single_bit 
lint on signed_unsigned_mixed_expr 
lint on fsm_state_count_large 
lint on fsm_without_one_hot_encoding 
lint on func_arg_array_constrained 
lint on func_bit_not_set 
lint on func_input_unused 
lint on func_input_width_mismatch 
lint on func_return_before_last_stmt 
lint on func_return_range_fixed 
lint on func_return_range_mismatch 
lint on func_sets_global_var 
lint on func_to_stdlogicvector 
lint on subroutines_recursive_loop 
lint on for_loop_var_init_not_const 
lint on for_stmt_with_complex_logic 
lint on gen_loop_index_not_int 
lint on loop_condition_const 
lint on loop_index_in_multi_always_blocks 
lint on loop_index_modified 
lint on loop_index_not_int 
lint on loop_step_incorrect 
lint on loop_var_not_in_condition 
lint on loop_var_not_in_init 
lint on synth_pragma_prefix_missing 
lint on while_loop_iteration_limit 
lint on module_with_duplicate_ports 
lint on module_with_null_port 
lint on multi_ports_in_single_line 
lint on parameter_count_large 
lint on sensitivity_list_edge_multi_bit 
lint on sensitivity_list_operator_unexpected 
lint on sensitivity_list_signal_repeated 
lint on procedure_sets_global_var 
lint on task_in_combo_block 
lint on task_in_seq_block 
lint on task_sets_global_var 
lint on loop_with_next_exit 
lint on unsynth_allocator 
lint on unsynth_wand_wor_net 
lint on assign_with_multi_arith_operations 
lint on div_mod_rem_operand_complex_expr 
lint on loop_without_break 
lint on tristate_enable_with_expr 
lint on unsynth_dc_shell_script 
lint on unsynth_sensitivity_list_conditions 
lint on always_exceeds_line_limit 
lint on always_signal_assign_large 
lint on always_without_event 
lint on array_index_with_expr 
lint on bit_order_reversed 
lint on bus_bits_in_multi_seq_blocks 
lint on bus_bits_not_read 
lint on bus_bits_not_set 
lint on case_condition_with_tristate 
lint on case_stmt_with_parallel_case 
lint on case_with_memory_output 
lint on concurrent_block_with_duplicate_assign 
lint on conversion_to_stdlogicvector_invalid 
lint on data_type_std_ulogic 
lint on design_ware_inst 
lint on else_condition_dangling 
lint on empty_block 
lint on empty_module 
lint on empty_stmt 
lint on enum_decl_invalid 
lint on flop_output_in_initial 
lint on func_expr_input_size_mismatch 
lint on gen_inst_label_duplicate 
lint on gen_label_duplicate 
lint on gen_label_missing 
lint on if_condition_with_tristate 
lint on if_else_if_can_be_case 
lint on if_else_nested_large 
lint on if_stmt_shares_arithmetic_operator 
lint on if_stmt_with_arith_expr 
lint on if_with_memory_output 
lint on implicit_wire 
lint on inferred_blackbox 
lint on inst_param_width_overflow 
lint on int_without_range 
lint on latch_inferred 
lint on line_char_large 
lint on memory_not_set 
lint on memory_redefined 
lint on multi_wave_element 
lint on part_select_illegal 
lint on power_operand_invalid 
lint on pragma_coverage_off_nested 
lint on pragma_translate_off_nested 
lint on pragma_translate_on_nested 
lint on procedure_call 
lint on process_exceeds_line_limit 
lint on process_signal_assign_large 
lint on process_var_assign_disorder 
lint on process_without_event 
lint on record_type 
lint on reference_event_without_edge 
lint on selected_signal_stmt 
lint on seq_block_has_duplicate_assign 
lint on shared_variable_in_multi_process 
lint on signal_assign_in_multi_initial 
lint on stable_attribute 
lint on std_packages_mixed 
lint on string_has_control_char 
lint on sync_read_as_async 
lint on synopsys_attribute 
lint on tristate_inferred 
lint on tristate_not_at_top_level 
lint on tristate_other_desc_mixed 
lint on two_state_data_type 
lint on unresolved_module 
lint on user_blackbox 
lint on var_assign_in_process 
lint on var_index_range_insufficient 
lint on var_read_before_set 
lint on when_else_nested 
lint on assign_width_overflow 
lint on assign_width_underflow 
lint on case_width_mismatch 
lint on comparison_width_mismatch 
lint on concat_expr_with_unsized_operand 
lint on div_mod_lhs_too_wide 
lint on div_mod_rhs_too_wide 
lint on expr_operands_width_mismatch 
lint on inst_port_width_mismatch 
lint on func_return_value_unspecified 
lint on sensitivity_list_var_modified 
lint on always_has_multiple_events 
lint on assign_or_comparison_has_x 
lint on assign_or_comparison_has_z 
lint on case_default_missing 
lint on case_default_not_last_item 
lint on case_item_duplicate 
lint on case_pragma_redundant 
lint on case_with_x_z 
lint on casex 
lint on casez 
lint on casez_has_x 
lint on data_type_not_recommended 
lint on for_loop_with_wait 
lint on func_nonblocking_assign 
lint on incomplete_case_stmt_with_full_case 
lint on index_x_z 
lint on process_has_async_set_reset 
lint on sensitivity_list_var_missing 
lint on sim_synth_mismatch_assign_event 
lint on sim_synth_mismatch_shared_var 
lint on sim_synth_mismatch_tristate_compare 
lint on std_logic_vector_without_range 
lint on unsynth_delay_in_blocking_assign 
lint on unsynth_delay_in_stmt 
lint on unsynth_initial_value 
lint on assigns_mixed 
lint on assigns_mixed_in_always_block 
lint on blocking_assign_in_seq_block 
lint on combo_loop 
lint on combo_loop_with_latch 
lint on multi_driven_signal 
lint on nonblocking_assign_and_delay_in_always 
lint on nonblocking_assign_in_combo_block 
lint on attribute_with_keyword_all 
lint on const_with_inconsistent_value 
lint on repeat_ctrl_not_const 
lint on unsynth_access_type 
lint on unsynth_alias_declaration 
lint on unsynth_assert_stmt 
lint on unsynth_assign_deassign 
lint on unsynth_bidirectional_switch 
lint on unsynth_charge_strength 
lint on unsynth_deferred_const 
lint on unsynth_defparam 
lint on unsynth_disable_stmt 
lint on unsynth_disconnection_spec 
lint on unsynth_drive_strength_assign 
lint on unsynth_drive_strength_gate 
lint on unsynth_enum_encoding_attribute 
lint on unsynth_event_var 
lint on unsynth_file_type 
lint on unsynth_force_release 
lint on unsynth_fork_join_block 
lint on unsynth_guarded_block_stmt 
lint on unsynth_initial_stmt 
lint on unsynth_integer_array 
lint on unsynth_mos_switch 
lint on unsynth_multi_dim_array 
lint on unsynth_pli_task_func 
lint on unsynth_port_type 
lint on unsynth_port_type_unconstrained 
lint on unsynth_predefined_attribute 
lint on unsynth_pulldown 
lint on unsynth_pullup 
lint on unsynth_real_var 
lint on unsynth_repeat 
lint on unsynth_resolution_func 
lint on unsynth_shift_operator 
lint on unsynth_signal_kind_register_bus 
lint on unsynth_specify_block 
lint on unsynth_time_var 
lint on unsynth_tri_net 
lint on unsynth_udp 
lint on unsynth_user_defined_attribute 
lint on unsynth_wait_stmt 
lint on always_has_nested_event_control 
lint on case_eq_operator 
lint on div_mod_rhs_invalid 
lint on port_exp_with_integer 
lint on sensitivity_list_var_both_edges 
lint on synth_pragma_prefix_invalid 
lint on task_has_event 
lint on unsynth_arithmetic_operator 
lint on unsynth_array_index_type_enum 
lint on unsynth_block_stmt_header 
lint on unsynth_const_redefined 
lint on unsynth_delay_in_bidirectional_switch 
lint on unsynth_delay_in_cmos_switch 
lint on unsynth_delay_in_gate 
lint on unsynth_delay_in_mos_switch 
lint on unsynth_delay_in_net_decl 
lint on unsynth_delay_in_tristate_gate 
lint on unsynth_func_returns_real 
lint on unsynth_generic_not_int 
lint on unsynth_hier_reference 
lint on unsynth_physical_type 
lint on unsynth_repeat_in_nonblocking_assign 
lint on unsynth_stmt_in_entity 
lint on unsynth_type_declaration_incomplete 
lint on unsynth_while_in_subprogram 
lint on unsynth_while_loop 
lint on task_has_event_and_input 
lint on task_has_event_and_output 
lint preference -allow_non_port_data_types reg wire tri integer logic interface -allow_port_data_types reg wire tri integer logic interface 
lint report check -severity info always_exceeds_line_limit 
lint report check -severity warning always_has_inconsistent_async_control 
lint report check -severity info always_has_multiple_async_control 
lint report check -severity error always_has_multiple_events 
lint report check -severity warning always_has_nested_event_control 
lint report check -severity warning always_signal_assign_large 
lint report check -severity error always_without_event 
lint report check -severity error arith_expr_with_conditional_operator 
lint report check -severity error array_index_with_expr 
lint report check -severity warning assign_chain 
lint report check -severity error assign_int_to_reg 
lint report check -severity error assign_or_comparison_has_x 
lint report check -severity error assign_or_comparison_has_z 
lint report check -severity info assign_others_to_slice 
lint report check -severity error assign_real_to_bit 
lint report check -severity error assign_real_to_int 
lint report check -severity error assign_real_to_reg 
lint report check -severity error assign_reg_to_int 
lint report check -severity error assign_reg_to_real 
lint report check -severity info assign_to_supply_net 
lint report check -severity error assign_width_overflow 
lint report check -severity error assign_width_underflow 
lint report check -severity warning assign_with_multi_arith_operations 
lint report check -severity error assigns_mixed 
lint report check -severity error assigns_mixed_in_always_block 
lint report check -severity error async_block_top_stmt_not_if 
lint report check -severity warning async_control_is_gated 
lint report check -severity error async_control_is_internal 
lint report check -severity info async_reset_active_high 
lint report check -severity error attribute_with_keyword_all 
lint report check -severity warning bit_order_reversed 
lint report check -severity error blackbox_input_conn_inconsistent 
lint report check -severity error blackbox_output_control_signal 
lint report check -severity error blocking_assign_in_seq_block 
lint report check -severity error bus_bit_as_clk 
lint report check -severity error bus_bits_in_multi_seq_blocks 
lint report check -severity warning bus_bits_not_read 
lint report check -severity warning bus_bits_not_set 
lint report check -severity error bus_conn_to_inst_reversed 
lint report check -severity warning bus_conn_to_prim_gate 
lint report check -severity error case_condition_with_tristate 
lint report check -severity error case_default_missing 
lint report check -severity error case_default_not_last_item 
lint report check -severity info case_default_redundant 
lint report check -severity error case_eq_operator 
lint report check -severity error case_item_duplicate 
lint report check -severity error case_item_invalid 
lint report check -severity error case_item_not_const 
lint report check -severity info case_large 
lint report check -severity warning case_nested 
lint report check -severity info case_others_null 
lint report check -severity info case_pragma_redundant 
lint report check -severity error case_select_const 
lint report check -severity warning case_select_has_expr 
lint report check -severity error case_stmt_with_parallel_case 
lint report check -severity error case_width_mismatch 
lint report check -severity error case_with_memory_output 
lint report check -severity error case_with_x_z 
lint report check -severity error casex 
lint report check -severity info casez 
lint report check -severity error casez_has_x 
lint report check -severity error clk_port_conn_complex 
lint report check -severity warning clock_gated 
lint report check -severity error clock_in_wait_stmt 
lint report check -severity warning clock_internal 
lint report check -severity info clock_path_buffer 
lint report check -severity error clock_signal_as_non_clock 
lint report check -severity info clock_with_both_edges 
lint report check -severity error combo_loop 
lint report check -severity error combo_loop_with_latch 
lint report check -severity info combo_path_input_to_output 
lint report check -severity info comment_has_control_char 
lint report check -severity info comment_not_in_english 
lint report check -severity info comparison_has_real_operand 
lint report check -severity error comparison_width_mismatch 
lint report check -severity info complex_expression 
lint report check -severity info concat_expr_with_unsized_operand 
lint report check -severity warning concurrent_block_with_duplicate_assign 
lint report check -severity warning condition_const 
lint report check -severity error condition_has_assign 
lint report check -severity error condition_is_multi_bit 
lint report check -severity info conditional_operator_nested 
lint report check -severity info const_latch_data 
lint report check -severity info const_output 
lint report check -severity info const_reg_clock 
lint report check -severity info const_reg_data 
lint report check -severity info const_signal 
lint report check -severity error const_with_inconsistent_value 
lint report check -severity error conversion_to_stdlogicvector_invalid 
lint report check -severity warning data_event_has_edge 
lint report check -severity warning data_type_bit_select_invalid 
lint report check -severity warning data_type_not_recommended 
lint report check -severity info data_type_std_ulogic 
lint report check -severity info delay_in_non_flop_expr 
lint report check -severity info design_ware_inst 
lint report check -severity warning div_mod_lhs_too_wide 
lint report check -severity warning div_mod_rem_operand_complex_expr 
lint report check -severity error div_mod_rhs_invalid 
lint report check -severity warning div_mod_rhs_too_wide 
lint report check -severity error div_mod_rhs_var 
lint report check -severity error div_mod_rhs_zero 
lint report check -severity error else_condition_dangling 
lint report check -severity error empty_block 
lint report check -severity error empty_module 
lint report check -severity info empty_stmt 
lint report check -severity warning enum_decl_invalid 
lint report check -severity error exponent_negative 
lint report check -severity error expr_operands_width_mismatch 
lint report check -severity info feedthrough_path 
lint report check -severity info flop_async_reset_const 
lint report check -severity error flop_clock_reset_loop 
lint report check -severity warning flop_output_as_clock 
lint report check -severity warning flop_output_in_initial 
lint report check -severity info flop_redundant 
lint report check -severity info flop_with_inverted_clock 
lint report check -severity info flop_without_control 
lint report check -severity error for_loop_var_init_not_const 
lint report check -severity error for_loop_with_wait 
lint report check -severity warning for_stmt_with_complex_logic 
lint report check -severity info fsm_state_count_large 
lint report check -severity info fsm_without_one_hot_encoding 
lint report check -severity warning func_arg_array_constrained 
lint report check -severity error func_as_reset_condition 
lint report check -severity error func_bit_not_set 
lint report check -severity error func_expr_input_size_mismatch 
lint report check -severity info func_input_unused 
lint report check -severity error func_input_width_mismatch 
lint report check -severity error func_nonblocking_assign 
lint report check -severity warning func_return_before_last_stmt 
lint report check -severity error func_return_range_fixed 
lint report check -severity error func_return_range_mismatch 
lint report check -severity error func_return_value_unspecified 
lint report check -severity error func_sets_global_var 
lint report check -severity warning func_to_stdlogicvector 
lint report check -severity error gen_inst_label_duplicate 
lint report check -severity error gen_label_duplicate 
lint report check -severity info gen_label_missing 
lint report check -severity error gen_loop_index_not_int 
lint report check -severity warning generic_map_ordered 
lint report check -severity info identifier_with_error_warning 
lint report check -severity error if_condition_with_tristate 
lint report check -severity info if_else_if_can_be_case 
lint report check -severity warning if_else_nested_large 
lint report check -severity error if_stmt_shares_arithmetic_operator 
lint report check -severity warning if_stmt_with_arith_expr 
lint report check -severity warning if_with_memory_output 
lint report check -severity info implicit_wire 
lint report check -severity error incomplete_case_stmt_with_full_case 
lint report check -severity error index_x_z 
lint report check -severity error inferred_blackbox 
lint report check -severity info inout_port_exists 
lint report check -severity warning inout_port_not_set 
lint report check -severity info inout_port_unused 
lint report check -severity error input_port_set 
lint report check -severity error inst_param_width_overflow 
lint report check -severity error inst_port_width_mismatch 
lint report check -severity info int_without_range 
lint report check -severity warning latch_inferred 
lint report check -severity info line_char_large 
lint report check -severity warning logical_not_on_multi_bit 
lint report check -severity warning logical_operator_on_multi_bit 
lint report check -severity error long_combinational_path 
lint report check -severity error loop_condition_const 
lint report check -severity error loop_index_in_multi_always_blocks 
lint report check -severity error loop_index_modified 
lint report check -severity error loop_index_not_int 
lint report check -severity error loop_step_incorrect 
lint report check -severity error loop_var_not_in_condition 
lint report check -severity error loop_var_not_in_init 
lint report check -severity error loop_with_next_exit 
lint report check -severity error loop_without_break 
lint report check -severity warning memory_not_set 
lint report check -severity warning memory_redefined 
lint report check -severity warning module_has_blackbox_instance 
lint report check -severity error module_with_duplicate_ports 
lint report check -severity error module_with_null_port 
lint report check -severity warning module_without_ports 
lint report check -severity error multi_driven_signal 
lint report check -severity info multi_ports_in_single_line 
lint report check -severity warning multi_wave_element 
lint report check -severity info multiplication_operator 
lint report check -severity warning mux_select_const 
lint report check -severity warning nonblocking_assign_and_delay_in_always 
lint report check -severity error nonblocking_assign_in_combo_block 
lint report check -severity error operand_redundant 
lint report check -severity warning ordered_port_connection 
lint report check -severity info parameter_count_large 
lint report check -severity info parameter_name_duplicate 
lint report check -severity error part_select_illegal 
lint report check -severity error port_conn_is_expression 
lint report check -severity error port_exp_with_integer 
lint report check -severity error power_operand_invalid 
lint report check -severity warning pragma_coverage_off_nested 
lint report check -severity warning pragma_translate_off_nested 
lint report check -severity error pragma_translate_on_nested 
lint report check -severity warning procedure_call 
lint report check -severity error procedure_sets_global_var 
lint report check -severity warning process_exceeds_line_limit 
lint report check -severity info process_has_async_set_reset 
lint report check -severity warning process_has_inconsistent_async_control 
lint report check -severity info process_has_multiple_async_control 
lint report check -severity warning process_signal_assign_large 
lint report check -severity warning process_var_assign_disorder 
lint report check -severity error process_without_event 
lint report check -severity info qualified_expression 
lint report check -severity info re_entrant_output 
lint report check -severity warning record_type 
lint report check -severity info reduction_operator_on_single_bit 
lint report check -severity warning reference_event_without_edge 
lint report check -severity error repeat_ctrl_not_const 
lint report check -severity info reserved_keyword 
lint report check -severity error reset_polarity_mismatch 
lint report check -severity info reset_port_connection_static 
lint report check -severity error reset_pragma_mismatch 
lint report check -severity error reset_set_non_const_assign 
lint report check -severity error reset_set_with_both_polarity 
lint report check -severity warning selected_signal_stmt 
lint report check -severity error sensitivity_list_edge_multi_bit 
lint report check -severity error sensitivity_list_operator_unexpected 
lint report check -severity warning sensitivity_list_signal_repeated 
lint report check -severity warning sensitivity_list_var_both_edges 
lint report check -severity error sensitivity_list_var_missing 
lint report check -severity error sensitivity_list_var_modified 
lint report check -severity error seq_block_first_stmt_not_if 
lint report check -severity warning seq_block_has_complex_cond 
lint report check -severity warning seq_block_has_duplicate_assign 
lint report check -severity error seq_block_has_multi_clks 
lint report check -severity error shared_variable_in_multi_process 
lint report check -severity warning signal_assign_in_multi_initial 
lint report check -severity error signal_sync_async 
lint report check -severity error signal_with_negative_value 
lint report check -severity error signed_unsigned_mixed_expr 
lint report check -severity error sim_synth_mismatch_assign_event 
lint report check -severity error sim_synth_mismatch_shared_var 
lint report check -severity error sim_synth_mismatch_tristate_compare 
lint report check -severity error stable_attribute 
lint report check -severity error std_logic_vector_without_range 
lint report check -severity info std_packages_mixed 
lint report check -severity warning string_has_control_char 
lint report check -severity error subroutines_recursive_loop 
lint report check -severity warning sync_read_as_async 
lint report check -severity info synopsys_attribute 
lint report check -severity error synth_pragma_prefix_invalid 
lint report check -severity error synth_pragma_prefix_missing 
lint report check -severity error task_has_event 
lint report check -severity info task_has_event_and_input 
lint report check -severity info task_has_event_and_output 
lint report check -severity error task_in_combo_block 
lint report check -severity error task_in_seq_block 
lint report check -severity error task_sets_global_var 
lint report check -severity warning tristate_enable_with_expr 
lint report check -severity warning tristate_inferred 
lint report check -severity info tristate_multi_driven 
lint report check -severity warning tristate_not_at_top_level 
lint report check -severity info tristate_other_desc_mixed 
lint report check -severity info two_state_data_type 
lint report check -severity info unconnected_inst 
lint report check -severity error unconnected_inst_input 
lint report check -severity warning unconnected_inst_output 
lint report check -severity warning undriven_latch_data 
lint report check -severity warning undriven_latch_enable 
lint report check -severity warning undriven_reg_clock 
lint report check -severity warning undriven_reg_data 
lint report check -severity error undriven_signal 
lint report check -severity info unloaded_input_port 
lint report check -severity error unresolved_module 
lint report check -severity error unsynth_access_type 
lint report check -severity error unsynth_alias_declaration 
lint report check -severity error unsynth_allocator 
lint report check -severity error unsynth_arithmetic_operator 
lint report check -severity error unsynth_array_index_type_enum 
lint report check -severity info unsynth_assert_stmt 
lint report check -severity error unsynth_assign_deassign 
lint report check -severity error unsynth_bidirectional_switch 
lint report check -severity error unsynth_block_stmt_header 
lint report check -severity error unsynth_charge_strength 
lint report check -severity error unsynth_clk_in_concurrent_stmt 
lint report check -severity error unsynth_clocking_style 
lint report check -severity error unsynth_const_redefined 
lint report check -severity error unsynth_dc_shell_script 
lint report check -severity error unsynth_deferred_const 
lint report check -severity error unsynth_defparam 
lint report check -severity error unsynth_delay_in_bidirectional_switch 
lint report check -severity error unsynth_delay_in_blocking_assign 
lint report check -severity error unsynth_delay_in_cmos_switch 
lint report check -severity error unsynth_delay_in_gate 
lint report check -severity error unsynth_delay_in_mos_switch 
lint report check -severity error unsynth_delay_in_net_decl 
lint report check -severity error unsynth_delay_in_stmt 
lint report check -severity error unsynth_delay_in_tristate_gate 
lint report check -severity error unsynth_disable_stmt 
lint report check -severity error unsynth_disconnection_spec 
lint report check -severity error unsynth_drive_strength_assign 
lint report check -severity error unsynth_drive_strength_gate 
lint report check -severity error unsynth_else_after_clk_event 
lint report check -severity error unsynth_enum_encoding_attribute 
lint report check -severity error unsynth_event_var 
lint report check -severity error unsynth_file_type 
lint report check -severity error unsynth_force_release 
lint report check -severity error unsynth_fork_join_block 
lint report check -severity error unsynth_func_returns_real 
lint report check -severity warning unsynth_generic_not_int 
lint report check -severity error unsynth_guarded_block_stmt 
lint report check -severity error unsynth_hier_reference 
lint report check -severity error unsynth_initial_stmt 
lint report check -severity error unsynth_initial_value 
lint report check -severity error unsynth_integer_array 
lint report check -severity error unsynth_mos_switch 
lint report check -severity error unsynth_multi_dim_array 
lint report check -severity error unsynth_multi_wait_with_same_clk 
lint report check -severity error unsynth_physical_type 
lint report check -severity error unsynth_pli_task_func 
lint report check -severity error unsynth_port_type 
lint report check -severity error unsynth_port_type_unconstrained 
lint report check -severity error unsynth_predefined_attribute 
lint report check -severity error unsynth_pulldown 
lint report check -severity error unsynth_pullup 
lint report check -severity error unsynth_real_var 
lint report check -severity error unsynth_repeat 
lint report check -severity error unsynth_repeat_in_nonblocking_assign 
lint report check -severity error unsynth_resolution_func 
lint report check -severity error unsynth_sensitivity_list_conditions 
lint report check -severity error unsynth_shift_operator 
lint report check -severity error unsynth_signal_kind_register_bus 
lint report check -severity error unsynth_specify_block 
lint report check -severity error unsynth_stmt_in_entity 
lint report check -severity error unsynth_time_var 
lint report check -severity error unsynth_tri_net 
lint report check -severity error unsynth_type_declaration_incomplete 
lint report check -severity error unsynth_udp 
lint report check -severity error unsynth_user_defined_attribute 
lint report check -severity error unsynth_wait_stmt 
lint report check -severity error unsynth_wand_wor_net 
lint report check -severity error unsynth_while_in_subprogram 
lint report check -severity error unsynth_while_loop 
lint report check -severity info user_blackbox 
lint report check -severity warning var_assign_in_process 
lint report check -severity warning var_assign_without_deassign 
lint report check -severity warning var_deassign_without_assign 
lint report check -severity error var_forced_without_release 
lint report check -severity error var_index_range_insufficient 
lint report check -severity error var_name_duplicate 
lint report check -severity error var_read_before_set 
lint report check -severity error var_released_without_force 
lint report check -severity warning when_else_nested 
lint report check -severity warning while_loop_iteration_limit 
lint methodology soc -goal implementation 
lint run -d TOP -L work
set qsDebug { lint_gui_mode } 
# 
# Questa Static Verification System
# Version 2021.1 4558100 win64 28-Jan-2021

clear settings -all
clear directives
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
clear settings  -lib
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
lint on clk_port_conn_complex 
lint on clock_gated 
lint on clock_internal 
lint on clock_path_buffer 
lint on clock_signal_as_non_clock 
lint on flop_with_inverted_clock 
lint on bus_bit_as_clk 
lint on clock_in_wait_stmt 
lint on clock_with_both_edges 
lint on seq_block_has_multi_clks 
lint on unsynth_clk_in_concurrent_stmt 
lint on unsynth_clocking_style 
lint on unsynth_else_after_clk_event 
lint on unsynth_multi_wait_with_same_clk 
lint on async_reset_active_high 
lint on bus_conn_to_prim_gate 
lint on feedthrough_path 
lint on flop_clock_reset_loop 
lint on flop_output_as_clock 
lint on flop_redundant 
lint on long_combinational_path 
lint on module_has_blackbox_instance 
lint on re_entrant_output 
lint on tristate_multi_driven 
lint on unconnected_inst 
lint on unconnected_inst_input 
lint on unconnected_inst_output 
lint on undriven_latch_data 
lint on undriven_latch_enable 
lint on undriven_reg_clock 
lint on undriven_reg_data 
lint on undriven_signal 
lint on unloaded_input_port 
lint on const_latch_data 
lint on const_output 
lint on const_reg_clock 
lint on const_reg_data 
lint on const_signal 
lint on mux_select_const 
lint on blackbox_input_conn_inconsistent 
lint on blackbox_output_control_signal 
lint on bus_conn_to_inst_reversed 
lint on combo_path_input_to_output 
lint on generic_map_ordered 
lint on inout_port_exists 
lint on inout_port_not_set 
lint on inout_port_unused 
lint on input_port_set 
lint on module_without_ports 
lint on ordered_port_connection 
lint on port_conn_is_expression 
lint on comment_has_control_char 
lint on comment_not_in_english 
lint on identifier_with_error_warning 
lint on parameter_name_duplicate 
lint on reserved_keyword 
lint on var_name_duplicate 
lint on async_block_top_stmt_not_if 
lint on async_control_is_gated 
lint on async_control_is_internal 
lint on flop_async_reset_const 
lint on flop_without_control 
lint on reset_port_connection_static 
lint on signal_sync_async 
lint on always_has_inconsistent_async_control 
lint on always_has_multiple_async_control 
lint on func_as_reset_condition 
lint on process_has_inconsistent_async_control 
lint on process_has_multiple_async_control 
lint on reset_polarity_mismatch 
lint on reset_pragma_mismatch 
lint on reset_set_non_const_assign 
lint on reset_set_with_both_polarity 
lint on seq_block_first_stmt_not_if 
lint on seq_block_has_complex_cond 
lint on assign_chain 
lint on assign_int_to_reg 
lint on assign_others_to_slice 
lint on assign_real_to_bit 
lint on assign_real_to_int 
lint on assign_real_to_reg 
lint on assign_reg_to_int 
lint on assign_reg_to_real 
lint on assign_to_supply_net 
lint on signal_with_negative_value 
lint on var_assign_without_deassign 
lint on var_deassign_without_assign 
lint on var_forced_without_release 
lint on var_released_without_force 
lint on case_default_redundant 
lint on case_item_invalid 
lint on case_item_not_const 
lint on case_large 
lint on case_nested 
lint on case_others_null 
lint on case_select_const 
lint on case_select_has_expr 
lint on data_event_has_edge 
lint on delay_in_non_flop_expr 
lint on arith_expr_with_conditional_operator 
lint on comparison_has_real_operand 
lint on complex_expression 
lint on condition_const 
lint on condition_has_assign 
lint on condition_is_multi_bit 
lint on conditional_operator_nested 
lint on data_type_bit_select_invalid 
lint on div_mod_rhs_var 
lint on div_mod_rhs_zero 
lint on exponent_negative 
lint on logical_not_on_multi_bit 
lint on logical_operator_on_multi_bit 
lint on multiplication_operator 
lint on operand_redundant 
lint on qualified_expression 
lint on reduction_operator_on_single_bit 
lint on signed_unsigned_mixed_expr 
lint on fsm_state_count_large 
lint on fsm_without_one_hot_encoding 
lint on func_arg_array_constrained 
lint on func_bit_not_set 
lint on func_input_unused 
lint on func_input_width_mismatch 
lint on func_return_before_last_stmt 
lint on func_return_range_fixed 
lint on func_return_range_mismatch 
lint on func_sets_global_var 
lint on func_to_stdlogicvector 
lint on subroutines_recursive_loop 
lint on for_loop_var_init_not_const 
lint on for_stmt_with_complex_logic 
lint on gen_loop_index_not_int 
lint on loop_condition_const 
lint on loop_index_in_multi_always_blocks 
lint on loop_index_modified 
lint on loop_index_not_int 
lint on loop_step_incorrect 
lint on loop_var_not_in_condition 
lint on loop_var_not_in_init 
lint on synth_pragma_prefix_missing 
lint on while_loop_iteration_limit 
lint on module_with_duplicate_ports 
lint on module_with_null_port 
lint on multi_ports_in_single_line 
lint on parameter_count_large 
lint on sensitivity_list_edge_multi_bit 
lint on sensitivity_list_operator_unexpected 
lint on sensitivity_list_signal_repeated 
lint on procedure_sets_global_var 
lint on task_in_combo_block 
lint on task_in_seq_block 
lint on task_sets_global_var 
lint on loop_with_next_exit 
lint on unsynth_allocator 
lint on unsynth_wand_wor_net 
lint on assign_with_multi_arith_operations 
lint on div_mod_rem_operand_complex_expr 
lint on loop_without_break 
lint on tristate_enable_with_expr 
lint on unsynth_dc_shell_script 
lint on unsynth_sensitivity_list_conditions 
lint on always_exceeds_line_limit 
lint on always_signal_assign_large 
lint on always_without_event 
lint on array_index_with_expr 
lint on bit_order_reversed 
lint on bus_bits_in_multi_seq_blocks 
lint on bus_bits_not_read 
lint on bus_bits_not_set 
lint on case_condition_with_tristate 
lint on case_stmt_with_parallel_case 
lint on case_with_memory_output 
lint on concurrent_block_with_duplicate_assign 
lint on conversion_to_stdlogicvector_invalid 
lint on data_type_std_ulogic 
lint on design_ware_inst 
lint on else_condition_dangling 
lint on empty_block 
lint on empty_module 
lint on empty_stmt 
lint on enum_decl_invalid 
lint on flop_output_in_initial 
lint on func_expr_input_size_mismatch 
lint on gen_inst_label_duplicate 
lint on gen_label_duplicate 
lint on gen_label_missing 
lint on if_condition_with_tristate 
lint on if_else_if_can_be_case 
lint on if_else_nested_large 
lint on if_stmt_shares_arithmetic_operator 
lint on if_stmt_with_arith_expr 
lint on if_with_memory_output 
lint on implicit_wire 
lint on inferred_blackbox 
lint on inst_param_width_overflow 
lint on int_without_range 
lint on latch_inferred 
lint on line_char_large 
lint on memory_not_set 
lint on memory_redefined 
lint on multi_wave_element 
lint on part_select_illegal 
lint on power_operand_invalid 
lint on pragma_coverage_off_nested 
lint on pragma_translate_off_nested 
lint on pragma_translate_on_nested 
lint on procedure_call 
lint on process_exceeds_line_limit 
lint on process_signal_assign_large 
lint on process_var_assign_disorder 
lint on process_without_event 
lint on record_type 
lint on reference_event_without_edge 
lint on selected_signal_stmt 
lint on seq_block_has_duplicate_assign 
lint on shared_variable_in_multi_process 
lint on signal_assign_in_multi_initial 
lint on stable_attribute 
lint on std_packages_mixed 
lint on string_has_control_char 
lint on sync_read_as_async 
lint on synopsys_attribute 
lint on tristate_inferred 
lint on tristate_not_at_top_level 
lint on tristate_other_desc_mixed 
lint on two_state_data_type 
lint on unresolved_module 
lint on user_blackbox 
lint on var_assign_in_process 
lint on var_index_range_insufficient 
lint on var_read_before_set 
lint on when_else_nested 
lint on assign_width_overflow 
lint on assign_width_underflow 
lint on case_width_mismatch 
lint on comparison_width_mismatch 
lint on concat_expr_with_unsized_operand 
lint on div_mod_lhs_too_wide 
lint on div_mod_rhs_too_wide 
lint on expr_operands_width_mismatch 
lint on inst_port_width_mismatch 
lint on func_return_value_unspecified 
lint on sensitivity_list_var_modified 
lint on always_has_multiple_events 
lint on assign_or_comparison_has_x 
lint on assign_or_comparison_has_z 
lint on case_default_missing 
lint on case_default_not_last_item 
lint on case_item_duplicate 
lint on case_pragma_redundant 
lint on case_with_x_z 
lint on casex 
lint on casez 
lint on casez_has_x 
lint on data_type_not_recommended 
lint on for_loop_with_wait 
lint on func_nonblocking_assign 
lint on incomplete_case_stmt_with_full_case 
lint on index_x_z 
lint on process_has_async_set_reset 
lint on sensitivity_list_var_missing 
lint on sim_synth_mismatch_assign_event 
lint on sim_synth_mismatch_shared_var 
lint on sim_synth_mismatch_tristate_compare 
lint on std_logic_vector_without_range 
lint on unsynth_delay_in_blocking_assign 
lint on unsynth_delay_in_stmt 
lint on unsynth_initial_value 
lint on assigns_mixed 
lint on assigns_mixed_in_always_block 
lint on blocking_assign_in_seq_block 
lint on combo_loop 
lint on combo_loop_with_latch 
lint on multi_driven_signal 
lint on nonblocking_assign_and_delay_in_always 
lint on nonblocking_assign_in_combo_block 
lint on attribute_with_keyword_all 
lint on const_with_inconsistent_value 
lint on repeat_ctrl_not_const 
lint on unsynth_access_type 
lint on unsynth_alias_declaration 
lint on unsynth_assert_stmt 
lint on unsynth_assign_deassign 
lint on unsynth_bidirectional_switch 
lint on unsynth_charge_strength 
lint on unsynth_deferred_const 
lint on unsynth_defparam 
lint on unsynth_disable_stmt 
lint on unsynth_disconnection_spec 
lint on unsynth_drive_strength_assign 
lint on unsynth_drive_strength_gate 
lint on unsynth_enum_encoding_attribute 
lint on unsynth_event_var 
lint on unsynth_file_type 
lint on unsynth_force_release 
lint on unsynth_fork_join_block 
lint on unsynth_guarded_block_stmt 
lint on unsynth_initial_stmt 
lint on unsynth_integer_array 
lint on unsynth_mos_switch 
lint on unsynth_multi_dim_array 
lint on unsynth_pli_task_func 
lint on unsynth_port_type 
lint on unsynth_port_type_unconstrained 
lint on unsynth_predefined_attribute 
lint on unsynth_pulldown 
lint on unsynth_pullup 
lint on unsynth_real_var 
lint on unsynth_repeat 
lint on unsynth_resolution_func 
lint on unsynth_shift_operator 
lint on unsynth_signal_kind_register_bus 
lint on unsynth_specify_block 
lint on unsynth_time_var 
lint on unsynth_tri_net 
lint on unsynth_udp 
lint on unsynth_user_defined_attribute 
lint on unsynth_wait_stmt 
lint on always_has_nested_event_control 
lint on case_eq_operator 
lint on div_mod_rhs_invalid 
lint on port_exp_with_integer 
lint on sensitivity_list_var_both_edges 
lint on synth_pragma_prefix_invalid 
lint on task_has_event 
lint on unsynth_arithmetic_operator 
lint on unsynth_array_index_type_enum 
lint on unsynth_block_stmt_header 
lint on unsynth_const_redefined 
lint on unsynth_delay_in_bidirectional_switch 
lint on unsynth_delay_in_cmos_switch 
lint on unsynth_delay_in_gate 
lint on unsynth_delay_in_mos_switch 
lint on unsynth_delay_in_net_decl 
lint on unsynth_delay_in_tristate_gate 
lint on unsynth_func_returns_real 
lint on unsynth_generic_not_int 
lint on unsynth_hier_reference 
lint on unsynth_physical_type 
lint on unsynth_repeat_in_nonblocking_assign 
lint on unsynth_stmt_in_entity 
lint on unsynth_type_declaration_incomplete 
lint on unsynth_while_in_subprogram 
lint on unsynth_while_loop 
lint on task_has_event_and_input 
lint on task_has_event_and_output 
lint preference -allow_non_port_data_types reg wire tri integer logic interface -allow_port_data_types reg wire tri integer logic interface 
lint report check -severity info always_exceeds_line_limit 
lint report check -severity warning always_has_inconsistent_async_control 
lint report check -severity info always_has_multiple_async_control 
lint report check -severity error always_has_multiple_events 
lint report check -severity warning always_has_nested_event_control 
lint report check -severity warning always_signal_assign_large 
lint report check -severity error always_without_event 
lint report check -severity error arith_expr_with_conditional_operator 
lint report check -severity error array_index_with_expr 
lint report check -severity warning assign_chain 
lint report check -severity error assign_int_to_reg 
lint report check -severity error assign_or_comparison_has_x 
lint report check -severity error assign_or_comparison_has_z 
lint report check -severity info assign_others_to_slice 
lint report check -severity error assign_real_to_bit 
lint report check -severity error assign_real_to_int 
lint report check -severity error assign_real_to_reg 
lint report check -severity error assign_reg_to_int 
lint report check -severity error assign_reg_to_real 
lint report check -severity info assign_to_supply_net 
lint report check -severity error assign_width_overflow 
lint report check -severity error assign_width_underflow 
lint report check -severity warning assign_with_multi_arith_operations 
lint report check -severity error assigns_mixed 
lint report check -severity error assigns_mixed_in_always_block 
lint report check -severity error async_block_top_stmt_not_if 
lint report check -severity warning async_control_is_gated 
lint report check -severity error async_control_is_internal 
lint report check -severity info async_reset_active_high 
lint report check -severity error attribute_with_keyword_all 
lint report check -severity warning bit_order_reversed 
lint report check -severity error blackbox_input_conn_inconsistent 
lint report check -severity error blackbox_output_control_signal 
lint report check -severity error blocking_assign_in_seq_block 
lint report check -severity error bus_bit_as_clk 
lint report check -severity error bus_bits_in_multi_seq_blocks 
lint report check -severity warning bus_bits_not_read 
lint report check -severity warning bus_bits_not_set 
lint report check -severity error bus_conn_to_inst_reversed 
lint report check -severity warning bus_conn_to_prim_gate 
lint report check -severity error case_condition_with_tristate 
lint report check -severity error case_default_missing 
lint report check -severity error case_default_not_last_item 
lint report check -severity info case_default_redundant 
lint report check -severity error case_eq_operator 
lint report check -severity error case_item_duplicate 
lint report check -severity error case_item_invalid 
lint report check -severity error case_item_not_const 
lint report check -severity info case_large 
lint report check -severity warning case_nested 
lint report check -severity info case_others_null 
lint report check -severity info case_pragma_redundant 
lint report check -severity error case_select_const 
lint report check -severity warning case_select_has_expr 
lint report check -severity error case_stmt_with_parallel_case 
lint report check -severity error case_width_mismatch 
lint report check -severity error case_with_memory_output 
lint report check -severity error case_with_x_z 
lint report check -severity error casex 
lint report check -severity info casez 
lint report check -severity error casez_has_x 
lint report check -severity error clk_port_conn_complex 
lint report check -severity warning clock_gated 
lint report check -severity error clock_in_wait_stmt 
lint report check -severity warning clock_internal 
lint report check -severity info clock_path_buffer 
lint report check -severity error clock_signal_as_non_clock 
lint report check -severity info clock_with_both_edges 
lint report check -severity error combo_loop 
lint report check -severity error combo_loop_with_latch 
lint report check -severity info combo_path_input_to_output 
lint report check -severity info comment_has_control_char 
lint report check -severity info comment_not_in_english 
lint report check -severity info comparison_has_real_operand 
lint report check -severity error comparison_width_mismatch 
lint report check -severity info complex_expression 
lint report check -severity info concat_expr_with_unsized_operand 
lint report check -severity warning concurrent_block_with_duplicate_assign 
lint report check -severity warning condition_const 
lint report check -severity error condition_has_assign 
lint report check -severity error condition_is_multi_bit 
lint report check -severity info conditional_operator_nested 
lint report check -severity info const_latch_data 
lint report check -severity info const_output 
lint report check -severity info const_reg_clock 
lint report check -severity info const_reg_data 
lint report check -severity info const_signal 
lint report check -severity error const_with_inconsistent_value 
lint report check -severity error conversion_to_stdlogicvector_invalid 
lint report check -severity warning data_event_has_edge 
lint report check -severity warning data_type_bit_select_invalid 
lint report check -severity warning data_type_not_recommended 
lint report check -severity info data_type_std_ulogic 
lint report check -severity info delay_in_non_flop_expr 
lint report check -severity info design_ware_inst 
lint report check -severity warning div_mod_lhs_too_wide 
lint report check -severity warning div_mod_rem_operand_complex_expr 
lint report check -severity error div_mod_rhs_invalid 
lint report check -severity warning div_mod_rhs_too_wide 
lint report check -severity error div_mod_rhs_var 
lint report check -severity error div_mod_rhs_zero 
lint report check -severity error else_condition_dangling 
lint report check -severity error empty_block 
lint report check -severity error empty_module 
lint report check -severity info empty_stmt 
lint report check -severity warning enum_decl_invalid 
lint report check -severity error exponent_negative 
lint report check -severity error expr_operands_width_mismatch 
lint report check -severity info feedthrough_path 
lint report check -severity info flop_async_reset_const 
lint report check -severity error flop_clock_reset_loop 
lint report check -severity warning flop_output_as_clock 
lint report check -severity warning flop_output_in_initial 
lint report check -severity info flop_redundant 
lint report check -severity info flop_with_inverted_clock 
lint report check -severity info flop_without_control 
lint report check -severity error for_loop_var_init_not_const 
lint report check -severity error for_loop_with_wait 
lint report check -severity warning for_stmt_with_complex_logic 
lint report check -severity info fsm_state_count_large 
lint report check -severity info fsm_without_one_hot_encoding 
lint report check -severity warning func_arg_array_constrained 
lint report check -severity error func_as_reset_condition 
lint report check -severity error func_bit_not_set 
lint report check -severity error func_expr_input_size_mismatch 
lint report check -severity info func_input_unused 
lint report check -severity error func_input_width_mismatch 
lint report check -severity error func_nonblocking_assign 
lint report check -severity warning func_return_before_last_stmt 
lint report check -severity error func_return_range_fixed 
lint report check -severity error func_return_range_mismatch 
lint report check -severity error func_return_value_unspecified 
lint report check -severity error func_sets_global_var 
lint report check -severity warning func_to_stdlogicvector 
lint report check -severity error gen_inst_label_duplicate 
lint report check -severity error gen_label_duplicate 
lint report check -severity info gen_label_missing 
lint report check -severity error gen_loop_index_not_int 
lint report check -severity warning generic_map_ordered 
lint report check -severity info identifier_with_error_warning 
lint report check -severity error if_condition_with_tristate 
lint report check -severity info if_else_if_can_be_case 
lint report check -severity warning if_else_nested_large 
lint report check -severity error if_stmt_shares_arithmetic_operator 
lint report check -severity warning if_stmt_with_arith_expr 
lint report check -severity warning if_with_memory_output 
lint report check -severity info implicit_wire 
lint report check -severity error incomplete_case_stmt_with_full_case 
lint report check -severity error index_x_z 
lint report check -severity error inferred_blackbox 
lint report check -severity info inout_port_exists 
lint report check -severity warning inout_port_not_set 
lint report check -severity info inout_port_unused 
lint report check -severity error input_port_set 
lint report check -severity error inst_param_width_overflow 
lint report check -severity error inst_port_width_mismatch 
lint report check -severity info int_without_range 
lint report check -severity warning latch_inferred 
lint report check -severity info line_char_large 
lint report check -severity warning logical_not_on_multi_bit 
lint report check -severity warning logical_operator_on_multi_bit 
lint report check -severity error long_combinational_path 
lint report check -severity error loop_condition_const 
lint report check -severity error loop_index_in_multi_always_blocks 
lint report check -severity error loop_index_modified 
lint report check -severity error loop_index_not_int 
lint report check -severity error loop_step_incorrect 
lint report check -severity error loop_var_not_in_condition 
lint report check -severity error loop_var_not_in_init 
lint report check -severity error loop_with_next_exit 
lint report check -severity error loop_without_break 
lint report check -severity warning memory_not_set 
lint report check -severity warning memory_redefined 
lint report check -severity warning module_has_blackbox_instance 
lint report check -severity error module_with_duplicate_ports 
lint report check -severity error module_with_null_port 
lint report check -severity warning module_without_ports 
lint report check -severity error multi_driven_signal 
lint report check -severity info multi_ports_in_single_line 
lint report check -severity warning multi_wave_element 
lint report check -severity info multiplication_operator 
lint report check -severity warning mux_select_const 
lint report check -severity warning nonblocking_assign_and_delay_in_always 
lint report check -severity error nonblocking_assign_in_combo_block 
lint report check -severity error operand_redundant 
lint report check -severity warning ordered_port_connection 
lint report check -severity info parameter_count_large 
lint report check -severity info parameter_name_duplicate 
lint report check -severity error part_select_illegal 
lint report check -severity error port_conn_is_expression 
lint report check -severity error port_exp_with_integer 
lint report check -severity error power_operand_invalid 
lint report check -severity warning pragma_coverage_off_nested 
lint report check -severity warning pragma_translate_off_nested 
lint report check -severity error pragma_translate_on_nested 
lint report check -severity warning procedure_call 
lint report check -severity error procedure_sets_global_var 
lint report check -severity warning process_exceeds_line_limit 
lint report check -severity info process_has_async_set_reset 
lint report check -severity warning process_has_inconsistent_async_control 
lint report check -severity info process_has_multiple_async_control 
lint report check -severity warning process_signal_assign_large 
lint report check -severity warning process_var_assign_disorder 
lint report check -severity error process_without_event 
lint report check -severity info qualified_expression 
lint report check -severity info re_entrant_output 
lint report check -severity warning record_type 
lint report check -severity info reduction_operator_on_single_bit 
lint report check -severity warning reference_event_without_edge 
lint report check -severity error repeat_ctrl_not_const 
lint report check -severity info reserved_keyword 
lint report check -severity error reset_polarity_mismatch 
lint report check -severity info reset_port_connection_static 
lint report check -severity error reset_pragma_mismatch 
lint report check -severity error reset_set_non_const_assign 
lint report check -severity error reset_set_with_both_polarity 
lint report check -severity warning selected_signal_stmt 
lint report check -severity error sensitivity_list_edge_multi_bit 
lint report check -severity error sensitivity_list_operator_unexpected 
lint report check -severity warning sensitivity_list_signal_repeated 
lint report check -severity warning sensitivity_list_var_both_edges 
lint report check -severity error sensitivity_list_var_missing 
lint report check -severity error sensitivity_list_var_modified 
lint report check -severity error seq_block_first_stmt_not_if 
lint report check -severity warning seq_block_has_complex_cond 
lint report check -severity warning seq_block_has_duplicate_assign 
lint report check -severity error seq_block_has_multi_clks 
lint report check -severity error shared_variable_in_multi_process 
lint report check -severity warning signal_assign_in_multi_initial 
lint report check -severity error signal_sync_async 
lint report check -severity error signal_with_negative_value 
lint report check -severity error signed_unsigned_mixed_expr 
lint report check -severity error sim_synth_mismatch_assign_event 
lint report check -severity error sim_synth_mismatch_shared_var 
lint report check -severity error sim_synth_mismatch_tristate_compare 
lint report check -severity error stable_attribute 
lint report check -severity error std_logic_vector_without_range 
lint report check -severity info std_packages_mixed 
lint report check -severity warning string_has_control_char 
lint report check -severity error subroutines_recursive_loop 
lint report check -severity warning sync_read_as_async 
lint report check -severity info synopsys_attribute 
lint report check -severity error synth_pragma_prefix_invalid 
lint report check -severity error synth_pragma_prefix_missing 
lint report check -severity error task_has_event 
lint report check -severity info task_has_event_and_input 
lint report check -severity info task_has_event_and_output 
lint report check -severity error task_in_combo_block 
lint report check -severity error task_in_seq_block 
lint report check -severity error task_sets_global_var 
lint report check -severity warning tristate_enable_with_expr 
lint report check -severity warning tristate_inferred 
lint report check -severity info tristate_multi_driven 
lint report check -severity warning tristate_not_at_top_level 
lint report check -severity info tristate_other_desc_mixed 
lint report check -severity info two_state_data_type 
lint report check -severity info unconnected_inst 
lint report check -severity error unconnected_inst_input 
lint report check -severity warning unconnected_inst_output 
lint report check -severity warning undriven_latch_data 
lint report check -severity warning undriven_latch_enable 
lint report check -severity warning undriven_reg_clock 
lint report check -severity warning undriven_reg_data 
lint report check -severity error undriven_signal 
lint report check -severity info unloaded_input_port 
lint report check -severity error unresolved_module 
lint report check -severity error unsynth_access_type 
lint report check -severity error unsynth_alias_declaration 
lint report check -severity error unsynth_allocator 
lint report check -severity error unsynth_arithmetic_operator 
lint report check -severity error unsynth_array_index_type_enum 
lint report check -severity info unsynth_assert_stmt 
lint report check -severity error unsynth_assign_deassign 
lint report check -severity error unsynth_bidirectional_switch 
lint report check -severity error unsynth_block_stmt_header 
lint report check -severity error unsynth_charge_strength 
lint report check -severity error unsynth_clk_in_concurrent_stmt 
lint report check -severity error unsynth_clocking_style 
lint report check -severity error unsynth_const_redefined 
lint report check -severity error unsynth_dc_shell_script 
lint report check -severity error unsynth_deferred_const 
lint report check -severity error unsynth_defparam 
lint report check -severity error unsynth_delay_in_bidirectional_switch 
lint report check -severity error unsynth_delay_in_blocking_assign 
lint report check -severity error unsynth_delay_in_cmos_switch 
lint report check -severity error unsynth_delay_in_gate 
lint report check -severity error unsynth_delay_in_mos_switch 
lint report check -severity error unsynth_delay_in_net_decl 
lint report check -severity error unsynth_delay_in_stmt 
lint report check -severity error unsynth_delay_in_tristate_gate 
lint report check -severity error unsynth_disable_stmt 
lint report check -severity error unsynth_disconnection_spec 
lint report check -severity error unsynth_drive_strength_assign 
lint report check -severity error unsynth_drive_strength_gate 
lint report check -severity error unsynth_else_after_clk_event 
lint report check -severity error unsynth_enum_encoding_attribute 
lint report check -severity error unsynth_event_var 
lint report check -severity error unsynth_file_type 
lint report check -severity error unsynth_force_release 
lint report check -severity error unsynth_fork_join_block 
lint report check -severity error unsynth_func_returns_real 
lint report check -severity warning unsynth_generic_not_int 
lint report check -severity error unsynth_guarded_block_stmt 
lint report check -severity error unsynth_hier_reference 
lint report check -severity error unsynth_initial_stmt 
lint report check -severity error unsynth_initial_value 
lint report check -severity error unsynth_integer_array 
lint report check -severity error unsynth_mos_switch 
lint report check -severity error unsynth_multi_dim_array 
lint report check -severity error unsynth_multi_wait_with_same_clk 
lint report check -severity error unsynth_physical_type 
lint report check -severity error unsynth_pli_task_func 
lint report check -severity error unsynth_port_type 
lint report check -severity error unsynth_port_type_unconstrained 
lint report check -severity error unsynth_predefined_attribute 
lint report check -severity error unsynth_pulldown 
lint report check -severity error unsynth_pullup 
lint report check -severity error unsynth_real_var 
lint report check -severity error unsynth_repeat 
lint report check -severity error unsynth_repeat_in_nonblocking_assign 
lint report check -severity error unsynth_resolution_func 
lint report check -severity error unsynth_sensitivity_list_conditions 
lint report check -severity error unsynth_shift_operator 
lint report check -severity error unsynth_signal_kind_register_bus 
lint report check -severity error unsynth_specify_block 
lint report check -severity error unsynth_stmt_in_entity 
lint report check -severity error unsynth_time_var 
lint report check -severity error unsynth_tri_net 
lint report check -severity error unsynth_type_declaration_incomplete 
lint report check -severity error unsynth_udp 
lint report check -severity error unsynth_user_defined_attribute 
lint report check -severity error unsynth_wait_stmt 
lint report check -severity error unsynth_wand_wor_net 
lint report check -severity error unsynth_while_in_subprogram 
lint report check -severity error unsynth_while_loop 
lint report check -severity info user_blackbox 
lint report check -severity warning var_assign_in_process 
lint report check -severity warning var_assign_without_deassign 
lint report check -severity warning var_deassign_without_assign 
lint report check -severity error var_forced_without_release 
lint report check -severity error var_index_range_insufficient 
lint report check -severity error var_name_duplicate 
lint report check -severity error var_read_before_set 
lint report check -severity error var_released_without_force 
lint report check -severity warning when_else_nested 
lint report check -severity warning while_loop_iteration_limit 
lint methodology soc -goal implementation 
lint run -d TOP -L work
set qsDebug { lint_gui_mode } 
# 
# Questa Static Verification System
# Version 2021.1 4558100 win64 28-Jan-2021

clear settings -all
clear directives
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
clear settings  -lib
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
lint on clk_port_conn_complex 
lint on clock_gated 
lint on clock_internal 
lint on clock_path_buffer 
lint on clock_signal_as_non_clock 
lint on flop_with_inverted_clock 
lint on bus_bit_as_clk 
lint on clock_in_wait_stmt 
lint on clock_with_both_edges 
lint on seq_block_has_multi_clks 
lint on unsynth_clk_in_concurrent_stmt 
lint on unsynth_clocking_style 
lint on unsynth_else_after_clk_event 
lint on unsynth_multi_wait_with_same_clk 
lint on async_reset_active_high 
lint on bus_conn_to_prim_gate 
lint on feedthrough_path 
lint on flop_clock_reset_loop 
lint on flop_output_as_clock 
lint on flop_redundant 
lint on long_combinational_path 
lint on module_has_blackbox_instance 
lint on re_entrant_output 
lint on tristate_multi_driven 
lint on unconnected_inst 
lint on unconnected_inst_input 
lint on unconnected_inst_output 
lint on undriven_latch_data 
lint on undriven_latch_enable 
lint on undriven_reg_clock 
lint on undriven_reg_data 
lint on undriven_signal 
lint on unloaded_input_port 
lint on const_latch_data 
lint on const_output 
lint on const_reg_clock 
lint on const_reg_data 
lint on const_signal 
lint on mux_select_const 
lint on blackbox_input_conn_inconsistent 
lint on blackbox_output_control_signal 
lint on bus_conn_to_inst_reversed 
lint on combo_path_input_to_output 
lint on generic_map_ordered 
lint on inout_port_exists 
lint on inout_port_not_set 
lint on inout_port_unused 
lint on input_port_set 
lint on module_without_ports 
lint on ordered_port_connection 
lint on port_conn_is_expression 
lint on comment_has_control_char 
lint on comment_not_in_english 
lint on identifier_with_error_warning 
lint on parameter_name_duplicate 
lint on reserved_keyword 
lint on var_name_duplicate 
lint on async_block_top_stmt_not_if 
lint on async_control_is_gated 
lint on async_control_is_internal 
lint on flop_async_reset_const 
lint on flop_without_control 
lint on reset_port_connection_static 
lint on signal_sync_async 
lint on always_has_inconsistent_async_control 
lint on always_has_multiple_async_control 
lint on func_as_reset_condition 
lint on process_has_inconsistent_async_control 
lint on process_has_multiple_async_control 
lint on reset_polarity_mismatch 
lint on reset_pragma_mismatch 
lint on reset_set_non_const_assign 
lint on reset_set_with_both_polarity 
lint on seq_block_first_stmt_not_if 
lint on seq_block_has_complex_cond 
lint on assign_chain 
lint on assign_int_to_reg 
lint on assign_others_to_slice 
lint on assign_real_to_bit 
lint on assign_real_to_int 
lint on assign_real_to_reg 
lint on assign_reg_to_int 
lint on assign_reg_to_real 
lint on assign_to_supply_net 
lint on signal_with_negative_value 
lint on var_assign_without_deassign 
lint on var_deassign_without_assign 
lint on var_forced_without_release 
lint on var_released_without_force 
lint on case_default_redundant 
lint on case_item_invalid 
lint on case_item_not_const 
lint on case_large 
lint on case_nested 
lint on case_others_null 
lint on case_select_const 
lint on case_select_has_expr 
lint on data_event_has_edge 
lint on delay_in_non_flop_expr 
lint on arith_expr_with_conditional_operator 
lint on comparison_has_real_operand 
lint on complex_expression 
lint on condition_const 
lint on condition_has_assign 
lint on condition_is_multi_bit 
lint on conditional_operator_nested 
lint on data_type_bit_select_invalid 
lint on div_mod_rhs_var 
lint on div_mod_rhs_zero 
lint on exponent_negative 
lint on logical_not_on_multi_bit 
lint on logical_operator_on_multi_bit 
lint on multiplication_operator 
lint on operand_redundant 
lint on qualified_expression 
lint on reduction_operator_on_single_bit 
lint on signed_unsigned_mixed_expr 
lint on fsm_state_count_large 
lint on fsm_without_one_hot_encoding 
lint on func_arg_array_constrained 
lint on func_bit_not_set 
lint on func_input_unused 
lint on func_input_width_mismatch 
lint on func_return_before_last_stmt 
lint on func_return_range_fixed 
lint on func_return_range_mismatch 
lint on func_sets_global_var 
lint on func_to_stdlogicvector 
lint on subroutines_recursive_loop 
lint on for_loop_var_init_not_const 
lint on for_stmt_with_complex_logic 
lint on gen_loop_index_not_int 
lint on loop_condition_const 
lint on loop_index_in_multi_always_blocks 
lint on loop_index_modified 
lint on loop_index_not_int 
lint on loop_step_incorrect 
lint on loop_var_not_in_condition 
lint on loop_var_not_in_init 
lint on synth_pragma_prefix_missing 
lint on while_loop_iteration_limit 
lint on module_with_duplicate_ports 
lint on module_with_null_port 
lint on multi_ports_in_single_line 
lint on parameter_count_large 
lint on sensitivity_list_edge_multi_bit 
lint on sensitivity_list_operator_unexpected 
lint on sensitivity_list_signal_repeated 
lint on procedure_sets_global_var 
lint on task_in_combo_block 
lint on task_in_seq_block 
lint on task_sets_global_var 
lint on loop_with_next_exit 
lint on unsynth_allocator 
lint on unsynth_wand_wor_net 
lint on assign_with_multi_arith_operations 
lint on div_mod_rem_operand_complex_expr 
lint on loop_without_break 
lint on tristate_enable_with_expr 
lint on unsynth_dc_shell_script 
lint on unsynth_sensitivity_list_conditions 
lint on always_exceeds_line_limit 
lint on always_signal_assign_large 
lint on always_without_event 
lint on array_index_with_expr 
lint on bit_order_reversed 
lint on bus_bits_in_multi_seq_blocks 
lint on bus_bits_not_read 
lint on bus_bits_not_set 
lint on case_condition_with_tristate 
lint on case_stmt_with_parallel_case 
lint on case_with_memory_output 
lint on concurrent_block_with_duplicate_assign 
lint on conversion_to_stdlogicvector_invalid 
lint on data_type_std_ulogic 
lint on design_ware_inst 
lint on else_condition_dangling 
lint on empty_block 
lint on empty_module 
lint on empty_stmt 
lint on enum_decl_invalid 
lint on flop_output_in_initial 
lint on func_expr_input_size_mismatch 
lint on gen_inst_label_duplicate 
lint on gen_label_duplicate 
lint on gen_label_missing 
lint on if_condition_with_tristate 
lint on if_else_if_can_be_case 
lint on if_else_nested_large 
lint on if_stmt_shares_arithmetic_operator 
lint on if_stmt_with_arith_expr 
lint on if_with_memory_output 
lint on implicit_wire 
lint on inferred_blackbox 
lint on inst_param_width_overflow 
lint on int_without_range 
lint on latch_inferred 
lint on line_char_large 
lint on memory_not_set 
lint on memory_redefined 
lint on multi_wave_element 
lint on part_select_illegal 
lint on power_operand_invalid 
lint on pragma_coverage_off_nested 
lint on pragma_translate_off_nested 
lint on pragma_translate_on_nested 
lint on procedure_call 
lint on process_exceeds_line_limit 
lint on process_signal_assign_large 
lint on process_var_assign_disorder 
lint on process_without_event 
lint on record_type 
lint on reference_event_without_edge 
lint on selected_signal_stmt 
lint on seq_block_has_duplicate_assign 
lint on shared_variable_in_multi_process 
lint on signal_assign_in_multi_initial 
lint on stable_attribute 
lint on std_packages_mixed 
lint on string_has_control_char 
lint on sync_read_as_async 
lint on synopsys_attribute 
lint on tristate_inferred 
lint on tristate_not_at_top_level 
lint on tristate_other_desc_mixed 
lint on two_state_data_type 
lint on unresolved_module 
lint on user_blackbox 
lint on var_assign_in_process 
lint on var_index_range_insufficient 
lint on var_read_before_set 
lint on when_else_nested 
lint on assign_width_overflow 
lint on assign_width_underflow 
lint on case_width_mismatch 
lint on comparison_width_mismatch 
lint on concat_expr_with_unsized_operand 
lint on div_mod_lhs_too_wide 
lint on div_mod_rhs_too_wide 
lint on expr_operands_width_mismatch 
lint on inst_port_width_mismatch 
lint on func_return_value_unspecified 
lint on sensitivity_list_var_modified 
lint on always_has_multiple_events 
lint on assign_or_comparison_has_x 
lint on assign_or_comparison_has_z 
lint on case_default_missing 
lint on case_default_not_last_item 
lint on case_item_duplicate 
lint on case_pragma_redundant 
lint on case_with_x_z 
lint on casex 
lint on casez 
lint on casez_has_x 
lint on data_type_not_recommended 
lint on for_loop_with_wait 
lint on func_nonblocking_assign 
lint on incomplete_case_stmt_with_full_case 
lint on index_x_z 
lint on process_has_async_set_reset 
lint on sensitivity_list_var_missing 
lint on sim_synth_mismatch_assign_event 
lint on sim_synth_mismatch_shared_var 
lint on sim_synth_mismatch_tristate_compare 
lint on std_logic_vector_without_range 
lint on unsynth_delay_in_blocking_assign 
lint on unsynth_delay_in_stmt 
lint on unsynth_initial_value 
lint on assigns_mixed 
lint on assigns_mixed_in_always_block 
lint on blocking_assign_in_seq_block 
lint on combo_loop 
lint on combo_loop_with_latch 
lint on multi_driven_signal 
lint on nonblocking_assign_and_delay_in_always 
lint on nonblocking_assign_in_combo_block 
lint on attribute_with_keyword_all 
lint on const_with_inconsistent_value 
lint on repeat_ctrl_not_const 
lint on unsynth_access_type 
lint on unsynth_alias_declaration 
lint on unsynth_assert_stmt 
lint on unsynth_assign_deassign 
lint on unsynth_bidirectional_switch 
lint on unsynth_charge_strength 
lint on unsynth_deferred_const 
lint on unsynth_defparam 
lint on unsynth_disable_stmt 
lint on unsynth_disconnection_spec 
lint on unsynth_drive_strength_assign 
lint on unsynth_drive_strength_gate 
lint on unsynth_enum_encoding_attribute 
lint on unsynth_event_var 
lint on unsynth_file_type 
lint on unsynth_force_release 
lint on unsynth_fork_join_block 
lint on unsynth_guarded_block_stmt 
lint on unsynth_initial_stmt 
lint on unsynth_integer_array 
lint on unsynth_mos_switch 
lint on unsynth_multi_dim_array 
lint on unsynth_pli_task_func 
lint on unsynth_port_type 
lint on unsynth_port_type_unconstrained 
lint on unsynth_predefined_attribute 
lint on unsynth_pulldown 
lint on unsynth_pullup 
lint on unsynth_real_var 
lint on unsynth_repeat 
lint on unsynth_resolution_func 
lint on unsynth_shift_operator 
lint on unsynth_signal_kind_register_bus 
lint on unsynth_specify_block 
lint on unsynth_time_var 
lint on unsynth_tri_net 
lint on unsynth_udp 
lint on unsynth_user_defined_attribute 
lint on unsynth_wait_stmt 
lint on always_has_nested_event_control 
lint on case_eq_operator 
lint on div_mod_rhs_invalid 
lint on port_exp_with_integer 
lint on sensitivity_list_var_both_edges 
lint on synth_pragma_prefix_invalid 
lint on task_has_event 
lint on unsynth_arithmetic_operator 
lint on unsynth_array_index_type_enum 
lint on unsynth_block_stmt_header 
lint on unsynth_const_redefined 
lint on unsynth_delay_in_bidirectional_switch 
lint on unsynth_delay_in_cmos_switch 
lint on unsynth_delay_in_gate 
lint on unsynth_delay_in_mos_switch 
lint on unsynth_delay_in_net_decl 
lint on unsynth_delay_in_tristate_gate 
lint on unsynth_func_returns_real 
lint on unsynth_generic_not_int 
lint on unsynth_hier_reference 
lint on unsynth_physical_type 
lint on unsynth_repeat_in_nonblocking_assign 
lint on unsynth_stmt_in_entity 
lint on unsynth_type_declaration_incomplete 
lint on unsynth_while_in_subprogram 
lint on unsynth_while_loop 
lint on task_has_event_and_input 
lint on task_has_event_and_output 
lint preference -allow_non_port_data_types reg wire tri integer logic interface -allow_port_data_types reg wire tri integer logic interface 
lint report check -severity info always_exceeds_line_limit 
lint report check -severity warning always_has_inconsistent_async_control 
lint report check -severity info always_has_multiple_async_control 
lint report check -severity error always_has_multiple_events 
lint report check -severity warning always_has_nested_event_control 
lint report check -severity warning always_signal_assign_large 
lint report check -severity error always_without_event 
lint report check -severity error arith_expr_with_conditional_operator 
lint report check -severity error array_index_with_expr 
lint report check -severity warning assign_chain 
lint report check -severity error assign_int_to_reg 
lint report check -severity error assign_or_comparison_has_x 
lint report check -severity error assign_or_comparison_has_z 
lint report check -severity info assign_others_to_slice 
lint report check -severity error assign_real_to_bit 
lint report check -severity error assign_real_to_int 
lint report check -severity error assign_real_to_reg 
lint report check -severity error assign_reg_to_int 
lint report check -severity error assign_reg_to_real 
lint report check -severity info assign_to_supply_net 
lint report check -severity error assign_width_overflow 
lint report check -severity error assign_width_underflow 
lint report check -severity warning assign_with_multi_arith_operations 
lint report check -severity error assigns_mixed 
lint report check -severity error assigns_mixed_in_always_block 
lint report check -severity error async_block_top_stmt_not_if 
lint report check -severity warning async_control_is_gated 
lint report check -severity error async_control_is_internal 
lint report check -severity info async_reset_active_high 
lint report check -severity error attribute_with_keyword_all 
lint report check -severity warning bit_order_reversed 
lint report check -severity error blackbox_input_conn_inconsistent 
lint report check -severity error blackbox_output_control_signal 
lint report check -severity error blocking_assign_in_seq_block 
lint report check -severity error bus_bit_as_clk 
lint report check -severity error bus_bits_in_multi_seq_blocks 
lint report check -severity warning bus_bits_not_read 
lint report check -severity warning bus_bits_not_set 
lint report check -severity error bus_conn_to_inst_reversed 
lint report check -severity warning bus_conn_to_prim_gate 
lint report check -severity error case_condition_with_tristate 
lint report check -severity error case_default_missing 
lint report check -severity error case_default_not_last_item 
lint report check -severity info case_default_redundant 
lint report check -severity error case_eq_operator 
lint report check -severity error case_item_duplicate 
lint report check -severity error case_item_invalid 
lint report check -severity error case_item_not_const 
lint report check -severity info case_large 
lint report check -severity warning case_nested 
lint report check -severity info case_others_null 
lint report check -severity info case_pragma_redundant 
lint report check -severity error case_select_const 
lint report check -severity warning case_select_has_expr 
lint report check -severity error case_stmt_with_parallel_case 
lint report check -severity error case_width_mismatch 
lint report check -severity error case_with_memory_output 
lint report check -severity error case_with_x_z 
lint report check -severity error casex 
lint report check -severity info casez 
lint report check -severity error casez_has_x 
lint report check -severity error clk_port_conn_complex 
lint report check -severity warning clock_gated 
lint report check -severity error clock_in_wait_stmt 
lint report check -severity warning clock_internal 
lint report check -severity info clock_path_buffer 
lint report check -severity error clock_signal_as_non_clock 
lint report check -severity info clock_with_both_edges 
lint report check -severity error combo_loop 
lint report check -severity error combo_loop_with_latch 
lint report check -severity info combo_path_input_to_output 
lint report check -severity info comment_has_control_char 
lint report check -severity info comment_not_in_english 
lint report check -severity info comparison_has_real_operand 
lint report check -severity error comparison_width_mismatch 
lint report check -severity info complex_expression 
lint report check -severity info concat_expr_with_unsized_operand 
lint report check -severity warning concurrent_block_with_duplicate_assign 
lint report check -severity warning condition_const 
lint report check -severity error condition_has_assign 
lint report check -severity error condition_is_multi_bit 
lint report check -severity info conditional_operator_nested 
lint report check -severity info const_latch_data 
lint report check -severity info const_output 
lint report check -severity info const_reg_clock 
lint report check -severity info const_reg_data 
lint report check -severity info const_signal 
lint report check -severity error const_with_inconsistent_value 
lint report check -severity error conversion_to_stdlogicvector_invalid 
lint report check -severity warning data_event_has_edge 
lint report check -severity warning data_type_bit_select_invalid 
lint report check -severity warning data_type_not_recommended 
lint report check -severity info data_type_std_ulogic 
lint report check -severity info delay_in_non_flop_expr 
lint report check -severity info design_ware_inst 
lint report check -severity warning div_mod_lhs_too_wide 
lint report check -severity warning div_mod_rem_operand_complex_expr 
lint report check -severity error div_mod_rhs_invalid 
lint report check -severity warning div_mod_rhs_too_wide 
lint report check -severity error div_mod_rhs_var 
lint report check -severity error div_mod_rhs_zero 
lint report check -severity error else_condition_dangling 
lint report check -severity error empty_block 
lint report check -severity error empty_module 
lint report check -severity info empty_stmt 
lint report check -severity warning enum_decl_invalid 
lint report check -severity error exponent_negative 
lint report check -severity error expr_operands_width_mismatch 
lint report check -severity info feedthrough_path 
lint report check -severity info flop_async_reset_const 
lint report check -severity error flop_clock_reset_loop 
lint report check -severity warning flop_output_as_clock 
lint report check -severity warning flop_output_in_initial 
lint report check -severity info flop_redundant 
lint report check -severity info flop_with_inverted_clock 
lint report check -severity info flop_without_control 
lint report check -severity error for_loop_var_init_not_const 
lint report check -severity error for_loop_with_wait 
lint report check -severity warning for_stmt_with_complex_logic 
lint report check -severity info fsm_state_count_large 
lint report check -severity info fsm_without_one_hot_encoding 
lint report check -severity warning func_arg_array_constrained 
lint report check -severity error func_as_reset_condition 
lint report check -severity error func_bit_not_set 
lint report check -severity error func_expr_input_size_mismatch 
lint report check -severity info func_input_unused 
lint report check -severity error func_input_width_mismatch 
lint report check -severity error func_nonblocking_assign 
lint report check -severity warning func_return_before_last_stmt 
lint report check -severity error func_return_range_fixed 
lint report check -severity error func_return_range_mismatch 
lint report check -severity error func_return_value_unspecified 
lint report check -severity error func_sets_global_var 
lint report check -severity warning func_to_stdlogicvector 
lint report check -severity error gen_inst_label_duplicate 
lint report check -severity error gen_label_duplicate 
lint report check -severity info gen_label_missing 
lint report check -severity error gen_loop_index_not_int 
lint report check -severity warning generic_map_ordered 
lint report check -severity info identifier_with_error_warning 
lint report check -severity error if_condition_with_tristate 
lint report check -severity info if_else_if_can_be_case 
lint report check -severity warning if_else_nested_large 
lint report check -severity error if_stmt_shares_arithmetic_operator 
lint report check -severity warning if_stmt_with_arith_expr 
lint report check -severity warning if_with_memory_output 
lint report check -severity info implicit_wire 
lint report check -severity error incomplete_case_stmt_with_full_case 
lint report check -severity error index_x_z 
lint report check -severity error inferred_blackbox 
lint report check -severity info inout_port_exists 
lint report check -severity warning inout_port_not_set 
lint report check -severity info inout_port_unused 
lint report check -severity error input_port_set 
lint report check -severity error inst_param_width_overflow 
lint report check -severity error inst_port_width_mismatch 
lint report check -severity info int_without_range 
lint report check -severity warning latch_inferred 
lint report check -severity info line_char_large 
lint report check -severity warning logical_not_on_multi_bit 
lint report check -severity warning logical_operator_on_multi_bit 
lint report check -severity error long_combinational_path 
lint report check -severity error loop_condition_const 
lint report check -severity error loop_index_in_multi_always_blocks 
lint report check -severity error loop_index_modified 
lint report check -severity error loop_index_not_int 
lint report check -severity error loop_step_incorrect 
lint report check -severity error loop_var_not_in_condition 
lint report check -severity error loop_var_not_in_init 
lint report check -severity error loop_with_next_exit 
lint report check -severity error loop_without_break 
lint report check -severity warning memory_not_set 
lint report check -severity warning memory_redefined 
lint report check -severity warning module_has_blackbox_instance 
lint report check -severity error module_with_duplicate_ports 
lint report check -severity error module_with_null_port 
lint report check -severity warning module_without_ports 
lint report check -severity error multi_driven_signal 
lint report check -severity info multi_ports_in_single_line 
lint report check -severity warning multi_wave_element 
lint report check -severity info multiplication_operator 
lint report check -severity warning mux_select_const 
lint report check -severity warning nonblocking_assign_and_delay_in_always 
lint report check -severity error nonblocking_assign_in_combo_block 
lint report check -severity error operand_redundant 
lint report check -severity warning ordered_port_connection 
lint report check -severity info parameter_count_large 
lint report check -severity info parameter_name_duplicate 
lint report check -severity error part_select_illegal 
lint report check -severity error port_conn_is_expression 
lint report check -severity error port_exp_with_integer 
lint report check -severity error power_operand_invalid 
lint report check -severity warning pragma_coverage_off_nested 
lint report check -severity warning pragma_translate_off_nested 
lint report check -severity error pragma_translate_on_nested 
lint report check -severity warning procedure_call 
lint report check -severity error procedure_sets_global_var 
lint report check -severity warning process_exceeds_line_limit 
lint report check -severity info process_has_async_set_reset 
lint report check -severity warning process_has_inconsistent_async_control 
lint report check -severity info process_has_multiple_async_control 
lint report check -severity warning process_signal_assign_large 
lint report check -severity warning process_var_assign_disorder 
lint report check -severity error process_without_event 
lint report check -severity info qualified_expression 
lint report check -severity info re_entrant_output 
lint report check -severity warning record_type 
lint report check -severity info reduction_operator_on_single_bit 
lint report check -severity warning reference_event_without_edge 
lint report check -severity error repeat_ctrl_not_const 
lint report check -severity info reserved_keyword 
lint report check -severity error reset_polarity_mismatch 
lint report check -severity info reset_port_connection_static 
lint report check -severity error reset_pragma_mismatch 
lint report check -severity error reset_set_non_const_assign 
lint report check -severity error reset_set_with_both_polarity 
lint report check -severity warning selected_signal_stmt 
lint report check -severity error sensitivity_list_edge_multi_bit 
lint report check -severity error sensitivity_list_operator_unexpected 
lint report check -severity warning sensitivity_list_signal_repeated 
lint report check -severity warning sensitivity_list_var_both_edges 
lint report check -severity error sensitivity_list_var_missing 
lint report check -severity error sensitivity_list_var_modified 
lint report check -severity error seq_block_first_stmt_not_if 
lint report check -severity warning seq_block_has_complex_cond 
lint report check -severity warning seq_block_has_duplicate_assign 
lint report check -severity error seq_block_has_multi_clks 
lint report check -severity error shared_variable_in_multi_process 
lint report check -severity warning signal_assign_in_multi_initial 
lint report check -severity error signal_sync_async 
lint report check -severity error signal_with_negative_value 
lint report check -severity error signed_unsigned_mixed_expr 
lint report check -severity error sim_synth_mismatch_assign_event 
lint report check -severity error sim_synth_mismatch_shared_var 
lint report check -severity error sim_synth_mismatch_tristate_compare 
lint report check -severity error stable_attribute 
lint report check -severity error std_logic_vector_without_range 
lint report check -severity info std_packages_mixed 
lint report check -severity warning string_has_control_char 
lint report check -severity error subroutines_recursive_loop 
lint report check -severity warning sync_read_as_async 
lint report check -severity info synopsys_attribute 
lint report check -severity error synth_pragma_prefix_invalid 
lint report check -severity error synth_pragma_prefix_missing 
lint report check -severity error task_has_event 
lint report check -severity info task_has_event_and_input 
lint report check -severity info task_has_event_and_output 
lint report check -severity error task_in_combo_block 
lint report check -severity error task_in_seq_block 
lint report check -severity error task_sets_global_var 
lint report check -severity warning tristate_enable_with_expr 
lint report check -severity warning tristate_inferred 
lint report check -severity info tristate_multi_driven 
lint report check -severity warning tristate_not_at_top_level 
lint report check -severity info tristate_other_desc_mixed 
lint report check -severity info two_state_data_type 
lint report check -severity info unconnected_inst 
lint report check -severity error unconnected_inst_input 
lint report check -severity warning unconnected_inst_output 
lint report check -severity warning undriven_latch_data 
lint report check -severity warning undriven_latch_enable 
lint report check -severity warning undriven_reg_clock 
lint report check -severity warning undriven_reg_data 
lint report check -severity error undriven_signal 
lint report check -severity info unloaded_input_port 
lint report check -severity error unresolved_module 
lint report check -severity error unsynth_access_type 
lint report check -severity error unsynth_alias_declaration 
lint report check -severity error unsynth_allocator 
lint report check -severity error unsynth_arithmetic_operator 
lint report check -severity error unsynth_array_index_type_enum 
lint report check -severity info unsynth_assert_stmt 
lint report check -severity error unsynth_assign_deassign 
lint report check -severity error unsynth_bidirectional_switch 
lint report check -severity error unsynth_block_stmt_header 
lint report check -severity error unsynth_charge_strength 
lint report check -severity error unsynth_clk_in_concurrent_stmt 
lint report check -severity error unsynth_clocking_style 
lint report check -severity error unsynth_const_redefined 
lint report check -severity error unsynth_dc_shell_script 
lint report check -severity error unsynth_deferred_const 
lint report check -severity error unsynth_defparam 
lint report check -severity error unsynth_delay_in_bidirectional_switch 
lint report check -severity error unsynth_delay_in_blocking_assign 
lint report check -severity error unsynth_delay_in_cmos_switch 
lint report check -severity error unsynth_delay_in_gate 
lint report check -severity error unsynth_delay_in_mos_switch 
lint report check -severity error unsynth_delay_in_net_decl 
lint report check -severity error unsynth_delay_in_stmt 
lint report check -severity error unsynth_delay_in_tristate_gate 
lint report check -severity error unsynth_disable_stmt 
lint report check -severity error unsynth_disconnection_spec 
lint report check -severity error unsynth_drive_strength_assign 
lint report check -severity error unsynth_drive_strength_gate 
lint report check -severity error unsynth_else_after_clk_event 
lint report check -severity error unsynth_enum_encoding_attribute 
lint report check -severity error unsynth_event_var 
lint report check -severity error unsynth_file_type 
lint report check -severity error unsynth_force_release 
lint report check -severity error unsynth_fork_join_block 
lint report check -severity error unsynth_func_returns_real 
lint report check -severity warning unsynth_generic_not_int 
lint report check -severity error unsynth_guarded_block_stmt 
lint report check -severity error unsynth_hier_reference 
lint report check -severity error unsynth_initial_stmt 
lint report check -severity error unsynth_initial_value 
lint report check -severity error unsynth_integer_array 
lint report check -severity error unsynth_mos_switch 
lint report check -severity error unsynth_multi_dim_array 
lint report check -severity error unsynth_multi_wait_with_same_clk 
lint report check -severity error unsynth_physical_type 
lint report check -severity error unsynth_pli_task_func 
lint report check -severity error unsynth_port_type 
lint report check -severity error unsynth_port_type_unconstrained 
lint report check -severity error unsynth_predefined_attribute 
lint report check -severity error unsynth_pulldown 
lint report check -severity error unsynth_pullup 
lint report check -severity error unsynth_real_var 
lint report check -severity error unsynth_repeat 
lint report check -severity error unsynth_repeat_in_nonblocking_assign 
lint report check -severity error unsynth_resolution_func 
lint report check -severity error unsynth_sensitivity_list_conditions 
lint report check -severity error unsynth_shift_operator 
lint report check -severity error unsynth_signal_kind_register_bus 
lint report check -severity error unsynth_specify_block 
lint report check -severity error unsynth_stmt_in_entity 
lint report check -severity error unsynth_time_var 
lint report check -severity error unsynth_tri_net 
lint report check -severity error unsynth_type_declaration_incomplete 
lint report check -severity error unsynth_udp 
lint report check -severity error unsynth_user_defined_attribute 
lint report check -severity error unsynth_wait_stmt 
lint report check -severity error unsynth_wand_wor_net 
lint report check -severity error unsynth_while_in_subprogram 
lint report check -severity error unsynth_while_loop 
lint report check -severity info user_blackbox 
lint report check -severity warning var_assign_in_process 
lint report check -severity warning var_assign_without_deassign 
lint report check -severity warning var_deassign_without_assign 
lint report check -severity error var_forced_without_release 
lint report check -severity error var_index_range_insufficient 
lint report check -severity error var_name_duplicate 
lint report check -severity error var_read_before_set 
lint report check -severity error var_released_without_force 
lint report check -severity warning when_else_nested 
lint report check -severity warning while_loop_iteration_limit 
lint methodology soc -goal implementation 
lint run -d TOP -L work
set qsDebug { lint_gui_mode } 
# 
# Questa Static Verification System
# Version 2021.1 4558100 win64 28-Jan-2021

clear settings -all
clear directives
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
clear settings  -lib
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
lint on clk_port_conn_complex 
lint on clock_gated 
lint on clock_internal 
lint on clock_path_buffer 
lint on clock_signal_as_non_clock 
lint on flop_with_inverted_clock 
lint on bus_bit_as_clk 
lint on clock_in_wait_stmt 
lint on clock_with_both_edges 
lint on seq_block_has_multi_clks 
lint on unsynth_clk_in_concurrent_stmt 
lint on unsynth_clocking_style 
lint on unsynth_else_after_clk_event 
lint on unsynth_multi_wait_with_same_clk 
lint on async_reset_active_high 
lint on bus_conn_to_prim_gate 
lint on feedthrough_path 
lint on flop_clock_reset_loop 
lint on flop_output_as_clock 
lint on flop_redundant 
lint on long_combinational_path 
lint on module_has_blackbox_instance 
lint on re_entrant_output 
lint on tristate_multi_driven 
lint on unconnected_inst 
lint on unconnected_inst_input 
lint on unconnected_inst_output 
lint on undriven_latch_data 
lint on undriven_latch_enable 
lint on undriven_reg_clock 
lint on undriven_reg_data 
lint on undriven_signal 
lint on unloaded_input_port 
lint on const_latch_data 
lint on const_output 
lint on const_reg_clock 
lint on const_reg_data 
lint on const_signal 
lint on mux_select_const 
lint on blackbox_input_conn_inconsistent 
lint on blackbox_output_control_signal 
lint on bus_conn_to_inst_reversed 
lint on combo_path_input_to_output 
lint on generic_map_ordered 
lint on inout_port_exists 
lint on inout_port_not_set 
lint on inout_port_unused 
lint on input_port_set 
lint on module_without_ports 
lint on ordered_port_connection 
lint on port_conn_is_expression 
lint on comment_has_control_char 
lint on comment_not_in_english 
lint on identifier_with_error_warning 
lint on parameter_name_duplicate 
lint on reserved_keyword 
lint on var_name_duplicate 
lint on async_block_top_stmt_not_if 
lint on async_control_is_gated 
lint on async_control_is_internal 
lint on flop_async_reset_const 
lint on flop_without_control 
lint on reset_port_connection_static 
lint on signal_sync_async 
lint on always_has_inconsistent_async_control 
lint on always_has_multiple_async_control 
lint on func_as_reset_condition 
lint on process_has_inconsistent_async_control 
lint on process_has_multiple_async_control 
lint on reset_polarity_mismatch 
lint on reset_pragma_mismatch 
lint on reset_set_non_const_assign 
lint on reset_set_with_both_polarity 
lint on seq_block_first_stmt_not_if 
lint on seq_block_has_complex_cond 
lint on assign_chain 
lint on assign_int_to_reg 
lint on assign_others_to_slice 
lint on assign_real_to_bit 
lint on assign_real_to_int 
lint on assign_real_to_reg 
lint on assign_reg_to_int 
lint on assign_reg_to_real 
lint on assign_to_supply_net 
lint on signal_with_negative_value 
lint on var_assign_without_deassign 
lint on var_deassign_without_assign 
lint on var_forced_without_release 
lint on var_released_without_force 
lint on case_default_redundant 
lint on case_item_invalid 
lint on case_item_not_const 
lint on case_large 
lint on case_nested 
lint on case_others_null 
lint on case_select_const 
lint on case_select_has_expr 
lint on data_event_has_edge 
lint on delay_in_non_flop_expr 
lint on arith_expr_with_conditional_operator 
lint on comparison_has_real_operand 
lint on complex_expression 
lint on condition_const 
lint on condition_has_assign 
lint on condition_is_multi_bit 
lint on conditional_operator_nested 
lint on data_type_bit_select_invalid 
lint on div_mod_rhs_var 
lint on div_mod_rhs_zero 
lint on exponent_negative 
lint on logical_not_on_multi_bit 
lint on logical_operator_on_multi_bit 
lint on multiplication_operator 
lint on operand_redundant 
lint on qualified_expression 
lint on reduction_operator_on_single_bit 
lint on signed_unsigned_mixed_expr 
lint on fsm_state_count_large 
lint on fsm_without_one_hot_encoding 
lint on func_arg_array_constrained 
lint on func_bit_not_set 
lint on func_input_unused 
lint on func_input_width_mismatch 
lint on func_return_before_last_stmt 
lint on func_return_range_fixed 
lint on func_return_range_mismatch 
lint on func_sets_global_var 
lint on func_to_stdlogicvector 
lint on subroutines_recursive_loop 
lint on for_loop_var_init_not_const 
lint on for_stmt_with_complex_logic 
lint on gen_loop_index_not_int 
lint on loop_condition_const 
lint on loop_index_in_multi_always_blocks 
lint on loop_index_modified 
lint on loop_index_not_int 
lint on loop_step_incorrect 
lint on loop_var_not_in_condition 
lint on loop_var_not_in_init 
lint on synth_pragma_prefix_missing 
lint on while_loop_iteration_limit 
lint on module_with_duplicate_ports 
lint on module_with_null_port 
lint on multi_ports_in_single_line 
lint on parameter_count_large 
lint on sensitivity_list_edge_multi_bit 
lint on sensitivity_list_operator_unexpected 
lint on sensitivity_list_signal_repeated 
lint on procedure_sets_global_var 
lint on task_in_combo_block 
lint on task_in_seq_block 
lint on task_sets_global_var 
lint on loop_with_next_exit 
lint on unsynth_allocator 
lint on unsynth_wand_wor_net 
lint on assign_with_multi_arith_operations 
lint on div_mod_rem_operand_complex_expr 
lint on loop_without_break 
lint on tristate_enable_with_expr 
lint on unsynth_dc_shell_script 
lint on unsynth_sensitivity_list_conditions 
lint on always_exceeds_line_limit 
lint on always_signal_assign_large 
lint on always_without_event 
lint on array_index_with_expr 
lint on bit_order_reversed 
lint on bus_bits_in_multi_seq_blocks 
lint on bus_bits_not_read 
lint on bus_bits_not_set 
lint on case_condition_with_tristate 
lint on case_stmt_with_parallel_case 
lint on case_with_memory_output 
lint on concurrent_block_with_duplicate_assign 
lint on conversion_to_stdlogicvector_invalid 
lint on data_type_std_ulogic 
lint on design_ware_inst 
lint on else_condition_dangling 
lint on empty_block 
lint on empty_module 
lint on empty_stmt 
lint on enum_decl_invalid 
lint on flop_output_in_initial 
lint on func_expr_input_size_mismatch 
lint on gen_inst_label_duplicate 
lint on gen_label_duplicate 
lint on gen_label_missing 
lint on if_condition_with_tristate 
lint on if_else_if_can_be_case 
lint on if_else_nested_large 
lint on if_stmt_shares_arithmetic_operator 
lint on if_stmt_with_arith_expr 
lint on if_with_memory_output 
lint on implicit_wire 
lint on inferred_blackbox 
lint on inst_param_width_overflow 
lint on int_without_range 
lint on latch_inferred 
lint on line_char_large 
lint on memory_not_set 
lint on memory_redefined 
lint on multi_wave_element 
lint on part_select_illegal 
lint on power_operand_invalid 
lint on pragma_coverage_off_nested 
lint on pragma_translate_off_nested 
lint on pragma_translate_on_nested 
lint on procedure_call 
lint on process_exceeds_line_limit 
lint on process_signal_assign_large 
lint on process_var_assign_disorder 
lint on process_without_event 
lint on record_type 
lint on reference_event_without_edge 
lint on selected_signal_stmt 
lint on seq_block_has_duplicate_assign 
lint on shared_variable_in_multi_process 
lint on signal_assign_in_multi_initial 
lint on stable_attribute 
lint on std_packages_mixed 
lint on string_has_control_char 
lint on sync_read_as_async 
lint on synopsys_attribute 
lint on tristate_inferred 
lint on tristate_not_at_top_level 
lint on tristate_other_desc_mixed 
lint on two_state_data_type 
lint on unresolved_module 
lint on user_blackbox 
lint on var_assign_in_process 
lint on var_index_range_insufficient 
lint on var_read_before_set 
lint on when_else_nested 
lint on assign_width_overflow 
lint on assign_width_underflow 
lint on case_width_mismatch 
lint on comparison_width_mismatch 
lint on concat_expr_with_unsized_operand 
lint on div_mod_lhs_too_wide 
lint on div_mod_rhs_too_wide 
lint on expr_operands_width_mismatch 
lint on inst_port_width_mismatch 
lint on func_return_value_unspecified 
lint on sensitivity_list_var_modified 
lint on always_has_multiple_events 
lint on assign_or_comparison_has_x 
lint on assign_or_comparison_has_z 
lint on case_default_missing 
lint on case_default_not_last_item 
lint on case_item_duplicate 
lint on case_pragma_redundant 
lint on case_with_x_z 
lint on casex 
lint on casez 
lint on casez_has_x 
lint on data_type_not_recommended 
lint on for_loop_with_wait 
lint on func_nonblocking_assign 
lint on incomplete_case_stmt_with_full_case 
lint on index_x_z 
lint on process_has_async_set_reset 
lint on sensitivity_list_var_missing 
lint on sim_synth_mismatch_assign_event 
lint on sim_synth_mismatch_shared_var 
lint on sim_synth_mismatch_tristate_compare 
lint on std_logic_vector_without_range 
lint on unsynth_delay_in_blocking_assign 
lint on unsynth_delay_in_stmt 
lint on unsynth_initial_value 
lint on assigns_mixed 
lint on assigns_mixed_in_always_block 
lint on blocking_assign_in_seq_block 
lint on combo_loop 
lint on combo_loop_with_latch 
lint on multi_driven_signal 
lint on nonblocking_assign_and_delay_in_always 
lint on nonblocking_assign_in_combo_block 
lint on attribute_with_keyword_all 
lint on const_with_inconsistent_value 
lint on repeat_ctrl_not_const 
lint on unsynth_access_type 
lint on unsynth_alias_declaration 
lint on unsynth_assert_stmt 
lint on unsynth_assign_deassign 
lint on unsynth_bidirectional_switch 
lint on unsynth_charge_strength 
lint on unsynth_deferred_const 
lint on unsynth_defparam 
lint on unsynth_disable_stmt 
lint on unsynth_disconnection_spec 
lint on unsynth_drive_strength_assign 
lint on unsynth_drive_strength_gate 
lint on unsynth_enum_encoding_attribute 
lint on unsynth_event_var 
lint on unsynth_file_type 
lint on unsynth_force_release 
lint on unsynth_fork_join_block 
lint on unsynth_guarded_block_stmt 
lint on unsynth_initial_stmt 
lint on unsynth_integer_array 
lint on unsynth_mos_switch 
lint on unsynth_multi_dim_array 
lint on unsynth_pli_task_func 
lint on unsynth_port_type 
lint on unsynth_port_type_unconstrained 
lint on unsynth_predefined_attribute 
lint on unsynth_pulldown 
lint on unsynth_pullup 
lint on unsynth_real_var 
lint on unsynth_repeat 
lint on unsynth_resolution_func 
lint on unsynth_shift_operator 
lint on unsynth_signal_kind_register_bus 
lint on unsynth_specify_block 
lint on unsynth_time_var 
lint on unsynth_tri_net 
lint on unsynth_udp 
lint on unsynth_user_defined_attribute 
lint on unsynth_wait_stmt 
lint on always_has_nested_event_control 
lint on case_eq_operator 
lint on div_mod_rhs_invalid 
lint on port_exp_with_integer 
lint on sensitivity_list_var_both_edges 
lint on synth_pragma_prefix_invalid 
lint on task_has_event 
lint on unsynth_arithmetic_operator 
lint on unsynth_array_index_type_enum 
lint on unsynth_block_stmt_header 
lint on unsynth_const_redefined 
lint on unsynth_delay_in_bidirectional_switch 
lint on unsynth_delay_in_cmos_switch 
lint on unsynth_delay_in_gate 
lint on unsynth_delay_in_mos_switch 
lint on unsynth_delay_in_net_decl 
lint on unsynth_delay_in_tristate_gate 
lint on unsynth_func_returns_real 
lint on unsynth_generic_not_int 
lint on unsynth_hier_reference 
lint on unsynth_physical_type 
lint on unsynth_repeat_in_nonblocking_assign 
lint on unsynth_stmt_in_entity 
lint on unsynth_type_declaration_incomplete 
lint on unsynth_while_in_subprogram 
lint on unsynth_while_loop 
lint on task_has_event_and_input 
lint on task_has_event_and_output 
lint preference -allow_non_port_data_types reg wire tri integer logic interface -allow_port_data_types reg wire tri integer logic interface 
lint report check -severity info always_exceeds_line_limit 
lint report check -severity warning always_has_inconsistent_async_control 
lint report check -severity info always_has_multiple_async_control 
lint report check -severity error always_has_multiple_events 
lint report check -severity warning always_has_nested_event_control 
lint report check -severity warning always_signal_assign_large 
lint report check -severity error always_without_event 
lint report check -severity error arith_expr_with_conditional_operator 
lint report check -severity error array_index_with_expr 
lint report check -severity warning assign_chain 
lint report check -severity error assign_int_to_reg 
lint report check -severity error assign_or_comparison_has_x 
lint report check -severity error assign_or_comparison_has_z 
lint report check -severity info assign_others_to_slice 
lint report check -severity error assign_real_to_bit 
lint report check -severity error assign_real_to_int 
lint report check -severity error assign_real_to_reg 
lint report check -severity error assign_reg_to_int 
lint report check -severity error assign_reg_to_real 
lint report check -severity info assign_to_supply_net 
lint report check -severity error assign_width_overflow 
lint report check -severity error assign_width_underflow 
lint report check -severity warning assign_with_multi_arith_operations 
lint report check -severity error assigns_mixed 
lint report check -severity error assigns_mixed_in_always_block 
lint report check -severity error async_block_top_stmt_not_if 
lint report check -severity warning async_control_is_gated 
lint report check -severity error async_control_is_internal 
lint report check -severity info async_reset_active_high 
lint report check -severity error attribute_with_keyword_all 
lint report check -severity warning bit_order_reversed 
lint report check -severity error blackbox_input_conn_inconsistent 
lint report check -severity error blackbox_output_control_signal 
lint report check -severity error blocking_assign_in_seq_block 
lint report check -severity error bus_bit_as_clk 
lint report check -severity error bus_bits_in_multi_seq_blocks 
lint report check -severity warning bus_bits_not_read 
lint report check -severity warning bus_bits_not_set 
lint report check -severity error bus_conn_to_inst_reversed 
lint report check -severity warning bus_conn_to_prim_gate 
lint report check -severity error case_condition_with_tristate 
lint report check -severity error case_default_missing 
lint report check -severity error case_default_not_last_item 
lint report check -severity info case_default_redundant 
lint report check -severity error case_eq_operator 
lint report check -severity error case_item_duplicate 
lint report check -severity error case_item_invalid 
lint report check -severity error case_item_not_const 
lint report check -severity info case_large 
lint report check -severity warning case_nested 
lint report check -severity info case_others_null 
lint report check -severity info case_pragma_redundant 
lint report check -severity error case_select_const 
lint report check -severity warning case_select_has_expr 
lint report check -severity error case_stmt_with_parallel_case 
lint report check -severity error case_width_mismatch 
lint report check -severity error case_with_memory_output 
lint report check -severity error case_with_x_z 
lint report check -severity error casex 
lint report check -severity info casez 
lint report check -severity error casez_has_x 
lint report check -severity error clk_port_conn_complex 
lint report check -severity warning clock_gated 
lint report check -severity error clock_in_wait_stmt 
lint report check -severity warning clock_internal 
lint report check -severity info clock_path_buffer 
lint report check -severity error clock_signal_as_non_clock 
lint report check -severity info clock_with_both_edges 
lint report check -severity error combo_loop 
lint report check -severity error combo_loop_with_latch 
lint report check -severity info combo_path_input_to_output 
lint report check -severity info comment_has_control_char 
lint report check -severity info comment_not_in_english 
lint report check -severity info comparison_has_real_operand 
lint report check -severity error comparison_width_mismatch 
lint report check -severity info complex_expression 
lint report check -severity info concat_expr_with_unsized_operand 
lint report check -severity warning concurrent_block_with_duplicate_assign 
lint report check -severity warning condition_const 
lint report check -severity error condition_has_assign 
lint report check -severity error condition_is_multi_bit 
lint report check -severity info conditional_operator_nested 
lint report check -severity info const_latch_data 
lint report check -severity info const_output 
lint report check -severity info const_reg_clock 
lint report check -severity info const_reg_data 
lint report check -severity info const_signal 
lint report check -severity error const_with_inconsistent_value 
lint report check -severity error conversion_to_stdlogicvector_invalid 
lint report check -severity warning data_event_has_edge 
lint report check -severity warning data_type_bit_select_invalid 
lint report check -severity warning data_type_not_recommended 
lint report check -severity info data_type_std_ulogic 
lint report check -severity info delay_in_non_flop_expr 
lint report check -severity info design_ware_inst 
lint report check -severity warning div_mod_lhs_too_wide 
lint report check -severity warning div_mod_rem_operand_complex_expr 
lint report check -severity error div_mod_rhs_invalid 
lint report check -severity warning div_mod_rhs_too_wide 
lint report check -severity error div_mod_rhs_var 
lint report check -severity error div_mod_rhs_zero 
lint report check -severity error else_condition_dangling 
lint report check -severity error empty_block 
lint report check -severity error empty_module 
lint report check -severity info empty_stmt 
lint report check -severity warning enum_decl_invalid 
lint report check -severity error exponent_negative 
lint report check -severity error expr_operands_width_mismatch 
lint report check -severity info feedthrough_path 
lint report check -severity info flop_async_reset_const 
lint report check -severity error flop_clock_reset_loop 
lint report check -severity warning flop_output_as_clock 
lint report check -severity warning flop_output_in_initial 
lint report check -severity info flop_redundant 
lint report check -severity info flop_with_inverted_clock 
lint report check -severity info flop_without_control 
lint report check -severity error for_loop_var_init_not_const 
lint report check -severity error for_loop_with_wait 
lint report check -severity warning for_stmt_with_complex_logic 
lint report check -severity info fsm_state_count_large 
lint report check -severity info fsm_without_one_hot_encoding 
lint report check -severity warning func_arg_array_constrained 
lint report check -severity error func_as_reset_condition 
lint report check -severity error func_bit_not_set 
lint report check -severity error func_expr_input_size_mismatch 
lint report check -severity info func_input_unused 
lint report check -severity error func_input_width_mismatch 
lint report check -severity error func_nonblocking_assign 
lint report check -severity warning func_return_before_last_stmt 
lint report check -severity error func_return_range_fixed 
lint report check -severity error func_return_range_mismatch 
lint report check -severity error func_return_value_unspecified 
lint report check -severity error func_sets_global_var 
lint report check -severity warning func_to_stdlogicvector 
lint report check -severity error gen_inst_label_duplicate 
lint report check -severity error gen_label_duplicate 
lint report check -severity info gen_label_missing 
lint report check -severity error gen_loop_index_not_int 
lint report check -severity warning generic_map_ordered 
lint report check -severity info identifier_with_error_warning 
lint report check -severity error if_condition_with_tristate 
lint report check -severity info if_else_if_can_be_case 
lint report check -severity warning if_else_nested_large 
lint report check -severity error if_stmt_shares_arithmetic_operator 
lint report check -severity warning if_stmt_with_arith_expr 
lint report check -severity warning if_with_memory_output 
lint report check -severity info implicit_wire 
lint report check -severity error incomplete_case_stmt_with_full_case 
lint report check -severity error index_x_z 
lint report check -severity error inferred_blackbox 
lint report check -severity info inout_port_exists 
lint report check -severity warning inout_port_not_set 
lint report check -severity info inout_port_unused 
lint report check -severity error input_port_set 
lint report check -severity error inst_param_width_overflow 
lint report check -severity error inst_port_width_mismatch 
lint report check -severity info int_without_range 
lint report check -severity warning latch_inferred 
lint report check -severity info line_char_large 
lint report check -severity warning logical_not_on_multi_bit 
lint report check -severity warning logical_operator_on_multi_bit 
lint report check -severity error long_combinational_path 
lint report check -severity error loop_condition_const 
lint report check -severity error loop_index_in_multi_always_blocks 
lint report check -severity error loop_index_modified 
lint report check -severity error loop_index_not_int 
lint report check -severity error loop_step_incorrect 
lint report check -severity error loop_var_not_in_condition 
lint report check -severity error loop_var_not_in_init 
lint report check -severity error loop_with_next_exit 
lint report check -severity error loop_without_break 
lint report check -severity warning memory_not_set 
lint report check -severity warning memory_redefined 
lint report check -severity warning module_has_blackbox_instance 
lint report check -severity error module_with_duplicate_ports 
lint report check -severity error module_with_null_port 
lint report check -severity warning module_without_ports 
lint report check -severity error multi_driven_signal 
lint report check -severity info multi_ports_in_single_line 
lint report check -severity warning multi_wave_element 
lint report check -severity info multiplication_operator 
lint report check -severity warning mux_select_const 
lint report check -severity warning nonblocking_assign_and_delay_in_always 
lint report check -severity error nonblocking_assign_in_combo_block 
lint report check -severity error operand_redundant 
lint report check -severity warning ordered_port_connection 
lint report check -severity info parameter_count_large 
lint report check -severity info parameter_name_duplicate 
lint report check -severity error part_select_illegal 
lint report check -severity error port_conn_is_expression 
lint report check -severity error port_exp_with_integer 
lint report check -severity error power_operand_invalid 
lint report check -severity warning pragma_coverage_off_nested 
lint report check -severity warning pragma_translate_off_nested 
lint report check -severity error pragma_translate_on_nested 
lint report check -severity warning procedure_call 
lint report check -severity error procedure_sets_global_var 
lint report check -severity warning process_exceeds_line_limit 
lint report check -severity info process_has_async_set_reset 
lint report check -severity warning process_has_inconsistent_async_control 
lint report check -severity info process_has_multiple_async_control 
lint report check -severity warning process_signal_assign_large 
lint report check -severity warning process_var_assign_disorder 
lint report check -severity error process_without_event 
lint report check -severity info qualified_expression 
lint report check -severity info re_entrant_output 
lint report check -severity warning record_type 
lint report check -severity info reduction_operator_on_single_bit 
lint report check -severity warning reference_event_without_edge 
lint report check -severity error repeat_ctrl_not_const 
lint report check -severity info reserved_keyword 
lint report check -severity error reset_polarity_mismatch 
lint report check -severity info reset_port_connection_static 
lint report check -severity error reset_pragma_mismatch 
lint report check -severity error reset_set_non_const_assign 
lint report check -severity error reset_set_with_both_polarity 
lint report check -severity warning selected_signal_stmt 
lint report check -severity error sensitivity_list_edge_multi_bit 
lint report check -severity error sensitivity_list_operator_unexpected 
lint report check -severity warning sensitivity_list_signal_repeated 
lint report check -severity warning sensitivity_list_var_both_edges 
lint report check -severity error sensitivity_list_var_missing 
lint report check -severity error sensitivity_list_var_modified 
lint report check -severity error seq_block_first_stmt_not_if 
lint report check -severity warning seq_block_has_complex_cond 
lint report check -severity warning seq_block_has_duplicate_assign 
lint report check -severity error seq_block_has_multi_clks 
lint report check -severity error shared_variable_in_multi_process 
lint report check -severity warning signal_assign_in_multi_initial 
lint report check -severity error signal_sync_async 
lint report check -severity error signal_with_negative_value 
lint report check -severity error signed_unsigned_mixed_expr 
lint report check -severity error sim_synth_mismatch_assign_event 
lint report check -severity error sim_synth_mismatch_shared_var 
lint report check -severity error sim_synth_mismatch_tristate_compare 
lint report check -severity error stable_attribute 
lint report check -severity error std_logic_vector_without_range 
lint report check -severity info std_packages_mixed 
lint report check -severity warning string_has_control_char 
lint report check -severity error subroutines_recursive_loop 
lint report check -severity warning sync_read_as_async 
lint report check -severity info synopsys_attribute 
lint report check -severity error synth_pragma_prefix_invalid 
lint report check -severity error synth_pragma_prefix_missing 
lint report check -severity error task_has_event 
lint report check -severity info task_has_event_and_input 
lint report check -severity info task_has_event_and_output 
lint report check -severity error task_in_combo_block 
lint report check -severity error task_in_seq_block 
lint report check -severity error task_sets_global_var 
lint report check -severity warning tristate_enable_with_expr 
lint report check -severity warning tristate_inferred 
lint report check -severity info tristate_multi_driven 
lint report check -severity warning tristate_not_at_top_level 
lint report check -severity info tristate_other_desc_mixed 
lint report check -severity info two_state_data_type 
lint report check -severity info unconnected_inst 
lint report check -severity error unconnected_inst_input 
lint report check -severity warning unconnected_inst_output 
lint report check -severity warning undriven_latch_data 
lint report check -severity warning undriven_latch_enable 
lint report check -severity warning undriven_reg_clock 
lint report check -severity warning undriven_reg_data 
lint report check -severity error undriven_signal 
lint report check -severity info unloaded_input_port 
lint report check -severity error unresolved_module 
lint report check -severity error unsynth_access_type 
lint report check -severity error unsynth_alias_declaration 
lint report check -severity error unsynth_allocator 
lint report check -severity error unsynth_arithmetic_operator 
lint report check -severity error unsynth_array_index_type_enum 
lint report check -severity info unsynth_assert_stmt 
lint report check -severity error unsynth_assign_deassign 
lint report check -severity error unsynth_bidirectional_switch 
lint report check -severity error unsynth_block_stmt_header 
lint report check -severity error unsynth_charge_strength 
lint report check -severity error unsynth_clk_in_concurrent_stmt 
lint report check -severity error unsynth_clocking_style 
lint report check -severity error unsynth_const_redefined 
lint report check -severity error unsynth_dc_shell_script 
lint report check -severity error unsynth_deferred_const 
lint report check -severity error unsynth_defparam 
lint report check -severity error unsynth_delay_in_bidirectional_switch 
lint report check -severity error unsynth_delay_in_blocking_assign 
lint report check -severity error unsynth_delay_in_cmos_switch 
lint report check -severity error unsynth_delay_in_gate 
lint report check -severity error unsynth_delay_in_mos_switch 
lint report check -severity error unsynth_delay_in_net_decl 
lint report check -severity error unsynth_delay_in_stmt 
lint report check -severity error unsynth_delay_in_tristate_gate 
lint report check -severity error unsynth_disable_stmt 
lint report check -severity error unsynth_disconnection_spec 
lint report check -severity error unsynth_drive_strength_assign 
lint report check -severity error unsynth_drive_strength_gate 
lint report check -severity error unsynth_else_after_clk_event 
lint report check -severity error unsynth_enum_encoding_attribute 
lint report check -severity error unsynth_event_var 
lint report check -severity error unsynth_file_type 
lint report check -severity error unsynth_force_release 
lint report check -severity error unsynth_fork_join_block 
lint report check -severity error unsynth_func_returns_real 
lint report check -severity warning unsynth_generic_not_int 
lint report check -severity error unsynth_guarded_block_stmt 
lint report check -severity error unsynth_hier_reference 
lint report check -severity error unsynth_initial_stmt 
lint report check -severity error unsynth_initial_value 
lint report check -severity error unsynth_integer_array 
lint report check -severity error unsynth_mos_switch 
lint report check -severity error unsynth_multi_dim_array 
lint report check -severity error unsynth_multi_wait_with_same_clk 
lint report check -severity error unsynth_physical_type 
lint report check -severity error unsynth_pli_task_func 
lint report check -severity error unsynth_port_type 
lint report check -severity error unsynth_port_type_unconstrained 
lint report check -severity error unsynth_predefined_attribute 
lint report check -severity error unsynth_pulldown 
lint report check -severity error unsynth_pullup 
lint report check -severity error unsynth_real_var 
lint report check -severity error unsynth_repeat 
lint report check -severity error unsynth_repeat_in_nonblocking_assign 
lint report check -severity error unsynth_resolution_func 
lint report check -severity error unsynth_sensitivity_list_conditions 
lint report check -severity error unsynth_shift_operator 
lint report check -severity error unsynth_signal_kind_register_bus 
lint report check -severity error unsynth_specify_block 
lint report check -severity error unsynth_stmt_in_entity 
lint report check -severity error unsynth_time_var 
lint report check -severity error unsynth_tri_net 
lint report check -severity error unsynth_type_declaration_incomplete 
lint report check -severity error unsynth_udp 
lint report check -severity error unsynth_user_defined_attribute 
lint report check -severity error unsynth_wait_stmt 
lint report check -severity error unsynth_wand_wor_net 
lint report check -severity error unsynth_while_in_subprogram 
lint report check -severity error unsynth_while_loop 
lint report check -severity info user_blackbox 
lint report check -severity warning var_assign_in_process 
lint report check -severity warning var_assign_without_deassign 
lint report check -severity warning var_deassign_without_assign 
lint report check -severity error var_forced_without_release 
lint report check -severity error var_index_range_insufficient 
lint report check -severity error var_name_duplicate 
lint report check -severity error var_read_before_set 
lint report check -severity error var_released_without_force 
lint report check -severity warning when_else_nested 
lint report check -severity warning while_loop_iteration_limit 
lint methodology soc -goal implementation 
lint run -d TOP -L work
set qsDebug { lint_gui_mode } 
# 
# Questa Static Verification System
# Version 2021.1 4558100 win64 28-Jan-2021

clear settings -all
clear directives
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
clear settings  -lib
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#clear directives 
#clear directives 
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
lint on clk_port_conn_complex 
lint on clock_gated 
lint on clock_internal 
lint on clock_path_buffer 
lint on clock_signal_as_non_clock 
lint on flop_with_inverted_clock 
lint on bus_bit_as_clk 
lint on clock_in_wait_stmt 
lint on clock_with_both_edges 
lint on seq_block_has_multi_clks 
lint on unsynth_clk_in_concurrent_stmt 
lint on unsynth_clocking_style 
lint on unsynth_else_after_clk_event 
lint on unsynth_multi_wait_with_same_clk 
lint on async_reset_active_high 
lint on bus_conn_to_prim_gate 
lint on feedthrough_path 
lint on flop_clock_reset_loop 
lint on flop_output_as_clock 
lint on flop_redundant 
lint on long_combinational_path 
lint on module_has_blackbox_instance 
lint on re_entrant_output 
lint on tristate_multi_driven 
lint on unconnected_inst 
lint on unconnected_inst_input 
lint on unconnected_inst_output 
lint on undriven_latch_data 
lint on undriven_latch_enable 
lint on undriven_reg_clock 
lint on undriven_reg_data 
lint on undriven_signal 
lint on unloaded_input_port 
lint on const_latch_data 
lint on const_output 
lint on const_reg_clock 
lint on const_reg_data 
lint on const_signal 
lint on mux_select_const 
lint on blackbox_input_conn_inconsistent 
lint on blackbox_output_control_signal 
lint on bus_conn_to_inst_reversed 
lint on combo_path_input_to_output 
lint on generic_map_ordered 
lint on inout_port_exists 
lint on inout_port_not_set 
lint on inout_port_unused 
lint on input_port_set 
lint on module_without_ports 
lint on ordered_port_connection 
lint on port_conn_is_expression 
lint on comment_has_control_char 
lint on comment_not_in_english 
lint on identifier_with_error_warning 
lint on parameter_name_duplicate 
lint on reserved_keyword 
lint on var_name_duplicate 
lint on async_block_top_stmt_not_if 
lint on async_control_is_gated 
lint on async_control_is_internal 
lint on flop_async_reset_const 
lint on flop_without_control 
lint on reset_port_connection_static 
lint on signal_sync_async 
lint on always_has_inconsistent_async_control 
lint on always_has_multiple_async_control 
lint on func_as_reset_condition 
lint on process_has_inconsistent_async_control 
lint on process_has_multiple_async_control 
lint on reset_polarity_mismatch 
lint on reset_pragma_mismatch 
lint on reset_set_non_const_assign 
lint on reset_set_with_both_polarity 
lint on seq_block_first_stmt_not_if 
lint on seq_block_has_complex_cond 
lint on assign_chain 
lint on assign_int_to_reg 
lint on assign_others_to_slice 
lint on assign_real_to_bit 
lint on assign_real_to_int 
lint on assign_real_to_reg 
lint on assign_reg_to_int 
lint on assign_reg_to_real 
lint on assign_to_supply_net 
lint on signal_with_negative_value 
lint on var_assign_without_deassign 
lint on var_deassign_without_assign 
lint on var_forced_without_release 
lint on var_released_without_force 
lint on case_default_redundant 
lint on case_item_invalid 
lint on case_item_not_const 
lint on case_large 
lint on case_nested 
lint on case_others_null 
lint on case_select_const 
lint on case_select_has_expr 
lint on data_event_has_edge 
lint on delay_in_non_flop_expr 
lint on arith_expr_with_conditional_operator 
lint on comparison_has_real_operand 
lint on complex_expression 
lint on condition_const 
lint on condition_has_assign 
lint on condition_is_multi_bit 
lint on conditional_operator_nested 
lint on data_type_bit_select_invalid 
lint on div_mod_rhs_var 
lint on div_mod_rhs_zero 
lint on exponent_negative 
lint on logical_not_on_multi_bit 
lint on logical_operator_on_multi_bit 
lint on multiplication_operator 
lint on operand_redundant 
lint on qualified_expression 
lint on reduction_operator_on_single_bit 
lint on signed_unsigned_mixed_expr 
lint on fsm_state_count_large 
lint on fsm_without_one_hot_encoding 
lint on func_arg_array_constrained 
lint on func_bit_not_set 
lint on func_input_unused 
lint on func_input_width_mismatch 
lint on func_return_before_last_stmt 
lint on func_return_range_fixed 
lint on func_return_range_mismatch 
lint on func_sets_global_var 
lint on func_to_stdlogicvector 
lint on subroutines_recursive_loop 
lint on for_loop_var_init_not_const 
lint on for_stmt_with_complex_logic 
lint on gen_loop_index_not_int 
lint on loop_condition_const 
lint on loop_index_in_multi_always_blocks 
lint on loop_index_modified 
lint on loop_index_not_int 
lint on loop_step_incorrect 
lint on loop_var_not_in_condition 
lint on loop_var_not_in_init 
lint on synth_pragma_prefix_missing 
lint on while_loop_iteration_limit 
lint on module_with_duplicate_ports 
lint on module_with_null_port 
lint on multi_ports_in_single_line 
lint on parameter_count_large 
lint on sensitivity_list_edge_multi_bit 
lint on sensitivity_list_operator_unexpected 
lint on sensitivity_list_signal_repeated 
lint on procedure_sets_global_var 
lint on task_in_combo_block 
lint on task_in_seq_block 
lint on task_sets_global_var 
lint on loop_with_next_exit 
lint on unsynth_allocator 
lint on unsynth_wand_wor_net 
lint on assign_with_multi_arith_operations 
lint on div_mod_rem_operand_complex_expr 
lint on loop_without_break 
lint on tristate_enable_with_expr 
lint on unsynth_dc_shell_script 
lint on unsynth_sensitivity_list_conditions 
lint on always_exceeds_line_limit 
lint on always_signal_assign_large 
lint on always_without_event 
lint on array_index_with_expr 
lint on bit_order_reversed 
lint on bus_bits_in_multi_seq_blocks 
lint on bus_bits_not_read 
lint on bus_bits_not_set 
lint on case_condition_with_tristate 
lint on case_stmt_with_parallel_case 
lint on case_with_memory_output 
lint on concurrent_block_with_duplicate_assign 
lint on conversion_to_stdlogicvector_invalid 
lint on data_type_std_ulogic 
lint on design_ware_inst 
lint on else_condition_dangling 
lint on empty_block 
lint on empty_module 
lint on empty_stmt 
lint on enum_decl_invalid 
lint on flop_output_in_initial 
lint on func_expr_input_size_mismatch 
lint on gen_inst_label_duplicate 
lint on gen_label_duplicate 
lint on gen_label_missing 
lint on if_condition_with_tristate 
lint on if_else_if_can_be_case 
lint on if_else_nested_large 
lint on if_stmt_shares_arithmetic_operator 
lint on if_stmt_with_arith_expr 
lint on if_with_memory_output 
lint on implicit_wire 
lint on inferred_blackbox 
lint on inst_param_width_overflow 
lint on int_without_range 
lint on latch_inferred 
lint on line_char_large 
lint on memory_not_set 
lint on memory_redefined 
lint on multi_wave_element 
lint on part_select_illegal 
lint on power_operand_invalid 
lint on pragma_coverage_off_nested 
lint on pragma_translate_off_nested 
lint on pragma_translate_on_nested 
lint on procedure_call 
lint on process_exceeds_line_limit 
lint on process_signal_assign_large 
lint on process_var_assign_disorder 
lint on process_without_event 
lint on record_type 
lint on reference_event_without_edge 
lint on selected_signal_stmt 
lint on seq_block_has_duplicate_assign 
lint on shared_variable_in_multi_process 
lint on signal_assign_in_multi_initial 
lint on stable_attribute 
lint on std_packages_mixed 
lint on string_has_control_char 
lint on sync_read_as_async 
lint on synopsys_attribute 
lint on tristate_inferred 
lint on tristate_not_at_top_level 
lint on tristate_other_desc_mixed 
lint on two_state_data_type 
lint on unresolved_module 
lint on user_blackbox 
lint on var_assign_in_process 
lint on var_index_range_insufficient 
lint on var_read_before_set 
lint on when_else_nested 
lint on assign_width_overflow 
lint on assign_width_underflow 
lint on case_width_mismatch 
lint on comparison_width_mismatch 
lint on concat_expr_with_unsized_operand 
lint on div_mod_lhs_too_wide 
lint on div_mod_rhs_too_wide 
lint on expr_operands_width_mismatch 
lint on inst_port_width_mismatch 
lint on func_return_value_unspecified 
lint on sensitivity_list_var_modified 
lint on always_has_multiple_events 
lint on assign_or_comparison_has_x 
lint on assign_or_comparison_has_z 
lint on case_default_missing 
lint on case_default_not_last_item 
lint on case_item_duplicate 
lint on case_pragma_redundant 
lint on case_with_x_z 
lint on casex 
lint on casez 
lint on casez_has_x 
lint on data_type_not_recommended 
lint on for_loop_with_wait 
lint on func_nonblocking_assign 
lint on incomplete_case_stmt_with_full_case 
lint on index_x_z 
lint on process_has_async_set_reset 
lint on sensitivity_list_var_missing 
lint on sim_synth_mismatch_assign_event 
lint on sim_synth_mismatch_shared_var 
lint on sim_synth_mismatch_tristate_compare 
lint on std_logic_vector_without_range 
lint on unsynth_delay_in_blocking_assign 
lint on unsynth_delay_in_stmt 
lint on unsynth_initial_value 
lint on assigns_mixed 
lint on assigns_mixed_in_always_block 
lint on blocking_assign_in_seq_block 
lint on combo_loop 
lint on combo_loop_with_latch 
lint on multi_driven_signal 
lint on nonblocking_assign_and_delay_in_always 
lint on nonblocking_assign_in_combo_block 
lint on attribute_with_keyword_all 
lint on const_with_inconsistent_value 
lint on repeat_ctrl_not_const 
lint on unsynth_access_type 
lint on unsynth_alias_declaration 
lint on unsynth_assert_stmt 
lint on unsynth_assign_deassign 
lint on unsynth_bidirectional_switch 
lint on unsynth_charge_strength 
lint on unsynth_deferred_const 
lint on unsynth_defparam 
lint on unsynth_disable_stmt 
lint on unsynth_disconnection_spec 
lint on unsynth_drive_strength_assign 
lint on unsynth_drive_strength_gate 
lint on unsynth_enum_encoding_attribute 
lint on unsynth_event_var 
lint on unsynth_file_type 
lint on unsynth_force_release 
lint on unsynth_fork_join_block 
lint on unsynth_guarded_block_stmt 
lint on unsynth_initial_stmt 
lint on unsynth_integer_array 
lint on unsynth_mos_switch 
lint on unsynth_multi_dim_array 
lint on unsynth_pli_task_func 
lint on unsynth_port_type 
lint on unsynth_port_type_unconstrained 
lint on unsynth_predefined_attribute 
lint on unsynth_pulldown 
lint on unsynth_pullup 
lint on unsynth_real_var 
lint on unsynth_repeat 
lint on unsynth_resolution_func 
lint on unsynth_shift_operator 
lint on unsynth_signal_kind_register_bus 
lint on unsynth_specify_block 
lint on unsynth_time_var 
lint on unsynth_tri_net 
lint on unsynth_udp 
lint on unsynth_user_defined_attribute 
lint on unsynth_wait_stmt 
lint on always_has_nested_event_control 
lint on case_eq_operator 
lint on div_mod_rhs_invalid 
lint on port_exp_with_integer 
lint on sensitivity_list_var_both_edges 
lint on synth_pragma_prefix_invalid 
lint on task_has_event 
lint on unsynth_arithmetic_operator 
lint on unsynth_array_index_type_enum 
lint on unsynth_block_stmt_header 
lint on unsynth_const_redefined 
lint on unsynth_delay_in_bidirectional_switch 
lint on unsynth_delay_in_cmos_switch 
lint on unsynth_delay_in_gate 
lint on unsynth_delay_in_mos_switch 
lint on unsynth_delay_in_net_decl 
lint on unsynth_delay_in_tristate_gate 
lint on unsynth_func_returns_real 
lint on unsynth_generic_not_int 
lint on unsynth_hier_reference 
lint on unsynth_physical_type 
lint on unsynth_repeat_in_nonblocking_assign 
lint on unsynth_stmt_in_entity 
lint on unsynth_type_declaration_incomplete 
lint on unsynth_while_in_subprogram 
lint on unsynth_while_loop 
lint on task_has_event_and_input 
lint on task_has_event_and_output 
lint preference -allow_non_port_data_types reg wire tri integer logic interface -allow_port_data_types reg wire tri integer logic interface 
lint report check -severity info always_exceeds_line_limit 
lint report check -severity warning always_has_inconsistent_async_control 
lint report check -severity info always_has_multiple_async_control 
lint report check -severity error always_has_multiple_events 
lint report check -severity warning always_has_nested_event_control 
lint report check -severity warning always_signal_assign_large 
lint report check -severity error always_without_event 
lint report check -severity error arith_expr_with_conditional_operator 
lint report check -severity error array_index_with_expr 
lint report check -severity warning assign_chain 
lint report check -severity error assign_int_to_reg 
lint report check -severity error assign_or_comparison_has_x 
lint report check -severity error assign_or_comparison_has_z 
lint report check -severity info assign_others_to_slice 
lint report check -severity error assign_real_to_bit 
lint report check -severity error assign_real_to_int 
lint report check -severity error assign_real_to_reg 
lint report check -severity error assign_reg_to_int 
lint report check -severity error assign_reg_to_real 
lint report check -severity info assign_to_supply_net 
lint report check -severity error assign_width_overflow 
lint report check -severity error assign_width_underflow 
lint report check -severity warning assign_with_multi_arith_operations 
lint report check -severity error assigns_mixed 
lint report check -severity error assigns_mixed_in_always_block 
lint report check -severity error async_block_top_stmt_not_if 
lint report check -severity warning async_control_is_gated 
lint report check -severity error async_control_is_internal 
lint report check -severity info async_reset_active_high 
lint report check -severity error attribute_with_keyword_all 
lint report check -severity warning bit_order_reversed 
lint report check -severity error blackbox_input_conn_inconsistent 
lint report check -severity error blackbox_output_control_signal 
lint report check -severity error blocking_assign_in_seq_block 
lint report check -severity error bus_bit_as_clk 
lint report check -severity error bus_bits_in_multi_seq_blocks 
lint report check -severity warning bus_bits_not_read 
lint report check -severity warning bus_bits_not_set 
lint report check -severity error bus_conn_to_inst_reversed 
lint report check -severity warning bus_conn_to_prim_gate 
lint report check -severity error case_condition_with_tristate 
lint report check -severity error case_default_missing 
lint report check -severity error case_default_not_last_item 
lint report check -severity info case_default_redundant 
lint report check -severity error case_eq_operator 
lint report check -severity error case_item_duplicate 
lint report check -severity error case_item_invalid 
lint report check -severity error case_item_not_const 
lint report check -severity info case_large 
lint report check -severity warning case_nested 
lint report check -severity info case_others_null 
lint report check -severity info case_pragma_redundant 
lint report check -severity error case_select_const 
lint report check -severity warning case_select_has_expr 
lint report check -severity error case_stmt_with_parallel_case 
lint report check -severity error case_width_mismatch 
lint report check -severity error case_with_memory_output 
lint report check -severity error case_with_x_z 
lint report check -severity error casex 
lint report check -severity info casez 
lint report check -severity error casez_has_x 
lint report check -severity error clk_port_conn_complex 
lint report check -severity warning clock_gated 
lint report check -severity error clock_in_wait_stmt 
lint report check -severity warning clock_internal 
lint report check -severity info clock_path_buffer 
lint report check -severity error clock_signal_as_non_clock 
lint report check -severity info clock_with_both_edges 
lint report check -severity error combo_loop 
lint report check -severity error combo_loop_with_latch 
lint report check -severity info combo_path_input_to_output 
lint report check -severity info comment_has_control_char 
lint report check -severity info comment_not_in_english 
lint report check -severity info comparison_has_real_operand 
lint report check -severity error comparison_width_mismatch 
lint report check -severity info complex_expression 
lint report check -severity info concat_expr_with_unsized_operand 
lint report check -severity warning concurrent_block_with_duplicate_assign 
lint report check -severity warning condition_const 
lint report check -severity error condition_has_assign 
lint report check -severity error condition_is_multi_bit 
lint report check -severity info conditional_operator_nested 
lint report check -severity info const_latch_data 
lint report check -severity info const_output 
lint report check -severity info const_reg_clock 
lint report check -severity info const_reg_data 
lint report check -severity info const_signal 
lint report check -severity error const_with_inconsistent_value 
lint report check -severity error conversion_to_stdlogicvector_invalid 
lint report check -severity warning data_event_has_edge 
lint report check -severity warning data_type_bit_select_invalid 
lint report check -severity warning data_type_not_recommended 
lint report check -severity info data_type_std_ulogic 
lint report check -severity info delay_in_non_flop_expr 
lint report check -severity info design_ware_inst 
lint report check -severity warning div_mod_lhs_too_wide 
lint report check -severity warning div_mod_rem_operand_complex_expr 
lint report check -severity error div_mod_rhs_invalid 
lint report check -severity warning div_mod_rhs_too_wide 
lint report check -severity error div_mod_rhs_var 
lint report check -severity error div_mod_rhs_zero 
lint report check -severity error else_condition_dangling 
lint report check -severity error empty_block 
lint report check -severity error empty_module 
lint report check -severity info empty_stmt 
lint report check -severity warning enum_decl_invalid 
lint report check -severity error exponent_negative 
lint report check -severity error expr_operands_width_mismatch 
lint report check -severity info feedthrough_path 
lint report check -severity info flop_async_reset_const 
lint report check -severity error flop_clock_reset_loop 
lint report check -severity warning flop_output_as_clock 
lint report check -severity warning flop_output_in_initial 
lint report check -severity info flop_redundant 
lint report check -severity info flop_with_inverted_clock 
lint report check -severity info flop_without_control 
lint report check -severity error for_loop_var_init_not_const 
lint report check -severity error for_loop_with_wait 
lint report check -severity warning for_stmt_with_complex_logic 
lint report check -severity info fsm_state_count_large 
lint report check -severity info fsm_without_one_hot_encoding 
lint report check -severity warning func_arg_array_constrained 
lint report check -severity error func_as_reset_condition 
lint report check -severity error func_bit_not_set 
lint report check -severity error func_expr_input_size_mismatch 
lint report check -severity info func_input_unused 
lint report check -severity error func_input_width_mismatch 
lint report check -severity error func_nonblocking_assign 
lint report check -severity warning func_return_before_last_stmt 
lint report check -severity error func_return_range_fixed 
lint report check -severity error func_return_range_mismatch 
lint report check -severity error func_return_value_unspecified 
lint report check -severity error func_sets_global_var 
lint report check -severity warning func_to_stdlogicvector 
lint report check -severity error gen_inst_label_duplicate 
lint report check -severity error gen_label_duplicate 
lint report check -severity info gen_label_missing 
lint report check -severity error gen_loop_index_not_int 
lint report check -severity warning generic_map_ordered 
lint report check -severity info identifier_with_error_warning 
lint report check -severity error if_condition_with_tristate 
lint report check -severity info if_else_if_can_be_case 
lint report check -severity warning if_else_nested_large 
lint report check -severity error if_stmt_shares_arithmetic_operator 
lint report check -severity warning if_stmt_with_arith_expr 
lint report check -severity warning if_with_memory_output 
lint report check -severity info implicit_wire 
lint report check -severity error incomplete_case_stmt_with_full_case 
lint report check -severity error index_x_z 
lint report check -severity error inferred_blackbox 
lint report check -severity info inout_port_exists 
lint report check -severity warning inout_port_not_set 
lint report check -severity info inout_port_unused 
lint report check -severity error input_port_set 
lint report check -severity error inst_param_width_overflow 
lint report check -severity error inst_port_width_mismatch 
lint report check -severity info int_without_range 
lint report check -severity warning latch_inferred 
lint report check -severity info line_char_large 
lint report check -severity warning logical_not_on_multi_bit 
lint report check -severity warning logical_operator_on_multi_bit 
lint report check -severity error long_combinational_path 
lint report check -severity error loop_condition_const 
lint report check -severity error loop_index_in_multi_always_blocks 
lint report check -severity error loop_index_modified 
lint report check -severity error loop_index_not_int 
lint report check -severity error loop_step_incorrect 
lint report check -severity error loop_var_not_in_condition 
lint report check -severity error loop_var_not_in_init 
lint report check -severity error loop_with_next_exit 
lint report check -severity error loop_without_break 
lint report check -severity warning memory_not_set 
lint report check -severity warning memory_redefined 
lint report check -severity warning module_has_blackbox_instance 
lint report check -severity error module_with_duplicate_ports 
lint report check -severity error module_with_null_port 
lint report check -severity warning module_without_ports 
lint report check -severity error multi_driven_signal 
lint report check -severity info multi_ports_in_single_line 
lint report check -severity warning multi_wave_element 
lint report check -severity info multiplication_operator 
lint report check -severity warning mux_select_const 
lint report check -severity warning nonblocking_assign_and_delay_in_always 
lint report check -severity error nonblocking_assign_in_combo_block 
lint report check -severity error operand_redundant 
lint report check -severity warning ordered_port_connection 
lint report check -severity info parameter_count_large 
lint report check -severity info parameter_name_duplicate 
lint report check -severity error part_select_illegal 
lint report check -severity error port_conn_is_expression 
lint report check -severity error port_exp_with_integer 
lint report check -severity error power_operand_invalid 
lint report check -severity warning pragma_coverage_off_nested 
lint report check -severity warning pragma_translate_off_nested 
lint report check -severity error pragma_translate_on_nested 
lint report check -severity warning procedure_call 
lint report check -severity error procedure_sets_global_var 
lint report check -severity warning process_exceeds_line_limit 
lint report check -severity info process_has_async_set_reset 
lint report check -severity warning process_has_inconsistent_async_control 
lint report check -severity info process_has_multiple_async_control 
lint report check -severity warning process_signal_assign_large 
lint report check -severity warning process_var_assign_disorder 
lint report check -severity error process_without_event 
lint report check -severity info qualified_expression 
lint report check -severity info re_entrant_output 
lint report check -severity warning record_type 
lint report check -severity info reduction_operator_on_single_bit 
lint report check -severity warning reference_event_without_edge 
lint report check -severity error repeat_ctrl_not_const 
lint report check -severity info reserved_keyword 
lint report check -severity error reset_polarity_mismatch 
lint report check -severity info reset_port_connection_static 
lint report check -severity error reset_pragma_mismatch 
lint report check -severity error reset_set_non_const_assign 
lint report check -severity error reset_set_with_both_polarity 
lint report check -severity warning selected_signal_stmt 
lint report check -severity error sensitivity_list_edge_multi_bit 
lint report check -severity error sensitivity_list_operator_unexpected 
lint report check -severity warning sensitivity_list_signal_repeated 
lint report check -severity warning sensitivity_list_var_both_edges 
lint report check -severity error sensitivity_list_var_missing 
lint report check -severity error sensitivity_list_var_modified 
lint report check -severity error seq_block_first_stmt_not_if 
lint report check -severity warning seq_block_has_complex_cond 
lint report check -severity warning seq_block_has_duplicate_assign 
lint report check -severity error seq_block_has_multi_clks 
lint report check -severity error shared_variable_in_multi_process 
lint report check -severity warning signal_assign_in_multi_initial 
lint report check -severity error signal_sync_async 
lint report check -severity error signal_with_negative_value 
lint report check -severity error signed_unsigned_mixed_expr 
lint report check -severity error sim_synth_mismatch_assign_event 
lint report check -severity error sim_synth_mismatch_shared_var 
lint report check -severity error sim_synth_mismatch_tristate_compare 
lint report check -severity error stable_attribute 
lint report check -severity error std_logic_vector_without_range 
lint report check -severity info std_packages_mixed 
lint report check -severity warning string_has_control_char 
lint report check -severity error subroutines_recursive_loop 
lint report check -severity warning sync_read_as_async 
lint report check -severity info synopsys_attribute 
lint report check -severity error synth_pragma_prefix_invalid 
lint report check -severity error synth_pragma_prefix_missing 
lint report check -severity error task_has_event 
lint report check -severity info task_has_event_and_input 
lint report check -severity info task_has_event_and_output 
lint report check -severity error task_in_combo_block 
lint report check -severity error task_in_seq_block 
lint report check -severity error task_sets_global_var 
lint report check -severity warning tristate_enable_with_expr 
lint report check -severity warning tristate_inferred 
lint report check -severity info tristate_multi_driven 
lint report check -severity warning tristate_not_at_top_level 
lint report check -severity info tristate_other_desc_mixed 
lint report check -severity info two_state_data_type 
lint report check -severity info unconnected_inst 
lint report check -severity error unconnected_inst_input 
lint report check -severity warning unconnected_inst_output 
lint report check -severity warning undriven_latch_data 
lint report check -severity warning undriven_latch_enable 
lint report check -severity warning undriven_reg_clock 
lint report check -severity warning undriven_reg_data 
lint report check -severity error undriven_signal 
lint report check -severity info unloaded_input_port 
lint report check -severity error unresolved_module 
lint report check -severity error unsynth_access_type 
lint report check -severity error unsynth_alias_declaration 
lint report check -severity error unsynth_allocator 
lint report check -severity error unsynth_arithmetic_operator 
lint report check -severity error unsynth_array_index_type_enum 
lint report check -severity info unsynth_assert_stmt 
lint report check -severity error unsynth_assign_deassign 
lint report check -severity error unsynth_bidirectional_switch 
lint report check -severity error unsynth_block_stmt_header 
lint report check -severity error unsynth_charge_strength 
lint report check -severity error unsynth_clk_in_concurrent_stmt 
lint report check -severity error unsynth_clocking_style 
lint report check -severity error unsynth_const_redefined 
lint report check -severity error unsynth_dc_shell_script 
lint report check -severity error unsynth_deferred_const 
lint report check -severity error unsynth_defparam 
lint report check -severity error unsynth_delay_in_bidirectional_switch 
lint report check -severity error unsynth_delay_in_blocking_assign 
lint report check -severity error unsynth_delay_in_cmos_switch 
lint report check -severity error unsynth_delay_in_gate 
lint report check -severity error unsynth_delay_in_mos_switch 
lint report check -severity error unsynth_delay_in_net_decl 
lint report check -severity error unsynth_delay_in_stmt 
lint report check -severity error unsynth_delay_in_tristate_gate 
lint report check -severity error unsynth_disable_stmt 
lint report check -severity error unsynth_disconnection_spec 
lint report check -severity error unsynth_drive_strength_assign 
lint report check -severity error unsynth_drive_strength_gate 
lint report check -severity error unsynth_else_after_clk_event 
lint report check -severity error unsynth_enum_encoding_attribute 
lint report check -severity error unsynth_event_var 
lint report check -severity error unsynth_file_type 
lint report check -severity error unsynth_force_release 
lint report check -severity error unsynth_fork_join_block 
lint report check -severity error unsynth_func_returns_real 
lint report check -severity warning unsynth_generic_not_int 
lint report check -severity error unsynth_guarded_block_stmt 
lint report check -severity error unsynth_hier_reference 
lint report check -severity error unsynth_initial_stmt 
lint report check -severity error unsynth_initial_value 
lint report check -severity error unsynth_integer_array 
lint report check -severity error unsynth_mos_switch 
lint report check -severity error unsynth_multi_dim_array 
lint report check -severity error unsynth_multi_wait_with_same_clk 
lint report check -severity error unsynth_physical_type 
lint report check -severity error unsynth_pli_task_func 
lint report check -severity error unsynth_port_type 
lint report check -severity error unsynth_port_type_unconstrained 
lint report check -severity error unsynth_predefined_attribute 
lint report check -severity error unsynth_pulldown 
lint report check -severity error unsynth_pullup 
lint report check -severity error unsynth_real_var 
lint report check -severity error unsynth_repeat 
lint report check -severity error unsynth_repeat_in_nonblocking_assign 
lint report check -severity error unsynth_resolution_func 
lint report check -severity error unsynth_sensitivity_list_conditions 
lint report check -severity error unsynth_shift_operator 
lint report check -severity error unsynth_signal_kind_register_bus 
lint report check -severity error unsynth_specify_block 
lint report check -severity error unsynth_stmt_in_entity 
lint report check -severity error unsynth_time_var 
lint report check -severity error unsynth_tri_net 
lint report check -severity error unsynth_type_declaration_incomplete 
lint report check -severity error unsynth_udp 
lint report check -severity error unsynth_user_defined_attribute 
lint report check -severity error unsynth_wait_stmt 
lint report check -severity error unsynth_wand_wor_net 
lint report check -severity error unsynth_while_in_subprogram 
lint report check -severity error unsynth_while_loop 
lint report check -severity info user_blackbox 
lint report check -severity warning var_assign_in_process 
lint report check -severity warning var_assign_without_deassign 
lint report check -severity warning var_deassign_without_assign 
lint report check -severity error var_forced_without_release 
lint report check -severity error var_index_range_insufficient 
lint report check -severity error var_name_duplicate 
lint report check -severity error var_read_before_set 
lint report check -severity error var_released_without_force 
lint report check -severity warning when_else_nested 
lint report check -severity warning while_loop_iteration_limit 
lint methodology soc -goal implementation 
lint run -d TOP -L work
set qsDebug { lint_gui_mode } 
# 
# Questa Static Verification System
# Version 2021.1 4558100 win64 28-Jan-2021

clear settings -all
clear directives
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
clear settings  -lib
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
#clear directives 
#clear directives 
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#lint run -d TOP -L work
clear settings  -lib
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
#configure output directory  D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System
#clear directives 
lint on clk_port_conn_complex 
lint on clock_gated 
lint on clock_internal 
lint on clock_path_buffer 
lint on clock_signal_as_non_clock 
lint on flop_with_inverted_clock 
lint on bus_bit_as_clk 
lint on clock_in_wait_stmt 
lint on clock_with_both_edges 
lint on seq_block_has_multi_clks 
lint on unsynth_clk_in_concurrent_stmt 
lint on unsynth_clocking_style 
lint on unsynth_else_after_clk_event 
lint on unsynth_multi_wait_with_same_clk 
lint on async_reset_active_high 
lint on bus_conn_to_prim_gate 
lint on feedthrough_path 
lint on flop_clock_reset_loop 
lint on flop_output_as_clock 
lint on flop_redundant 
lint on long_combinational_path 
lint on module_has_blackbox_instance 
lint on re_entrant_output 
lint on tristate_multi_driven 
lint on unconnected_inst 
lint on unconnected_inst_input 
lint on unconnected_inst_output 
lint on undriven_latch_data 
lint on undriven_latch_enable 
lint on undriven_reg_clock 
lint on undriven_reg_data 
lint on undriven_signal 
lint on unloaded_input_port 
lint on const_latch_data 
lint on const_output 
lint on const_reg_clock 
lint on const_reg_data 
lint on const_signal 
lint on mux_select_const 
lint on blackbox_input_conn_inconsistent 
lint on blackbox_output_control_signal 
lint on bus_conn_to_inst_reversed 
lint on combo_path_input_to_output 
lint on generic_map_ordered 
lint on inout_port_exists 
lint on inout_port_not_set 
lint on inout_port_unused 
lint on input_port_set 
lint on module_without_ports 
lint on ordered_port_connection 
lint on port_conn_is_expression 
lint on comment_has_control_char 
lint on comment_not_in_english 
lint on identifier_with_error_warning 
lint on parameter_name_duplicate 
lint on reserved_keyword 
lint on var_name_duplicate 
lint on async_block_top_stmt_not_if 
lint on async_control_is_gated 
lint on async_control_is_internal 
lint on flop_async_reset_const 
lint on flop_without_control 
lint on reset_port_connection_static 
lint on signal_sync_async 
lint on always_has_inconsistent_async_control 
lint on always_has_multiple_async_control 
lint on func_as_reset_condition 
lint on process_has_inconsistent_async_control 
lint on process_has_multiple_async_control 
lint on reset_polarity_mismatch 
lint on reset_pragma_mismatch 
lint on reset_set_non_const_assign 
lint on reset_set_with_both_polarity 
lint on seq_block_first_stmt_not_if 
lint on seq_block_has_complex_cond 
lint on assign_chain 
lint on assign_int_to_reg 
lint on assign_others_to_slice 
lint on assign_real_to_bit 
lint on assign_real_to_int 
lint on assign_real_to_reg 
lint on assign_reg_to_int 
lint on assign_reg_to_real 
lint on assign_to_supply_net 
lint on signal_with_negative_value 
lint on var_assign_without_deassign 
lint on var_deassign_without_assign 
lint on var_forced_without_release 
lint on var_released_without_force 
lint on case_default_redundant 
lint on case_item_invalid 
lint on case_item_not_const 
lint on case_large 
lint on case_nested 
lint on case_others_null 
lint on case_select_const 
lint on case_select_has_expr 
lint on data_event_has_edge 
lint on delay_in_non_flop_expr 
lint on arith_expr_with_conditional_operator 
lint on comparison_has_real_operand 
lint on complex_expression 
lint on condition_const 
lint on condition_has_assign 
lint on condition_is_multi_bit 
lint on conditional_operator_nested 
lint on data_type_bit_select_invalid 
lint on div_mod_rhs_var 
lint on div_mod_rhs_zero 
lint on exponent_negative 
lint on logical_not_on_multi_bit 
lint on logical_operator_on_multi_bit 
lint on multiplication_operator 
lint on operand_redundant 
lint on qualified_expression 
lint on reduction_operator_on_single_bit 
lint on signed_unsigned_mixed_expr 
lint on fsm_state_count_large 
lint on fsm_without_one_hot_encoding 
lint on func_arg_array_constrained 
lint on func_bit_not_set 
lint on func_input_unused 
lint on func_input_width_mismatch 
lint on func_return_before_last_stmt 
lint on func_return_range_fixed 
lint on func_return_range_mismatch 
lint on func_sets_global_var 
lint on func_to_stdlogicvector 
lint on subroutines_recursive_loop 
lint on for_loop_var_init_not_const 
lint on for_stmt_with_complex_logic 
lint on gen_loop_index_not_int 
lint on loop_condition_const 
lint on loop_index_in_multi_always_blocks 
lint on loop_index_modified 
lint on loop_index_not_int 
lint on loop_step_incorrect 
lint on loop_var_not_in_condition 
lint on loop_var_not_in_init 
lint on synth_pragma_prefix_missing 
lint on while_loop_iteration_limit 
lint on module_with_duplicate_ports 
lint on module_with_null_port 
lint on multi_ports_in_single_line 
lint on parameter_count_large 
lint on sensitivity_list_edge_multi_bit 
lint on sensitivity_list_operator_unexpected 
lint on sensitivity_list_signal_repeated 
lint on procedure_sets_global_var 
lint on task_in_combo_block 
lint on task_in_seq_block 
lint on task_sets_global_var 
lint on loop_with_next_exit 
lint on unsynth_allocator 
lint on unsynth_wand_wor_net 
lint on assign_with_multi_arith_operations 
lint on div_mod_rem_operand_complex_expr 
lint on loop_without_break 
lint on tristate_enable_with_expr 
lint on unsynth_dc_shell_script 
lint on unsynth_sensitivity_list_conditions 
lint on always_exceeds_line_limit 
lint on always_signal_assign_large 
lint on always_without_event 
lint on array_index_with_expr 
lint on bit_order_reversed 
lint on bus_bits_in_multi_seq_blocks 
lint on bus_bits_not_read 
lint on bus_bits_not_set 
lint on case_condition_with_tristate 
lint on case_stmt_with_parallel_case 
lint on case_with_memory_output 
lint on concurrent_block_with_duplicate_assign 
lint on conversion_to_stdlogicvector_invalid 
lint on data_type_std_ulogic 
lint on design_ware_inst 
lint on else_condition_dangling 
lint on empty_block 
lint on empty_module 
lint on empty_stmt 
lint on enum_decl_invalid 
lint on flop_output_in_initial 
lint on func_expr_input_size_mismatch 
lint on gen_inst_label_duplicate 
lint on gen_label_duplicate 
lint on gen_label_missing 
lint on if_condition_with_tristate 
lint on if_else_if_can_be_case 
lint on if_else_nested_large 
lint on if_stmt_shares_arithmetic_operator 
lint on if_stmt_with_arith_expr 
lint on if_with_memory_output 
lint on implicit_wire 
lint on inferred_blackbox 
lint on inst_param_width_overflow 
lint on int_without_range 
lint on latch_inferred 
lint on line_char_large 
lint on memory_not_set 
lint on memory_redefined 
lint on multi_wave_element 
lint on part_select_illegal 
lint on power_operand_invalid 
lint on pragma_coverage_off_nested 
lint on pragma_translate_off_nested 
lint on pragma_translate_on_nested 
lint on procedure_call 
lint on process_exceeds_line_limit 
lint on process_signal_assign_large 
lint on process_var_assign_disorder 
lint on process_without_event 
lint on record_type 
lint on reference_event_without_edge 
lint on selected_signal_stmt 
lint on seq_block_has_duplicate_assign 
lint on shared_variable_in_multi_process 
lint on signal_assign_in_multi_initial 
lint on stable_attribute 
lint on std_packages_mixed 
lint on string_has_control_char 
lint on sync_read_as_async 
lint on synopsys_attribute 
lint on tristate_inferred 
lint on tristate_not_at_top_level 
lint on tristate_other_desc_mixed 
lint on two_state_data_type 
lint on unresolved_module 
lint on user_blackbox 
lint on var_assign_in_process 
lint on var_index_range_insufficient 
lint on var_read_before_set 
lint on when_else_nested 
lint on assign_width_overflow 
lint on assign_width_underflow 
lint on case_width_mismatch 
lint on comparison_width_mismatch 
lint on concat_expr_with_unsized_operand 
lint on div_mod_lhs_too_wide 
lint on div_mod_rhs_too_wide 
lint on expr_operands_width_mismatch 
lint on inst_port_width_mismatch 
lint on func_return_value_unspecified 
lint on sensitivity_list_var_modified 
lint on always_has_multiple_events 
lint on assign_or_comparison_has_x 
lint on assign_or_comparison_has_z 
lint on case_default_missing 
lint on case_default_not_last_item 
lint on case_item_duplicate 
lint on case_pragma_redundant 
lint on case_with_x_z 
lint on casex 
lint on casez 
lint on casez_has_x 
lint on data_type_not_recommended 
lint on for_loop_with_wait 
lint on func_nonblocking_assign 
lint on incomplete_case_stmt_with_full_case 
lint on index_x_z 
lint on process_has_async_set_reset 
lint on sensitivity_list_var_missing 
lint on sim_synth_mismatch_assign_event 
lint on sim_synth_mismatch_shared_var 
lint on sim_synth_mismatch_tristate_compare 
lint on std_logic_vector_without_range 
lint on unsynth_delay_in_blocking_assign 
lint on unsynth_delay_in_stmt 
lint on unsynth_initial_value 
lint on assigns_mixed 
lint on assigns_mixed_in_always_block 
lint on blocking_assign_in_seq_block 
lint on combo_loop 
lint on combo_loop_with_latch 
lint on multi_driven_signal 
lint on nonblocking_assign_and_delay_in_always 
lint on nonblocking_assign_in_combo_block 
lint on attribute_with_keyword_all 
lint on const_with_inconsistent_value 
lint on repeat_ctrl_not_const 
lint on unsynth_access_type 
lint on unsynth_alias_declaration 
lint on unsynth_assert_stmt 
lint on unsynth_assign_deassign 
lint on unsynth_bidirectional_switch 
lint on unsynth_charge_strength 
lint on unsynth_deferred_const 
lint on unsynth_defparam 
lint on unsynth_disable_stmt 
lint on unsynth_disconnection_spec 
lint on unsynth_drive_strength_assign 
lint on unsynth_drive_strength_gate 
lint on unsynth_enum_encoding_attribute 
lint on unsynth_event_var 
lint on unsynth_file_type 
lint on unsynth_force_release 
lint on unsynth_fork_join_block 
lint on unsynth_guarded_block_stmt 
lint on unsynth_initial_stmt 
lint on unsynth_integer_array 
lint on unsynth_mos_switch 
lint on unsynth_multi_dim_array 
lint on unsynth_pli_task_func 
lint on unsynth_port_type 
lint on unsynth_port_type_unconstrained 
lint on unsynth_predefined_attribute 
lint on unsynth_pulldown 
lint on unsynth_pullup 
lint on unsynth_real_var 
lint on unsynth_repeat 
lint on unsynth_resolution_func 
lint on unsynth_shift_operator 
lint on unsynth_signal_kind_register_bus 
lint on unsynth_specify_block 
lint on unsynth_time_var 
lint on unsynth_tri_net 
lint on unsynth_udp 
lint on unsynth_user_defined_attribute 
lint on unsynth_wait_stmt 
lint on always_has_nested_event_control 
lint on case_eq_operator 
lint on div_mod_rhs_invalid 
lint on port_exp_with_integer 
lint on sensitivity_list_var_both_edges 
lint on synth_pragma_prefix_invalid 
lint on task_has_event 
lint on unsynth_arithmetic_operator 
lint on unsynth_array_index_type_enum 
lint on unsynth_block_stmt_header 
lint on unsynth_const_redefined 
lint on unsynth_delay_in_bidirectional_switch 
lint on unsynth_delay_in_cmos_switch 
lint on unsynth_delay_in_gate 
lint on unsynth_delay_in_mos_switch 
lint on unsynth_delay_in_net_decl 
lint on unsynth_delay_in_tristate_gate 
lint on unsynth_func_returns_real 
lint on unsynth_generic_not_int 
lint on unsynth_hier_reference 
lint on unsynth_physical_type 
lint on unsynth_repeat_in_nonblocking_assign 
lint on unsynth_stmt_in_entity 
lint on unsynth_type_declaration_incomplete 
lint on unsynth_while_in_subprogram 
lint on unsynth_while_loop 
lint on task_has_event_and_input 
lint on task_has_event_and_output 
lint preference -allow_non_port_data_types reg wire tri integer logic interface -allow_port_data_types reg wire tri integer logic interface 
lint report check -severity info always_exceeds_line_limit 
lint report check -severity warning always_has_inconsistent_async_control 
lint report check -severity info always_has_multiple_async_control 
lint report check -severity error always_has_multiple_events 
lint report check -severity warning always_has_nested_event_control 
lint report check -severity warning always_signal_assign_large 
lint report check -severity error always_without_event 
lint report check -severity error arith_expr_with_conditional_operator 
lint report check -severity error array_index_with_expr 
lint report check -severity warning assign_chain 
lint report check -severity error assign_int_to_reg 
lint report check -severity error assign_or_comparison_has_x 
lint report check -severity error assign_or_comparison_has_z 
lint report check -severity info assign_others_to_slice 
lint report check -severity error assign_real_to_bit 
lint report check -severity error assign_real_to_int 
lint report check -severity error assign_real_to_reg 
lint report check -severity error assign_reg_to_int 
lint report check -severity error assign_reg_to_real 
lint report check -severity info assign_to_supply_net 
lint report check -severity error assign_width_overflow 
lint report check -severity error assign_width_underflow 
lint report check -severity warning assign_with_multi_arith_operations 
lint report check -severity error assigns_mixed 
lint report check -severity error assigns_mixed_in_always_block 
lint report check -severity error async_block_top_stmt_not_if 
lint report check -severity warning async_control_is_gated 
lint report check -severity error async_control_is_internal 
lint report check -severity info async_reset_active_high 
lint report check -severity error attribute_with_keyword_all 
lint report check -severity warning bit_order_reversed 
lint report check -severity error blackbox_input_conn_inconsistent 
lint report check -severity error blackbox_output_control_signal 
lint report check -severity error blocking_assign_in_seq_block 
lint report check -severity error bus_bit_as_clk 
lint report check -severity error bus_bits_in_multi_seq_blocks 
lint report check -severity warning bus_bits_not_read 
lint report check -severity warning bus_bits_not_set 
lint report check -severity error bus_conn_to_inst_reversed 
lint report check -severity warning bus_conn_to_prim_gate 
lint report check -severity error case_condition_with_tristate 
lint report check -severity error case_default_missing 
lint report check -severity error case_default_not_last_item 
lint report check -severity info case_default_redundant 
lint report check -severity error case_eq_operator 
lint report check -severity error case_item_duplicate 
lint report check -severity error case_item_invalid 
lint report check -severity error case_item_not_const 
lint report check -severity info case_large 
lint report check -severity warning case_nested 
lint report check -severity info case_others_null 
lint report check -severity info case_pragma_redundant 
lint report check -severity error case_select_const 
lint report check -severity warning case_select_has_expr 
lint report check -severity error case_stmt_with_parallel_case 
lint report check -severity error case_width_mismatch 
lint report check -severity error case_with_memory_output 
lint report check -severity error case_with_x_z 
lint report check -severity error casex 
lint report check -severity info casez 
lint report check -severity error casez_has_x 
lint report check -severity error clk_port_conn_complex 
lint report check -severity warning clock_gated 
lint report check -severity error clock_in_wait_stmt 
lint report check -severity warning clock_internal 
lint report check -severity info clock_path_buffer 
lint report check -severity error clock_signal_as_non_clock 
lint report check -severity info clock_with_both_edges 
lint report check -severity error combo_loop 
lint report check -severity error combo_loop_with_latch 
lint report check -severity info combo_path_input_to_output 
lint report check -severity info comment_has_control_char 
lint report check -severity info comment_not_in_english 
lint report check -severity info comparison_has_real_operand 
lint report check -severity error comparison_width_mismatch 
lint report check -severity info complex_expression 
lint report check -severity info concat_expr_with_unsized_operand 
lint report check -severity warning concurrent_block_with_duplicate_assign 
lint report check -severity warning condition_const 
lint report check -severity error condition_has_assign 
lint report check -severity error condition_is_multi_bit 
lint report check -severity info conditional_operator_nested 
lint report check -severity info const_latch_data 
lint report check -severity info const_output 
lint report check -severity info const_reg_clock 
lint report check -severity info const_reg_data 
lint report check -severity info const_signal 
lint report check -severity error const_with_inconsistent_value 
lint report check -severity error conversion_to_stdlogicvector_invalid 
lint report check -severity warning data_event_has_edge 
lint report check -severity warning data_type_bit_select_invalid 
lint report check -severity warning data_type_not_recommended 
lint report check -severity info data_type_std_ulogic 
lint report check -severity info delay_in_non_flop_expr 
lint report check -severity info design_ware_inst 
lint report check -severity warning div_mod_lhs_too_wide 
lint report check -severity warning div_mod_rem_operand_complex_expr 
lint report check -severity error div_mod_rhs_invalid 
lint report check -severity warning div_mod_rhs_too_wide 
lint report check -severity error div_mod_rhs_var 
lint report check -severity error div_mod_rhs_zero 
lint report check -severity error else_condition_dangling 
lint report check -severity error empty_block 
lint report check -severity error empty_module 
lint report check -severity info empty_stmt 
lint report check -severity warning enum_decl_invalid 
lint report check -severity error exponent_negative 
lint report check -severity error expr_operands_width_mismatch 
lint report check -severity info feedthrough_path 
lint report check -severity info flop_async_reset_const 
lint report check -severity error flop_clock_reset_loop 
lint report check -severity warning flop_output_as_clock 
lint report check -severity warning flop_output_in_initial 
lint report check -severity info flop_redundant 
lint report check -severity info flop_with_inverted_clock 
lint report check -severity info flop_without_control 
lint report check -severity error for_loop_var_init_not_const 
lint report check -severity error for_loop_with_wait 
lint report check -severity warning for_stmt_with_complex_logic 
lint report check -severity info fsm_state_count_large 
lint report check -severity info fsm_without_one_hot_encoding 
lint report check -severity warning func_arg_array_constrained 
lint report check -severity error func_as_reset_condition 
lint report check -severity error func_bit_not_set 
lint report check -severity error func_expr_input_size_mismatch 
lint report check -severity info func_input_unused 
lint report check -severity error func_input_width_mismatch 
lint report check -severity error func_nonblocking_assign 
lint report check -severity warning func_return_before_last_stmt 
lint report check -severity error func_return_range_fixed 
lint report check -severity error func_return_range_mismatch 
lint report check -severity error func_return_value_unspecified 
lint report check -severity error func_sets_global_var 
lint report check -severity warning func_to_stdlogicvector 
lint report check -severity error gen_inst_label_duplicate 
lint report check -severity error gen_label_duplicate 
lint report check -severity info gen_label_missing 
lint report check -severity error gen_loop_index_not_int 
lint report check -severity warning generic_map_ordered 
lint report check -severity info identifier_with_error_warning 
lint report check -severity error if_condition_with_tristate 
lint report check -severity info if_else_if_can_be_case 
lint report check -severity warning if_else_nested_large 
lint report check -severity error if_stmt_shares_arithmetic_operator 
lint report check -severity warning if_stmt_with_arith_expr 
lint report check -severity warning if_with_memory_output 
lint report check -severity info implicit_wire 
lint report check -severity error incomplete_case_stmt_with_full_case 
lint report check -severity error index_x_z 
lint report check -severity error inferred_blackbox 
lint report check -severity info inout_port_exists 
lint report check -severity warning inout_port_not_set 
lint report check -severity info inout_port_unused 
lint report check -severity error input_port_set 
lint report check -severity error inst_param_width_overflow 
lint report check -severity error inst_port_width_mismatch 
lint report check -severity info int_without_range 
lint report check -severity warning latch_inferred 
lint report check -severity info line_char_large 
lint report check -severity warning logical_not_on_multi_bit 
lint report check -severity warning logical_operator_on_multi_bit 
lint report check -severity error long_combinational_path 
lint report check -severity error loop_condition_const 
lint report check -severity error loop_index_in_multi_always_blocks 
lint report check -severity error loop_index_modified 
lint report check -severity error loop_index_not_int 
lint report check -severity error loop_step_incorrect 
lint report check -severity error loop_var_not_in_condition 
lint report check -severity error loop_var_not_in_init 
lint report check -severity error loop_with_next_exit 
lint report check -severity error loop_without_break 
lint report check -severity warning memory_not_set 
lint report check -severity warning memory_redefined 
lint report check -severity warning module_has_blackbox_instance 
lint report check -severity error module_with_duplicate_ports 
lint report check -severity error module_with_null_port 
lint report check -severity warning module_without_ports 
lint report check -severity error multi_driven_signal 
lint report check -severity info multi_ports_in_single_line 
lint report check -severity warning multi_wave_element 
lint report check -severity info multiplication_operator 
lint report check -severity warning mux_select_const 
lint report check -severity warning nonblocking_assign_and_delay_in_always 
lint report check -severity error nonblocking_assign_in_combo_block 
lint report check -severity error operand_redundant 
lint report check -severity warning ordered_port_connection 
lint report check -severity info parameter_count_large 
lint report check -severity info parameter_name_duplicate 
lint report check -severity error part_select_illegal 
lint report check -severity error port_conn_is_expression 
lint report check -severity error port_exp_with_integer 
lint report check -severity error power_operand_invalid 
lint report check -severity warning pragma_coverage_off_nested 
lint report check -severity warning pragma_translate_off_nested 
lint report check -severity error pragma_translate_on_nested 
lint report check -severity warning procedure_call 
lint report check -severity error procedure_sets_global_var 
lint report check -severity warning process_exceeds_line_limit 
lint report check -severity info process_has_async_set_reset 
lint report check -severity warning process_has_inconsistent_async_control 
lint report check -severity info process_has_multiple_async_control 
lint report check -severity warning process_signal_assign_large 
lint report check -severity warning process_var_assign_disorder 
lint report check -severity error process_without_event 
lint report check -severity info qualified_expression 
lint report check -severity info re_entrant_output 
lint report check -severity warning record_type 
lint report check -severity info reduction_operator_on_single_bit 
lint report check -severity warning reference_event_without_edge 
lint report check -severity error repeat_ctrl_not_const 
lint report check -severity info reserved_keyword 
lint report check -severity error reset_polarity_mismatch 
lint report check -severity info reset_port_connection_static 
lint report check -severity error reset_pragma_mismatch 
lint report check -severity error reset_set_non_const_assign 
lint report check -severity error reset_set_with_both_polarity 
lint report check -severity warning selected_signal_stmt 
lint report check -severity error sensitivity_list_edge_multi_bit 
lint report check -severity error sensitivity_list_operator_unexpected 
lint report check -severity warning sensitivity_list_signal_repeated 
lint report check -severity warning sensitivity_list_var_both_edges 
lint report check -severity error sensitivity_list_var_missing 
lint report check -severity error sensitivity_list_var_modified 
lint report check -severity error seq_block_first_stmt_not_if 
lint report check -severity warning seq_block_has_complex_cond 
lint report check -severity warning seq_block_has_duplicate_assign 
lint report check -severity error seq_block_has_multi_clks 
lint report check -severity error shared_variable_in_multi_process 
lint report check -severity warning signal_assign_in_multi_initial 
lint report check -severity error signal_sync_async 
lint report check -severity error signal_with_negative_value 
lint report check -severity error signed_unsigned_mixed_expr 
lint report check -severity error sim_synth_mismatch_assign_event 
lint report check -severity error sim_synth_mismatch_shared_var 
lint report check -severity error sim_synth_mismatch_tristate_compare 
lint report check -severity error stable_attribute 
lint report check -severity error std_logic_vector_without_range 
lint report check -severity info std_packages_mixed 
lint report check -severity warning string_has_control_char 
lint report check -severity error subroutines_recursive_loop 
lint report check -severity warning sync_read_as_async 
lint report check -severity info synopsys_attribute 
lint report check -severity error synth_pragma_prefix_invalid 
lint report check -severity error synth_pragma_prefix_missing 
lint report check -severity error task_has_event 
lint report check -severity info task_has_event_and_input 
lint report check -severity info task_has_event_and_output 
lint report check -severity error task_in_combo_block 
lint report check -severity error task_in_seq_block 
lint report check -severity error task_sets_global_var 
lint report check -severity warning tristate_enable_with_expr 
lint report check -severity warning tristate_inferred 
lint report check -severity info tristate_multi_driven 
lint report check -severity warning tristate_not_at_top_level 
lint report check -severity info tristate_other_desc_mixed 
lint report check -severity info two_state_data_type 
lint report check -severity info unconnected_inst 
lint report check -severity error unconnected_inst_input 
lint report check -severity warning unconnected_inst_output 
lint report check -severity warning undriven_latch_data 
lint report check -severity warning undriven_latch_enable 
lint report check -severity warning undriven_reg_clock 
lint report check -severity warning undriven_reg_data 
lint report check -severity error undriven_signal 
lint report check -severity info unloaded_input_port 
lint report check -severity error unresolved_module 
lint report check -severity error unsynth_access_type 
lint report check -severity error unsynth_alias_declaration 
lint report check -severity error unsynth_allocator 
lint report check -severity error unsynth_arithmetic_operator 
lint report check -severity error unsynth_array_index_type_enum 
lint report check -severity info unsynth_assert_stmt 
lint report check -severity error unsynth_assign_deassign 
lint report check -severity error unsynth_bidirectional_switch 
lint report check -severity error unsynth_block_stmt_header 
lint report check -severity error unsynth_charge_strength 
lint report check -severity error unsynth_clk_in_concurrent_stmt 
lint report check -severity error unsynth_clocking_style 
lint report check -severity error unsynth_const_redefined 
lint report check -severity error unsynth_dc_shell_script 
lint report check -severity error unsynth_deferred_const 
lint report check -severity error unsynth_defparam 
lint report check -severity error unsynth_delay_in_bidirectional_switch 
lint report check -severity error unsynth_delay_in_blocking_assign 
lint report check -severity error unsynth_delay_in_cmos_switch 
lint report check -severity error unsynth_delay_in_gate 
lint report check -severity error unsynth_delay_in_mos_switch 
lint report check -severity error unsynth_delay_in_net_decl 
lint report check -severity error unsynth_delay_in_stmt 
lint report check -severity error unsynth_delay_in_tristate_gate 
lint report check -severity error unsynth_disable_stmt 
lint report check -severity error unsynth_disconnection_spec 
lint report check -severity error unsynth_drive_strength_assign 
lint report check -severity error unsynth_drive_strength_gate 
lint report check -severity error unsynth_else_after_clk_event 
lint report check -severity error unsynth_enum_encoding_attribute 
lint report check -severity error unsynth_event_var 
lint report check -severity error unsynth_file_type 
lint report check -severity error unsynth_force_release 
lint report check -severity error unsynth_fork_join_block 
lint report check -severity error unsynth_func_returns_real 
lint report check -severity warning unsynth_generic_not_int 
lint report check -severity error unsynth_guarded_block_stmt 
lint report check -severity error unsynth_hier_reference 
lint report check -severity error unsynth_initial_stmt 
lint report check -severity error unsynth_initial_value 
lint report check -severity error unsynth_integer_array 
lint report check -severity error unsynth_mos_switch 
lint report check -severity error unsynth_multi_dim_array 
lint report check -severity error unsynth_multi_wait_with_same_clk 
lint report check -severity error unsynth_physical_type 
lint report check -severity error unsynth_pli_task_func 
lint report check -severity error unsynth_port_type 
lint report check -severity error unsynth_port_type_unconstrained 
lint report check -severity error unsynth_predefined_attribute 
lint report check -severity error unsynth_pulldown 
lint report check -severity error unsynth_pullup 
lint report check -severity error unsynth_real_var 
lint report check -severity error unsynth_repeat 
lint report check -severity error unsynth_repeat_in_nonblocking_assign 
lint report check -severity error unsynth_resolution_func 
lint report check -severity error unsynth_sensitivity_list_conditions 
lint report check -severity error unsynth_shift_operator 
lint report check -severity error unsynth_signal_kind_register_bus 
lint report check -severity error unsynth_specify_block 
lint report check -severity error unsynth_stmt_in_entity 
lint report check -severity error unsynth_time_var 
lint report check -severity error unsynth_tri_net 
lint report check -severity error unsynth_type_declaration_incomplete 
lint report check -severity error unsynth_udp 
lint report check -severity error unsynth_user_defined_attribute 
lint report check -severity error unsynth_wait_stmt 
lint report check -severity error unsynth_wand_wor_net 
lint report check -severity error unsynth_while_in_subprogram 
lint report check -severity error unsynth_while_loop 
lint report check -severity info user_blackbox 
lint report check -severity warning var_assign_in_process 
lint report check -severity warning var_assign_without_deassign 
lint report check -severity warning var_deassign_without_assign 
lint report check -severity error var_forced_without_release 
lint report check -severity error var_index_range_insufficient 
lint report check -severity error var_name_duplicate 
lint report check -severity error var_read_before_set 
lint report check -severity error var_released_without_force 
lint report check -severity warning when_else_nested 
lint report check -severity warning while_loop_iteration_limit 
lint methodology soc -goal implementation 
lint run -d TOP -L work
