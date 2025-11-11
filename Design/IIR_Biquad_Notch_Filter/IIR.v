////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Design: 2nd Order Infinite Impulse Response Notch Filter
// Date: 11-11-2025
// Description: An IIR module configurable for 1MHz (5MHz) and 2.4MHz coefficients 
// implemented using transposed Direct Form II. 
////////////////////////////////////////////////////////////////////////////////

module IIR #(parameter DATA_WIDTH = 16)(
    input wire clk, // 18MHz, to avoid CDC
    input wire rst_n,
    input wire f_c, // Centre Frequency 0 (1MHz) or 1 (2.4MHz) 
    input wire signed [DATA_WIDTH-1:0] x_in,
    output reg signed [DATA_WIDTH-1:0] x_out
);
    localparam signed [DATA_WIDTH-1:0] b0_0 = 16'h79A0;
    localparam signed [DATA_WIDTH-1:0] b0_1 = 16'hC4CB;
    localparam signed [DATA_WIDTH-1:0] b0_2 = 16'h79A0;
    localparam signed [DATA_WIDTH-1:0] b1_0 = 16'h79A0;
    localparam signed [DATA_WIDTH-1:0] b1_1 = 16'h8660;
    localparam signed [DATA_WIDTH-1:0] b1_2 = 16'h79A0;

    localparam signed [DATA_WIDTH-1:0] a0_1 = 16'hC4CB;
    localparam signed [DATA_WIDTH-1:0] a0_2 = 16'h7340;
    localparam signed [DATA_WIDTH-1:0] a1_1 = 16'h8660;
    localparam signed [DATA_WIDTH-1:0] a1_2 = 16'h7340;

    reg signed [DATA_WIDTH-1:0] b0, b1, b2;
    reg signed [DATA_WIDTH-1:0] a1, a2;

    reg signed [(DATA_WIDTH<<1)-1:0] stagef0, stagef1, stagef2; // forward
    reg signed [(DATA_WIDTH<<1)-1:0] stageb1, stageb2; // backward

    reg signed [(DATA_WIDTH<<1)-1:0] delay2_1, delay2_2, delay1_1, delay1_2;

    reg [1:0] count;

    always @(*) begin
        case (f_c)
            1'b0: begin
                b0 = b0_0;
                b1 = b0_1;
                b2 = b0_2;
                a1 = a0_1;
                a2 = a0_2;
            end
            1'b1: begin
                b0 = b1_0;
                b1 = b1_1;
                b2 = b1_2;
                a1 = a1_1;
                a2 = a1_2;
            end 
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_out    <= 'd0;
            stagef0  <= 'd0;
            stagef1  <= 'd0;
            stagef2  <= 'd0; 
            stageb1  <= 'd0;
            stageb2  <= 'd0;
            delay2_1 <= 'd0;
            delay2_2 <= 'd0;
            delay1_1 <= 'd0;
            delay1_2 <= 'd0;
            count <= 2'b0;
        end
        else if (count[1]) begin // for 6MHz
            count <= 2'b0;
            stagef0 <= x_in * b0;
            stagef1 <= x_in * b1;
            stagef2 <= x_in * b2; 
            stageb1 <= x_out * a1;
            stageb2 <= x_out * a2;
            
            delay2_1 <= stagef2 * stageb2;
            delay2_2 <= delay2_1;

            delay1_1 <= delay2_2 + stagef1 + stageb1;
            delay1_2 <= delay1_1;

            x_out <= (delay1_2 + stagef0) >> (DATA_WIDTH-1);
        end else
            count <= count + 1;
    end
endmodule