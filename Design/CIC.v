module CIC #(parameter DATA_WIDTH = 16, Q = 3, D = 1) (
    input wire clk, // 18MHz, to avoid CDC
    input wire rst_n,
    input wire signed [DATA_WIDTH-1:0] x_in,
    output wire signed [DATA_WIDTH-1:0] x_out
);
    genvar i;
    local parameter LOG2_D = (D == 1) ? 0 :
                             (D == 2) ? 1 :
                             (D == 4) ? 2 :
                             (D == 8) ? 3 :
                             (D == 16) ? 4 : 0;

    wire signed [(DATA_WIDTH + Q*LOG2_D)-1:0] integrator_out [0:Q-1];
    wire signed [(DATA_WIDTH + Q*LOG2_D)-1:0] comb_out [0:Q-1];
    reg signed [(DATA_WIDTH + Q*LOG2_D)-1:0] downsampler_out;
    reg signed [(DATA_WIDTH + Q*LOG2_D)-1:0] integ_buf [0:Q<<1];
    reg [7:0] sample_count;
    reg [1:0] count_og;
    reg [6:0] count_down;
    reg en_d;
    integer m, k, j;

    Integrator #(.DATA_WIDTH(DATA_WIDTH + Q*LOG2_D)) U_INTEG_0 (.clk(clk), .rst_n(rst_n), .en(count_og[1]), .in(x_in), .out(integrator_out[0]));

    Comb #(.DATA_WIDTH(DATA_WIDTH + Q*LOG2_D)) U_COMB_0 (.clk(clk), .rst_n(rst_n), .en(en_d), .in(downsampler_out), .out(comb_out[0]));
    generate
        for (i = 1; i < Q; i = i + 1) begin : gen_integ_comb
            Integrator #(.DATA_WIDTH(DATA_WIDTH)) U_INTEG (.clk(clk), .rst_n(rst_n), .en(count_og[1]), .in(integrator_out[i-1]), .out(integrator_out[i]));
            Comb #(.DATA_WIDTH(DATA_WIDTH)) U_COMB (.clk(clk), .rst_n(rst_n), .en(en_d), .in(comb_out[i-1]), .out(comb_out[i]));
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            downsampler_out <= 'd0;
            sample_count <= 8'd0;
            count_og <= 2'b0;
            count_down <= 7'd0;
            en_d <= 1'b0;
            k <= 0;
            j <= 0;
            for (m = 0; m < Q; m = m + 1) begin
                integ_buf[m] <= 'd0;
            end
        end else begin
            if(count_og[1]) begin// for 6MHz
                count_og <= 2'b0;
                if(sample_count == 0) begin
                    integ_buf[k] <= integrator_out[Q-1];
                    if (k < (Q<<1))
                        k <= k + 1;
                    else
                        k <= 0;
                end
                if (sample_count < D-1) 
                    sample_count <= sample_count + 1;
                else 
                    sample_count <= 8'd0;
            end else
                count_og <= count_og + 1;
            if (en_d) begin
                en_d <= 1'b0;
                downsampler_out <= integ_buf[j];
                if (j < (Q<<1))
                    j <= j + 1;
                else
                    j <= 0;
            end
            else begin // downsampler enable logic
                if (count_down < (3 << LOG2_D)) begin
                    if (count_down == (3 << LOG2_D)-1)
                        en_d <= 1'b1;
                    count_down <= count_down + 1;
                end else begin
                    count_down <= 7'd0;
                end
            end
        end
    end   

    assign x_out = comb_out[Q-1];
endmodule