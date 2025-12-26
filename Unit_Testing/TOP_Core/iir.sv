////////////////////////////////////////////////////////////////////////////////
// Design Author: Mustaf EL-Sherif
// Verified by Mustaf EL-Sherif
// --> Linting check
// --> Synthesis
// --> Functional Simulation
// Design: IIR
// Date: 02-11-2025
////////////////////////////////////////////////////////////////////////////////

module IIR #(
    parameter   int  DATA_WIDTH         = 32'd16                                ,
    parameter   int  DATA_FRAC          = 32'd15                                ,
    parameter   int  COEFF_WIDTH        = 32'd20                                ,
    parameter   int  COEFF_FRAC         = 32'd18                                ,
    parameter   int  IIR_NOTCH_FREQ     = 32'd2                                 , // 0: 1MHz, 1:2.4MHz
    // Coefficient depths
    localparam  int NUM_COEFF_DEPTH     = 32'd3                                 ,
    localparam  int DEN_COEFF_DEPTH     = 32'd2                                 ,
    localparam  int COEFF_DEPTH         = NUM_COEFF_DEPTH + DEN_COEFF_DEPTH     ,
    // Product and Accumulator widths
    localparam  int PROD_WIDTH          = DATA_WIDTH + COEFF_WIDTH              ,
    localparam  int PROD_FRAC           = DATA_FRAC + COEFF_FRAC                ,
    localparam  int ACC_WIDTH           = PROD_WIDTH + $clog2(NUM_COEFF_DEPTH)  ,
    localparam  int ACC_FRAC            = PROD_FRAC                             ,   
    localparam  int SCALE               = 32'd1
) (
    input   logic                               clk                                             ,
    input   logic                               rst_n                                           ,
    input   logic                               valid_in                                        ,
    input   logic                               bypass                                          , 

    input   logic         			            coeff_wr_en                                     ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  coeff_in            [COEFF_DEPTH - 1 : 0]       ,
    
    input   logic signed [DATA_WIDTH - 1 : 0]   iir_in                                          ,
        
    output  logic signed [DATA_WIDTH - 1 : 0]   iir_out                                         ,

    output  logic signed [COEFF_WIDTH - 1 : 0]  coeff_out           [COEFF_DEPTH - 1 : 0]       ,
        
    output  logic                               overflow                                        ,
    output  logic                               underflow                                       ,
    output  logic                               valid_out
);

    // Coefficients 1 MHz Notch Filter
    localparam logic signed [COEFF_WIDTH - 1 : 0] B0_1 = 20'sh37061     ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B1_1 = 20'shc8f9f     ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B2_1 = 20'sh37061     ;

    localparam logic signed [COEFF_WIDTH - 1 : 0] A1_1 = 20'shc8f9f     ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] A2_1 = 20'sh2e0c3     ;

    // Coefficients 2.4 MHz Notch Filter
    localparam logic signed [COEFF_WIDTH - 1 : 0] B0_2_4 = 20'sh37061   ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B1_2_4 = 20'sh5907c   ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B2_2_4 = 20'sh37061   ;

    localparam logic signed [COEFF_WIDTH - 1 : 0] A1_2_4 = 20'sh5907c   ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] A2_2_4 = 20'sh2e0c3   ;
    
    // Select coefficients based on IIR_NOTCH_FREQ parameter
    localparam logic signed [COEFF_WIDTH - 1 : 0] B0_INIT = (IIR_NOTCH_FREQ == 0) ? B0_1 : B0_2_4;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B1_INIT = (IIR_NOTCH_FREQ == 0) ? B1_1 : B1_2_4;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B2_INIT = (IIR_NOTCH_FREQ == 0) ? B2_1 : B2_2_4;
    localparam logic signed [COEFF_WIDTH - 1 : 0] A1_INIT = (IIR_NOTCH_FREQ == 0) ? A1_1 : A1_2_4;
    localparam logic signed [COEFF_WIDTH - 1 : 0] A2_INIT = (IIR_NOTCH_FREQ == 0) ? A2_1 : A2_2_4;
    
    logic signed [COEFF_WIDTH - 1 : 0]      num_coeff       [NUM_COEFF_DEPTH - 1 : 0]   ;
    logic signed [COEFF_WIDTH - 1 : 0]      den_coeff       [DEN_COEFF_DEPTH - 1 : 0]   ;

    logic signed [DATA_WIDTH - 1 : 0]       x_delay         [NUM_COEFF_DEPTH - 1 :0]    ;  // x[n-1], x[n-2]
    logic signed [DATA_WIDTH - 1 : 0]       y_delay         [DEN_COEFF_DEPTH - 1 :0]    ;  // y[n-1], y[n-2]

    logic signed [PROD_WIDTH - 1 : 0]       num_products    [NUM_COEFF_DEPTH - 1 : 0]   ;
    logic signed [PROD_WIDTH - 1 : 0]       den_products    [DEN_COEFF_DEPTH - 1 : 0]   ;

    logic signed [ACC_WIDTH - 1 : 0]        result_acc                                  ;

    logic signed [DATA_WIDTH - 1 : 0]       rounded_result                              ;
    logic                                   overflow_reg                                ;
    logic                                   underflow_reg                               ;
    logic                                   valid_out_reg                               ;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            num_coeff[0] <= B0_INIT;
            num_coeff[1] <= B1_INIT;
            num_coeff[2] <= B2_INIT;
            den_coeff[0] <= A1_INIT;
            den_coeff[1] <= A2_INIT;
        end else if (coeff_wr_en) begin
            for (int i = 0 ; i < COEFF_DEPTH ; i++) begin
                if (i < NUM_COEFF_DEPTH) begin
                    num_coeff[i] <= coeff_in[i];
                end else begin
                    den_coeff[i - NUM_COEFF_DEPTH] <= coeff_in[i];
                end
            end
        end
    end 

    always_comb begin
        for (int i = 0 ; i < COEFF_DEPTH ; i++) begin
            if (i < NUM_COEFF_DEPTH) begin
                coeff_out[i] = num_coeff[i];
            end else begin
                coeff_out[i] = den_coeff[i - NUM_COEFF_DEPTH];
            end
        end
    end

    // Main pipeline
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset delay lines
            for (int i = 0 ; i < NUM_COEFF_DEPTH ; i++) begin
                x_delay[i] <= {DATA_WIDTH{1'sb0}};

                if (i < DEN_COEFF_DEPTH) y_delay[i] <= {DATA_WIDTH{1'sb0}};
            end
        end else if (valid_in) begin
            x_delay[0] <= iir_in        ;
            x_delay[1] <= x_delay[0]    ;
            x_delay[2] <= x_delay[1]    ;
            
            y_delay[0] <= rounded_result;
            y_delay[1] <= y_delay[0]    ;
        end
    end

    always_comb begin
        result_acc      = {ACC_WIDTH{1'sb0}}    ;
        num_products[0] = {PROD_WIDTH{1'sb0}}   ;
        num_products[1] = {PROD_WIDTH{1'sb0}}   ;
        num_products[2] = {PROD_WIDTH{1'sb0}}   ;
        den_products[0] = {PROD_WIDTH{1'sb0}}   ;
        den_products[1] = {PROD_WIDTH{1'sb0}}   ;
        
        if (valid_in) begin
            num_products[0] = {{(PROD_WIDTH - DATA_WIDTH){iir_in[DATA_WIDTH - 1]}}, iir_in} * 

                              {{(PROD_WIDTH - COEFF_WIDTH){num_coeff[0][COEFF_WIDTH - 1]}}, num_coeff[0]};


            num_products[1] = {{(PROD_WIDTH - DATA_WIDTH){x_delay[0][DATA_WIDTH - 1]}}, x_delay[0]} * 

                              {{(PROD_WIDTH - COEFF_WIDTH){num_coeff[1][COEFF_WIDTH - 1]}}, num_coeff[1]};


            num_products[2] = {{(PROD_WIDTH - DATA_WIDTH){x_delay[1][DATA_WIDTH - 1]}}, x_delay[1]} * 

                              {{(PROD_WIDTH - COEFF_WIDTH){num_coeff[2][COEFF_WIDTH - 1]}}, num_coeff[2]};


            den_products[0] = {{(PROD_WIDTH - DATA_WIDTH){y_delay[0][DATA_WIDTH - 1]}}, y_delay[0]} * 

                              {{(PROD_WIDTH - COEFF_WIDTH){den_coeff[0][COEFF_WIDTH - 1]}}, den_coeff[0]};


            den_products[1] = {{(PROD_WIDTH - DATA_WIDTH){y_delay[1][DATA_WIDTH - 1]}}, y_delay[1]} * 

                              {{(PROD_WIDTH - COEFF_WIDTH){den_coeff[1][COEFF_WIDTH - 1]}}, den_coeff[1]};
            
            result_acc = (num_products[0] + num_products[1] + num_products[2]) - (den_products[0] + den_products[1]);
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out  <= 1'b0;
        end else if (bypass || valid_in) begin
            valid_out  <= valid_in;
        end else begin
            valid_out  <= 1'b0;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            iir_out     <= {DATA_WIDTH{1'sb0}}  ;
            overflow    <= 1'b0                 ;
            underflow   <= 1'b0                 ;
        end else if (bypass) begin
            iir_out     <= iir_in   ;
            overflow    <= 1'b0     ;
            underflow   <= 1'b0     ;
        end else if (valid_out_reg) begin
            iir_out     <= rounded_result   ;
            overflow    <= overflow_reg     ;
            underflow   <= underflow_reg    ;
        end
    end

    // Instantiate rounding module
    rounding_overflow_arith #(
        .ACC_WIDTH      (ACC_WIDTH)     ,
        .ACC_FRAC       (ACC_FRAC)      ,
        .OUT_WIDTH      (DATA_WIDTH)    ,
        .OUT_FRAC       (DATA_FRAC)     ,
        .SCALE          (SCALE)
    ) ROUNDING_INST (
        .data_in        (result_acc)        ,
        .valid_in       (valid_in)          ,
        .data_out       (rounded_result)    ,
        .overflow       (overflow_reg)      ,
        .underflow      (underflow_reg)     ,
        .valid_out      (valid_out_reg)
    );

    
endmodule