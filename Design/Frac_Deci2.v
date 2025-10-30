////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Design: Fractional Decimator
// Date: 27-10-2025
// Description: A second Fractional Decimator module using a custom multiplier.
////////////////////////////////////////////////////////////////////////////////

module Frac_Deci #(parameter HALF_N = 113, DATA_WIDTH = 16) (
    input wire clk, // 18MHz
    input wire rst_n,
    input wire signed [DATA_WIDTH-1:0] x_in, // s16.15 format
    output reg signed [DATA_WIDTH-1:0] x_out // s16.15 format
);

    reg signed [DATA_WIDTH-1:0] x_buf [0:((HALF_N<<1)-1)]; // a buffer to store input samples
    reg [7:0] wr_ptr; // write pointer for the input buffer

    wire signed [DATA_WIDTH-1:0] h_k [0:HALF_N-1]; // filter coefficients
    wire signed [DATA_WIDTH-1:0] h_k_reg [0:HALF_N-1]; // filter coefficients
    reg signed [(DATA_WIDTH<<1)-1:0] x_temp [0:((HALF_N<<1)-1)];
    reg signed [(DATA_WIDTH<<1)-1:0] x_reg [0:((HALF_N<<1)-1)];
    reg signed [(DATA_WIDTH<<1)-1:0] x_sum;
    reg select;

    reg enable_M, enable_L;
    reg [1:0] count_M;
    reg count_L;

    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    reg [15:0] ROM [0:HALF_N-1];

    assign ROM[0] = 16'h0000;
    assign ROM[1] = 16'h0000;
    assign ROM[2] = 16'h0000;
    assign ROM[3] = 16'h0000;
    assign ROM[4] = 16'h0000;
    assign ROM[5] = 16'hFFFF;
    assign ROM[6] = 16'h0000;
    assign ROM[7] = 16'h0001;
    assign ROM[8] = 16'h0001;
    assign ROM[9] = 16'h0001;
    assign ROM[10] = 16'hFFFF;
    assign ROM[11] = 16'hFFFE;
    assign ROM[12] = 16'hFFFE;
    assign ROM[13] = 16'h0000;
    assign ROM[14] = 16'h0002;
    assign ROM[15] = 16'h0003;
    assign ROM[16] = 16'h0000;
    assign ROM[17] = 16'hFFFD;
    assign ROM[18] = 16'hFFFC;
    assign ROM[19] = 16'hFFFF;
    assign ROM[20] = 16'h0003;
    assign ROM[21] = 16'h0006;
    assign ROM[22] = 16'h0003;
    assign ROM[23] = 16'hFFFD;
    assign ROM[24] = 16'hFFF9;
    assign ROM[25] = 16'hFFFB;
    assign ROM[26] = 16'h0002;
    assign ROM[27] = 16'h0009;
    assign ROM[28] = 16'h0008;
    assign ROM[29] = 16'hFFFF;
    assign ROM[30] = 16'hFFF5;
    assign ROM[31] = 16'hFFF4;
    assign ROM[32] = 16'hFFFE;
    assign ROM[33] = 16'h000C;
    assign ROM[34] = 16'h0011;
    assign ROM[35] = 16'h0006;
    assign ROM[36] = 16'hFFF4;
    assign ROM[37] = 16'hFFEB;
    assign ROM[38] = 16'hFFF4;
    assign ROM[39] = 16'h000A;
    assign ROM[40] = 16'h001A;
    assign ROM[41] = 16'h0013;
    assign ROM[42] = 16'hFFFA;
    assign ROM[43] = 16'hFFE3;
    assign ROM[44] = 16'hFFE4;
    assign ROM[45] = 16'h0000;
    assign ROM[46] = 16'h0020;
    assign ROM[47] = 16'h0026;
    assign ROM[48] = 16'h0009;
    assign ROM[49] = 16'hFFE0;
    assign ROM[50] = 16'hFFD0;
    assign ROM[51] = 16'hFFEB;
    assign ROM[52] = 16'h001D;
    assign ROM[53] = 16'h003A;
    assign ROM[54] = 16'h0024;
    assign ROM[55] = 16'hFFEA;
    assign ROM[56] = 16'hFFBD;
    assign ROM[57] = 16'hFFCA;
    assign ROM[58] = 16'h000B;
    assign ROM[59] = 16'h0049;
    assign ROM[60] = 16'h004A;
    assign ROM[61] = 16'h0006;
    assign ROM[62] = 16'hFFB5;
    assign ROM[63] = 16'hFFA1;
    assign ROM[64] = 16'hFFE3;
    assign ROM[65] = 16'h0047;
    assign ROM[66] = 16'h0074;
    assign ROM[67] = 16'h003A;
    assign ROM[68] = 16'hFFC3;
    assign ROM[69] = 16'hFF79;
    assign ROM[70] = 16'hFFA4;
    assign ROM[71] = 16'h0029;
    assign ROM[72] = 16'h0096;
    assign ROM[73] = 16'h0083;
    assign ROM[74] = 16'hFFF4;
    assign ROM[75] = 16'hFF62;
    assign ROM[76] = 16'hFF53;
    assign ROM[77] = 16'hFFE4;
    assign ROM[78] = 16'h009E;
    assign ROM[79] = 16'h00D9;
    assign ROM[80] = 16'h0050;
    assign ROM[81] = 16'hFF6F;
    assign ROM[82] = 16'hFEFC;
    assign ROM[83] = 16'hFF6F;
    assign ROM[84] = 16'h0075;
    assign ROM[85] = 16'h012B;
    assign ROM[86] = 16'h00DE;
    assign ROM[87] = 16'hFFBA;
    assign ROM[88] = 16'hFEB5;
    assign ROM[89] = 16'hFEC7;
    assign ROM[90] = 16'h0000;
    assign ROM[91] = 16'h015F;
    assign ROM[92] = 16'h01A1;
    assign ROM[93] = 16'h0064;
    assign ROM[94] = 16'hFE9E;
    assign ROM[95] = 16'hFDE7;
    assign ROM[96] = 16'hFF12;
    assign ROM[97] = 16'h014C;
    assign ROM[98] = 16'h02A4;
    assign ROM[99] = 16'h01AF;
    assign ROM[100] = 16'hFEEF;
    assign ROM[101] = 16'hFCB1;
    assign ROM[102] = 16'hFD35;
    assign ROM[103] = 16'h0095;
    assign ROM[104] = 16'h0438;
    assign ROM[105] = 16'h04A1;
    assign ROM[106] = 16'h006F;
    assign ROM[107] = 16'hFA37;
    assign ROM[108] = 16'hF771;
    assign ROM[109] = 16'hFCCD;
    assign ROM[110] = 16'h0A75;
    assign ROM[111] = 16'h1AFF;
    assign ROM[112] = 16'h2641;

    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    
    genvar i, k, j, p;

    generate 
        k = 0;
        for (i = 0; i < HALF_N-1; i = i + 1) begin : gen_mux
            if (!i[0]) begin
                MUX2x1 U_MUX_0 (.sel(select), .in0(ROM[i]), .in1(ROM[i+1]), .out(h_k[k]));
                k = k + 1;
            end
        end
    endgenerate

    // generate 
    //     k = HALF_N;
    //     for (i = HALF_N - 2; i >= 0; i = i - 1) begin : gen_mux_1
    //         if (i == 0)
    //             MUX2x1 U_MUX_LAST (.sel(select), .in0(ROM[i]), .in1('0), .out(h_k[k]));
    //         else
    //         if (!i[0]) begin
    //             MUX2x1 U_MUX_1 (.sel(select), .in0(ROM[i]), .in1(ROM[i-1]), .out(h_k[k]));
    //             k = k + 1;
    //         end
    //     end
    // endgenerate

    generate
        p = 0; 
        for (j = 0; j < (HALF_N<<1)-1; j = j + 1) begin : gen_mult
            if ((wr_ptr - j) >= 0) begin
                MULT #(DATA_WIDTH) U_MULT (.a(x_buf[wr_ptr - j]), .b(h_k_reg[p]), .product(x_temp[j]));
                if((p < HALF_N-1) && (j < HALF_N))
                    p = p + 1; // till 112
                else if ((p == HALF_N-1) && (j == HALF_N-1))
                    p = p; // stay at 112 when j=113
                else
                    p = p - 1; // decrease p
            end
        end
    endgenerate

    reg [7:0] m, n;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 8'd0;
            for (m = 0; m < ((HALF_N<<1)-2); m = m + 1) begin
                x_buf[m] <= 16'd0;
            end
            enable_L <= 1'b0;
            count_L <= 1'b0;
        end else if (enable_L) begin
            x_buf[wr_ptr] <= x_in;
            if (wr_ptr == (HALF_N<<1) - 2)
                wr_ptr <= 8'd0;
            else
                wr_ptr <= wr_ptr + 1;
            enable_L <= 1'b0;
        end
        else (count_L)begin
            enable_L <= 1'b1;
            count_L <= 1'b0;
        end
        else 
            count_L <= 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_out <= 16'd0;
            x_sum <= 32'd0;
            for (n = 0; n < (HALF_N<<1) - 2; n = n + 1) begin
                x_temp[n] <= 32'd0;
                h_k_reg[n] <= 16'd0;
            end
            enable_M <= 1'b0;
            count_M <= 3'b0;
            select <= 1'b0;
        end else if (enable_M) begin
            select <= ~select;
            x_reg <= x_temp;
            h_k_reg <= h_k;
            h_k_reg[112] <= rom[112];
            for (n = 0; n < (HALF_N<<1) - 2; n = n + 1) begin
                if ((wr_ptr - n) >= 0) begin
                    x_sum <= (x_reg[n] + x_sum) >> 1;
                end
            end
            x_out <= x_sum[30:15]; // s16.15 format
            enable_M <= 1'b0;
        end
        else (count_M[1])begin
            enable_M <= 1'b1;
            count_M <= 3'b0;
        end
        else 
            count_M <= count_M + 1'b1;
    end
endmodule