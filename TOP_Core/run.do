vlib work

vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top_tb -cover -l sim.log

add wave *
#add wave -position insertpoint  \
#sim:/top_tb/DUT/ARITH_HANDLER/data_in \
#sim:/top_tb/DUT/ARITH_HANDLER/valid_in \
#sim:/top_tb/DUT/ARITH_HANDLER/data_out \
#sim:/top_tb/DUT/ARITH_HANDLER/overflow \
#sim:/top_tb/DUT/ARITH_HANDLER/underflow \
#sim:/top_tb/DUT/ARITH_HANDLER/valid_out \
#sim:/top_tb/DUT/ARITH_HANDLER/acc_in \
#sim:/top_tb/DUT/ARITH_HANDLER/guard_bit \
#sim:/top_tb/DUT/ARITH_HANDLER/round_bit \
#sim:/top_tb/DUT/ARITH_HANDLER/sticky_bit \
#sim:/top_tb/DUT/ARITH_HANDLER/raw \
#sim:/top_tb/DUT/ARITH_HANDLER/increment \
#sim:/top_tb/DUT/ARITH_HANDLER/result_interm \
#sim:/top_tb/DUT/ARITH_HANDLER/shifted_acc

coverage save CIC.ucdb -onexit

run -all

#quit -sim

#vcover report CIC.ucdb -details -annotate -all -output CIC_coverage_rpt.txt



