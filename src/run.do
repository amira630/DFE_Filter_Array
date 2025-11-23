vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.DFE_tb -cover -l sim.log

add wave *

coverage save DFE.ucdb -onexit

run -all

#quit -sim

#vcover report DFE.ucdb -details -annotate -all -output DFE_coverage_rpt.txt



