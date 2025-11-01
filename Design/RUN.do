vlib work
vlog MUX2x1.v  SUM.v Frac_Deci.v Frac_Deci_tb.v
vsim -voptargs=+acc work.Frac_Deci_tb
add wave *
add wave -position insertpoint  \
sim:/Frac_Deci_tb/DUT/x_in \
sim:/Frac_Deci_tb/DUT/x_buf \
sim:/Frac_Deci_tb/DUT/count_M \
sim:/Frac_Deci_tb/DUT/count_L \
sim:/Frac_Deci_tb/DUT/x_reg \
sim:/Frac_Deci_tb/DUT/sum_out \
sim:/Frac_Deci_tb/DUT/wr_ptr \
sim:/Frac_Deci_tb/DUT/h_k \
sim:/Frac_Deci_tb/DUT/h_k_reg
run -all