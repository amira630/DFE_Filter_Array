vlib work
vlog FIR.v FIR_tb.v
vsim -voptargs=+acc work.FIR_tb
add wave *
add wave -position insertpoint  \
sim:/FIR_tb/DUT/acc \
sim:/FIR_tb/DUT/int_reg \
sim:/FIR_tb/DUT/N \
sim:/FIR_tb/DUT/coeff
run -all