vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover -l sim.log

add wave *

coverage save CIC.ucdb -onexit

run -all

#quit -sim

#vcover report CIC.ucdb -details -annotate -all -output CIC_coverage_rpt.txt



