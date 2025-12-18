vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.DFE_tb -cover -l sim.log

add wave -position insertpoint  \
sim:/DFE_tb/clk_tb \
sim:/DFE_tb/rst_n_tb \
sim:/DFE_tb/valid_in_tb \
sim:/DFE_tb/DUT/U_CORE/frac_dec_bypass \
sim:/DFE_tb/DUT/U_CORE/iir_bypass_2_4MHz \
sim:/DFE_tb/DUT/U_CORE/iir_bypass_5MHz \
sim:/DFE_tb/DUT/U_CORE/cic_bypass \
sim:/DFE_tb/arith_base_var \
sim:/DFE_tb/TC \
sim:/DFE_tb/shape_var \
sim:/DFE_tb/dec_factor \
sim:/DFE_tb/input_sig \
sim:/DFE_tb/frac_decimator_sig \
sim:/DFE_tb/frac_decimator_sig_tb \
sim:/DFE_tb/iir_24mhz_sig \
sim:/DFE_tb/iir_24mhz_sig_tb \
sim:/DFE_tb/iir_5mhz_1_sig \
sim:/DFE_tb/iir_5mhz_1_sig_tb \
sim:/DFE_tb/cic_sig \
sim:/DFE_tb/cic_sig_tb \
sim:/DFE_tb/output_sig \
sim:/DFE_tb/core_out_sig_tb \
sim:/DFE_tb/error \
sim:/DFE_tb/max_error \
sim:/DFE_tb/overflow_tb \
sim:/DFE_tb/underflow_tb \
sim:/DFE_tb/valid_out_tb \
sim:/DFE_tb/block_var \
sim:/DFE_tb/block_out_sig_tb \
sim:/DFE_tb/status_var \
sim:/DFE_tb/block_overflow_tb \
sim:/DFE_tb/block_underflow_tb \
sim:/DFE_tb/block_valid_out_tb \
sim:/DFE_tb/coeff_var \
sim:/DFE_tb/coeff_out_tb \
sim:/DFE_tb/core_out_fail

add wave -position insertpoint  \
sim:/DFE_tb/DUT/U_CORE/frac_dec_overflow \
sim:/DFE_tb/DUT/U_CORE/frac_dec_underflow \
sim:/DFE_tb/DUT/U_CORE/iir_overflow_1MHz \
sim:/DFE_tb/DUT/U_CORE/iir_underflow_1MHz \
sim:/DFE_tb/DUT/U_CORE/iir_overflow_2_4MHz \
sim:/DFE_tb/DUT/U_CORE/iir_underflow_2_4MHz \
sim:/DFE_tb/DUT/U_CORE/cic_overflow \
sim:/DFE_tb/DUT/U_CORE/cic_underflow

coverage save DFE.ucdb -onexit

run -all

#quit -sim

#vcover report DFE.ucdb -details -annotate -all -output DFE_coverage_rpt.txt



