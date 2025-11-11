module FIR_Filter #(
    parameter N_MAX = 92,
    parameter WIDTH = 16,
    parameter COEFF_WIDTH = 16
)(
    input clk,
    input rst_n,
    input wire [4:0] R,
    input signed [WIDTH-1:0] x_input,
    input valid_in,
    output reg signed [WIDTH-1:0] y_output,
    output reg valid_out
);

    reg signed [COEFF_WIDTH-1:0] coeff [0:N_MAX-1];
    reg [6:0] N;
    integer m;

    always @(*) begin
        case (R)
            1: N = 0; 
            2: N = 42; 
            4: N = 43; 
            8: N = 47; 
            16: N = N_MAX; 
            default:  N = 0;
        endcase
        for (m = 0; m < N_MAX; m = m+1) 
            coeff[m] = 16'h0; 
        case (R) 
            5'd2: begin
                coeff[0] = 16'hFFC3; coeff[1] = 16'hFFAF; coeff[2] = 16'h0043; coeff[3] = 16'h00D8; 
                coeff[4] = 16'h002D; coeff[5] = 16'hFF1D; coeff[6] = 16'hFFE2; coeff[7] = 16'h0187; 
                coeff[8] = 16'h0089; coeff[9] = 16'hFDF1; coeff[10] = 16'hFF0F; coeff[11] = 16'h02F0; 
                coeff[12] = 16'h01BD; coeff[13] = 16'hFBF0; coeff[14] = 16'hFD06; coeff[15] = 16'h05DB; 
                coeff[16] = 16'h0558; coeff[17] = 16'hF6C8; coeff[18] = 16'hF4B3; coeff[19] = 16'h13D3; 
                coeff[20] = 16'h39C8; coeff[21] = 16'h39C8; coeff[22] = 16'h13D3; coeff[23] = 16'hF4B3; 
                coeff[24] = 16'hF6C8; coeff[25] = 16'h0558; coeff[26] = 16'h05DB; coeff[27] = 16'hFD06; 
                coeff[28] = 16'hFBF0; coeff[29] = 16'h01BD; coeff[30] = 16'h02F0; coeff[31] = 16'hFF0F; 
                coeff[32] = 16'hFDF1; coeff[33] = 16'h0089; coeff[34] = 16'h0187; coeff[35] = 16'hFFE2; 
                coeff[36] = 16'hFF1D; coeff[37] = 16'h002D; coeff[38] = 16'h00D8; coeff[39] = 16'h0043; 
                coeff[40] = 16'hFFAF; coeff[41] = 16'hFFC3; 
            end
            5'd4: begin
                coeff[0] = 16'h0020; coeff[1] = 16'h0042; coeff[2] = 16'h005B; coeff[3] = 16'h0046; 
                coeff[4] = 16'hFFEB; coeff[5] = 16'hFF5C; coeff[6] = 16'hFEE1; coeff[7] = 16'hFEDB; 
                coeff[8] = 16'hFF8B; coeff[9] = 16'h00D3; coeff[10] = 16'h021A; coeff[11] = 16'h0284; 
                coeff[12] = 16'h0163; coeff[13] = 16'hFEC8; coeff[14] = 16'hFBC1; coeff[15] = 16'hFA1C; 
                coeff[16] = 16'hFBA8; coeff[17] = 16'h0144; coeff[18] = 16'h0A2E; coeff[19] = 16'h140F; 
                coeff[20] = 16'h1BC8; coeff[21] = 16'h1EB3; coeff[22] = 16'h1BC8; coeff[23] = 16'h140F; 
                coeff[24] = 16'h0A2E; coeff[25] = 16'h0144; coeff[26] = 16'hFBA8; coeff[27] = 16'hFA1C; 
                coeff[28] = 16'hFBC1; coeff[29] = 16'hFEC8; coeff[30] = 16'h0163; coeff[31] = 16'h0284; 
                coeff[32] = 16'h021A; coeff[33] = 16'h00D3; coeff[34] = 16'hFF8B; coeff[35] = 16'hFEDB; 
                coeff[36] = 16'hFEE1; coeff[37] = 16'hFF5C; coeff[38] = 16'hFFEB; coeff[39] = 16'h0046; 
                coeff[40] = 16'h005B; coeff[41] = 16'h0042; coeff[42] = 16'h0020;
            end
            5'd8: begin
                coeff[0] = 16'h0012; coeff[1] = 16'h0018; coeff[2] = 16'h0021; coeff[3] = 16'h0024; 
                coeff[4] = 16'h001B; coeff[5] = 16'hFFFF; coeff[6] = 16'hFFCD; coeff[7] = 16'hFF83; 
                coeff[8] = 16'hFF29; coeff[9] = 16'hFEC9; coeff[10] = 16'hFE77; coeff[11] = 16'hFE4C; 
                coeff[12] = 16'hFE63; coeff[13] = 16'hFED4; coeff[14] = 16'hFFB2; coeff[15] = 16'h0106; 
                coeff[16] = 16'h02C8; coeff[17] = 16'h04E2; coeff[18] = 16'h072E; coeff[19] = 16'h097B; 
                coeff[20] = 16'h0B93; coeff[21] = 16'h0D41; coeff[22] = 16'h0E56; coeff[23] = 16'h0EB6; 
                coeff[24] = 16'h0E56; coeff[25] = 16'h0D41; coeff[26] = 16'h0B93; coeff[27] = 16'h097B; 
                coeff[28] = 16'h072E; coeff[29] = 16'h04E2; coeff[30] = 16'h02C8; coeff[31] = 16'h0106; 
                coeff[32] = 16'hFFB2; coeff[33] = 16'hFED4; coeff[34] = 16'hFE63; coeff[35] = 16'hFE4C; 
                coeff[36] = 16'hFE77; coeff[37] = 16'hFEC9; coeff[38] = 16'hFF29; coeff[39] = 16'hFF83; 
                coeff[40] = 16'hFFCD; coeff[41] = 16'hFFFF; coeff[42] = 16'h001B; coeff[43] = 16'h0024; 
                coeff[44] = 16'h0021; coeff[45] = 16'h0018; coeff[46] = 16'h0012; 
            end
            5'd16: begin
                coeff[0] = 16'h000D; coeff[1] = 16'h0009; coeff[2] = 16'h000B; coeff[3] = 16'h000D; 
                coeff[4] = 16'h000F; coeff[5] = 16'h000F; coeff[6] = 16'h000E; coeff[7] = 16'h000C; 
                coeff[8] = 16'h0007; coeff[9] = 16'h0001; coeff[10] = 16'hFFF7; coeff[11] = 16'hFFEB; 
                coeff[12] = 16'hFFDC; coeff[13] = 16'hFFCA; coeff[14] = 16'hFFB6; coeff[15] = 16'hFFA0; 
                coeff[16] = 16'hFF89; coeff[17] = 16'hFF71; coeff[18] = 16'hFF5B; coeff[19] = 16'hFF48; 
                coeff[20] = 16'hFF38; coeff[21] = 16'hFF2E; coeff[22] = 16'hFF2B; coeff[23] = 16'hFF31; 
                coeff[24] = 16'hFF41; coeff[25] = 16'hFF5E; coeff[26] = 16'hFF87; coeff[27] = 16'hFFBF; 
                coeff[28] = 16'h0005; coeff[29] = 16'h0059; coeff[30] = 16'h00BC; coeff[31] = 16'h012C; 
                coeff[32] = 16'h01A7; coeff[33] = 16'h022D; coeff[34] = 16'h02BB; coeff[35] = 16'h034D; 
                coeff[36] = 16'h03E1; coeff[37] = 16'h0473; coeff[38] = 16'h0501; coeff[39] = 16'h0586; 
                coeff[40] = 16'h0600; coeff[41] = 16'h066A; coeff[42] = 16'h06C3; coeff[43] = 16'h0708; 
                coeff[44] = 16'h0737; coeff[45] = 16'h074F; coeff[46] = 16'h074F; coeff[47] = 16'h0737; 
                coeff[48] = 16'h0708; coeff[49] = 16'h06C3; coeff[50] = 16'h066A; coeff[51] = 16'h0600; 
                coeff[52] = 16'h0586; coeff[53] = 16'h0501; coeff[54] = 16'h0473; coeff[55] = 16'h03E1; 
                coeff[56] = 16'h034D; coeff[57] = 16'h02BB; coeff[58] = 16'h022D; coeff[59] = 16'h01A7; 
                coeff[60] = 16'h012C; coeff[61] = 16'h00BC; coeff[62] = 16'h0059; coeff[63] = 16'h0005; 
                coeff[64] = 16'hFFBF; coeff[65] = 16'hFF87; coeff[66] = 16'hFF5E; coeff[67] = 16'hFF41; 
                coeff[68] = 16'hFF31; coeff[69] = 16'hFF2B; coeff[70] = 16'hFF2E; coeff[71] = 16'hFF38; 
                coeff[72] = 16'hFF48; coeff[73] = 16'hFF5B; coeff[74] = 16'hFF71; coeff[75] = 16'hFF89; 
                coeff[76] = 16'hFFA0; coeff[77] = 16'hFFB6; coeff[78] = 16'hFFCA; coeff[79] = 16'hFFDC; 
                coeff[80] = 16'hFFEB; coeff[81] = 16'hFFF7; coeff[82] = 16'h0001; coeff[83] = 16'h0007; 
                coeff[84] = 16'h000C; coeff[85] = 16'h000E; coeff[86] = 16'h000F; coeff[87] = 16'h000F; 
                coeff[88] = 16'h000D; coeff[89] = 16'h000B; coeff[90] = 16'h0009; coeff[91] = 16'h000D; 
            end
        endcase
    end 

    reg signed [WIDTH-1:0] int_reg [0:N_MAX-1];
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0;i<N;i=i+1) int_reg[i]<=0;
        end else if (valid_in) begin
            int_reg[0]<=x_input;
            for (i=1;i<N;i=i+1) int_reg[i]<=int_reg[i-1];
        end
    end

    reg signed [WIDTH+COEFF_WIDTH+8:0] acc;
    always @(*) begin
        acc=0;
        for (i=0;i<N;i=i+1)
            acc=acc+int_reg[i]*coeff[i];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y_output<=0;
            valid_out<=0;
        end else if (valid_in) begin
            if (R == 1) 
                y_output <= x_input;
            else 
                y_output<= acc >>> (WIDTH-1);
            valid_out<=1;
        end else begin
            valid_out<=0;
        end
    end
endmodule
