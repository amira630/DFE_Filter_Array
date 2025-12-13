////////////////////////////////////////////////////////////////////////////////
// Design Author: Mustaf EL-Sherif
// Verified by Mustaf EL-Sherif
// --> Linting check
// --> Synthesis
// --> Functional Simulation
// Design: DFE core
// Date: 02-11-2025
////////////////////////////////////////////////////////////////////////////////

module CORE #(
    //********************** General Parameters ********************//
    parameter int  DATA_WIDTH       = 32'd16                            ,
    parameter int  DATA_FRAC        = 32'd15                            ,
    parameter int  COEFF_WIDTH      = 32'd20                            ,
    parameter int  COEFF_FRAC       = 32'd18                            ,

    //********************** Fractional Decimator ********************//
    localparam int N_TAP            = 32'd72                            ,
    
    //********************** IIR Chain Parameters ********************//
    localparam int NUM_COEFF_DEPTH  = 32'd3                             ,
    localparam int DEN_COEFF_DEPTH  = 32'd2                             ,
    localparam int COEFF_DEPTH      = NUM_COEFF_DEPTH + DEN_COEFF_DEPTH ,

    //********************** CIC Parameters ********************//
    parameter int Q                 = 32'd1                             , 
    parameter int N                 = 32'd1                             ,
    localparam int MAX_DEC_FACTOR   = 32'd16                            ,
    localparam int DEC_WIDTH        = $clog2(MAX_DEC_FACTOR)
) (
    //********************** General I/O ************************//
    input  logic                                clk                                             ,
    input  logic                                valid_in                                        ,
    input  logic                                rst_n                                           ,
    input  logic signed [DATA_WIDTH - 1 : 0]    core_in                                         ,
         
    output logic                                valid_out                                       ,
    output logic signed [DATA_WIDTH - 1 : 0]    core_out                                        ,

    output logic                                overflow                                        ,
    output logic                                underflow                                       ,

    //********************** Fractional Decimator I/O ************************//
    input  logic                                frac_dec_bypass                                 ,
    input  logic         			            frac_dec_coeff_wr_en                            ,
    input  logic signed [COEFF_WIDTH - 1 : 0]   frac_dec_coeff_data_in  [N_TAP - 1 : 0]         ,

    output logic signed [COEFF_WIDTH - 1 : 0]   frac_dec_coeff_data_out [N_TAP - 1 : 0]         ,
    output logic                                frac_dec_overflow                               ,
    output logic                                frac_dec_underflow                              ,
    output logic signed [DATA_WIDTH - 1 : 0]    frac_dec_out                                    ,
    output logic                                frac_dec_valid_out                              ,

    //********************** IIR Chain I/O ************************//
    /********************** 1 MHz Notch Filter I/O ************************/
    input  logic                                iir_bypass_5MHz                                 ,
    input  logic         			            iir_coeff_wr_en_1MHz                            ,
    input  logic signed [COEFF_WIDTH - 1 : 0]   iir_coeff_in_1MHz       [COEFF_DEPTH - 1 : 0]   ,
    output logic signed [COEFF_WIDTH - 1 : 0]   iir_coeff_out_1MHz      [COEFF_DEPTH - 1 : 0]   ,
    output logic                                iir_overflow_1MHz                               ,
    output logic                                iir_underflow_1MHz                              ,
    
    /********************** 2 MHz Notch Filter I/O ************************/
    input  logic         			            iir_coeff_wr_en_2MHz                            ,
    input  logic signed [COEFF_WIDTH - 1 : 0]   iir_coeff_in_2MHz       [COEFF_DEPTH - 1 : 0]   ,
    output logic signed [COEFF_WIDTH - 1 : 0]   iir_coeff_out_2MHz      [COEFF_DEPTH - 1 : 0]   ,
    output logic                                iir_overflow_2MHz                               ,
    output logic                                iir_underflow_2MHz                              ,
    
    /********************** 2.4 MHz Notch Filter I/O ************************/
    input  logic                                iir_bypass_2_4MHz                               , 
    input  logic         			            iir_coeff_wr_en_2_4MHz                          ,
    input  logic signed [COEFF_WIDTH - 1 : 0]   iir_coeff_in_2_4MHz     [COEFF_DEPTH - 1 : 0]   ,
    output logic signed [COEFF_WIDTH - 1 : 0]   iir_coeff_out_2_4MHz    [COEFF_DEPTH - 1 : 0]   ,
    output logic                                iir_overflow_2_4MHz                             ,
    output logic                                iir_underflow_2_4MHz                            ,

    output logic signed [DATA_WIDTH - 1 : 0]    iir_out                                         ,
    output logic                                iir_valid_out                                   ,

    //********************** CIC I/O ************************//
    input  logic                                cic_bypass                                      ,
    input  logic        [DEC_WIDTH : 0]         cic_dec_factor                                  ,  // Decimation factor

    output logic                                cic_overflow                                    ,
    output logic                                cic_underflow   
    
);

    assign overflow     = frac_dec_overflow     |   iir_overflow_1MHz   |   iir_overflow_2MHz   |   iir_overflow_2_4MHz     |   cic_overflow    ;
    
    assign underflow    = frac_dec_underflow    |   iir_underflow_1MHz  |   iir_underflow_2MHz  |   iir_underflow_2_4MHz    |   cic_underflow   ;


    fractional_decimator #(
        .DATA_WIDTH    (DATA_WIDTH)      ,
        .DATA_FRAC     (DATA_FRAC)       ,
        .COEFF_WIDTH   (COEFF_WIDTH)     ,
        .COEFF_FRAC    (COEFF_FRAC)      
    ) FRACTIONAL_DECIMATOR (
        .clk            (clk)                       ,
        .valid_in       (valid_in)                  ,
        .rst_n          (rst_n)                     ,
        .bypass         (frac_dec_bypass)           ,
        .coeff_wr_en    (frac_dec_coeff_wr_en)      ,
        .coeff_data_in  (frac_dec_coeff_data_in)    ,
        .filter_in      (core_in)                   ,
        .coeff_data_out (frac_dec_coeff_data_out)   ,
        .filter_out     (frac_dec_out)              ,
        .overflow       (frac_dec_overflow)         ,
        .underflow      (frac_dec_underflow)        ,
        .valid_out      (frac_dec_valid_out)
    );

    IIR_chain #(
        .DATA_WIDTH      (DATA_WIDTH)  ,
        .DATA_FRAC       (DATA_FRAC)   ,
        .COEFF_WIDTH     (COEFF_WIDTH) ,
        .COEFF_FRAC      (COEFF_FRAC)     
    ) IIR (
        .clk                 (clk)                     ,
        .rst_n               (rst_n)                   ,
        .valid_in            (frac_dec_valid_out)      ,
        .iir_in              (frac_dec_out)            ,
        .iir_out             (iir_out)                 ,
        .valid_out           (iir_valid_out)           ,
        .bypass_1MHz         (iir_bypass_5MHz)         ,
        .coeff_wr_en_1MHz    (iir_coeff_wr_en_1MHz)    ,
        .coeff_in_1MHz       (iir_coeff_in_1MHz)       ,
        .coeff_out_1MHz      (iir_coeff_out_1MHz)      ,
        .overflow_1MHz       (iir_overflow_1MHz)       ,
        .underflow_1MHz      (iir_underflow_1MHz)      ,
        .bypass_2MHz         (iir_bypass_5MHz)         ,
        .coeff_wr_en_2MHz    (iir_coeff_wr_en_2MHz)    ,
        .coeff_in_2MHz       (iir_coeff_in_2MHz)       ,
        .coeff_out_2MHz      (iir_coeff_out_2MHz)      ,
        .overflow_2MHz       (iir_overflow_2MHz)       ,
        .underflow_2MHz      (iir_underflow_2MHz)      ,
        .bypass_2_4MHz       (iir_bypass_2_4MHz)       ,
        .coeff_wr_en_2_4MHz  (iir_coeff_wr_en_2_4MHz)  ,
        .coeff_in_2_4MHz     (iir_coeff_in_2_4MHz)     ,
        .coeff_out_2_4MHz    (iir_coeff_out_2_4MHz)    ,
        .overflow_2_4MHz     (iir_overflow_2_4MHz)     ,
        .underflow_2_4MHz    (iir_underflow_2_4MHz)
    );

    CIC #(
        .DATA_WIDTH (DATA_WIDTH), 
        .DATA_FRAC  (DATA_FRAC),
        .Q (Q), 
        .N (N)
    ) CIC (
        .clk         (clk)              ,
        .rst_n       (rst_n)            ,
        .valid_in    (iir_valid_out)    ,
        .bypass      (cic_bypass)       ,
        .dec_factor  (cic_dec_factor)   ,  // Decimation factor
        .cic_in      (iir_out)          ,
        .cic_out     (core_out)         ,
        .valid_out   (valid_out)        ,
        .overflow    (cic_overflow)     ,
        .underflow   (cic_underflow)
    );
    
endmodule