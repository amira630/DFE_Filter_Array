module FIFO #(
    parameter FIFO_WIDTH = 32,
    parameter FIFO_DEPTH = 512,
    localparam ADDR_WIDTH = $clog2(FIFO_DEPTH)
) (
    input logic signed [FIFO_WIDTH - 1:0] din,
    input logic wr_en,
    input logic rd_en,
    input logic clk_wr,
    input logic clk_rd,
    input logic rst_n,

    output logic signed [FIFO_WIDTH - 1:0] dout,
    output logic full,
    output logic empty,
    output logic wr_ack,
    output logic rd_ack
);

    logic [FIFO_WIDTH - 1:0] mem [FIFO_DEPTH - 1:0];

    logic [ADDR_WIDTH:0] read_count;
    logic [ADDR_WIDTH:0]  wrt_count;

    logic wr_ack_reg, rd_ack_reg;
    
    always @(posedge clk_wr or negedge rst_n) begin
        if (!rst_n) begin
            wrt_count <= 0;
        end
        else if (wr_en && !full) begin
            mem[wrt_count[ADDR_WIDTH-1:0]] <= din;
            wrt_count <= wrt_count + 1;
        end
    end

    always @(posedge clk_wr or negedge rst_n) begin
        if (!rst_n) begin
            wr_ack_reg <= 0;
        end else if (wr_en && !full) begin
            wr_ack_reg <= 1;
        end else begin
            wr_ack_reg <= 0;
        end

        wr_ack <= wr_ack_reg;
    end

    always @(posedge clk_rd or negedge rst_n) begin
        if (!rst_n) begin
            read_count <= 0;
            dout <= 0;
        end
        else if (rd_en && !empty) begin
            dout <= mem[read_count[ADDR_WIDTH-1:0]];
            mem[read_count[ADDR_WIDTH-1:0]] <= 0;
            read_count <= read_count + 1;
        end
    end

    always @(posedge clk_rd or negedge rst_n) begin
        if (!rst_n) begin
            rd_ack_reg <= 0;
        end else if (rd_en && !empty) begin
            rd_ack_reg <= 1;
        end else begin
            rd_ack_reg <= 0;
        end

        rd_ack <= rd_ack_reg;
    end

    assign full = (((read_count[ADDR_WIDTH] ^ wrt_count[ADDR_WIDTH])== 1) && (read_count[(ADDR_WIDTH-1):0] == wrt_count[(ADDR_WIDTH-1):0]));

    assign empty = (((read_count[ADDR_WIDTH] ^ wrt_count[ADDR_WIDTH]) == 0) && (read_count[(ADDR_WIDTH-1):0] == wrt_count[(ADDR_WIDTH-1):0]));

endmodule
