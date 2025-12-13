vlib work

vlog -f src_files.list 

vsim -voptargs=+acc work.top_tb -l sim.log

add wave *

add wave -position insertpoint  \
sim:/top_tb/CORE_DUT/IIR/iir_out \
sim:/top_tb/CORE_DUT/IIR/valid_out \
sim:/top_tb/CORE_DUT/IIR/iir_out_1MHz \
sim:/top_tb/CORE_DUT/IIR/iir_out_2_4MHz \
sim:/top_tb/CORE_DUT/IIR/valid_1MHz_out \
sim:/top_tb/CORE_DUT/IIR/valid_2_4MHz_out

run -all

#quit -sim

