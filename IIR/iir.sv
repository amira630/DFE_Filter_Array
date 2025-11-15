module IIR #(
    parameter   DATA_WIDTH      = 16                                ,
    parameter   DATA_FRAC       = 15                                ,
    parameter   COEFF_WIDTH     = 20                                ,
    parameter   COEFF_FRAC      = 18                                ,
    parameter   IIR_NOTCH_FREQ  = 2                                 , // 0: 1MHz, 1: 2MHz, 2:2.4MHz
    localparam  PROD_WIDTH      = DATA_WIDTH + COEFF_WIDTH          ,
    localparam  PROD_FRAC       = DATA_FRAC + COEFF_FRAC            ,
    localparam  ACC_WIDTH       = PROD_WIDTH + $clog2(3)            ,
    localparam  ACC_FRAC        = PROD_FRAC                         ,
    localparam NUM_COEFF_DEPTH  = 3                                 ,
    localparam DEN_COEFF_DEPTH  = 2                                 ,
    localparam  SCALE           = 1                                 
) (
    input   logic                               clk                                             ,
    input   logic                               rst_n                                           ,
    input   logic                               valid_in                                        ,
    input   logic                               bypass                                          , 

    input   logic         			            num_coeff_wr_en                                 ,
    input   logic         			            den_coeff_wr_en                                 ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  num_coeff_in        [NUM_COEFF_DEPTH - 1 : 0]   ,
    input   logic signed [COEFF_WIDTH - 1 : 0]  den_coeff_in        [DEN_COEFF_DEPTH - 1 : 0]   ,

    input   logic signed [DATA_WIDTH - 1 : 0]   iir_in                                          ,
        
    output  logic signed [DATA_WIDTH - 1 : 0]   iir_out                                         ,
        
    output  logic                               overflow                                        ,
    output  logic                               underflow                                       ,
    output  logic                               valid_out
);

    // Coefficients 1 MHz Notch Filter
    localparam B0_1 = 20'sh37061;
    localparam B1_1 = 20'shc8f9f;
    localparam B2_1 = 20'sh37061;

    localparam A1_1 = 20'shc8f9f;
    localparam A2_1 = 20'sh2e0c3;

    // Coefficients 2 MHz Notch Filter
    localparam B0_2 = 20'sh37061;
    localparam B1_2 = 20'sh37061;
    localparam B2_2 = 20'sh37061;

    localparam A1_2 = 20'sh37061;
    localparam A2_2 = 20'sh2e0c3;

    // Coefficients 2.4 MHz Notch Filter
    localparam B0_2_4 = 20'sh37061;
    localparam B1_2_4 = 20'sh5907c;
    localparam B2_2_4 = 20'sh37061;

    localparam A1_2_4 = 20'sh5907c;
    localparam A2_2_4 = 20'sh2e0c3;
    
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
            case (IIR_NOTCH_FREQ)
                0: begin
                    // Initialize coefficients for 1 MHz Notch Filter
                    num_coeff[0] <= B0_1;
                    num_coeff[1] <= B1_1;
                    num_coeff[2] <= B2_1;

                    den_coeff[0] <= A1_1;
                    den_coeff[1] <= A2_1;
                end
                1: begin
                    // Initialize coefficients for 2 MHz Notch Filter
                    num_coeff[0] <= B0_2;
                    num_coeff[1] <= B1_2;
                    num_coeff[2] <= B2_2;

                    den_coeff[0] <= A1_2;
                    den_coeff[1] <= A2_2;
                end
                2: begin
                    // Initialize coefficients for 2.4 MHz Notch Filter
                    num_coeff[0] <= B0_2_4;
                    num_coeff[1] <= B1_2_4;
                    num_coeff[2] <= B2_2_4;

                    den_coeff[0] <= A1_2_4;
                    den_coeff[1] <= A2_2_4;
                end 
                default: begin
                    // Default to 2.4 MHz Notch Filter
                    num_coeff[0] <= B0_2_4;
                    num_coeff[1] <= B1_2_4;
                    num_coeff[2] <= B2_2_4;

                    den_coeff[0] <= A1_2_4;
                    den_coeff[1] <= A2_2_4;
                end
            endcase 
        end else if (num_coeff_wr_en) begin
            for (int i = 0 ; i < NUM_COEFF_DEPTH ; i++) begin
                num_coeff[i] <= num_coeff_in[i];
            end
        end else if (den_coeff_wr_en) begin
            for (int i = 0 ; i < DEN_COEFF_DEPTH ; i++) begin
                den_coeff[i] <= den_coeff_in[i];
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
            x_delay[0] <= iir_in;
            x_delay[1] <= x_delay[0];
            x_delay[2] <= x_delay[1];
            
            y_delay[0] <= rounded_result;
            y_delay[1] <= y_delay[0];
        end
    end

    always_comb begin
        result_acc      = {ACC_WIDTH{1'sb0}};
        num_products[0] = {PROD_WIDTH{1'sb0}};
        num_products[1] = {PROD_WIDTH{1'sb0}};
        num_products[2] = {PROD_WIDTH{1'sb0}};
        den_products[0] = {PROD_WIDTH{1'sb0}};
        den_products[1] = {PROD_WIDTH{1'sb0}};
        
        if (valid_in) begin
            num_products[0] = iir_in * num_coeff[0];
            num_products[1] = x_delay[0] * num_coeff[1];
            num_products[2] = x_delay[1] * num_coeff[2];

            den_products[0] = y_delay[0] * den_coeff[0];
            den_products[1] = y_delay[1] * den_coeff[1];
            
            result_acc = (num_products[0] + num_products[1] + num_products[2]) - (den_products[0] + den_products[1]);
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out  <= 1'b0;
            overflow   <= 1'b0;
            underflow  <= 1'b0;
        end else if (valid_in) begin
            valid_out <= valid_out_reg;
            overflow   <= overflow_reg;
            underflow  <= underflow_reg;
        end
    end

    always_comb begin 
        if (bypass) begin
            iir_out = iir_in;
        end else begin
            iir_out = y_delay[0];
        end
    end

    // Instantiate rounding module
    rounding_overflow_arith #(
        .ACC_WIDTH      (ACC_WIDTH)     ,
        .ACC_FRAC       (ACC_FRAC)      ,
        .OUT_WIDTH      (DATA_WIDTH)    ,
        .OUT_FRAC       (DATA_FRAC)     ,
        .PROD_WIDTH     (PROD_WIDTH)    ,
        .PROD_FRAC      (PROD_FRAC)     ,
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