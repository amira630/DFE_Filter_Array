////////////////////////////////////////////////////////////////////////////////
// Design Author: Amira Atef
// Verified by Mustaf EL-Sherif
// --> Linting check
// --> Synthesis
// --> Functional Simulation
// Design: Cascaded Integrator-Comb (CIC) Filter Decimator
// Date: 02-11-2025
// Description: A CIC module using an integrator-comb structure to decimate
// a signal's Fs from 6 MHz to (6 / dec_factor) MHz. 
// This design is for a CIC where D is the Delay, 
// Q is the order, N is the differential delay (D / dec_factor).
// dec_factor can take inputs of {1, 2, 4, 8, 16}.
////////////////////////////////////////////////////////////////////////////////

module CIC #(
    parameter DATA_WIDTH = 16, 
    parameter DATA_FRAC  = 15,
    parameter Q = 1, 
    parameter N = 1,
    localparam MAX_DEC_FACTOR = 16,
    localparam ACC_FRAC = DATA_FRAC,
    localparam ACC_WIDTH = DATA_WIDTH + ($clog2(N * MAX_DEC_FACTOR) * Q),
    localparam DEC_WIDTH = $clog2(MAX_DEC_FACTOR),
    localparam SCALE = 1
) (
    input  logic                                                    clk         ,
    input  logic                                                    rst_n       ,
    input  logic                                                    valid_in    ,
    input  logic        [DEC_WIDTH : 0]                             dec_factor  ,  // Decimation factor
    input  logic signed [DATA_WIDTH-1:0]                            cic_in      ,
    output logic signed [DATA_WIDTH-1:0]                            cic_out     ,
    output logic                                                    valid_out   ,

    output logic                                                    overflow    ,
    output logic                                                    underflow   
);

    logic signed [ACC_WIDTH - 1 : 0]                intg_out        [Q - 1 : 0]     ;
    logic signed [ACC_WIDTH - 1 : 0]                comb_out        [Q - 1 : 0]     ;
    logic signed [ACC_WIDTH - 1 : 0]                decimator_out                   ;
    logic        [DEC_WIDTH : 0]                    counter                         ;
    logic                                           dec_in_enable                   ;

    logic signed [DATA_WIDTH - 1 : 0]               rounded_out                     ;
    logic                                           valid_out_reg                   ;

    logic                                           trig                            ;

    assign dec_in_enable = (counter == 0) ? 1'b1 : 1'b0; 
  
    INTEG #(
        .DATA_WIDTH (DATA_WIDTH)   , 
        .ACC_WIDTH  (ACC_WIDTH)
    ) INTEG_INST_0(
        .clk      (clk)         ,
        .rst_n    (rst_n)       ,   
        .valid_in (valid_in)    ,
        .intg_in  (cic_in)      ,
        .intg_out (intg_out[0])
    );


    genvar i;
    generate
        for (i = 1 ; i < Q ; i++) begin : gen_integ
            INTEG #(
                .DATA_WIDTH (ACC_WIDTH)   , 
                .ACC_WIDTH  (ACC_WIDTH)
            ) INTEG_INST (
                .clk      (clk)             ,
                .rst_n    (rst_n)           ,   
                .valid_in (valid_in)        ,
                .intg_in  (intg_out[i - 1]) ,
                .intg_out (intg_out[i])
            );
        end
    endgenerate

    
    always_ff @(posedge clk or negedge rst_n) begin : COUNTER
        if (!rst_n) begin
            counter         <= {DEC_WIDTH{1'b0}};
        end else if (valid_in) begin
            if (counter == (dec_factor - 1)) begin
                counter <= {DEC_WIDTH{1'b0}};
            end else begin
                counter <= counter + 1'b1;
            end
            
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            decimator_out   <= {ACC_WIDTH{1'b0}};
        end else begin
            if (dec_in_enable) begin
                decimator_out <= intg_out[Q - 1];
            end
        end
    end   

    COMB #(
        .ACC_WIDTH  (ACC_WIDTH)    , 
        .N          (N)              
    ) COMB_INST_0 (
        .clk      (clk)             ,
        .rst_n    (rst_n)           ,
        .valid_in (dec_in_enable)                ,
        .comb_in  (decimator_out)   ,   
        .comb_out (comb_out[0])
    );

    genvar j;
    generate
        for (j = 1 ; j < Q ; j++) begin : gen_comb
            COMB #(
                .ACC_WIDTH  (ACC_WIDTH)    , 
                .N          (N)              
            ) COMB_INST (
                .clk      (clk)             ,
                .rst_n    (rst_n)           ,
                .valid_in (dec_in_enable)    ,
                .comb_in  (comb_out[j - 1])   ,   
                .comb_out (comb_out[j])
            );
        end
    endgenerate

    rounding_overflow_arith #(
        .ACC_WIDTH (ACC_WIDTH) ,
        .ACC_FRAC  (ACC_FRAC),
        .OUT_WIDTH (DATA_WIDTH) ,
        .OUT_FRAC  (DATA_FRAC),
        .PROD_WIDTH(0),
        .PROD_FRAC (0),
        .SCALE(SCALE) 

    ) ARITH_HANDLER (
        .data_in   (comb_out[Q - 1])    ,
        .valid_in  (dec_in_enable)      ,   
        .data_out  (rounded_out)        ,
        .overflow  (overflow)           ,
        .underflow (underflow)          ,
        .valid_out (valid_out_reg)  
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            cic_out   <= {DATA_WIDTH{1'sb0}};
        end else if (valid_in) begin
            valid_out <= valid_out_reg;
            if (valid_out_reg) begin
                cic_out <= rounded_out;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule




