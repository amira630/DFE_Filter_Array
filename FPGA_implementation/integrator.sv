////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Design: An integrator module.
// Date: 02-11-2025
// Description: An integration stage for CIC filter
////////////////////////////////////////////////////////////////////////////////

module INTEG #(
    parameter DATA_WIDTH = 16   , 
    parameter ACC_WIDTH = 20
) (
    input  logic                                clk         ,
    input  logic                                rst_n       ,   
    input  logic                                valid_in    ,
    input  logic signed [DATA_WIDTH - 1 : 0]    intg_in     ,
    output logic signed [ACC_WIDTH - 1 : 0]     intg_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            intg_out <= {ACC_WIDTH{'sb0}};
        end else if (valid_in) begin
            intg_out <= intg_in + intg_out;
        end
    end
endmodule