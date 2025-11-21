module core #(
    parameter   DATA_WIDTH      = 16                                ,
    parameter   DATA_FRAC       = 15                                ,
    parameter   COEFF_WIDTH     = 20                                ,
    parameter   COEFF_FRAC      = 18                                ,
    parameter   N_TAP           = 72                                
) (
    //********************** General I/O ************************/
    input  logic                                clk                                      ,
    input  logic                                valid_in                                 ,
    input  logic                                rst_n                                    ,
    input  logic signed [DATA_WIDTH - 1 : 0]    core_in                                  ,
         
    output logic                                valid_out                                ,
    output logic signed [DATA_WIDTH - 1 : 0]    core_out                                 ,

    //********************** Fractional Decimator I/O ************************/
    input  logic                                frac_dec_bypass                          ,
    input  logic         			            frac_dec_coeff_wr_en                     ,
    input  logic signed [COEFF_WIDTH - 1 : 0]   frac_dec_coeff_data_in  [N_TAP - 1 : 0]  ,

    output logic signed [COEFF_WIDTH - 1 : 0]   frac_dec_coeff_data_out [N_TAP - 1 : 0]  ,
    output logic                                frac_dec_overflow                        ,
    output logic                                frac_dec_underflow                       ,
    
);

    logic signed [DATA_WIDTH - 1 : 0]    frac_dec_out    ;
    logic                                 frac_dec_valid_out;

    

    fractional_decimator #(
        .DATA_WIDTH    (DATA_WIDTH)      ,
        .DATA_FRAC     (DATA_FRAC)       ,
        .COEFF_WIDTH   (COEFF_WIDTH)     ,
        .COEFF_FRAC    (COEFF_FRAC)      ,
        .N_TAP         (N_TAP)  
    ) FRACTIONAL_DECIMATOR (
        .clk            (clk) ,
        .valid_in       (valid_in) ,
        .rst_n          (rst_n) ,
        .bypass         (frac_dec_bypass) ,
        .coeff_wr_en    (frac_dec_coeff_wr_en) ,
        .coeff_data_in  (frac_dec_coeff_data_in) ,
        .filter_in      (core_in) ,
        .coeff_data_out (frac_dec_coeff_data_out) ,
        .filter_out     (frac_dec_out) ,
        .overflow       (frac_dec_overflow) ,
        .underflow      (frac_dec_underflow) ,
        .valid_out      (frac_dec_valid_out)
    );
    
endmodule