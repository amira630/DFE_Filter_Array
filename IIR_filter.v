`timescale 1ns / 1ps
/* IIR Notch Filter implementation on FPGA
 * Dual notch filters for 2.4 MHz and 5.0 MHz interference rejection
 * Sampling frequency: 6 MHz after fractional decimation
 * Direct-form I structure biquad
 * s16.15 fixed-point format
 * 
 * Source: https://ccrma.stanford.edu/~jos/filters/BiQuad_Section.html
 *
 * v1.0 - Dominic Meads
 */

module IIR_notch_biquad_DF1 (
  input clk,
  input rst_n,
  input notch_select,      // 0: 2.4 MHz notch, 1: 5.0 MHz notch
  input signed [15:0] din,
  output signed [15:0] dout
);

  // Notch Filter 1 Coefficients (2.4 MHz) - s16.15 format
  // B1 = [32768, 53019, 32768] = [1.0000, 1.6180, 1.0000]
  // A1 = [32768, 52913, 32637] = [1.0000, 1.6148, 0.9960]
  localparam signed [15:0] B1_0 = 32768;   // b0 = 1.0000
  localparam signed [15:0] B1_1 = 53019;   // b1 = 1.6180
  localparam signed [15:0] B1_2 = 32768;   // b2 = 1.0000
  localparam signed [15:0] A1_1 = -52913;  // -a1 = -1.6148
  localparam signed [15:0] A1_2 = -32637;  // -a2 = -0.9960

  // Notch Filter 2 Coefficients (5.0 MHz) - s16.15 format
  // B2 = [32768, -32768, 32768] = [1.0000, -1.0000, 1.0000]
  // A2 = [32768, -32702, 32637] = [1.0000, -0.9980, 0.9960]
  localparam signed [15:0] B2_0 = 32768;   // b0 = 1.0000
  localparam signed [15:0] B2_1 = -32768;  // b1 = -1.0000
  localparam signed [15:0] B2_2 = 32768;   // b2 = 1.0000
  localparam signed [15:0] A2_1 = 32702;   // -a1 = 0.9980
  localparam signed [15:0] A2_2 = -32637;  // -a2 = -0.9960

  // Selected coefficients based on notch_select
  reg signed [15:0] b0_sel, b1_sel, b2_sel, a1_sel, a2_sel;

  // Input registers
  reg signed [15:0] r_x = 0;

  // Output register
  reg signed [15:0] r_y = 0;

  // Delay registers
  reg signed [15:0] r_x_z1 = 0;
  reg signed [15:0] r_x_z2 = 0;
  reg signed [15:0] r_y_z1 = 0;
  reg signed [15:0] r_y_z2 = 0;

  // Multiplication wires
  wire signed [31:0] w_product_a1;
  wire signed [31:0] w_product_a2;
  wire signed [31:0] w_product_b0;
  wire signed [31:0] w_product_b1;
  wire signed [31:0] w_product_b2;

  wire signed [31:0] w_sum;

  // Coefficient selection
  always @(*) begin
    if (notch_select == 1'b0) begin
      // Notch 1: 2.4 MHz
      b0_sel = B1_0;
      b1_sel = B1_1;
      b2_sel = B1_2;
      a1_sel = A1_1;
      a2_sel = A1_2;
    end else begin
      // Notch 2: 5.0 MHz
      b0_sel = B2_0;
      b1_sel = B2_1;
      b2_sel = B2_2;
      a1_sel = A2_1;
      a2_sel = A2_2;
    end
  end

  // Pipeline registers
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r_x <= 0;
      r_x_z1 <= 0;
      r_x_z2 <= 0;
      r_y_z1 <= 0;
      r_y_z2 <= 0;
      r_y <= 0;
    end else begin
      // Input pipeline
      r_x <= din;
      r_x_z1 <= r_x;
      r_x_z2 <= r_x_z1;
      
      // Output pipeline with scaling (divide by 2^15 for s16.15 format)
      r_y_z1 <= w_sum >>> 15;
      r_y_z2 <= r_y_z1;
      r_y <= r_y_z1;
    end
  end

  // Multiplications
  assign w_product_a1 = r_y_z1 * a1_sel;   // Already stored as -a1, so no need to negate
  assign w_product_a2 = r_y_z2 * a2_sel;   // Already stored as -a2, so no need to negate
  assign w_product_b0 = r_x * b0_sel;
  assign w_product_b1 = r_x_z1 * b1_sel;
  assign w_product_b2 = r_x_z2 * b2_sel;

  // Sum all products
  assign w_sum = w_product_b0 + w_product_b1 + w_product_b2 + 
                 w_product_a1 + w_product_a2;

  assign dout = r_y;

endmodule