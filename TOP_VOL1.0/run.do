vlib work

vlog -f src_files.list
vsim -voptargs=+acc work.top_tb -l sim.log

add wave -position insertpoint  \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/DATA_WIDTH \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/DATA_FRAC \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/Q \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/N \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/MAX_DEC_FACTOR \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/ACC_FRAC \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/ACC_WIDTH \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/DEC_WIDTH \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/SCALE \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/clk \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/rst_n \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/valid_in \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/dec_factor \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/cic_in \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/cic_out \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/valid_out \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/overflow \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/underflow \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/intg_out \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/comb_out \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/decimator_out \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/counter \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/dec_in_enable \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/rounded_out \
sim:/top_tb/PHASE_1_DUT/CIC_STAGE/valid_comb_in

add wave -position insertpoint  \
sim:/top_tb/input_sig \
sim:/top_tb/ph1_output_sig \
sim:/top_tb/output_sig_exp


#coverage save PHASE_1.ucdb -onexit

run -all

#quit -sim

#vcover report PHASE_1.ucdb -details -annotate -all -output PHASE_1_coverage_rpt.txt



