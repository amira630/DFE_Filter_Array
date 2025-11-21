module wrapper(
    input logic                  rst_n,
    input logic                  valid_in,
    input logic                  cic_dec_factor,
    output logic signed [7 : 0]  top_out
);
    logic signed [7 : 0] top_in_mem [479999:0];
    logic signed [7 : 0] top_in;

    initial begin
        $readmemb("input.txt", top_in_mem);
    end

    Design_top TOP(
        .clk                ()                   ,
        .rst_n              (rst_n)              ,
        .valid_in           (valid_in)           ,
        .top_chain_in       (top_in)             ,
        .cic_dec_factor     (cic_dec_factor)     ,
        .top_chain_out      (top_out)            ,
        .iir_overflow_2_4   ()                   ,
        .iir_underflow_2_4  ()                   ,
        .iir_overflow_2     ()                   ,
        .iir_underflow_2    ()                   ,
        .iir_overflow_1     ()                   ,
        .iir_underflow_1    ()                   ,
        .frac_dec_overflow  ()                   ,
        .frac_dec_underflow ()                   ,
        .cic_overflow       ()                   ,
        .cic_underflow      ()                   ,
        .valid_out          ()                 
    );
endmodule