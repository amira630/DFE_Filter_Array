////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Design: A comb module.
// Date: 02-11-2025
// Description: A comb stage for CIC filter
////////////////////////////////////////////////////////////////////////////////



module COMB #(
    parameter ACC_WIDTH     = 42    ,       // Accumulator width
    parameter N             = 1             // Differential delay
) (
    input  logic                                clk      ,
    input  logic                                rst_n    ,
    input  logic                                valid_in ,
    input  logic signed [ACC_WIDTH - 1 :0]      comb_in  ,
    output logic signed [ACC_WIDTH - 1 : 0]     comb_out ,
    output logic                                valid_out
);

    logic signed [ACC_WIDTH - 1 : 0] delay_reg [N - 1 : 0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0 ; i < N ; i++) begin
                delay_reg[i] <= {ACC_WIDTH{1'sb0}};
            end
            comb_out <= {ACC_WIDTH{1'sb0}};
        end else if (valid_in) begin
            
            delay_reg[0] <= comb_in;

            for(int j = 1 ; j < N ; j++) begin
                delay_reg[j] <= delay_reg[j - 1]; 
            end
            
            comb_out <= comb_in - delay_reg[N - 1];
            
        end
    end
endmodule