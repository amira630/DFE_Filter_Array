module Cascaded_IIR #(parameter DATA_WIDTH = 16)(
    input wire clk, // 18MHz, to avoid CDC
    input wire rst_n,
    input wire signed [DATA_WIDTH-1:0] x_in,
    output wire signed [DATA_WIDTH-1:0] x_out
);

wire signed [DATA_WIDTH-1:0] out_1, out_2;

IIR #(.DATA_WIDTH(DATA_WIDTH)) IIR_2_4 (
    .clk(clk), // 18MHz, to avoid CDC
    .rst_n(rst_n),
    .f_c(2'b1), // Centre Frequency 0 (1MHz) or 1 (2.4MHz) or 2 (2MHz)
    .x_in(x_in),
    .x_out(out_1)
);

IIR #(.DATA_WIDTH(DATA_WIDTH)) IIR_1 (
    .clk(clk), // 18MHz, to avoid CDC
    .rst_n(rst_n),
    .f_c(2'b0), // Centre Frequency 0 (1MHz) or 1 (2.4MHz) or 2 (2MHz)
    .x_in(out_1),
    .x_out(out_2)
);

IIR #(.DATA_WIDTH(DATA_WIDTH)) IIR_2 (
    .clk(clk), // 18MHz, to avoid CDC
    .rst_n(rst_n),
    .f_c(2'b10), // Centre Frequency 0 (1MHz) or 1 (2.4MHz) or 2 (2MHz)
    .x_in(out_2),
    .x_out(x_out)
);

endmodule