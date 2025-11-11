vlib work
vlog INTEG.v COMB.v CIC.v CIC_tb.v
vsim -voptargs=+acc work.CIC_tb
add wave *
run -all