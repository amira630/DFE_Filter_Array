vlib work
vlog INTEG.v COMB.v CIC.v CIC_tb.v
vsim -voptargs=+acc work.CIC_tb
add wave *
add wave -position insertpoint  \
sim:/CIC_tb/DUT/en_d \
sim:/CIC_tb/DUT/count_down
run -all