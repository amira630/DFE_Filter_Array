vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover -l sim.log


add wave *

coverage save Decimator.ucdb -onexit

run -all

#quit -sim

#vcover report Decimator.ucdb -details -annotate -all -output Decimator_coverage_rpt.txt



