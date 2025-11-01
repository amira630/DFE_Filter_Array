
module CIC #(parameter WIDTH = 30)(
    input wire clk,
    input wire rst,
    input wire [15:0] decimation_R,
    input wire [15:0] input_D,
    output reg [15:0] output_D,
    output reg clk_D
);
    reg [WIDTH-1:0] Int1, Int2, Int3, Int4, Int5;
    reg [15:0] Count;
    reg clk_Dtemp;
    reg valid;

    always @(posedge clk) begin
        if (rst) begin
            clk_Dtemp <= 0;
            Count <= 0;
            Int1 <= 0;
            Int2 <= 0;
            Int3 <= 0;
            Int4 <= 0;
            Int5 <= 0;
            output_D <= 0;
            clk_D <= 0;
        end else begin
            Int1 <= Int1 + input_D;
            Int2 <= Int2 + Int1;
            Int3 <= Int3 + Int2;
            Int4 <= Int4 + Int3;
            Int5 <= Int5 + Int4;

            if (Count == decimation_R - 1) begin
                Count <= 0;
                clk_Dtemp <= 1;
                valid <= 1;
            end else begin
                Count <= Count + 1;
                valid <= 0;
            end
        end
    end
endmodule
