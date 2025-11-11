module MUX2x1 (
    input wire sel,
    input wire [15:0] in0,
    input wire [15:0] in1,
    output reg [15:0] out
);

    always @(*) begin
        if (sel) begin
            out = in1;
        end else begin
            out = in0;
        end
    end
endmodule