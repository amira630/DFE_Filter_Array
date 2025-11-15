vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover -l sim.log

add wave -position insertpoint  \
sim:/top_tb/clk

add wave -position insertpoint  \
sim:/top_tb/valid_in_tb

add wave -position insertpoint  \
sim:/top_tb/valid_out_tb

add wave -position insertpoint  \
sim:/top_tb/input_sig \
sim:/top_tb/ph1_output_sig \
sim:/top_tb/output_sig_exp

coverage save PHASE_1.ucdb -onexit

run -all

#quit -sim

#vcover report PHASE_1.ucdb -details -annotate -all -output PHASE_1_coverage_rpt.txt



