vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover -l sim.log


add wave *

coverage save CLK_CONVERTER.ucdb -onexit

run -all

#quit -sim

#vcover report CLK_CONVERTER.ucdb -details -annotate -all -output CLK_CONVERTER_coverage_rpt.txt



