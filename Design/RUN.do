vlib work
vlog APB_Bridge.sv APB_Bridge_tb.sv
vsim -voptargs=+acc work.APB_Bridge_tb
add wave -position insertpoint  \
sim:/APB_Bridge_tb/clk_tb \
sim:/APB_Bridge_tb/rst_n_tb \
sim:/APB_Bridge_tb/MTRANS_tb \
sim:/APB_Bridge_tb/MADDR_tb \
sim:/APB_Bridge_tb/MWRITE_tb \
sim:/APB_Bridge_tb/MSELx_tb \
sim:/APB_Bridge_tb/MRDATA_tb \
sim:/APB_Bridge_tb/MWDATA_tb \
sim:/APB_Bridge_tb/PADDR_tb \
sim:/APB_Bridge_tb/PWRITE_tb \
sim:/APB_Bridge_tb/PSELx_tb \
sim:/APB_Bridge_tb/PENABLE_tb \
sim:/APB_Bridge_tb/PWDATA_tb \
sim:/APB_Bridge_tb/PREADY_tb \
sim:/APB_Bridge_tb/PRDATA_tb \
sim:/APB_Bridge_tb/DUT/current_state \
sim:/APB_Bridge_tb/DUT/next_state \
sim:/APB_Bridge_tb/RW/waits \
sim:/APB_Bridge_tb/DUT/SELx_reg \
sim:/APB_Bridge_tb/DUT/ADDR_reg \
sim:/APB_Bridge_tb/DUT/WDATA_reg \
sim:/APB_Bridge_tb/DUT/WRITE_reg \
sim:/APB_Bridge_tb/DUT/READY_reg
run -all