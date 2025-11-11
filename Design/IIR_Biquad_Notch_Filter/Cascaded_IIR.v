module Cascaded_IIR #(parameter DATA_WIDTH = 16)(
    input wire clk, // 18MHz, to avoid CDC
    input wire rst_n,
    input wire signed [DATA_WIDTH-1:0] x_in,
    output reg signed [DATA_WIDTH-1:0] x_out
);

reg signed [DATA_WIDTH-1:0] out;

IIR #(.DATA_WIDTH(DATA_WIDTH)) IIR_2_4 (
    .clk(clk), // 18MHz, to avoid CDC
    .rst_n(rst_n),
    .f_c(1), // Centre Frequency 0 (1MHz) or 1 (2.4MHz) 
    .x_in(x_in),
    .x_out(out)
);

IIR #(.DATA_WIDTH(DATA_WIDTH)) IIR_1 (
    .clk(clk), // 18MHz, to avoid CDC
    .rst_n(rst_n),
    .f_c(0), // Centre Frequency 0 (1MHz) or 1 (2.4MHz) 
    .x_in(out),
    .x_out(x_out)
);

endmodule