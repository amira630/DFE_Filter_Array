vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover


add wave *

coverage save Interpolator.ucdb -onexit

run -all

#quit -sim

#vcover report Interpolator.ucdb -details -annotate -all -output Interpolator_coverage_rpt.txt



