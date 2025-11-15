vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover -l sim.log


add wave *

coverage save IIR.ucdb -onexit

run -all

#quit -sim

#vcover report IIR.ucdb -details -annotate -all -output IIR_coverage_rpt.txt



