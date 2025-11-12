vlib work
vlog IIR.v Cascaded_IIR.v Cascaded_IIR_tb.v
vsim -voptargs=+acc work.Cascaded_IIR_tb
add wave *
run -all