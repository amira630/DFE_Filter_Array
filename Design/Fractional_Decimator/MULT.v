module MULT #(parameter DATA_WIDTH = 16) (
    input wire signed [DATA_WIDTH-1:0] a,
    input wire signed [DATA_WIDTH-1:0] b,
    output wire signed [(DATA_WIDTH << 1)-1:0] product
);
    wire [DATA_WIDTH-1:0] a_unsigned, b_unsigned;
    wire [(DATA_WIDTH << 1)-1:0] product_unsigned;

    integer i;

    assign product = (a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]) ? (~product_unsigned + 1) : product_unsigned;

    always @(*) begin
        if (a[DATA_WIDTH-1]) begin
            a_unsigned = ~a + 1;
        end else begin
            a_unsigned = a;
        end
        if (b[DATA_WIDTH-1]) begin
            b_unsigned = ~b + 1;
        end else begin
            b_unsigned = b;
        end
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            if (b_unsigned[i]) begin
                product_unsigned = product_unsigned + (a_unsigned << i);
            end
        end
    end
endmodule