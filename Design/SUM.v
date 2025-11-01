module SUM #(parameter DATA_WIDTH = 16) (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire signed [(DATA_WIDTH<<1)-1:0] a,  
    input wire signed [(DATA_WIDTH<<1)-1:0] b,
    output reg signed [(DATA_WIDTH<<1)-1:0] sum_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_out <= 'd0;
        end else if (en) begin
            sum_out <= (a + b) >> 1;
        end
    end
endmodule