module APB #(
    parameter ADDR_WIDTH  = 7  ,
    parameter PDATA_WIDTH = 32 ,
    parameter DATA_WIDTH  = 16 ,
    parameter COEFF_WIDTH = 20 ,
    parameter N_TAP       = 72 ,
    parameter NUM_DENUM   = 5  ,
    parameter COMP        = 5  ,
    parameter L           = 2  ,
    parameter M           = 3       
)(
    input logic                              clk                               ,
    input logic                              rst_n                             ,   
                        
    input logic                              MTRANS                            , 
    input logic                              MWRITE                            ,
    input logic        [COMP-1:0]            MSELx                             ,
    input logic        [ADDR_WIDTH-1:0]      MADDR                             ,
    input logic signed [COEFF_WIDTH-1:0]     MWDATA                            , 
    output logic       [PDATA_WIDTH-1:0]     MRDATA                            ,
    // input logic                              clk_enable,
    // input logic signed [DATA_WIDTH - 1 : 0]  filter_in ,

    // output logic signed [DATA_WIDTH - 1 : 0] filter_out,
    // output logic                             overflow  ,
    // output logic                             underflow ,
    // output logic                             ce_in     ,
    // output logic                             ce_out
    output logic                          FRAC_DECI_VLD                       ,
    output logic signed [COEFF_WIDTH-1:0] FRAC_DECI_OUT    [N_TAP-1:0]        ,

    output logic                          IIR_24_VLD                          , 
    output logic signed [COEFF_WIDTH-1:0] IIR_24_OUT       [NUM_DENUM-1:0]    , 
    output logic                          IIR_5_1_VLD                         , 
    output logic signed [COEFF_WIDTH-1:0] IIR_5_1_OUT      [NUM_DENUM-1:0]    , 
    output logic                          IIR_5_2_VLD                         , 
    output logic signed [COEFF_WIDTH-1:0] IIR_5_2_OUT      [NUM_DENUM-1:0]    , 

    output logic                          CIC_R_VLD                           ,
    output logic signed [4:0]             CIC_R_OUT                           ,

    output logic                          CTRL_OUT         [4:0]              ,

    output logic        [1:0]             OUT_SEL                             ,

    output logic                          FRAC_DECI_STATUS [1:0]              ,
    output logic                          IIR_24_STATUS    [1:0]              ,
    output logic                          IIR_5_1_STATUS   [1:0]              ,
    output logic                          IIR_5_2_STATUS   [1:0]              ,
    output logic                          CIC_STATUS       [1:0]              ,
    output logic                          FIR_STATUS       [1:0]               
);

    logic                   PREADY;
    logic                   PENABLE;
    logic                   PWRITE;
    logic [ADDR_WIDTH-1:0]  PADDR;
    logic [COMP-1:0]        PSELx;
    logic [PDATA_WIDTH-1:0] PWDATA; 
    logic [PDATA_WIDTH-1:0] PRDATA;      

    // logic signed [DATA_WIDTH-1:0]      CTRL           [5:0];

    // fractional_decimator #(
    //     .DATA_WIDTH (DATA_WIDTH),
    //     .COEFF_WIDTH(COEFF_WIDTH),
    //     .L          (L),
    //     .M          (M)             
    // ) U_FRAC_DECI (
    //     .clk          (clk),
    //     .clk_enable   (CTRL[0][0]),
    //     .rst_n        (rst_n),   
    //     .coeff_wr_en  (coeff_wr_en),
    //     .coeff_data_in(coeff_data_in), 
    //     .filter_in    (filter_in),
    //     .filter_out   (filter_out),
    //     .overflow     (overflow),
    //     .underflow    (underflow),
    //     .ce_in        (ce_in),
    //     .ce_out       (ce_out)
    // );

    APB_Bridge #(
        .ADDR_WIDTH(ADDR_WIDTH),     
        .DATA_WIDTH(PDATA_WIDTH),      
        .COMP(COMP)        
    ) U_APB (
        .PCLK   (clk),
        .PRESETn(rst_n),
        .PREADY (PREADY),
        .MTRANS (MTRANS),  
        .MWRITE (MWRITE),
        .MSELx  (MSELx),
        .MADDR  (MADDR),
        .PRDATA (PRDATA),
        .MWDATA (MWDATA), 
        .PENABLE(PENABLE),
        .PWRITE (PWRITE),
        .PADDR  (PADDR),
        .PSELx  (PSELx),
        .PWDATA (PWDATA),
        .MRDATA (MRDATA) 
    );

    MPRAM #(
        .ADDR_WIDTH(ADDR_WIDTH)     ,
        .DATA_WIDTH(PDATA_WIDTH)    ,
        .TAPS(N_TAP)                ,
        .COEFF_WIDTH(COEFF_WIDTH)   ,
        .NUM_DENUM(NUM_DENUM)       ,      
        .COMP(COMP)      
    ) U_MPRAM (
        .clk(clk),
        .rst_n(rst_n),
        .FRAC_DECI_EN(PSELx[0]),
        .IIR_EN(PSELx[1]),
        .CTRL_EN(PSELx[2]),
        .CIC_EN(PSELx[3]),
        .FIR_EN(PSELx[4]),
        .PWRITE(PWRITE),
        .PENABLE(PENABLE),
        .DATA_ADDR(PADDR),
        .DATA_IN(PWDATA),
        .PREADY(PREADY),
        .PRDATA(PRDATA),
        .FRAC_DECI_VLD(FRAC_DECI_VLD),
        .FRAC_DECI_OUT(FRAC_DECI_OUT),
        .IIR_24_VLD(IIR_24_VLD),
        .IIR_24_OUT(IIR_24_OUT),
        .IIR_5_1_VLD(IIR_5_1_VLD),
        .IIR_5_1_OUT(IIR_5_1_OUT),
        .IIR_5_2_VLD(IIR_5_2_VLD),
        .IIR_5_2_OUT(IIR_5_2_OUT),
        .CIC_R_VLD(CIC_R_VLD),
        .CIC_R_OUT(CIC_R_OUT), 
        .CTRL_OUT(CTRL_OUT),
        .OUT_SEL(OUT_SEL),         
        .FRAC_DECI_STATUS(FRAC_DECI_STATUS),
        .IIR_24_STATUS(IIR_24_STATUS),
        .IIR_5_1_STATUS(IIR_5_1_STATUS),
        .IIR_5_2_STATUS(IIR_5_2_STATUS),
        .CIC_STATUS(CIC_STATUS),
        .FIR_STATUS(FIR_STATUS)
    );
endmodule