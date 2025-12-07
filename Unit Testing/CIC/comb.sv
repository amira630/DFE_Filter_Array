////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Design: A comb module.
// Date: 02-11-2025
// Description: A comb stage for CIC filter
////////////////////////////////////////////////////////////////////////////////

module COMB #(
    parameter int ACC_WIDTH     = 32'd42    ,       // Accumulator width
    parameter int N             = 32'd1             // Differential delay
) (
    input  logic                                clk      ,
    input  logic                                rst_n    ,
    input  logic                                valid_in ,
    input  logic signed [ACC_WIDTH - 1 :0]      comb_in  ,
    output logic signed [ACC_WIDTH - 1 : 0]     comb_out ,
    output logic                                valid_out
);
    
    logic [(N * ACC_WIDTH) - 1 : 0] delay_line;

    generate
        if (N == 1) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    delay_line  <= {(N * ACC_WIDTH){1'b0}}  ;
                    comb_out    <= {ACC_WIDTH{1'sb0}}       ;
                    valid_out   <= 1'b0                     ;
                end else if (valid_in) begin
                    delay_line  <= comb_in                      ;
                    comb_out    <= comb_in - $signed(delay_line);
                    valid_out   <= 1'b1                         ;
                end else begin
                    valid_out <= 1'b0;
                end
            end
        end else begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    delay_line  <= {(N * ACC_WIDTH){1'b0}}  ;
                    comb_out    <= {ACC_WIDTH{1'sb0}}       ;
                    valid_out   <= 1'b0                     ;
                end else if (valid_in) begin
                    delay_line  <= {delay_line[0 +: ((N - 1) * ACC_WIDTH)], comb_in}                ;
                    comb_out    <= comb_in - delay_line[(N * ACC_WIDTH) - 1 : (N - 1) * ACC_WIDTH]  ;
                    valid_out   <= 1'b1                                                             ;
                end else begin
                    valid_out <= 1'b0;
                end
            end
        end
    endgenerate

    
endmodule