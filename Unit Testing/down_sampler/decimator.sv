module decimator #(
    parameter DATA_WIDTH = 16,
    parameter DECIMATION_FACTOR = 3,
    localparam COUNTER_WIDTH = $clog2(DECIMATION_FACTOR)
)(
    input   logic clk,
    input   logic clk_enable,
    input   logic rst_n,
    input   logic signed [DATA_WIDTH - 1 : 0] dec_in,
    output  logic signed [DATA_WIDTH - 1 : 0] dec_out
);

    logic dec_valid_out;
    logic [COUNTER_WIDTH - 1 : 0] counter;

    always_comb begin : DECIMATOR_VALID_OUT
        if (!rst_n) begin
            dec_valid_out = '0;
        end else if (clk_enable) begin
            if (counter == '0) begin
                dec_valid_out = 1'b1;
            end else begin
                dec_valid_out = 1'b0;
            end
        end else begin
            dec_valid_out = 'b0;
        end
    end

    always_comb begin : DECIMATOR_OUT
        if (!rst_n) begin
            dec_out = '0;
        end else if (clk_enable) begin
            if(dec_valid_out) begin
                dec_out = dec_in;
            end else begin
                dec_out = dec_out;
            end
        end
    end

    always_ff @(posedge clk) begin : COUNTER
        if (!rst_n) begin
            counter = '0;
        end else if (clk_enable) begin
            if(counter == (DECIMATION_FACTOR - 1)) begin
                counter = '0;
            end else begin
                counter = counter + 1;
            end
        end
    end
endmodule