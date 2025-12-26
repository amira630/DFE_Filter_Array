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

module INTEG #(
    parameter int DATA_WIDTH = 32'd16   , 
    parameter int ACC_WIDTH = 32'd20
) (
    input  logic                                clk         ,
    input  logic                                rst_n       ,   
    input  logic                                valid_in    ,
    input  logic signed [DATA_WIDTH - 1 : 0]    intg_in     ,
    output logic signed [ACC_WIDTH - 1 : 0]     intg_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            intg_out <= {ACC_WIDTH{1'sb0}};
        end else if (valid_in) begin
            intg_out <= $signed({{(ACC_WIDTH - DATA_WIDTH){intg_in[DATA_WIDTH - 1]}}, intg_in}) + intg_out;
        end
    end
endmodule