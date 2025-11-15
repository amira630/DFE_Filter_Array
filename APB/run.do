vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover


add wave *

coverage save APB.ucdb -onexit

run -all

#quit -sim

#vcover report APB.ucdb -details -annotate -all -output APB_coverage_rpt.txt



