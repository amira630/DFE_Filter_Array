vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover -l sim.log

add wave -position insertpoint  \
sim:/top_tb/fractional_Decimator/clk

add wave -position insertpoint  \
sim:/top_tb/fractional_Decimator/valid_out

add wave -position insertpoint  \
sim:/top_tb/number_of_output_samples \
sim:/top_tb/input_sig \
sim:/top_tb/frac_output_sig \
sim:/top_tb/output_sig_exp

coverage save Fractional_Decimator.ucdb -onexit

run -all

#quit -sim

#vcover report Fractional_Decimator.ucdb -details -annotate -all -output Fractional_Decimator_coverage_rpt.txt



