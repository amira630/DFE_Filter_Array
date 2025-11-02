////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Design: A comb module.
// Date: 02-11-2025
// Description: A comb stage for CIC filter
////////////////////////////////////////////////////////////////////////////////

module COMB #(parameter DATA_WIDTH = 16) (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire signed [DATA_WIDTH-1:0] in,
    output reg signed [DATA_WIDTH-1:0] out
);

    reg signed [DATA_WIDTH-1:0] in_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            in_reg <= 'd0;
            out <= 'd0;
        end else if (en) begin
            in_reg <= in;
            out <= (in - in_reg) >> 1; // Simple averaging differentiator
        end
    end
endmodule
