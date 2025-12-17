////////////////////////////////////////////////////////////////////////////////
// Design Author: Amira EL-Komy
// Verified by Mustaf EL-Sherif
// --> Linting check
// --> Synthesis
// --> Functional Simulation
// Design: APB Interfaced DFE TOP
// Date: 02-11-2025
////////////////////////////////////////////////////////////////////////////////

module DFE_TOP #(
    //********************** General Parameters ********************//
    parameter   int DATA_WIDTH      = 32'd16    ,
    parameter   int DATA_FRAC       = 32'd15    ,
    parameter   int COEFF_WIDTH     = 32'd20    ,
    parameter   int COEFF_FRAC      = 32'd18    ,

    //********************** Fractional Decimator ********************//
    localparam  int N_TAP           = 32'd146    ,
    
    //********************** IIR Parameters ********************//
    localparam  int NUM_DENUM       = 32'd5     ,

    //********************** CIC Parameters ********************//
    parameter   int Q               = 32'd1     , 
    parameter   int N               = 32'd1     ,

    //********************** APB Parameters ********************//
    parameter   int ADDR_WIDTH      = 32'd7     ,
    parameter   int PDATA_WIDTH     = 32'd32    ,
    parameter   int COMP            = 32'd4  
)(
    input   logic                                   clk                                 ,
    input   logic                                   rst_n                               ,

    input   logic                                   MTRANS                              , 
    input   logic                                   MWRITE                              ,
    input   logic           [COMP - 1 : 0]          MSELx                               ,
    input   logic           [ADDR_WIDTH - 1 : 0]    MADDR                               ,
    input   logic signed    [COEFF_WIDTH - 1 : 0]   MWDATA                              , 
    output  logic           [PDATA_WIDTH - 1 : 0]   MRDATA                              ,

    input   logic                                   valid_in                            ,
    input   logic signed    [DATA_WIDTH - 1 : 0]    core_in                             ,

    output  logic                                   valid_out                           ,
    output  logic signed    [DATA_WIDTH - 1 : 0]    core_out                            ,
    output  logic                                   overflow                            ,
    output  logic                                   underflow                           ,

    output  logic                                   block_overflow                      ,
    output  logic                                   block_underflow                     ,
    output  logic                                   block_valid_out                     ,
    output  logic signed    [DATA_WIDTH - 1 : 0]    block_out                           ,

    output  logic signed    [COEFF_WIDTH - 1 : 0]   coeff_out           [N_TAP - 1 : 0]                
);

    logic                               FRAC_DECI_VLD                               ;   
    logic signed [COEFF_WIDTH - 1 : 0]  FRAC_DECI_OUT           [N_TAP - 1 : 0]     ;

    logic                               IIR_24_VLD                                  ; 
    logic signed [COEFF_WIDTH - 1 : 0]  IIR_24_OUT              [NUM_DENUM - 1 : 0] ; 
    logic                               IIR_5_1_VLD                                 ;    
    logic signed [COEFF_WIDTH - 1 : 0]  IIR_5_1_OUT             [NUM_DENUM - 1 : 0] ; 
    
    logic signed [4 : 0]                CIC_R_OUT                                   ;

    logic                               CTRL                    [4 : 0]             ;
    logic        [1 : 0]                OUT_SEL                                     ;
    logic        [1 : 0]                COEFF_SEL                                   ;
    logic        [2 : 0]                STATUS                                      ;

    logic signed [COEFF_WIDTH - 1 : 0]  frac_dec_coeff_data_out [N_TAP - 1 : 0]     ;
    logic                               frac_dec_overflow                           ;
    logic                               frac_dec_underflow                          ;
    logic signed [DATA_WIDTH - 1 : 0]   frac_dec_out                                ;
    logic                               frac_dec_valid_out                          ;


    logic signed [COEFF_WIDTH - 1 : 0]  iir_coeff_out_1MHz      [NUM_DENUM - 1 : 0] ;
    logic                               iir_overflow_1MHz                           ;
    logic                               iir_underflow_1MHz                          ;

    logic signed [COEFF_WIDTH - 1 : 0]  iir_coeff_out_2_4MHz    [NUM_DENUM - 1 : 0] ;
    logic                               iir_overflow_2_4MHz                         ;
    logic                               iir_underflow_2_4MHz                        ;

    logic signed [DATA_WIDTH - 1 : 0]   iir_out                                     ;
    logic                               iir_valid_out                               ;

    logic                               cic_overflow                                ;
    logic                               cic_underflow                               ;
    


    CORE #(
        .DATA_WIDTH   (DATA_WIDTH)  ,
        .DATA_FRAC    (DATA_FRAC)   ,
        .COEFF_WIDTH  (COEFF_WIDTH) ,
        .COEFF_FRAC   (COEFF_FRAC)  ,
        .Q            (Q)           ,
        .N            (N)
    ) U_CORE (
        //********************** General I/O ************************//
        .clk                     (clk)                      ,
        .valid_in                (valid_in)                 ,
        .rst_n                   (rst_n)                    ,
        .core_in                 (core_in)                  ,
                        
        .valid_out               (valid_out)                ,
        .core_out                (core_out)                 ,
        .overflow                (overflow)                 ,
        .underflow               (underflow)                ,

        //********************** Fractional Decimator I/O ************************//
        .frac_dec_bypass         (CTRL[0])                  ,
        .frac_dec_coeff_wr_en    (FRAC_DECI_VLD)            ,
        .frac_dec_coeff_data_in  (FRAC_DECI_OUT)            ,

        .frac_dec_coeff_data_out (frac_dec_coeff_data_out)  ,
        .frac_dec_overflow       (frac_dec_overflow      )  ,
        .frac_dec_underflow      (frac_dec_underflow     )  ,
        .frac_dec_out            (frac_dec_out           )  ,
        .frac_dec_valid_out      (frac_dec_valid_out     )  ,

        //********************** IIR Chain I/O ************************//
        /********************** 1 MHz Notch Filter I/O ************************/
        .iir_bypass_5MHz         (CTRL[2])                  ,
        .iir_coeff_wr_en_1MHz    (IIR_5_1_VLD)              ,
        .iir_coeff_in_1MHz       (IIR_5_1_OUT)              ,
        .iir_coeff_out_1MHz      (iir_coeff_out_1MHz)       ,
        .iir_overflow_1MHz       (iir_overflow_1MHz )       ,
        .iir_underflow_1MHz      (iir_underflow_1MHz)       ,
        
        /********************** 2.4 MHz Notch Filter I/O ************************/
        .iir_bypass_2_4MHz       (CTRL[1])                  , 
        .iir_coeff_wr_en_2_4MHz  (IIR_24_VLD)               ,
        .iir_coeff_in_2_4MHz     (IIR_24_OUT)               ,
        .iir_coeff_out_2_4MHz    (iir_coeff_out_2_4MHz)     ,
        .iir_overflow_2_4MHz     (iir_overflow_2_4MHz )     ,
        .iir_underflow_2_4MHz    (iir_underflow_2_4MHz)     ,

        .iir_out                 (iir_out      )            ,
        .iir_valid_out           (iir_valid_out)            ,


        //********************** CIC I/O ************************//
        .cic_bypass              (CTRL[3])                  ,
        .cic_dec_factor          (CIC_R_OUT)                ,  // Decimation factor

        .cic_overflow            (cic_overflow )            ,
        .cic_underflow           (cic_underflow)    
    );


    APB #(
        .ADDR_WIDTH  (ADDR_WIDTH)   ,
        .PDATA_WIDTH (PDATA_WIDTH)  ,
        .DATA_WIDTH  (DATA_WIDTH)   ,
        .COEFF_WIDTH (COEFF_WIDTH)  ,
        .N_TAP       (N_TAP)        ,
        .COMP        (COMP)
    )U_APB(
        .clk            (clk)           ,
        .rst_n          (rst_n)         ,   
        
        .MTRANS         (MTRANS)        , 
        .MWRITE         (MWRITE)        ,
        .MSELx          (MSELx )        ,
        .MADDR          (MADDR )        ,
        .MWDATA         (MWDATA)        , 
        .MRDATA         (MRDATA)        ,

        .FRAC_DECI_VLD  (FRAC_DECI_VLD) ,
        .FRAC_DECI_OUT  (FRAC_DECI_OUT) ,

        .IIR_24_VLD     (IIR_24_VLD )   , 
        .IIR_24_OUT     (IIR_24_OUT )   , 
        .IIR_5_1_VLD    (IIR_5_1_VLD)   , 
        .IIR_5_1_OUT    (IIR_5_1_OUT)   , 
        
        .CIC_R_OUT      (CIC_R_OUT)     ,

        .CTRL           (CTRL     )     ,
        .OUT_SEL        (OUT_SEL  )     ,
        .COEFF_SEL      (COEFF_SEL)     ,
        .STATUS         (STATUS   )
    );

    always_comb begin
        case (OUT_SEL)
            2'b00: block_out = {(DATA_WIDTH){1'b0}} ;
            2'b01: block_out = frac_dec_out         ;
            2'b10: block_out = iir_out              ;
            2'b11: block_out = core_out             ;
        endcase
    end

    always_comb begin
        case (COEFF_SEL)
            2'b01: coeff_out = frac_dec_coeff_data_out;
            2'b10: begin
                for (int i = 0; i < N_TAP; i++) begin
                    if (i < NUM_DENUM)
                        coeff_out[i] = iir_coeff_out_1MHz[i];
                    else
                        coeff_out[i] = {(COEFF_WIDTH){1'b0}};
                end
            end
            2'b11: begin
                for (int i = 0; i < N_TAP; i++) begin
                    if (i < NUM_DENUM)
                        coeff_out[i] = iir_coeff_out_2_4MHz[i]  ;
                    else
                        coeff_out[i] = {(COEFF_WIDTH){1'b0}}    ;
                end
            end
            default : begin
                for (int i = 0 ; i < N_TAP ; i++) begin
                    coeff_out[i] = {(COEFF_WIDTH){1'b0}};
                end
            end
        endcase
    end

    always_comb begin
        case (STATUS)
            3'b001: begin
                block_overflow  = frac_dec_overflow  ;
                block_underflow = frac_dec_underflow ;
                block_valid_out = frac_dec_valid_out ;
            end
            3'b010: begin
                block_overflow  = iir_overflow_1MHz  ;
                block_underflow = iir_underflow_1MHz ;
                block_valid_out = iir_valid_out      ;
            end
            3'b011: begin
                block_overflow  = iir_overflow_2_4MHz  ;
                block_underflow = iir_underflow_2_4MHz ;
                block_valid_out = iir_valid_out        ;
            end
            3'b100: begin
                block_overflow  = cic_overflow  ;
                block_underflow = cic_underflow ;
                block_valid_out = valid_out     ;
            end
            default : begin
                block_overflow  = 1'b0;
                block_underflow = 1'b0;
                block_valid_out = 1'b0;
            end
        endcase
    end
endmodule
