module IIR_chain #(
    parameter   DATA_WIDTH      = 16                                ,
    parameter   DATA_FRAC       = 15                                ,
    parameter   COEFF_WIDTH     = 20                                ,
    parameter   COEFF_FRAC      = 18                               
) (
    input   logic                               clk                                                 ,
    input   logic                               rst_n                                               ,
    input   logic                               valid_in                                            ,
    
    input   logic                               bypass_2_4                                          ,
    input   logic                               bypass_2                                            ,
    input   logic                               bypass_1                                            , 

    input   logic         			            num_coeff_2_4_wr_en                                 ,
    input   logic         			            den_coeff_2_4_wr_en                                 ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  num_coeff_2_4_in        [NUM_COEFF_DEPTH - 1 : 0]   ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  den_coeff_2_4_in        [DEN_COEFF_DEPTH - 1 : 0]   ,

    input   logic         			            num_coeff_2_wr_en                                   ,
    input   logic         			            den_coeff_2_wr_en                                   ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  num_coeff_2_in          [NUM_COEFF_DEPTH - 1 : 0]   ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  den_coeff_2_in          [DEN_COEFF_DEPTH - 1 : 0]   ,

    input   logic         			            num_coeff_1_wr_en                                   ,
    input   logic         			            den_coeff_1_wr_en                                   ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  num_coeff_1_in          [NUM_COEFF_DEPTH - 1 : 0]   ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  den_coeff_1_in          [DEN_COEFF_DEPTH - 1 : 0]   ,

    input   logic signed [DATA_WIDTH - 1 : 0]   iir_chain_in                                        ,
        
    output  logic signed [DATA_WIDTH - 1 : 0]   iir_chain_out                                       ,
        
    output  logic                               overflow_2_4                                        ,
    output  logic                               underflow_2_4                                       ,
    
    output  logic                               overflow_2                                          ,
    output  logic                               underflow_2                                         ,
    
    output  logic                               overflow_1                                          ,
    output  logic                               underflow_1                                         ,
    
    output  logic                               valid_out                                       
);

    localparam  IIR_2_4_NOTCH   = 2                                 ;
    localparam  IIR_2_NOTCH     = 1                                 ;
    localparam  IIR_1_NOTCH     = 0                                 ;
    localparam  NUM_COEFF_DEPTH = 3                                 ;
    localparam  DEN_COEFF_DEPTH = 2                                 ;

    logic signed [DATA_WIDTH - 1 : 0]       iir_out_2_4MHz      ;
    logic signed [DATA_WIDTH - 1 : 0]       iir_out_1MHz        ;

    logic                                   valid_out_2_4       ;
    logic                                   valid_out_1         ;

    IIR #(
        .DATA_WIDTH       (DATA_WIDTH)      ,
        .DATA_FRAC        (DATA_FRAC)       ,
        .COEFF_WIDTH      (COEFF_WIDTH)     ,
        .COEFF_FRAC       (COEFF_FRAC)      ,
        .IIR_NOTCH_FREQ   (IIR_2_4_NOTCH)
    ) IIR_2_4MHz (
        .clk                 (clk)                  ,
        .rst_n               (rst_n)                ,
        .valid_in            (valid_in)             ,
        .bypass              (bypass_2_4)           ,   
        .num_coeff_wr_en     (num_coeff_2_4_wr_en)  ,
        .den_coeff_wr_en     (den_coeff_2_4_wr_en)  ,
        .num_coeff_in        (num_coeff_2_4_in)     ,
        .den_coeff_in        (den_coeff_2_4_in)     ,
        .iir_in              (iir_chain_in)         ,
        .iir_out             (iir_out_2_4MHz)       ,
        .overflow            (overflow_2_4)         ,
        .underflow           (underflow_2_4)        ,
        .valid_out           (valid_out_2_4)
    );
    
    IIR #(
        .DATA_WIDTH       (DATA_WIDTH)  ,
        .DATA_FRAC        (DATA_FRAC)   ,
        .COEFF_WIDTH      (COEFF_WIDTH) ,
        .COEFF_FRAC       (COEFF_FRAC)  ,
        .IIR_NOTCH_FREQ   (IIR_1_NOTCH)
    ) IIR_1MHz (
        .clk                 (clk)                  ,
        .rst_n               (rst_n)                ,
        .valid_in            (valid_out_2_4)        ,
        .bypass              (bypass_1)             ,
        .num_coeff_wr_en     (num_coeff_1_wr_en)    ,
        .den_coeff_wr_en     (den_coeff_1_wr_en)    ,
        .num_coeff_in        (num_coeff_1_in)       ,
        .den_coeff_in        (den_coeff_1_in)       ,
        .iir_in              (iir_out_2_4MHz)       ,
        .iir_out             (iir_out_1MHz)         ,
        .overflow            (overflow_1)           ,
        .underflow           (underflow_1)          ,
        .valid_out           (valid_out_1)
    );
    
    IIR #(
        .DATA_WIDTH       (DATA_WIDTH)  ,
        .DATA_FRAC        (DATA_FRAC)   ,
        .COEFF_WIDTH      (COEFF_WIDTH) ,
        .COEFF_FRAC       (COEFF_FRAC)  ,
        .IIR_NOTCH_FREQ   (IIR_2_NOTCH)
    ) IIR_2MHz (
        .clk                 (clk)                  ,
        .rst_n               (rst_n)                ,
        .valid_in            (valid_out_1)          ,
        .bypass              (bypass_2)             ,
        .num_coeff_wr_en     (num_coeff_2_wr_en)    ,
        .den_coeff_wr_en     (den_coeff_2_wr_en)    ,
        .num_coeff_in        (num_coeff_2_in)       ,
        .den_coeff_in        (den_coeff_2_in)       ,
        .iir_in              (iir_out_1MHz)         ,
        .iir_out             (iir_chain_out)        ,
        .overflow            (overflow_2)           ,
        .underflow           (underflow_2)          ,
        .valid_out           (valid_out) 
    );



endmodule