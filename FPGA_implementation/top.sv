module Design_top #(
    parameter   DATA_WIDTH      = 16                                ,
    parameter   DATA_FRAC       = 15                                ,
    parameter   COEFF_WIDTH     = 20                                ,
    parameter   COEFF_FRAC      = 18                                ,
    parameter   N_TAP           = 72                               
) (
    input   logic                               clk                                                     ,
    input   logic                               rst_n                                                   ,
    input   logic                               valid_in                                                ,

    input   logic signed [DATA_WIDTH - 1 : 0]   top_chain_in                                            ,

    input   logic        [4 : 0]                cic_dec_factor                                          ,

    output  logic signed [DATA_WIDTH - 1 : 0]   top_chain_out                                           ,
  
    output  logic                               iir_overflow_2_4                                        ,
    output  logic                               iir_underflow_2_4                                       ,
    
    output  logic                               iir_overflow_2                                          ,
    output  logic                               iir_underflow_2                                         ,
    
    output  logic                               iir_overflow_1                                          ,
    output  logic                               iir_underflow_1                                         ,

    output  logic                               frac_dec_overflow                                       ,
    output  logic                               frac_dec_underflow                                      ,

    output  logic                               cic_overflow                                            ,
    output  logic                               cic_underflow                                           ,
    
    output  logic                               valid_out                                       
);

    localparam  NUM_COEFF_DEPTH = 3                                 ;
    localparam  DEN_COEFF_DEPTH = 2                                 ;
    localparam  CIC_Q           = 1                                 ;
    localparam  CIC_N           = 1                                 ;
    localparam  DEC_WIDTH       = $clog2(16)                        ;

    logic signed [DATA_WIDTH - 1 : 0]   frac_dec_out;
    logic frac_dec_valid_out;

    logic signed [DATA_WIDTH - 1 : 0]   iir_chain_out;
    logic iir_chain_valid_out;

    fractional_decimator #(
        .DATA_WIDTH   (DATA_WIDTH)  ,
        .DATA_FRAC    (DATA_FRAC)   ,
        .COEFF_WIDTH  (COEFF_WIDTH) ,
        .COEFF_FRAC   (COEFF_FRAC)  ,
        .N_TAP        (N_TAP)  
  
    ) FRAC_DEC_STAGE (
        .clk           (clk),
        .valid_in      (valid_in),
        .rst_n         (rst_n),
        .coeff_wr_en   (),
        .coeff_data_in (),
        .filter_in     (top_chain_in),
        .filter_out    (frac_dec_out),
        .overflow      (frac_dec_overflow)      ,
        .underflow     (frac_dec_underflow)     ,
        .valid_out     (frac_dec_valid_out)
    );


    IIR_chain #(
        .DATA_WIDTH    (DATA_WIDTH)    ,
        .DATA_FRAC     (DATA_FRAC)     ,
        .COEFF_WIDTH   (COEFF_WIDTH)   ,
        .COEFF_FRAC    (COEFF_FRAC)                       
    ) IIR_CHAIN_STAGE (
        .clk                    (clk)                       ,
        .rst_n                  (rst_n)                     ,
        .valid_in               (frac_dec_valid_out)        ,
        .bypass_2_4             (iir_bypass_2_4)            ,
        .bypass_2               (iir_bypass_2)              ,
        .bypass_1               (iir_bypass_1)              , 
        .num_coeff_2_4_wr_en    ()   ,
        .den_coeff_2_4_wr_en    ()   ,
        .num_coeff_2_4_in       ()      ,
        .den_coeff_2_4_in       ()      ,
        .num_coeff_2_wr_en      ()     ,
        .den_coeff_2_wr_en      ()     ,
        .num_coeff_2_in         ()        ,
        .den_coeff_2_in         ()        ,
        .num_coeff_1_wr_en      ()     ,
        .den_coeff_1_wr_en      ()     ,
        .num_coeff_1_in         ()        ,
        .den_coeff_1_in         ()        ,
        .iir_chain_in           (frac_dec_out)              ,
        .iir_chain_out          (iir_chain_out)             ,
        .overflow_2_4           (iir_overflow_2_4)          ,
        .underflow_2_4          (iir_underflow_2_4)         ,
        .overflow_2             (iir_overflow_2)            ,
        .underflow_2            (iir_underflow_2)           ,
        .overflow_1             (iir_overflow_1)            ,
        .underflow_1            (iir_underflow_1)           ,
        .valid_out              (iir_chain_valid_out)
    );

    CIC #(
        .DATA_WIDTH (DATA_WIDTH),
        .DATA_FRAC  (DATA_FRAC),
        .Q          (CIC_Q),
        .N          (CIC_N)
    ) CIC_STAGE (
        .clk        (clk)                   ,
        .rst_n      (rst_n)                 ,
        .valid_in   (iir_chain_valid_out)   ,
        .dec_factor (cic_dec_factor)        ,
        .cic_in     (iir_chain_out)         ,
        .cic_out    (top_chain_out)         ,
        .valid_out  (valid_out)             ,
        .overflow   (cic_overflow)          ,
        .underflow  (cic_underflow)
    );

endmodule