vlib work
vlog APB_Bridge.sv MPRAM.sv APB.sv APB_tb.sv
vsim -voptargs=+acc work.APB_tb
add wave *
run -all