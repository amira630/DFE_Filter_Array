vlib work
vlog APB_Bridge.sv MPRAM.sv APB.sv APB_tb.sv
vsim -voptargs=+acc work.APB_tb
add wave -position insertpoint  \
sim:/APB_tb/i \
sim:/APB_tb/clk_tb \
sim:/APB_tb/rst_n_tb \
sim:/APB_tb/MTRANS_tb \
sim:/APB_tb/MADDR_tb \
sim:/APB_tb/MWRITE_tb \
sim:/APB_tb/MSELx_tb \
sim:/APB_tb/MWDATA_tb \
sim:/APB_tb/MRDATA_tb \
sim:/APB_tb/FRAC_DECI_OUT_tb \
sim:/APB_tb/FRAC_DECI_VLD_tb  \
sim:/APB_tb/IIR_24_OUT_tb \
sim:/APB_tb/IIR_24_VLD_tb \
sim:/APB_tb/IIR_5_1_OUT_tb \
sim:/APB_tb/IIR_5_1_VLD_tb \
sim:/APB_tb/IIR_5_2_OUT_tb \
sim:/APB_tb/IIR_5_2_VLD_tb \
sim:/APB_tb/CTRL_OUT_tb \
sim:/APB_tb/CIC_R_OUT_tb \
sim:/APB_tb/CIC_R_VLD_tb \
sim:/APB_tb/OUT_SEL_tb          \
sim:/APB_tb/FRAC_DECI_STATUS_tb \
sim:/APB_tb/IIR_24_STATUS_tb \
sim:/APB_tb/IIR_5_1_STATUS_tb \
sim:/APB_tb/IIR_5_2_STATUS_tb \
sim:/APB_tb/CIC_STATUS_tb \
sim:/APB_tb/FIR_STATUS_tb \
sim:/APB_tb/DUT/U_APB/PREADY \
sim:/APB_tb/DUT/U_APB/PENABLE \
sim:/APB_tb/DUT/U_APB/PWRITE \
sim:/APB_tb/DUT/U_APB/PADDR \
sim:/APB_tb/DUT/U_APB/PSELx \
sim:/APB_tb/DUT/U_APB/PWDATA \
sim:/APB_tb/DUT/U_APB/current_state \
sim:/APB_tb/DUT/U_APB/next_state 
run -all