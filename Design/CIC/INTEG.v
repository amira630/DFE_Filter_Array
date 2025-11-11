////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Design: An integrator module.
// Date: 02-11-2025
// Description: An integration stage for CIC filter
////////////////////////////////////////////////////////////////////////////////

module INTEG #(parameter DATA_WIDTH_IN = 16, DATA_WIDTH_OUT = 16) (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire signed [DATA_WIDTH_IN-1:0] in,
    output reg signed [DATA_WIDTH_OUT-1:0] out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 'd0;
        end else if (en) begin
            out <= in + out; // Simple averaging integrator
        end
    end
endmodule