`timescale 1ns/1fs
module DFE_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter CLOCK_PERIOD = 111.111111; //9MHz
    parameter DATA_WIDTH   = 16        ;
    parameter DATA_FRAC    = 15        ;
    parameter PDATA_WIDTH  = 32        ;
    parameter ADDR_WIDTH   = 7         ;
    parameter COEFF_WIDTH  = 20        ;
    parameter COEFF_FRAC   = 18        ;
    parameter N_TAP        = 72        ;
    parameter NUM_DENUM    = 5         ;
    parameter COMP         = 4         ;

    parameter N_SAMPLES_I     = 48000;

    int i, n;

    integer j = 0;
  
    real input_sig;
    real block_out_sig;
    real core_out_sig;
    real core_out_sig_exp;

    /////////////////////////////////////////////////////////
    /////////// Testbench Signal Declaration ////////////////
    /////////////////////////////////////////////////////////

    logic                                clk_tb                          ;
    logic                                rst_n_tb                        ;
    logic                                MTRANS_tb                       ; 
    logic                                MWRITE_tb                       ;
    logic        [COMP-1:0]              MSELx_tb                        ;
    logic        [ADDR_WIDTH-1:0]        MADDR_tb                        ;
    logic signed [COEFF_WIDTH-1:0]       MWDATA_tb                       ; 
    logic        [PDATA_WIDTH-1:0]       MRDATA_tb                       ;
    logic                                valid_in_tb                     ;   
    logic signed [DATA_WIDTH - 1 : 0]    core_in_tb                      ;   
    logic                                valid_out_tb                    ;   
    logic signed [DATA_WIDTH - 1 : 0]    core_out_tb                     ;   
    logic                                overflow_tb                     ;   
    logic                                underflow_tb                    ;   
    logic                                block_overflow_tb               ;   
    logic                                block_underflow_tb              ;   
    logic                                block_valid_out_tb              ;   
    logic signed [DATA_WIDTH - 1 : 0]    block_out_tb                    ;   
    logic signed [COEFF_WIDTH - 1 : 0]   coeff_out_tb [N_TAP - 1 : 0]    ;



    logic signed [DATA_WIDTH - 1 : 0] input_samples [N_SAMPLES_I - 1 : 0];

    logic signed [DATA_WIDTH - 1 : 0] output_0000_R_2_float_exp  [16000 - 1 : 0];       // ALL IS ON
    logic signed [DATA_WIDTH - 1 : 0] output_0001_R_2_float_exp  [32000 - 1 : 0];       //                                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0010_R_2_float_exp  [16000 - 1 : 0];       //                            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0011_R_2_float_exp  [32000 - 1 : 0];       //                            IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0100_R_2_float_exp  [16000 - 1 : 0];       //                IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0101_R_2_float_exp  [32000 - 1 : 0];       //                IIR 2.4 OFF           CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0110_R_2_float_exp  [16000 - 1 : 0];       //                IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0111_R_2_float_exp  [32000 - 1 : 0];       // FRAC. DECI. ON IIR 2.4 OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1000_R_2_float_exp  [24000 - 1 : 0];       // FRAC. DECI. OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1001_R_2_float_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1010_R_2_float_exp  [24000 - 1 : 0];       // FRAC. DECI. OFF            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1011_R_2_float_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1100_R_2_float_exp  [24000 - 1 : 0];       // FRAC. DECI. OFF IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1101_R_2_float_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 2.4 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1110_R_2_float_exp  [24000 - 1 : 0];       // FRAC. DECI. OFF IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1111_R_2_float_exp  [N_SAMPLES_I - 1 : 0]; // ALL IS OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0000_R_4_float_exp  [8000 - 1 : 0];        // ALL IS ON
    logic signed [DATA_WIDTH - 1 : 0] output_0001_R_4_float_exp  [32000 - 1 : 0];       //                                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0010_R_4_float_exp  [8000 - 1 : 0];        //                            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0011_R_4_float_exp  [32000 - 1 : 0];       //                            IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0100_R_4_float_exp  [8000 - 1 : 0];        //                IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0101_R_4_float_exp  [32000 - 1 : 0];       //                IIR 2.4 OFF           CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0110_R_4_float_exp  [8000 - 1 : 0];        //                IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0111_R_4_float_exp  [32000 - 1 : 0];       // FRAC. DECI. ON IIR 2.4 OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1000_R_4_float_exp  [12000 - 1 : 0];       // FRAC. DECI. OFF 
    logic signed [DATA_WIDTH - 1 : 0] output_1001_R_4_float_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1010_R_4_float_exp  [12000 - 1 : 0];       // FRAC. DECI. OFF            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1011_R_4_float_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1100_R_4_float_exp  [12000 - 1 : 0];       // FRAC. DECI. OFF IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1101_R_4_float_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 2.4 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1110_R_4_float_exp  [12000 - 1 : 0];       // FRAC. DECI. OFF IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1111_R_4_float_exp  [N_SAMPLES_I - 1 : 0]; // ALL IS OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0000_R_8_float_exp  [4000 - 1 : 0];        // ALL IS ON
    logic signed [DATA_WIDTH - 1 : 0] output_0001_R_8_float_exp  [32000 - 1 : 0];       //                                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0010_R_8_float_exp  [4000 - 1 : 0];        //                            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0011_R_8_float_exp  [32000 - 1 : 0];       //                            IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0100_R_8_float_exp  [4000 - 1 : 0];        //                IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0101_R_8_float_exp  [32000 - 1 : 0];       //                IIR 2.4 OFF           CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0110_R_8_float_exp  [4000 - 1 : 0];        //                IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0111_R_8_float_exp  [32000 - 1 : 0];       // FRAC. DECI. ON IIR 2.4 OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1000_R_8_float_exp  [6000 - 1 : 0];        // FRAC. DECI. OFF 
    logic signed [DATA_WIDTH - 1 : 0] output_1001_R_8_float_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1010_R_8_float_exp  [6000 - 1 : 0];        // FRAC. DECI. OFF            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1011_R_8_float_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1100_R_8_float_exp  [6000 - 1 : 0];        // FRAC. DECI. OFF IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1101_R_8_float_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 2.4 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1110_R_8_float_exp  [6000 - 1 : 0];        // FRAC. DECI. OFF IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1111_R_8_float_exp  [N_SAMPLES_I - 1 : 0]; // ALL IS OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0000_R_16_float_exp [2000 - 1 : 0];        // ALL IS ON
    logic signed [DATA_WIDTH - 1 : 0] output_0001_R_16_float_exp [32000 - 1 : 0];       //                                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0010_R_16_float_exp [2000 - 1 : 0];        //                            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0011_R_16_float_exp [32000 - 1 : 0];       //                            IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0100_R_16_float_exp [2000 - 1 : 0];        //                IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0101_R_16_float_exp [32000 - 1 : 0];       //                IIR 2.4 OFF           CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0110_R_16_float_exp [2000 - 1 : 0];        //                IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0111_R_16_float_exp [32000 - 1 : 0];       // FRAC. DECI. ON IIR 2.4 OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1000_R_16_float_exp [3000 - 1 : 0];        // FRAC. DECI. OFF 
    logic signed [DATA_WIDTH - 1 : 0] output_1001_R_16_float_exp [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1010_R_16_float_exp [3000 - 1 : 0];        // FRAC. DECI. OFF            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1011_R_16_float_exp [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1100_R_16_float_exp [3000 - 1 : 0];        // FRAC. DECI. OFF IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1101_R_16_float_exp [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 2.4 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1110_R_16_float_exp [3000 - 1 : 0];        // FRAC. DECI. OFF IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1111_R_16_float_exp [N_SAMPLES_I - 1 : 0]; // ALL IS OFF
       


    logic signed [DATA_WIDTH - 1 : 0] output_0000_R_2_fixed_exp  [16000 - 1 : 0];       // ALL IS ON
    logic signed [DATA_WIDTH - 1 : 0] output_0001_R_2_fixed_exp  [32000 - 1 : 0];       //                                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0010_R_2_fixed_exp  [16000 - 1 : 0];       //                            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0011_R_2_fixed_exp  [32000 - 1 : 0];       //                            IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0100_R_2_fixed_exp  [16000 - 1 : 0];       //                IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0101_R_2_fixed_exp  [32000 - 1 : 0];       //                IIR 2.4 OFF           CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0110_R_2_fixed_exp  [16000 - 1 : 0];       //                IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0111_R_2_fixed_exp  [32000 - 1 : 0];       // FRAC. DECI. ON IIR 2.4 OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1000_R_2_fixed_exp  [24000 - 1 : 0];       // FRAC. DECI. OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1001_R_2_fixed_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1010_R_2_fixed_exp  [24000 - 1 : 0];       // FRAC. DECI. OFF            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1011_R_2_fixed_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1100_R_2_fixed_exp  [24000 - 1 : 0];       // FRAC. DECI. OFF IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1101_R_2_fixed_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 2.4 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1110_R_2_fixed_exp  [24000 - 1 : 0];       // FRAC. DECI. OFF IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1111_R_2_fixed_exp  [N_SAMPLES_I - 1 : 0]; // ALL IS OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0000_R_4_fixed_exp  [8000 - 1 : 0];        // ALL IS ON
    logic signed [DATA_WIDTH - 1 : 0] output_0001_R_4_fixed_exp  [32000 - 1 : 0];       //                                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0010_R_4_fixed_exp  [8000 - 1 : 0];        //                            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0011_R_4_fixed_exp  [32000 - 1 : 0];       //                            IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0100_R_4_fixed_exp  [8000 - 1 : 0];        //                IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0101_R_4_fixed_exp  [32000 - 1 : 0];       //                IIR 2.4 OFF           CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0110_R_4_fixed_exp  [8000 - 1 : 0];        //                IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0111_R_4_fixed_exp  [32000 - 1 : 0];       // FRAC. DECI. ON IIR 2.4 OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1000_R_4_fixed_exp  [12000 - 1 : 0];       // FRAC. DECI. OFF 
    logic signed [DATA_WIDTH - 1 : 0] output_1001_R_4_fixed_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1010_R_4_fixed_exp  [12000 - 1 : 0];       // FRAC. DECI. OFF            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1011_R_4_fixed_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1100_R_4_fixed_exp  [12000 - 1 : 0];       // FRAC. DECI. OFF IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1101_R_4_fixed_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 2.4 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1110_R_4_fixed_exp  [12000 - 1 : 0];       // FRAC. DECI. OFF IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1111_R_4_fixed_exp  [N_SAMPLES_I - 1 : 0]; // ALL IS OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0000_R_8_fixed_exp  [4000 - 1 : 0];        // ALL IS ON
    logic signed [DATA_WIDTH - 1 : 0] output_0001_R_8_fixed_exp  [32000 - 1 : 0];       //                                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0010_R_8_fixed_exp  [4000 - 1 : 0];        //                            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0011_R_8_fixed_exp  [32000 - 1 : 0];       //                            IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0100_R_8_fixed_exp  [4000 - 1 : 0];        //                IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0101_R_8_fixed_exp  [32000 - 1 : 0];       //                IIR 2.4 OFF           CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0110_R_8_fixed_exp  [4000 - 1 : 0];        //                IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0111_R_8_fixed_exp  [32000 - 1 : 0];       // FRAC. DECI. ON IIR 2.4 OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1000_R_8_fixed_exp  [6000 - 1 : 0];        // FRAC. DECI. OFF 
    logic signed [DATA_WIDTH - 1 : 0] output_1001_R_8_fixed_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1010_R_8_fixed_exp  [6000 - 1 : 0];        // FRAC. DECI. OFF            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1011_R_8_fixed_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1100_R_8_fixed_exp  [6000 - 1 : 0];        // FRAC. DECI. OFF IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1101_R_8_fixed_exp  [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 2.4 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1110_R_8_fixed_exp  [6000 - 1 : 0];        // FRAC. DECI. OFF IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1111_R_8_fixed_exp  [N_SAMPLES_I - 1 : 0]; // ALL IS OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0000_R_16_fixed_exp [2000 - 1 : 0];        // ALL IS ON
    logic signed [DATA_WIDTH - 1 : 0] output_0001_R_16_fixed_exp [32000 - 1 : 0];       //                                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0010_R_16_fixed_exp [2000 - 1 : 0];        //                            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0011_R_16_fixed_exp [32000 - 1 : 0];       //                            IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0100_R_16_fixed_exp [2000 - 1 : 0];        //                IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0101_R_16_fixed_exp [32000 - 1 : 0];       //                IIR 2.4 OFF           CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0110_R_16_fixed_exp [2000 - 1 : 0];        //                IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_0111_R_16_fixed_exp [32000 - 1 : 0];       // FRAC. DECI. ON IIR 2.4 OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1000_R_16_fixed_exp [3000 - 1 : 0];        // FRAC. DECI. OFF 
    logic signed [DATA_WIDTH - 1 : 0] output_1001_R_16_fixed_exp [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF                      CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1010_R_16_fixed_exp [3000 - 1 : 0];        // FRAC. DECI. OFF            IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1011_R_16_fixed_exp [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 5 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1100_R_16_fixed_exp [3000 - 1 : 0];        // FRAC. DECI. OFF IIR 2.4 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1101_R_16_fixed_exp [N_SAMPLES_I - 1 : 0]; // FRAC. DECI. OFF IIR 2.4 OFF CIC OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1110_R_16_fixed_exp [3000 - 1 : 0];        // FRAC. DECI. OFF IIR 2.4 OFF IIR 5 OFF
    logic signed [DATA_WIDTH - 1 : 0] output_1111_R_16_fixed_exp [N_SAMPLES_I - 1 : 0]; // ALL IS OFF


    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    DFE_TOP #(
        //********************** General Parameters ********************//
        .DATA_WIDTH (DATA_WIDTH)                          ,
        .DATA_FRAC  (DATA_FRAC)                           ,
        .COEFF_WIDTH(COEFF_WIDTH)                         ,
        .COEFF_FRAC (COEFF_FRAC)                          ,
        //******************** Fractional Decimator Parameters **********//
        .N_TAP      (N_TAP)                               ,

        //********************** APB Parameters ********************//
        .ADDR_WIDTH  (ADDR_WIDTH)                         ,
        .PDATA_WIDTH (PDATA_WIDTH)                        ,
        .COMP        (COMP)
    )DUT(
        .clk               (clk_tb)                       ,
        .rst_n             (rst_n_tb)                     ,

        .MTRANS            (MTRANS_tb)                    , 
        .MWRITE            (MWRITE_tb)                    ,
        .MSELx             (MSELx_tb)                     ,
        .MADDR             (MADDR_tb)                     ,
        .MWDATA            (MWDATA_tb)                    , 
        .MRDATA            (MRDATA_tb)                    ,

        .valid_in          (valid_in_tb)                  ,
        .core_in           (core_in_tb)                   ,
        
        .valid_out         (valid_out_tb)                 ,
        .core_out          (core_out_tb)                  ,
        .overflow          (overflow_tb)                  ,
        .underflow         (underflow_tb)                 ,

        .block_overflow    (block_overflow_tb)            ,
        .block_underflow   (block_underflow_tb)           ,
        .block_valid_out   (block_valid_out_tb)           ,
        .block_out         (block_out_tb)                 ,

        .coeff_out(coeff_out_tb)             
    );

    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    always #(CLOCK_PERIOD/2) clk_tb = ~clk_tb;

    ////////////////////////////////////////////////////////
    /////////// Applying Stimulus on Inputs //////////////// 
    ////////////////////////////////////////////////////////

    initial begin
        // System Functions
        $dumpfile("DFE.vcd");
        $dumpvars;

        // initialization
        initialize();

        #15;
        


        #(5*CLOCK_PERIOD)
        $stop;
    end

    ////////////////////////////////////////////////////////
    /////////////////////// TASKS //////////////////////////
    ////////////////////////////////////////////////////////

    /////////////// Signals Initialization //////////////////

    task initialize;
        begin
            $readmemb("input_wave.txt", input_samples);

            $readmemb("output_0000_R_2_float_exp.txt"  ,   output_0000_R_2_float_exp     );
            $readmemb("output_0001_R_2_float_exp.txt"  ,   output_0001_R_2_float_exp     );
            $readmemb("output_0010_R_2_float_exp.txt"  ,   output_0010_R_2_float_exp     );
            $readmemb("output_0011_R_2_float_exp.txt"  ,   output_0011_R_2_float_exp     );
            $readmemb("output_0100_R_2_float_exp.txt"  ,   output_0100_R_2_float_exp     );
            $readmemb("output_0101_R_2_float_exp.txt"  ,   output_0101_R_2_float_exp     );
            $readmemb("output_0110_R_2_float_exp.txt"  ,   output_0110_R_2_float_exp     );
            $readmemb("output_0111_R_2_float_exp.txt"  ,   output_0111_R_2_float_exp     );
            $readmemb("output_1000_R_2_float_exp.txt"  ,   output_1000_R_2_float_exp     );
            $readmemb("output_1001_R_2_float_exp.txt"  ,   output_1001_R_2_float_exp     );
            $readmemb("output_1010_R_2_float_exp.txt"  ,   output_1010_R_2_float_exp     );
            $readmemb("output_1011_R_2_float_exp.txt"  ,   output_1011_R_2_float_exp     );
            $readmemb("output_1100_R_2_float_exp.txt"  ,   output_1100_R_2_float_exp     );
            $readmemb("output_1101_R_2_float_exp.txt"  ,   output_1101_R_2_float_exp     );
            $readmemb("output_1110_R_2_float_exp.txt"  ,   output_1110_R_2_float_exp     );
            $readmemb("output_1111_R_2_float_exp.txt"  ,   output_1111_R_2_float_exp     );
            $readmemb("output_0000_R_4_float_exp.txt"  ,   output_0000_R_4_float_exp     );
            $readmemb("output_0001_R_4_float_exp.txt"  ,   output_0001_R_4_float_exp     );
            $readmemb("output_0010_R_4_float_exp.txt"  ,   output_0010_R_4_float_exp     );
            $readmemb("output_0011_R_4_float_exp.txt"  ,   output_0011_R_4_float_exp     );
            $readmemb("output_0100_R_4_float_exp.txt"  ,   output_0100_R_4_float_exp     );
            $readmemb("output_0101_R_4_float_exp.txt"  ,   output_0101_R_4_float_exp     );
            $readmemb("output_0110_R_4_float_exp.txt"  ,   output_0110_R_4_float_exp     );
            $readmemb("output_0111_R_4_float_exp.txt"  ,   output_0111_R_4_float_exp     );
            $readmemb("output_1000_R_4_float_exp.txt"  ,   output_1000_R_4_float_exp     );
            $readmemb("output_1001_R_4_float_exp.txt"  ,   output_1001_R_4_float_exp     );
            $readmemb("output_1010_R_4_float_exp.txt"  ,   output_1010_R_4_float_exp     );
            $readmemb("output_1011_R_4_float_exp.txt"  ,   output_1011_R_4_float_exp     );
            $readmemb("output_1100_R_4_float_exp.txt"  ,   output_1100_R_4_float_exp     );
            $readmemb("output_1101_R_4_float_exp.txt"  ,   output_1101_R_4_float_exp     );
            $readmemb("output_1110_R_4_float_exp.txt"  ,   output_1110_R_4_float_exp     );
            $readmemb("output_1111_R_4_float_exp.txt"  ,   output_1111_R_4_float_exp     );
            $readmemb("output_0000_R_8_float_exp.txt"  ,   output_0000_R_8_float_exp     );
            $readmemb("output_0001_R_8_float_exp.txt"  ,   output_0001_R_8_float_exp     );
            $readmemb("output_0010_R_8_float_exp.txt"  ,   output_0010_R_8_float_exp     );
            $readmemb("output_0011_R_8_float_exp.txt"  ,   output_0011_R_8_float_exp     );
            $readmemb("output_0100_R_8_float_exp.txt"  ,   output_0100_R_8_float_exp     );
            $readmemb("output_0101_R_8_float_exp.txt"  ,   output_0101_R_8_float_exp     );
            $readmemb("output_0110_R_8_float_exp.txt"  ,   output_0110_R_8_float_exp     );
            $readmemb("output_0111_R_8_float_exp.txt"  ,   output_0111_R_8_float_exp     );
            $readmemb("output_1000_R_8_float_exp.txt"  ,   output_1000_R_8_float_exp     );
            $readmemb("output_1001_R_8_float_exp.txt"  ,   output_1001_R_8_float_exp     );
            $readmemb("output_1010_R_8_float_exp.txt"  ,   output_1010_R_8_float_exp     );
            $readmemb("output_1011_R_8_float_exp.txt"  ,   output_1011_R_8_float_exp     );
            $readmemb("output_1100_R_8_float_exp.txt"  ,   output_1100_R_8_float_exp     );
            $readmemb("output_1101_R_8_float_exp.txt"  ,   output_1101_R_8_float_exp     );
            $readmemb("output_1110_R_8_float_exp.txt"  ,   output_1110_R_8_float_exp     );
            $readmemb("output_1111_R_8_float_exp.txt"  ,   output_1111_R_8_float_exp     );
            $readmemb("output_0000_R_16_float_exp.txt" ,   output_0000_R_16_float_exp    );
            $readmemb("output_0001_R_16_float_exp.txt" ,   output_0001_R_16_float_exp    );
            $readmemb("output_0010_R_16_float_exp.txt" ,   output_0010_R_16_float_exp    );
            $readmemb("output_0011_R_16_float_exp.txt" ,   output_0011_R_16_float_exp    );
            $readmemb("output_0100_R_16_float_exp.txt" ,   output_0100_R_16_float_exp    );
            $readmemb("output_0101_R_16_float_exp.txt" ,   output_0101_R_16_float_exp    );
            $readmemb("output_0110_R_16_float_exp.txt" ,   output_0110_R_16_float_exp    );
            $readmemb("output_0111_R_16_float_exp.txt" ,   output_0111_R_16_float_exp    );
            $readmemb("output_1000_R_16_float_exp.txt" ,   output_1000_R_16_float_exp    );
            $readmemb("output_1001_R_16_float_exp.txt" ,   output_1001_R_16_float_exp    );
            $readmemb("output_1010_R_16_float_exp.txt" ,   output_1010_R_16_float_exp    );
            $readmemb("output_1011_R_16_float_exp.txt" ,   output_1011_R_16_float_exp    );
            $readmemb("output_1100_R_16_float_exp.txt" ,   output_1100_R_16_float_exp    );
            $readmemb("output_1101_R_16_float_exp.txt" ,   output_1101_R_16_float_exp    );
            $readmemb("output_1110_R_16_float_exp.txt" ,   output_1110_R_16_float_exp    );
            $readmemb("output_1111_R_16_float_exp.txt" ,   output_1111_R_16_float_exp    );


            $readmemb("output_0000_R_2_fixed_exp.txt"  ,   output_0000_R_2_fixed_exp     );
            $readmemb("output_0001_R_2_fixed_exp.txt"  ,   output_0001_R_2_fixed_exp     );
            $readmemb("output_0010_R_2_fixed_exp.txt"  ,   output_0010_R_2_fixed_exp     );
            $readmemb("output_0011_R_2_fixed_exp.txt"  ,   output_0011_R_2_fixed_exp     );
            $readmemb("output_0100_R_2_fixed_exp.txt"  ,   output_0100_R_2_fixed_exp     );
            $readmemb("output_0101_R_2_fixed_exp.txt"  ,   output_0101_R_2_fixed_exp     );
            $readmemb("output_0110_R_2_fixed_exp.txt"  ,   output_0110_R_2_fixed_exp     );
            $readmemb("output_0111_R_2_fixed_exp.txt"  ,   output_0111_R_2_fixed_exp     );
            $readmemb("output_1000_R_2_fixed_exp.txt"  ,   output_1000_R_2_fixed_exp     );
            $readmemb("output_1001_R_2_fixed_exp.txt"  ,   output_1001_R_2_fixed_exp     );
            $readmemb("output_1010_R_2_fixed_exp.txt"  ,   output_1010_R_2_fixed_exp     );
            $readmemb("output_1011_R_2_fixed_exp.txt"  ,   output_1011_R_2_fixed_exp     );
            $readmemb("output_1100_R_2_fixed_exp.txt"  ,   output_1100_R_2_fixed_exp     );
            $readmemb("output_1101_R_2_fixed_exp.txt"  ,   output_1101_R_2_fixed_exp     );
            $readmemb("output_1110_R_2_fixed_exp.txt"  ,   output_1110_R_2_fixed_exp     );
            $readmemb("output_1111_R_2_fixed_exp.txt"  ,   output_1111_R_2_fixed_exp     );
            $readmemb("output_0000_R_4_fixed_exp.txt"  ,   output_0000_R_4_fixed_exp     );
            $readmemb("output_0001_R_4_fixed_exp.txt"  ,   output_0001_R_4_fixed_exp     );
            $readmemb("output_0010_R_4_fixed_exp.txt"  ,   output_0010_R_4_fixed_exp     );
            $readmemb("output_0011_R_4_fixed_exp.txt"  ,   output_0011_R_4_fixed_exp     );
            $readmemb("output_0100_R_4_fixed_exp.txt"  ,   output_0100_R_4_fixed_exp     );
            $readmemb("output_0101_R_4_fixed_exp.txt"  ,   output_0101_R_4_fixed_exp     );
            $readmemb("output_0110_R_4_fixed_exp.txt"  ,   output_0110_R_4_fixed_exp     );
            $readmemb("output_0111_R_4_fixed_exp.txt"  ,   output_0111_R_4_fixed_exp     );
            $readmemb("output_1000_R_4_fixed_exp.txt"  ,   output_1000_R_4_fixed_exp     );
            $readmemb("output_1001_R_4_fixed_exp.txt"  ,   output_1001_R_4_fixed_exp     );
            $readmemb("output_1010_R_4_fixed_exp.txt"  ,   output_1010_R_4_fixed_exp     );
            $readmemb("output_1011_R_4_fixed_exp.txt"  ,   output_1011_R_4_fixed_exp     );
            $readmemb("output_1100_R_4_fixed_exp.txt"  ,   output_1100_R_4_fixed_exp     );
            $readmemb("output_1101_R_4_fixed_exp.txt"  ,   output_1101_R_4_fixed_exp     );
            $readmemb("output_1110_R_4_fixed_exp.txt"  ,   output_1110_R_4_fixed_exp     );
            $readmemb("output_1111_R_4_fixed_exp.txt"  ,   output_1111_R_4_fixed_exp     );
            $readmemb("output_0000_R_8_fixed_exp.txt"  ,   output_0000_R_8_fixed_exp     );
            $readmemb("output_0001_R_8_fixed_exp.txt"  ,   output_0001_R_8_fixed_exp     );
            $readmemb("output_0010_R_8_fixed_exp.txt"  ,   output_0010_R_8_fixed_exp     );
            $readmemb("output_0011_R_8_fixed_exp.txt"  ,   output_0011_R_8_fixed_exp     );
            $readmemb("output_0100_R_8_fixed_exp.txt"  ,   output_0100_R_8_fixed_exp     );
            $readmemb("output_0101_R_8_fixed_exp.txt"  ,   output_0101_R_8_fixed_exp     );
            $readmemb("output_0110_R_8_fixed_exp.txt"  ,   output_0110_R_8_fixed_exp     );
            $readmemb("output_0111_R_8_fixed_exp.txt"  ,   output_0111_R_8_fixed_exp     );
            $readmemb("output_1000_R_8_fixed_exp.txt"  ,   output_1000_R_8_fixed_exp     );
            $readmemb("output_1001_R_8_fixed_exp.txt"  ,   output_1001_R_8_fixed_exp     );
            $readmemb("output_1010_R_8_fixed_exp.txt"  ,   output_1010_R_8_fixed_exp     );
            $readmemb("output_1011_R_8_fixed_exp.txt"  ,   output_1011_R_8_fixed_exp     );
            $readmemb("output_1100_R_8_fixed_exp.txt"  ,   output_1100_R_8_fixed_exp     );
            $readmemb("output_1101_R_8_fixed_exp.txt"  ,   output_1101_R_8_fixed_exp     );
            $readmemb("output_1110_R_8_fixed_exp.txt"  ,   output_1110_R_8_fixed_exp     );
            $readmemb("output_1111_R_8_fixed_exp.txt"  ,   output_1111_R_8_fixed_exp     );
            $readmemb("output_0000_R_16_fixed_exp.txt" ,   output_0000_R_16_fixed_exp    );
            $readmemb("output_0001_R_16_fixed_exp.txt" ,   output_0001_R_16_fixed_exp    );
            $readmemb("output_0010_R_16_fixed_exp.txt" ,   output_0010_R_16_fixed_exp    );
            $readmemb("output_0011_R_16_fixed_exp.txt" ,   output_0011_R_16_fixed_exp    );
            $readmemb("output_0100_R_16_fixed_exp.txt" ,   output_0100_R_16_fixed_exp    );
            $readmemb("output_0101_R_16_fixed_exp.txt" ,   output_0101_R_16_fixed_exp    );
            $readmemb("output_0110_R_16_fixed_exp.txt" ,   output_0110_R_16_fixed_exp    );
            $readmemb("output_0111_R_16_fixed_exp.txt" ,   output_0111_R_16_fixed_exp    );
            $readmemb("output_1000_R_16_fixed_exp.txt" ,   output_1000_R_16_fixed_exp    );
            $readmemb("output_1001_R_16_fixed_exp.txt" ,   output_1001_R_16_fixed_exp    );
            $readmemb("output_1010_R_16_fixed_exp.txt" ,   output_1010_R_16_fixed_exp    );
            $readmemb("output_1011_R_16_fixed_exp.txt" ,   output_1011_R_16_fixed_exp    );
            $readmemb("output_1100_R_16_fixed_exp.txt" ,   output_1100_R_16_fixed_exp    );
            $readmemb("output_1101_R_16_fixed_exp.txt" ,   output_1101_R_16_fixed_exp    );
            $readmemb("output_1110_R_16_fixed_exp.txt" ,   output_1110_R_16_fixed_exp    );
            $readmemb("output_1111_R_16_fixed_exp.txt" ,   output_1111_R_16_fixed_exp    );
            clk_tb    = 1'b0;
            MTRANS_tb = 1'b0;
            MWRITE_tb = 1'b0;
            MSELx_tb  = 'b10;
            MADDR_tb  = $random();
            MWDATA_tb = $random();
            valid_in_tb = 1'b1;
            core_in_tb = $random();
            reset();
        end	
    endtask

    ///////////////////////// RESET /////////////////////////

    task reset;
        begin
            rst_n_tb = 1'b1;
            #(CLOCK_PERIOD)
            rst_n_tb = 1'b0;
            valid_in_tb = 1'b0;
            #(CLOCK_PERIOD)
            rst_n_tb = 1'b1;
        end
    endtask

    /////////////////////// Operations ////////////////////////

    task RW ;
        input logic                          WR;
        input logic                          last;
        input logic        [ADDR_WIDTH-1:0]  ADDR;
        input logic        [COMP-1:0]        SELx;
        input logic signed [COEFF_WIDTH-1:0] WDATA;
        begin
            n = 0;
            MWRITE_tb = WR;
            MADDR_tb  = ADDR;
            MTRANS_tb = 1'b1;
            MSELx_tb  = SELx;
            $display("MTRANS_tb is asserted at %0t", $realtime);
            if (WR) begin
                MWDATA_tb = WDATA;
            end
            #(2*CLOCK_PERIOD)
            MTRANS_tb = 1'b0;
            $display("MTRANS_tb is de-asserted at %0t", $realtime);
            if (last)
                @(negedge clk_tb);
            // MSELx_tb  = 'b0;
        end
    endtask

    task BYPASS ;
    input logic [1:0] sel; 
    input logic off;
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM +1 +sel,'b1000, off); // Write CTRLs
        end
    endtask

    task SET_OUTPUT ;
    input logic [1:0] sel; 
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM + 6,'b1000, sel); // Write OUT_SEL
        end
    endtask

    task SET_COEFF ;
    input logic [2:0] sel;
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM + 7,'b1000, sel); // Write COEFF_SEL
        end
    endtask
    
    task READ_STATUS ;
    input logic [2:0] sel;
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM + 8,'b1000, sel); // Write STATUS
        end
    endtask

    task CHANGE_DECIMATION ;
    input logic [4:0] rate;
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM,'b100, rate); // Write CIC_R
        end
    endtask

    task CHANGE_FAC_DECI_COEFF ;
    input logic signed [COEFF_WIDTH-1:0] coeff [N_TAP - 1 : 0];
        begin
            // WR, last, ADDR, SELx, WDATA
            for (i = 0; i < N_TAP; i = i + 1) begin
                RW(1, 0, i,'b1, coeff[i]); // Write Frac_Deci Coeff
            end
        end
    endtask

    task CHANGE_IIR24_COEFF ;
    input logic signed [COEFF_WIDTH-1:0] coeff [NUM_DENUM - 1 : 0];
        begin
            // WR, last, ADDR, SELx, WDATA
            for (i = N_TAP; i < N_TAP + NUM_DENUM; i = i + 1) begin
                RW(1, 0, i,'b10, coeff[i - N_TAP]); // Write IIR 2.4 Coeff
            end
        end         
    endtask

    task CHANGE_IIR51_COEFF ;
    input logic signed [COEFF_WIDTH-1:0] coeff [NUM_DENUM -1 : 0];
        begin
            // WR, last, ADDR, SELx, WDATA
            for (i = N_TAP + NUM_DENUM; i < N_TAP + 2*NUM_DENUM; i = i + 1) begin
                RW(1, 0, i,'b10, coeff[i - N_TAP - NUM_DENUM]); // Write IIR 5_1 Coeff
            end
        end
    endtask

    task CHANGE_IIR52_COEFF ;
    input logic signed [COEFF_WIDTH-1:0] coeff [NUM_DENUM -1 : 0];
        begin
            // WR, last, ADDR, SELx, WDATA
            for (i = N_TAP + 2*NUM_DENUM; i < N_TAP + 3*NUM_DENUM; i = i + 1) begin
                RW(1, 0, i,'b10, coeff[i - N_TAP - 2*NUM_DENUM]); // Write IIR 5_2 Coeff
            end
        end
    endtask
    //////////////////  Response  ////////////////////

    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            j <= 0;
            core_out_sig_exp <= 0;
        end
    end

    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (valid_out) begin
            core_out_sig_exp <= $itor($signed(output_0000_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0001_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0010_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0011_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0100_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0101_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0110_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0111_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1000_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1001_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1010_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1011_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1100_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1101_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1110_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1111_R_2_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0000_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0001_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0010_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0011_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0100_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0101_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0110_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0111_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1000_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1001_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1010_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1011_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1100_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1101_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1110_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1111_R_4_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0000_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0001_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0010_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0011_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0100_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0101_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0110_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0111_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1000_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1001_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1010_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1011_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1100_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1101_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1110_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1111_R_8_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0000_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0001_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0010_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0011_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0100_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0101_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0110_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0111_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1000_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1001_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1010_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1011_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1100_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1101_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1110_R_16_float_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1111_R_16_float_exp[j])) / 32768.0;



            core_out_sig_exp <= $itor($signed(output_0000_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0001_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0010_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0011_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0100_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0101_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0110_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0111_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1000_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1001_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1010_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1011_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1100_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1101_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1110_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1111_R_2_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0000_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0001_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0010_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0011_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0100_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0101_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0110_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0111_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1000_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1001_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1010_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1011_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1100_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1101_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1110_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1111_R_4_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0000_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0001_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0010_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0011_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0100_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0101_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0110_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0111_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1000_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1001_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1010_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1011_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1100_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1101_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1110_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1111_R_8_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0000_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0001_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0010_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0011_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0100_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0101_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0110_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_0111_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1000_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1001_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1010_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1011_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1100_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1101_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1110_R_16_fixed_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(output_1111_R_16_fixed_exp[j])) / 32768.0;

            j = j + 1;
        end
    end

        // Output monitoring - sequential logic  
    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            block_out_sig <= 'b0;
            core_out_sig  <= 'b0;
        end else if (valid_in_tb) begin
            block_out_sig <=  $itor($signed(block_out_tb)) / 32768.0;
            core_out_sig  <= $itor($signed(core_out_tb)) / 32768.0;
        end
    end

endmodule