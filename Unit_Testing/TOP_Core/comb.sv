////////////////////////////////////////////////////////////////////////////////
// Design Author: Amira Atef
// Verified by Mustaf EL-Sherif
// --> Linting check
// --> Synthesis
// --> Functional Simulation
// Design: Cascaded Integrator-Comb (CIC) Filter Decimator
// Date: 02-11-2025
// Description: A CIC module using an integrator-comb structure to decimate
// a signal's Fs from 6 MHz to (6 / dec_factor) MHz. 
// This design is for a CIC where D is the Delay, 
// Q is the order, N is the differential delay (D / dec_factor).
// dec_factor can take inputs of {1, 2, 4, 8, 16}.
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