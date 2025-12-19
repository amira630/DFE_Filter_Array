## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 111.111 -name sys_clk_pin -waveform {0.000 55.556} -add [get_ports clk]

## Set default IOSTANDARD for all ports first (catch-all)
set_property IOSTANDARD LVCMOS33 [get_ports -filter { NAME !~ "clk" }]

## Allow bitstream generation with unspecified pin locations (for ILA debug core)
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

## Set IOSTANDARD and location constraints for all ports
## Buttons
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports rst_n]

## Switches (SW0-SW15)
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {core_in[0]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {core_in[1]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {core_in[2]}]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports {core_in[3]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports {core_in[4]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {core_in[5]}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {core_in[6]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {core_in[7]}]
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {core_in[8]}]
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {core_in[9]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {core_in[10]}]
set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports {core_in[11]}]
set_property -dict {PACKAGE_PIN W2 IOSTANDARD LVCMOS33} [get_ports {core_in[12]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {core_in[13]}]
set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {core_in[14]}]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {core_in[15]}]

## LEDs (LD0-LD15)
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {core_out[0]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {core_out[1]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {core_out[2]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {core_out[3]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {core_out[4]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {core_out[5]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {core_out[6]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {core_out[7]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports {core_out[8]}]
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports {core_out[9]}]
set_property -dict {PACKAGE_PIN W3 IOSTANDARD LVCMOS33} [get_ports {core_out[10]}]
set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports {core_out[11]}]
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {core_out[12]}]
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {core_out[13]}]
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {core_out[14]}]
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {core_out[15]}]

## Pmod JA (Top row: JA1-JA4, Bottom row: JA7-JA10)
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports {cic_dec_factor[0]}]
set_property -dict {PACKAGE_PIN L2 IOSTANDARD LVCMOS33} [get_ports {cic_dec_factor[1]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {cic_dec_factor[2]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {cic_dec_factor[3]}]
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports {cic_dec_factor[4]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports cic_bypass]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports cic_overflow]
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports cic_underflow]

## Pmod JB (Top row: JB1-JB4, Bottom row: JB7-JB10)
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[0]}]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[1]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[2]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[3]}]
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[4]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[5]}]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[6]}]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[7]}]

## Pmod JC (Top row: JC1-JC4, Bottom row: JC7-JC10)
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[8]}]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[9]}]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[10]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[11]}]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[12]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[13]}]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[14]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {frac_dec_out[15]}]

## Pmod JXADC (Top row: XA1-XA4, Bottom row: XA7-XA10)
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {iir_out[0]}]
set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVCMOS33} [get_ports {iir_out[1]}]
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {iir_out[2]}]
set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports {iir_out[3]}]
set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS33} [get_ports {iir_out[4]}]
set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS33} [get_ports {iir_out[5]}]
set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports {iir_out[6]}]
set_property -dict {PACKAGE_PIN N1 IOSTANDARD LVCMOS33} [get_ports {iir_out[7]}]

## Additional control signals on remaining pins
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports valid_in]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports frac_dec_bypass]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports iir_bypass_2_4MHz]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports iir_bypass_5MHz]

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports valid_out]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports overflow]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports underflow]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports frac_dec_overflow]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports frac_dec_underflow]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports frac_dec_valid_out]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports iir_overflow_1MHz]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports iir_overflow_2_4MHz]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports iir_underflow_1MHz]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports iir_underflow_2_4MHz]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports iir_valid_out]

## IIR out remaining bits on available pins
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {iir_out[8]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33} [get_ports {iir_out[9]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {iir_out[10]}]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {iir_out[11]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {iir_out[12]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {iir_out[13]}]
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports {iir_out[14]}]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {iir_out[15]}]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## SPI configuration mode options for QSPI boot, can be used for all designs
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {frac_dec_out_OBUF[0]} {frac_dec_out_OBUF[1]} {frac_dec_out_OBUF[2]} {frac_dec_out_OBUF[3]} {frac_dec_out_OBUF[4]} {frac_dec_out_OBUF[5]} {frac_dec_out_OBUF[6]} {frac_dec_out_OBUF[7]} {frac_dec_out_OBUF[8]} {frac_dec_out_OBUF[9]} {frac_dec_out_OBUF[10]} {frac_dec_out_OBUF[11]} {frac_dec_out_OBUF[12]} {frac_dec_out_OBUF[13]} {frac_dec_out_OBUF[14]} {frac_dec_out_OBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {core_out_OBUF[0]} {core_out_OBUF[1]} {core_out_OBUF[2]} {core_out_OBUF[3]} {core_out_OBUF[4]} {core_out_OBUF[5]} {core_out_OBUF[6]} {core_out_OBUF[7]} {core_out_OBUF[8]} {core_out_OBUF[9]} {core_out_OBUF[10]} {core_out_OBUF[11]} {core_out_OBUF[12]} {core_out_OBUF[13]} {core_out_OBUF[14]} {core_out_OBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {iir_out_OBUF[0]} {iir_out_OBUF[1]} {iir_out_OBUF[2]} {iir_out_OBUF[3]} {iir_out_OBUF[4]} {iir_out_OBUF[5]} {iir_out_OBUF[6]} {iir_out_OBUF[7]} {iir_out_OBUF[8]} {iir_out_OBUF[9]} {iir_out_OBUF[10]} {iir_out_OBUF[11]} {iir_out_OBUF[12]} {iir_out_OBUF[13]} {iir_out_OBUF[14]} {iir_out_OBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 16 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {core_in_IBUF[0]} {core_in_IBUF[1]} {core_in_IBUF[2]} {core_in_IBUF[3]} {core_in_IBUF[4]} {core_in_IBUF[5]} {core_in_IBUF[6]} {core_in_IBUF[7]} {core_in_IBUF[8]} {core_in_IBUF[9]} {core_in_IBUF[10]} {core_in_IBUF[11]} {core_in_IBUF[12]} {core_in_IBUF[13]} {core_in_IBUF[14]} {core_in_IBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 5 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {cic_dec_factor_IBUF[0]} {cic_dec_factor_IBUF[1]} {cic_dec_factor_IBUF[2]} {cic_dec_factor_IBUF[3]} {cic_dec_factor_IBUF[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list cic_bypass_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list cic_overflow_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list cic_underflow_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list clk_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list frac_dec_bypass_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list frac_dec_overflow_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list frac_dec_underflow_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list frac_dec_valid_out_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list iir_bypass_2_4MHz_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list iir_bypass_5MHz_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list iir_overflow_1MHz_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list iir_overflow_2_4MHz_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list iir_underflow_1MHz_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list iir_underflow_2_4MHz_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list iir_valid_out_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list overflow_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list rst_n_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list underflow_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list valid_in_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list valid_out_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
