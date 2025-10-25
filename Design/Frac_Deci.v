module Frac_Deci #(parameter HALF_N = 114, DATA_WIDTH = 16) (
    input wire clk, // 18MHz
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] x_in, // s16.15 format
    output reg [DATA_WIDTH-1:0] x_out // s16.15 format
);

    reg [DATA_WIDTH-1:0] x_buf [0:((HALF_N<<1)-2)]; // a buffer to store input samples
    reg [7:0] wr_ptr; // write pointer for the input buffer

    wire [DATA_WIDTH-1:0] h_k [0:((HALF_N<<1)-2)]; // filter coefficients
    reg [(DATA_WIDTH<<1)-1:0] x_temp [0:((HALF_N<<1)-2)];
    reg [(DATA_WIDTH<<1)-1:0] x_sum;
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
    assign ROM[6] = 16'hFFFF;
    assign ROM[7] = 16'h0000;
    assign ROM[8] = 16'h0001;
    assign ROM[9] = 16'h0001;
    assign ROM[10] = 16'h0000;
    assign ROM[11] = 16'hFFFF;
    assign ROM[12] = 16'hFFFE;
    assign ROM[13] = 16'hFFFF;
    assign ROM[14] = 16'h0002;
    assign ROM[15] = 16'h0003;
    assign ROM[16] = 16'h0002;
    assign ROM[17] = 16'hFFFE;
    assign ROM[18] = 16'hFFFC;
    assign ROM[19] = 16'hFFFD;
    assign ROM[20] = 16'h0001;
    assign ROM[21] = 16'h0005;
    assign ROM[22] = 16'h0005;
    assign ROM[23] = 16'h0000;
    assign ROM[24] = 16'hFFFA;
    assign ROM[25] = 16'hFFF8;
    assign ROM[26] = 16'hFFFE;
    assign ROM[27] = 16'h0007;
    assign ROM[28] = 16'h000A;
    assign ROM[29] = 16'h0005;
    assign ROM[30] = 16'hFFF9;
    assign ROM[31] = 16'hFFF3;
    assign ROM[32] = 16'hFFF8;
    assign ROM[33] = 16'h0005;
    assign ROM[34] = 16'h0010;
    assign ROM[35] = 16'h000D;
    assign ROM[36] = 16'hFFFD;
    assign ROM[37] = 16'hFFED;
    assign ROM[38] = 16'hFFED;
    assign ROM[39] = 16'hFFFE;
    assign ROM[40] = 16'h0014;
    assign ROM[41] = 16'h001A;
    assign ROM[42] = 16'h0008;
    assign ROM[43] = 16'hFFEC;
    assign ROM[44] = 16'hFFDF;
    assign ROM[45] = 16'hFFEF;
    assign ROM[46] = 16'h0012;
    assign ROM[47] = 16'h0028;
    assign ROM[48] = 16'h001B;
    assign ROM[49] = 16'hFFF4;
    assign ROM[50] = 16'hFFD2;
    assign ROM[51] = 16'hFFD8;
    assign ROM[52] = 16'h0004;
    assign ROM[53] = 16'h0031;
    assign ROM[54] = 16'h0036;
    assign ROM[55] = 16'h0009;
    assign ROM[56] = 16'hFFCE;
    assign ROM[57] = 16'hFFBB;
    assign ROM[58] = 16'hFFE6;
    assign ROM[59] = 16'h002F;
    assign ROM[60] = 16'h0054;
    assign ROM[61] = 16'h002F;
    assign ROM[62] = 16'hFFDA;
    assign ROM[63] = 16'hFF9F;
    assign ROM[64] = 16'hFFB8;
    assign ROM[65] = 16'h0017;
    assign ROM[66] = 16'h006A;
    assign ROM[67] = 16'h0064;
    assign ROM[68] = 16'h0000;
    assign ROM[69] = 16'hFF92;
    assign ROM[70] = 16'hFF7E;
    assign ROM[71] = 16'hFFE1;
    assign ROM[72] = 16'h006B;
    assign ROM[73] = 16'h00A0;
    assign ROM[74] = 16'h0045;
    assign ROM[75] = 16'hFFA1;
    assign ROM[76] = 16'hFF44;
    assign ROM[77] = 16'hFF8C;
    assign ROM[78] = 16'h0047;
    assign ROM[79] = 16'h00D4;
    assign ROM[80] = 16'h00AB;
    assign ROM[81] = 16'hFFDE;
    assign ROM[82] = 16'hFF1C;
    assign ROM[83] = 16'hFF19;
    assign ROM[84] = 16'hFFEC;
    assign ROM[85] = 16'h00EA;
    assign ROM[86] = 16'h0129;
    assign ROM[87] = 16'h005B;
    assign ROM[88] = 16'hFF20;
    assign ROM[89] = 16'hFE92;
    assign ROM[90] = 16'hFF49;
    assign ROM[91] = 16'h00C1;
    assign ROM[92] = 16'h01B3;
    assign ROM[93] = 16'h012B;
    assign ROM[94] = 16'hFF78;
    assign ROM[95] = 16'hFE0A;
    assign ROM[96] = 16'hFE43;
    assign ROM[97] = 16'h002A;
    assign ROM[98] = 16'h0234;
    assign ROM[99] = 16'h0279;
    assign ROM[100] = 16'h006A;
    assign ROM[101] = 16'hFD94;
    assign ROM[102] = 16'hFC87;
    assign ROM[103] = 16'hFEA5;
    assign ROM[104] = 16'h0299;
    assign ROM[105] = 16'h04FF;
    assign ROM[106] = 16'h030B;
    assign ROM[107] = 16'hFD44;
    assign ROM[108] = 16'hF808;
    assign ROM[109] = 16'hF8F5;
    assign ROM[110] = 16'h02D1;
    assign ROM[111] = 16'h12DE;
    assign ROM[112] = 16'h21C5;
    assign ROM[113] = 16'h27D2;

    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    
    genvar i, k;

    generate 
        k = 0;
        for (i = 0; i < HALF_N; i = i + 1) begin : gen_mux_0
            if (!i[0]) begin
                MUX2x1 U_MUX_0 (.sel(select), .in0(ROM[i]), .in1(ROM[i+1]), .out(h_k[k]));
                k = k + 1;
            end
        end
    endgenerate

    generate 
        for (i = HALF_N - 2; i >= 0; i = i - 1) begin : gen_mux_1
            if (i == 0)
                MUX2x1 U_MUX_LAST (.sel(select), .in0(ROM[i]), .in1('0), .out(h_k[k]));
            else
            if (!i[0]) begin
                MUX2x1 U_MUX_1 (.sel(select), .in0(ROM[i]), .in1(ROM[i-1]), .out(h_k[k]));
                k = k + 1;
            end
        end
    endgenerate

    integer m, n;
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
            end
            enable_M <= 1'b0;
            count_M <= 3'b0;
            select <= 1'b0;
        end else if (enable_M) begin
            select <= ~select;
            for (n = 0; n < (HALF_N<<1) - 2; n = n + 1) begin
                if ((wr_ptr - n) >= 0) begin
                    x_temp[n] <= x_buf[wr_ptr - n] * h_k[n];
                    x_sum <= x_temp[n] + x_sum;
                end
            end
            x_out <= x_sum[30:15]; // s16.15 format
            enable_M <= 1'b0;
        end
        else (count_M[1] & 1)begin
            enable_M <= 1'b1;
            count_M <= 3'b0;
        end
        else 
            count_M <= count_M + 1'b1;
    end
endmodule