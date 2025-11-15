module interpolator #(
    parameter DATA_WIDTH = 16,
    parameter INTERPOLATION_FACTOR = 3,
    parameter FIFO_DEPTH = (2**16),
    localparam COUNTER_WIDTH = $clog2(INTERPOLATION_FACTOR)
)(
    input   logic clk,
    input   logic clk_enable,
    input   logic rst_n,
    input   logic signed [DATA_WIDTH - 1 : 0] inter_in,
    input   logic inter_in_valid,
    output  logic signed [DATA_WIDTH - 1 : 0] inter_out,
    output  logic inter_out_valid
);

    logic [COUNTER_WIDTH - 1 : 0] counter;
    logic fifo_wr_en;
    logic fifo_rd_en;
    logic fifo_full;
    logic fifo_empty;
    logic fifo_wr_ack;
    logic fifo_rd_ack;
    logic signed [DATA_WIDTH - 1 : 0] fifo_dout;
    logic signed [DATA_WIDTH - 1 : 0] fifo_din;
    logic signed [DATA_WIDTH - 1 : 0] sample_holder;

    // FIFO instance for buffering input samples
    FIFO #(
        .FIFO_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) FIFO_inst (
        .din(fifo_din),
        .wr_en(fifo_wr_en),
        .rd_en(fifo_rd_en),
        .clk_wr(clk),
        .clk_rd(clk),
        .rst_n(rst_n),
        .dout(fifo_dout),
        .full(fifo_full),
        .empty(fifo_empty),
        .wr_ack(fifo_wr_ack),
        .rd_ack(fifo_rd_ack)
    );

    // FIFO write logic - write input samples when valid
    assign fifo_din = inter_in;
    assign fifo_wr_en = inter_in_valid && !fifo_full && clk_enable;

    // FIFO read logic - read one sample every INTERPOLATION_FACTOR cycles
    assign fifo_rd_en = (counter == '0) && !fifo_empty && clk_enable;

    // Counter to control interpolation
    always_ff @(posedge clk or negedge rst_n) begin : INTERPOLATION_COUNTER
        if (!rst_n) begin
            counter <= '0;
        end else if (clk_enable) begin
            if (!fifo_empty) begin
                if (counter == (INTERPOLATION_FACTOR - 1)) begin
                    counter <= '0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
        end
    end

    // Sample holder - holds the current sample from FIFO
    always_ff @(posedge clk or negedge rst_n) begin : SAMPLE_HOLDER_LOGIC
        if (!rst_n) begin
            sample_holder <= '0;
        end else if (clk_enable) begin
            if (fifo_rd_ack) begin
                sample_holder <= fifo_dout;
            end
        end
    end

    // Output logic - output actual sample or zero
    always_ff @(posedge clk or negedge rst_n) begin : INTERPOLATOR_OUTPUT
        if (!rst_n) begin
            inter_out <= '0;
            inter_out_valid <= 1'b0;
        end else if (clk_enable) begin
            if (!fifo_empty) begin
                if (counter == '0) begin
                    // Output the actual sample at the first position
                    inter_out <= sample_holder;
                end else begin
                    // Output zeros for the remaining positions
                    inter_out <= '0;
                end
                inter_out_valid <= 1'b1;
            end else begin
                inter_out <= '0;
                inter_out_valid <= 1'b0;
            end
        end
    end

endmodule