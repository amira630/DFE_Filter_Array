vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover -l sim.log

add wave -position insertpoint  \
sim:/top_tb/clk \
sim:/top_tb/rst_n \
sim:/top_tb/valid_in \
sim:/top_tb/bypass \
sim:/top_tb/coeff_out \
sim:/top_tb/overflow \
sim:/top_tb/underflow \
sim:/top_tb/valid_out \
sim:/top_tb/input_sig \
sim:/top_tb/iir_output_sig \
sim:/top_tb/output_sig_exp

coverage save IIR.ucdb -onexit

run -all

#quit -sim

#vcover report IIR.ucdb -details -annotate -all -output IIR_coverage_rpt.txt



