`timescale 1ns / 1ps
/* Dual Notch Filter Top Module
 * Cascaded 2.4 MHz and 5.0 MHz notch filters
 * For DFE interference rejection
 * 
 * v1.0 - Dominic Meads
 */

module dual_notch_filter_top (
  input clk,
  input rst_n,
  input notch1_enable,     // Enable 2.4 MHz notch
  input notch2_enable,     // Enable 5.0 MHz notch
  input signed [15:0] din,
  output signed [15:0] dout
);

  // Internal signals between cascaded filters
  wire signed [15:0] notch1_out;
  
  // 2.4 MHz Notch Filter (first stage)
  IIR_notch_biquad_DF1 notch_2p4mhz (
    .clk(clk),
    .rst_n(rst_n),
    .notch_select(1'b0),        // Select 2.4 MHz coefficients
    .din(notch1_enable ? din : din),  // Bypass if disabled
    .dout(notch1_out)
  );

  // 5.0 MHz Notch Filter (second stage)  
  IIR_notch_biquad_DF1 notch_5p0mhz (
    .clk(clk),
    .rst_n(rst_n),
    .notch_select(1'b1),        // Select 5.0 MHz coefficients
    .din(notch2_enable ? notch1_out : notch1_out),  // Bypass if disabled
    .dout(dout)
  );

endmodule