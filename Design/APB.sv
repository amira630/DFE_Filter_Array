module APB #(
    parameter ADDR_WIDTH  = 7  ,
    parameter PDATA_WIDTH = 32 ,
    parameter DATA_WIDTH  = 16 ,
    parameter COEFF_WIDTH = 20 ,
    parameter N_TAP       = 72 ,
    parameter NUM_DENUM   = 5  ,
    parameter COMP        = 4  
)(
    input logic                              clk                               ,
    input logic                              rst_n                             ,   
                        
    input logic                              MTRANS                            , 
    input logic                              MWRITE                            ,
    input logic        [COMP-1:0]            MSELx                             ,
    input logic        [ADDR_WIDTH-1:0]      MADDR                             ,
    input logic signed [COEFF_WIDTH-1:0]     MWDATA                            , 
    output logic       [PDATA_WIDTH-1:0]     MRDATA                            ,

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

    output logic                          CTRL             [4:0]              ,

    output logic        [1:0]             OUT_SEL                             ,

    output logic        [2:0]             COEFF_SEL                           ,

    output logic        [2:0]             STATUS                
);

    logic                   PREADY;
    logic                   PENABLE;
    logic                   PWRITE;
    logic [ADDR_WIDTH-1:0]  PADDR;
    logic [COMP-1:0]        PSELx;
    logic [PDATA_WIDTH-1:0] PWDATA; 
    logic [PDATA_WIDTH-1:0] PRDATA;      

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
        .CTRL(CTRL),
        .OUT_SEL(OUT_SEL),         
        .COEFF_SEL(COEFF_SEL),
        .STATUS(STATUS)
    );
endmodule