////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Design: A comb module.
// Date: 02-11-2025
// Description: A comb stage for CIC filter
////////////////////////////////////////////////////////////////////////////////

module COMB #(parameter DATA_WIDTH = 16, N = 1) (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire signed [DATA_WIDTH-1:0] in,
    output reg signed [DATA_WIDTH-1:0] out
);

    reg signed [DATA_WIDTH-1:0] in_reg [0: N-1];
    
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < N; i = i+1)
                in_reg[i] <= 'd0;
            out <= 'd0;
        end else if (en) begin
            in_reg[0] <= in;
            for(i = 1; i < N; i = i+1)
                in_reg[i] <= in_reg[i-1] 
            out <= (in - in_reg[N-1]) >> 1; // Simple averaging differentiator
        end
    end
endmodule
