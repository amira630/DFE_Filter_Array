module IIR_chain #(
    parameter   DATA_WIDTH      = 16                                    ,
    parameter   DATA_FRAC       = 15                                    ,
    parameter   COEFF_WIDTH     = 20                                    ,
    parameter   COEFF_FRAC      = 18                                    ,

    // Coefficient depths
    localparam NUM_COEFF_DEPTH = 3                                      ,
    localparam DEN_COEFF_DEPTH = 2                                      ,
    localparam COEFF_DEPTH     = NUM_COEFF_DEPTH + DEN_COEFF_DEPTH      
) (
    /********************** General I/O ************************/
    input   logic                               clk                                             ,
    input   logic                               rst_n                                           ,
    input   logic                               valid_in                                        ,
    
    input   logic signed [DATA_WIDTH - 1 : 0]   iir_in                                          ,
    output  logic signed [DATA_WIDTH - 1 : 0]   iir_out                                         ,

    output  logic                               valid_out                                       ,

    /********************** 1 MHz Notch Filter I/O ************************/
    input   logic                               bypass_1MHz                                     ,

    input   logic         			            coeff_wr_en_1MHz                                ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  coeff_in_1MHz            [COEFF_DEPTH - 1 : 0]  ,
    
    output  logic signed [COEFF_WIDTH - 1 : 0]  coeff_out_1MHz           [COEFF_DEPTH - 1 : 0]  ,
    
    output  logic                               overflow_1MHz                                   ,
    output  logic                               underflow_1MHz                                  ,
    
    /********************** 2 MHz Notch Filter I/O ************************/
    input   logic                               bypass_2MHz                                     ,

    input   logic         			            coeff_wr_en_2MHz                                ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  coeff_in_2MHz            [COEFF_DEPTH - 1 : 0]  ,
    
    output  logic signed [COEFF_WIDTH - 1 : 0]  coeff_out_2MHz           [COEFF_DEPTH - 1 : 0]  ,
    
    output  logic                               overflow_2MHz                                   ,
    output  logic                               underflow_2MHz                                  ,
    
    /********************** 2.4 MHz Notch Filter I/O ************************/
    input   logic                               bypass_2_4MHz                                   , 

    input   logic         			            coeff_wr_en_2_4MHz                              ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  coeff_in_2_4MHz            [COEFF_DEPTH - 1 : 0],

    output  logic signed [COEFF_WIDTH - 1 : 0]  coeff_out_2_4MHz           [COEFF_DEPTH - 1 : 0],
        
    output  logic                               overflow_2_4MHz                                 ,
    output  logic                               underflow_2_4MHz                                
);
    localparam NOTCH_1MHZ   = 0;
    localparam NOTCH_2MHZ   = 1;
    localparam NOTCH_2_4MHZ = 2;

    logic signed [DATA_WIDTH - 1 : 0]   iir_out_1MHz    ;
    logic signed [DATA_WIDTH - 1 : 0]   iir_out_2_4MHz    ;

    logic valid_1MHz_out;
    logic valid_2_4MHz_out;

    IIR #(
        .DATA_WIDTH      (DATA_WIDTH)  ,
        .DATA_FRAC       (DATA_FRAC)   ,
        .COEFF_WIDTH     (COEFF_WIDTH) ,
        .COEFF_FRAC      (COEFF_FRAC)  ,
        .IIR_NOTCH_FREQ  (NOTCH_2_4MHZ)                // 0: 1MHz, 1: 2MHz, 2:2.4MHz

    ) IIR_2_4MHZ_NOTCH (
        .clk          (clk)                  ,
        .rst_n        (rst_n)                ,
        .valid_in     (valid_in)             ,
        .bypass       (bypass_2_4MHz)        ,   
        .coeff_wr_en  (coeff_wr_en_2_4MHz)   ,
        .coeff_in     (coeff_in_2_4MHz)      ,
        .iir_in       (iir_in)               ,
        .iir_out      (iir_out_2_4MHz)       ,   
        .coeff_out    (coeff_out_2_4MHz)     ,
        .overflow     (overflow_2_4MHz)      ,
        .underflow    (underflow_2_4MHz)     ,
        .valid_out    (valid_2_4MHz_out) 
    );

    IIR #(
        .DATA_WIDTH      (DATA_WIDTH)  ,
        .DATA_FRAC       (DATA_FRAC)   ,
        .COEFF_WIDTH     (COEFF_WIDTH) ,
        .COEFF_FRAC      (COEFF_FRAC)  ,
        .IIR_NOTCH_FREQ  (NOTCH_1MHZ)                // 0: 1MHz, 1: 2MHz, 2:2.4MHz

    ) IIR_1MHZ_NOTCH (
        .clk           (clk)                ,
        .rst_n         (rst_n)              ,
        .valid_in      (valid_2_4MHz_out)           ,
        .bypass        (bypass_1MHz)        ,   
        .coeff_wr_en   (coeff_wr_en_1MHz)   ,
        .coeff_in      (coeff_in_1MHz)      ,
        .iir_in        (iir_out_2_4MHz)             ,
        .iir_out       (iir_out_1MHz)       ,   
        .coeff_out     (coeff_out_1MHz)     ,
        .overflow      (overflow_1MHz)      ,
        .underflow     (underflow_1MHz)     ,
        .valid_out     (valid_1MHz_out)
    );

    IIR #(
        .DATA_WIDTH      (DATA_WIDTH)  ,
        .DATA_FRAC       (DATA_FRAC)   ,
        .COEFF_WIDTH     (COEFF_WIDTH) ,
        .COEFF_FRAC      (COEFF_FRAC)  ,
        .IIR_NOTCH_FREQ  (NOTCH_2MHZ)                // 0: 1MHz, 1: 2MHz, 2:2.4MHz

    ) IIR_2MHZ_NOTCH (
        .clk            (clk)                ,
        .rst_n          (rst_n)              ,
        .valid_in       (valid_1MHz_out)     ,
        .bypass         (bypass_2MHz)        ,   
        .coeff_wr_en    (coeff_wr_en_2MHz)   ,
        .coeff_in       (coeff_in_2MHz)      ,
        .iir_in         (iir_out_1MHz)       ,
        .iir_out        (iir_out)       ,   
        .coeff_out      (coeff_out_2MHz)     ,
        .overflow       (overflow_2MHz)      ,
        .underflow      (underflow_2MHz)     ,
        .valid_out      (valid_out)
    );

    
    
endmodule