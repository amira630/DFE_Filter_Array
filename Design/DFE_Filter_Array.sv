module DFE_Filter_Array #(
    parameter ADDR_WIDTH  = 7 ,
    parameter PDATA_WIDTH = 32,
    parameter DATA_WIDTH  = 16,
    parameter COEFF_WIDTH = 20,
    parameter N_TAP       = 72,
    parameter COMP        = 4 ,
    parameter L           = 2 ,
    parameter M           = 3               
)(
    input logic                              clk       ,
    input logic                              rst_n     ,   

    input logic                              MTRANS    , 
    input logic                              MWRITE    ,
    input logic        [COMP-1:0]            MSELx     ,
    input logic        [ADDR_WIDTH-1:0]      MADDR     ,
    input logic signed [COEFF_WIDTH-1:0]     MWDATA    , 

    input logic                              clk_enable,
    input logic signed [DATA_WIDTH - 1 : 0]  filter_in ,

    output logic signed [DATA_WIDTH - 1 : 0] filter_out,
    output logic                             overflow  ,
    output logic                             underflow ,
    output logic                             ce_in     ,
    output logic                             ce_out
);

    
    logic signed [COEFF_WIDTH - 1 : 0] coeff_data_in  [N_TAP - 1 : 0];
    logic         			           coeff_wr_en; 

    logic                   PREADY;
    logic                   PENABLE;
    logic                   PWRITE;  
    logic [ADDR_WIDTH-1:0]  PADDR;
    logic [COMP-1:0]        PSELx;
    logic [PDATA_WIDTH-1:0] PWDATA; 

    logic signed [DATA_WIDTH-1:0]      CTRL           [5:0];

    fractional_decimator #(
        .DATA_WIDTH (DATA_WIDTH),
        .COEFF_WIDTH(COEFF_WIDTH),
        .L          (L),
        .M          (M)             
    ) U_FRAC_DECI (
        .clk          (clk),
        .clk_enable   (CTRL[0][0]),
        .rst_n        (rst_n),   
        .coeff_wr_en  (coeff_wr_en),
        .coeff_data_in(coeff_data_in), 
        .filter_in    (filter_in),
        .filter_out   (filter_out),
        .overflow     (overflow),
        .underflow    (underflow),
        .ce_in        (ce_in),
        .ce_out       (ce_out)
    );

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
        .PRDATA (),
        .MWDATA (MWDATA), 
        .PENABLE(PENABLE),
        .PWRITE (PWRITE),
        .PADDR  (PADDR),
        .PSELx  (PSELx),
        .PWDATA (PWDATA),
        .MRDATA () 
    );


    MPRAM #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(PDATA_WIDTH),
        .TAPS(N_TAP)
    ) U_MPRAM (
        .clk(clk),
        .rst_n(rst_n),
        .FRAC_DECI_EN(PSELx[0]),
        .IIR_EN(PSELx[1]),
        .CTRL_EN(PSELx[2]),
        .CIC_R_EN(PSELx[3]),
        .PWRITE(PWRITE),
        .PENABLE(PENABLE),
        .DATA_ADDR(PADDR),
        .DATA_IN(PWDATA),
        .PREADY(PREADY),
        .FRAC_DECI_VLD(coeff_wr_en),
        .FRAC_DECI_OUT(coeff_data_in),
        .IIR_VLD(),
        .IIR_OUT(),
        .CTRL_OUT(CTRL),
        .CIC_R_VLD(),
        .CIC_R_OUT() 
    );
endmodule