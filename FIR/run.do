vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover -l sim.log


add wave *

coverage save FIR.ucdb -onexit

run -all

#quit -sim

#vcover report FIR.ucdb -details -annotate -all -output FIR_coverage_rpt.txt



