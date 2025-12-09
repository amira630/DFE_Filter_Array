module DFE_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter N_SAMPLES_I   = 4800                      ;   // Max = 48000
    parameter FREQ_CLK      = 9_000_000                 ;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK  ;

    parameter string CONFIG_FILE_NAME = "cfg.txt"  ;
    parameter string MATLAB_FILE_NAME = "System_run.m";
    parameter string PATH = "../MATLAB/";
    parameter string OUT_PATH = "";
    parameter string BASE_PATH = "scenario_";           // Path where MATLAB output files are located
    parameter string VCD_FILE_NAME = "DFE.vcd";        // VCD output file name

    parameter DATA_WIDTH   = 16        ;
    parameter DATA_FRAC    = 15        ;
    parameter PDATA_WIDTH  = 32        ;
    parameter ADDR_WIDTH   = 7         ;
    parameter COEFF_WIDTH  = 20        ;
    parameter COEFF_FRAC   = 18        ;
    parameter N_TAP        = 72        ;
    parameter NUM_DENUM    = 5         ;
    parameter COMP         = 4         ;

    integer input_idx = 0;
    integer frac_decimator_idx = 0;
    integer iir_24mhz_idx = 0;
    integer iir_5mhz_1_idx = 0;
    integer iir_5mhz_2_idx = 0;
    integer cic_idx = 0;
    integer output_idx = 0;

    typedef enum {EMPTY, FRACTIONAL_DECIMATOR, IIR_24, IIR_5_1, IIR_5_2, IIR, CIC} BLOCK_SEL;

    typedef enum {SINE, SQUARE, TRIANGULAR} INPUT_SHAPE; 

    typedef enum {FIXED_POINT, FLOATING_POINT} ARITH_BASE; 

    typedef enum {CIC_1, CIC_2, CIC_4, CIC_8, CIC_16} DEC_FACTOR_e;
    
    BLOCK_SEL block_var;
    BLOCK_SEL status_var;
    BLOCK_SEL coeff_var;

    logic [1 : 0] input_shape [0 : 0];
    INPUT_SHAPE shape_var;

    ARITH_BASE arith_base_var;

    DEC_FACTOR_e dec_factor;

    bit trig;
    bit core_test_end;

    bit floating_point_flag;

    logic [3:0] bypass_TC;
    logic [4:0] cic_decf_TC [4:0];

    logic signed [COEFF_WIDTH - 1 : 0] frac_dec_coeff_tb [N_TAP - 1 : 0];
    logic signed [COEFF_WIDTH - 1 : 0] iir_24mhz_coeff_tb [NUM_DENUM - 1 : 0];
    logic signed [COEFF_WIDTH - 1 : 0] iir_5mhz_1_coeff_tb [NUM_DENUM - 1 : 0];
    logic signed [COEFF_WIDTH - 1 : 0] iir_5mhz_2_coeff_tb [NUM_DENUM - 1 : 0];
    
    real input_sig;
    real frac_decimator_sig;
    real iir_24mhz_sig;
    real iir_5mhz_1_sig;
    real iir_5mhz_2_sig;
    real cic_sig;
    real output_sig;

    real frac_decimator_sig_tb;
    real iir_24mhz_sig_tb;
    real iir_5mhz_1_sig_tb;
    real iir_5mhz_2_sig_tb;
    real cic_sig_tb;

    real block_out_sig_tb;
    real core_out_sig_tb;

    real error;
    real acc_error;

    logic frac_decimator_valid_out_tb;
    logic iir_24mhz_valid_out_tb;
    logic iir_5mhz_1_valid_out_tb;
    logic iir_5mhz_2_valid_out_tb;
    logic cic_valid_out_tb;

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



    // Memory arrays with calculated depths based on bypass combinations
    logic signed [DATA_WIDTH - 1 : 0] input_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] frac_decimator_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] iir_24mhz_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] iir_5mhz_1_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] iir_5mhz_2_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] cic_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] output_exp [$];

    real frac_decimator_float_exp [$];
    real iir_24mhz_float_exp [$];
    real iir_5mhz_1_float_exp [$];
    real iir_5mhz_2_float_exp [$];
    real cic_float_exp [$];
    real output_float_exp [$];

    integer i;


    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    DFE_TOP #(
        //********************** General Parameters ********************//
        .DATA_WIDTH (DATA_WIDTH)                          ,
        .DATA_FRAC  (DATA_FRAC)                           ,
        .COEFF_WIDTH(COEFF_WIDTH)                         ,
        .COEFF_FRAC (COEFF_FRAC)                          ,
        
        //********************** APB Parameters ********************//
        .ADDR_WIDTH  (ADDR_WIDTH)                         ,
        .PDATA_WIDTH (PDATA_WIDTH)                        ,
        .COMP        (COMP)
    ) DUT (
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
    ////////////////// Report variables ////////////////////
    ////////////////////////////////////////////////////////

    integer core_out_success    = 0;
    integer core_out_fail       = 0;
    
    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    initial begin
        clk_tb = 0;
        forever #(T_CLK/2) clk_tb = ~clk_tb;
    end

    ////////////////////////////////////////////////////////
    ////////////////// Clocking Block  /////////////////////
    ////////////////////////////////////////////////////////

    clocking cb @(posedge clk_tb);
        output negedge valid_in_tb;
        output #1step core_in_tb;
        output #1step input_sig;
    endclocking

    ////////////////////////////////////////////////////////
    /////////// Applying Stimulus on Inputs //////////////// 
    ////////////////////////////////////////////////////////

    //////////////////  Response  ////////////////////

    assign frac_decimator_valid_out_tb = DUT.U_CORE.frac_dec_valid_out  ;
    assign iir_24mhz_valid_out_tb      = DUT.U_CORE.IIR.valid_2_4MHz_out;
    assign iir_5mhz_1_valid_out_tb     = DUT.U_CORE.IIR.valid_1MHz_out  ;
    assign iir_5mhz_2_valid_out_tb     = DUT.U_CORE.IIR.valid_out       ;
    assign cic_valid_out_tb            = DUT.U_CORE.valid_out           ;
 
    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            frac_decimator_idx <= 0;
            frac_decimator_sig      <= 0;
        end else if (frac_decimator_valid_out_tb && trig && frac_decimator_idx < frac_decimator_exp.size()) begin
            if (floating_point_flag == 0) begin
                frac_decimator_sig      <= $itor($signed(frac_decimator_exp[frac_decimator_idx])) / 32768.0;
            end else begin
                frac_decimator_sig      <= frac_decimator_float_exp[frac_decimator_idx];
            end
            frac_decimator_idx <= frac_decimator_idx + 1;
        end
    end

    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            iir_24mhz_idx <= 0;
            iir_24mhz_sig           <= 0;
        end else if (iir_24mhz_valid_out_tb && trig && iir_24mhz_idx < iir_24mhz_exp.size()) begin
            if (floating_point_flag == 0) begin
                iir_24mhz_sig           <= $itor($signed(iir_24mhz_exp[iir_24mhz_idx])) / 32768.0;
            end else begin
                iir_24mhz_sig           <= iir_24mhz_float_exp[iir_24mhz_idx];
            end
            iir_24mhz_idx <= iir_24mhz_idx + 1;
        end
    end

    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            iir_5mhz_1_idx <= 0;
            iir_5mhz_1_sig          <= 0;
        end else if (iir_5mhz_1_valid_out_tb && trig && iir_5mhz_1_idx < iir_5mhz_1_exp.size()) begin
            if (floating_point_flag == 0) begin
                iir_5mhz_1_sig          <= $itor($signed(iir_5mhz_1_exp[iir_5mhz_1_idx])) / 32768.0;
            end else begin
                iir_5mhz_1_sig          <= iir_5mhz_1_float_exp[iir_5mhz_1_idx];
            end
            iir_5mhz_1_idx <= iir_5mhz_1_idx + 1;
        end
    end

    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            iir_5mhz_2_idx <= 0;
            iir_5mhz_2_sig          <= 0;
        end else if (iir_5mhz_2_valid_out_tb && trig && iir_5mhz_2_idx < iir_5mhz_2_exp.size()) begin
            if (floating_point_flag == 0) begin
                iir_5mhz_2_sig          <= $itor($signed(iir_5mhz_2_exp[iir_5mhz_2_idx])) / 32768.0;
            end else begin
                iir_5mhz_2_sig          <= iir_5mhz_2_float_exp[iir_5mhz_2_idx];
            end
            iir_5mhz_2_idx <= iir_5mhz_2_idx + 1 ;
        end
    end

    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            cic_idx <= 0;
            cic_sig <= 0;
        end else if (cic_valid_out_tb && trig && cic_idx < cic_exp.size()) begin
            if (floating_point_flag == 0) begin
                cic_sig <= $itor($signed(cic_exp[cic_idx])) / 32768.0;
            end else begin
                cic_sig <= cic_float_exp[cic_idx];
            end
            cic_idx <= cic_idx + 1;
        end
    end

    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            output_idx <= 0;
            output_sig               <= 0;
        end else if (valid_out_tb && trig && output_idx < output_exp.size()) begin
            if (floating_point_flag == 0) begin
                output_sig               <= $itor($signed(output_exp[output_idx])) / 32768.0;
            end else begin
                output_sig               <= output_float_exp[output_idx];
            end

            if (!core_test_end) begin
                if (error < 0) begin
                    acc_error <= acc_error - error;
                end else begin
                    acc_error <= acc_error + error;
                end
            end

            output_idx <= output_idx + 1;
        end
    end


    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            input_idx       <= 0    ;
            cb.input_sig    <= 0    ;
            cb.valid_in_tb  <= 1'b0 ;
            cb.core_in_tb   <= '0   ;
        end else if (trig && input_idx < input_exp.size()) begin
            cb.input_sig    <= $itor($signed(input_exp[input_idx])) / 32768.0   ;
            cb.core_in_tb   <= input_exp[input_idx]                             ;
            cb.valid_in_tb  <= 1'b1                                             ;
            input_idx       <= input_idx + 1                                    ;
        end else begin
            cb.valid_in_tb  <= 1'b0 ;
        end
    end

    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            frac_decimator_sig_tb  <= 0;
            iir_24mhz_sig_tb       <= 0;
            iir_5mhz_1_sig_tb      <= 0;
            iir_5mhz_2_sig_tb      <= 0;
            cic_sig_tb             <= 0;
        end else begin
            frac_decimator_sig_tb  <= $itor($signed(DUT.U_CORE.frac_dec_out)) / 32768.0;
            iir_24mhz_sig_tb       <= $itor($signed(DUT.U_CORE.IIR.iir_out_2_4MHz)) / 32768.0;
            iir_5mhz_1_sig_tb      <= $itor($signed(DUT.U_CORE.IIR.iir_out_1MHz)) / 32768.0;
            iir_5mhz_2_sig_tb      <= $itor($signed(DUT.U_CORE.IIR.iir_out)) / 32768.0;
            cic_sig_tb             <= $itor($signed(DUT.U_CORE.core_out)) / 32768.0;
        end
    end

        // Output monitoring - sequential logic  
    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            block_out_sig_tb <= 'b0;
            core_out_sig_tb  <= 'b0;
        end else begin
            block_out_sig_tb <=  $itor($signed(block_out_tb)) / 32768.0;
            core_out_sig_tb  <= $itor($signed(core_out_tb)) / 32768.0;
        end
    end

    always_ff @(posedge clk_tb) begin
        if (!core_test_end && !floating_point_flag) begin
            if (core_out_sig_tb === output_sig) begin
                core_out_success = core_out_success + 1;
            end else begin
                core_out_fail = core_out_fail + 1;
            end
        end
    end

    always_comb begin
        if (!core_test_end) begin
            error = output_sig - core_out_sig_tb;
        end
    end

    always_ff @(posedge clk_tb) begin
        if (input_shape[0] == 2'b00) begin
            shape_var = SINE;
        end else if (input_shape[0] == 2'b01) begin
            shape_var = SQUARE;
        end else begin
            shape_var = TRIANGULAR;
        end
    end

    always_ff @(posedge clk_tb) begin
        if (floating_point_flag == 1'b0) begin
            arith_base_var = FIXED_POINT;
        end else begin
            arith_base_var = FLOATING_POINT;
        end
    end

    initial begin
        // System Functions
        $dumpfile(VCD_FILE_NAME);
        $dumpvars;

        // initialization
        init();
        repeat (2) @(negedge clk_tb);

        // Arithmetic-based Test Cases
        floating_point_flag = 1'b0;
        Arithmetic_based_TC(floating_point_flag); // Fixed-point

        assert_reset();

        floating_point_flag = 1'b1;
        Arithmetic_based_TC(floating_point_flag); // Floating-point
        
        
        $display("===========================================");
        $display("Core Output Success Count: %0d", core_out_success);
        $display("Core Output Failure Count: %0d", core_out_fail);
        $display("===========================================");
        $stop;
    end

    task Arithmetic_based_TC (
        input bit fl_fi_flag
    );
        core_test_end = 0;

        i = 0;
        repeat(5) begin
            bypass_TC = 0;
            TC_cfg({fl_fi_flag, 3'b0_0_0, cic_decf_TC[i]}, 4'b0000, 1, 1);
            repeat (16) begin
                // f = 0, a = 0, s = 0, bypass_frac_dec = 0, bypass_iir_24 = 0, bypass_iir_5 = 0, bypass_cic = 0, cic_decf = 4
                TC_cfg({fl_fi_flag, 3'b0_0_0, cic_decf_TC[i]}, bypass_TC, 0, 1);
                SET_OUTPUT($random % 4);
                SET_COEFF($random % 5);
                READ_STATUS(4);
                repeat (N_SAMPLES_I + 10) @(negedge clk_tb);
                bypass_TC = bypass_TC + 1;
            end
            i = i + 1;
        end

        repeat (2) begin
            bypass_TC = 0;
            TC_cfg({fl_fi_flag, 3'b0_0_1, cic_decf_TC[0]}, 4'b0000, 1, 1);
            repeat (16) begin
                // f = 0, a = 0, s = 0, bypass_frac_dec = 0, bypass_iir_24 = 0, bypass_iir_5 = 0, bypass_cic = 0, cic_decf = 4
                TC_cfg({fl_fi_flag, 3'b0_0_1, cic_decf_TC[0]}, bypass_TC, 0, 1);
                SET_OUTPUT($random % 4);
                SET_COEFF($random % 5);
                READ_STATUS(4);
                repeat (N_SAMPLES_I + 10) @(negedge clk_tb);
                bypass_TC = bypass_TC + 1;
            end
        end

        repeat (2) begin
            bypass_TC = 0;
            TC_cfg({fl_fi_flag, 3'b0_0_1, cic_decf_TC[1]}, 4'b0000, 1, 1);
            repeat (16) begin
                // f = 0, a = 0, s = 0, bypass_frac_dec = 0, bypass_iir_24 = 0, bypass_iir_5 = 0, bypass_cic = 0, cic_decf = 4
                TC_cfg({fl_fi_flag, 3'b0_0_1, cic_decf_TC[1]}, bypass_TC, 0, 1);
                SET_OUTPUT($random % 4);
                SET_COEFF($random % 5);
                READ_STATUS(4);
                repeat (N_SAMPLES_I + 10) @(negedge clk_tb);
                bypass_TC = bypass_TC + 1;
            end
        end

        repeat (2) begin
            bypass_TC = 0;
            TC_cfg({fl_fi_flag, 3'b1_0_1, cic_decf_TC[2]}, 4'b0000, 1, 1);
            repeat (16) begin
                // f = 0, a = 0, s = 0, bypass_frac_dec = 0, bypass_iir_24 = 0, bypass_iir_5 = 0, bypass_cic = 0, cic_decf = 4
                TC_cfg({fl_fi_flag, 3'b1_0_1, cic_decf_TC[2]}, bypass_TC, 0, 1);
                SET_OUTPUT($random % 4);
                SET_COEFF($random % 5);
                READ_STATUS(4);
                repeat (N_SAMPLES_I + 10) @(negedge clk_tb);
                bypass_TC = bypass_TC + 1;
            end
        end

        repeat (1) begin
            bypass_TC = 0;
            TC_cfg({fl_fi_flag, 3'b1_1_1, cic_decf_TC[3]}, 4'b0000, 1, 1);
            repeat (16) begin
                // f = 0, a = 0, s = 0, bypass_frac_dec = 0, bypass_iir_24 = 0, bypass_iir_5 = 0, bypass_cic = 0, cic_decf = 4
                TC_cfg({fl_fi_flag, 3'b1_1_1, cic_decf_TC[3]}, bypass_TC, 0, 1);
                SET_OUTPUT($random % 4);
                SET_COEFF($random % 5);
                READ_STATUS($random % 5);
                repeat (N_SAMPLES_I + 10) @(negedge clk_tb);
                bypass_TC = bypass_TC + 1;
            end
        end

        repeat (2) begin
            bypass_TC = 0;
            TC_cfg({fl_fi_flag, 3'b0_1_1, cic_decf_TC[4]}, 4'b0000, 1, 1);
            repeat (16) begin
                // f = 0, a = 0, s = 0, bypass_frac_dec = 0, bypass_iir_24 = 0, bypass_iir_5 = 0, bypass_cic = 0, cic_decf = 4
                TC_cfg({fl_fi_flag, 3'b0_1_1, cic_decf_TC[4]}, bypass_TC, 0, 1);
                SET_OUTPUT($random % 4);
                SET_COEFF($random % 5);
                READ_STATUS($random % 5);
                repeat (N_SAMPLES_I + 10) @(negedge clk_tb);
                bypass_TC = bypass_TC + 1;
            end
        end


        core_test_end = 1;

        // Verify coefficient readback
        $display("========== Verifying Coefficient Readback ==========");
        SET_COEFF(0);  // Default coefficients
        repeat (50) @(negedge clk_tb);
        SET_COEFF(1);  // Fractional decimator
        repeat (50) @(negedge clk_tb);
        SET_COEFF(2);  // 2.4 MHz IIR
        repeat (50) @(negedge clk_tb);
        SET_COEFF(3);  // 5 MHz IIR (1 MHz alias)
        repeat (50) @(negedge clk_tb);
        SET_COEFF(4);  // 5 MHz IIR (2 MHz alias)
        repeat (50) @(negedge clk_tb);
        SET_COEFF(0);  // Default coefficients
        
        // Test coefficient write functionality
        $display("========== Coefficient Write Tests ==========");
        
        // Test 1: Write Fractional Decimator Coefficients
        $display("[%0t] Writing Fractional Decimator Coefficients...", $time);
        CHANGE_FAC_DECI_COEFF(frac_dec_coeff_tb);
        $display("[%0t] Fractional Decimator coefficients written", $time);

        // Test 2: Write 2.4 MHz IIR Coefficients
        $display("[%0t] Writing 2.4 MHz IIR Coefficients...", $time);
        CHANGE_IIR24_COEFF(iir_24mhz_coeff_tb);
        $display("[%0t] 2.4 MHz IIR coefficients written", $time);
    
        // Test 3: Write 5 MHz IIR (1 MHz alias) Coefficients
        $display("[%0t] Writing 5 MHz IIR (1 MHz alias) Coefficients...", $time);
        CHANGE_IIR51_COEFF(iir_5mhz_1_coeff_tb);
        $display("[%0t] 5 MHz IIR (1 MHz alias) coefficients written", $time);

        // Test 4: Write 5 MHz IIR (2 MHz alias) Coefficients
        $display("[%0t] Writing 5 MHz IIR (2 MHz alias) Coefficients...", $time);
        CHANGE_IIR52_COEFF(iir_5mhz_2_coeff_tb);
        $display("[%0t] 5 MHz IIR (2 MHz alias) coefficients written", $time);

        $display("========== Reading Coeff After Modification ==========");

        SET_COEFF(0);  // Default coefficients
        repeat (50) @(negedge clk_tb);
        SET_COEFF(1);  // Fractional decimator
        repeat (50) @(negedge clk_tb);
        SET_COEFF(2);  // 2.4 MHz IIR
        repeat (50) @(negedge clk_tb);
        SET_COEFF(3);  // 5 MHz IIR (1 MHz alias)
        repeat (50) @(negedge clk_tb);
        SET_COEFF(4);  // 5 MHz IIR (2 MHz alias)
        repeat (50) @(negedge clk_tb);
        SET_COEFF(0);  // Default coefficients

        $display("========== Testing After Coefficient Modification ==========");

        repeat (1) begin
            bypass_TC = 0;
            TC_cfg({fl_fi_flag, 3'b0_0_0, cic_decf_TC[2]}, 4'b0000, 1, 1);
            repeat (16) begin
                // f = 0, a = 0, s = 0, bypass_frac_dec = 0, bypass_iir_24 = 0, bypass_iir_5 = 0, bypass_cic = 0, cic_decf = 4
                TC_cfg({fl_fi_flag, 3'b0_0_0, cic_decf_TC[2]}, bypass_TC, 0, 1);

                CHANGE_FAC_DECI_COEFF(frac_dec_coeff_tb);
                CHANGE_IIR24_COEFF(iir_24mhz_coeff_tb);
                CHANGE_IIR51_COEFF(iir_5mhz_1_coeff_tb);
                CHANGE_IIR52_COEFF(iir_5mhz_2_coeff_tb);

                SET_OUTPUT($random % 4);
                SET_COEFF($random % 5);
                READ_STATUS($random % 5);
                repeat (N_SAMPLES_I + 10) @(negedge clk_tb);
                bypass_TC = bypass_TC + 1;
            end
        end
    endtask

    ////////////////////////////////////////////////////
    /////////////////////// TASKS //////////////////////
    ////////////////////////////////////////////////////

    /////////////// Signals Initialization /////////////

    task init ();

        floating_point_flag = 0;

        error = 0.0;
        acc_error = 0.0;

        bypass_TC = 0;
        cic_decf_TC[0] = 5'b00001; // 1
        cic_decf_TC[1] = 5'b00010; // 2
        cic_decf_TC[2] = 5'b00100; // 4
        cic_decf_TC[3] = 5'b01000; // 8
        cic_decf_TC[4] = 5'b10000; // 16

        MTRANS_tb = 1'b0;
        MWRITE_tb = 1'b0;
        MSELx_tb  = 'b10;
        MADDR_tb  = $random();
        MWDATA_tb = $random();
        core_in_tb = $random();
        valid_in_tb = 0;

        core_test_end = 0;

        SET_COEFF(0);
        SET_OUTPUT(0);
        READ_STATUS(0);

        for (int i = 0; i < N_TAP; i = i + 1) begin
            frac_dec_coeff_tb[i] = 20'sh11111;
        end
        for (int i = 0; i < NUM_DENUM; i = i + 1) begin
            iir_24mhz_coeff_tb[i] = 20'sh22222;
            iir_5mhz_1_coeff_tb[i] = 20'sh33333;
            iir_5mhz_2_coeff_tb[i] = 20'sh44444;
        end
        assert_reset();

        // Default Configuration - Run MATLAB once at initialization
        TC_cfg({1'b0, 3'b0_0_0, cic_decf_TC[2]}, 4'b0000, 1, 1);  
    endtask

    ///////////////////////// RESET ////////////////////

    task assert_reset ();
        
        rst_n_tb = 1'b0;
        repeat (2) @(negedge clk_tb);
        rst_n_tb = 1'b1;
    endtask

    /////////////////////// Operations /////////////////

    task RW (
        input logic                          WR     ,
        input logic                          last   ,
        input logic        [ADDR_WIDTH-1:0]  ADDR   ,
        input logic        [COMP-1:0]        SELx   ,
        input logic signed [COEFF_WIDTH-1:0] WDATA
    );
        MWRITE_tb = WR;
        MADDR_tb  = ADDR;
        MTRANS_tb = 1'b1;
        MSELx_tb  = SELx;
        $display("MTRANS_tb is asserted at %0t", $realtime);
        if (WR) begin
            MWDATA_tb = WDATA;
        end

        repeat (2) @(negedge clk_tb);

        MTRANS_tb = 1'b0;
        $display("MTRANS_tb is de-asserted at %0t", $realtime);
        if (last) @(negedge clk_tb);
        // MSELx_tb  = 'b0;
    endtask

    task BYPASS (
        input logic [1:0] sel,
        input logic bypass_flag
    );
        // WR, last, ADDR, SELx, WDATA
        RW(1, 1, (N_TAP + (3 * NUM_DENUM) + 1 + sel), 'b1000, bypass_flag); // Write CTRLs
    endtask

    task SET_OUTPUT (
        input logic [1:0] sel
    );

        if (sel == 0) begin
            block_var = EMPTY;
        end else if (sel == 1) begin
            block_var = FRACTIONAL_DECIMATOR;
        end else if (sel == 2) begin
            block_var = IIR;
        end else begin
            block_var = CIC;
        end
        
        // WR, last, ADDR, SELx, WDATA
        RW(1, 1, N_TAP + 3*NUM_DENUM + 6,'b1000, sel); // Write OUT_SEL
    endtask

    task SET_COEFF (
        input logic [2:0] sel
    );

        if (sel == 0) begin
            coeff_var = EMPTY;
        end else if (sel == 1) begin
            coeff_var = FRACTIONAL_DECIMATOR;
        end else if (sel == 2) begin
            coeff_var = IIR_5_1;
        end else if (sel == 3) begin
            coeff_var = IIR_5_2;
        end else begin
            coeff_var = IIR_24;
        end
        
        // WR, last, ADDR, SELx, WDATA
        RW(1, 1, N_TAP + 3*NUM_DENUM + 7,'b1000, sel); // Write COEFF_SEL
    endtask
    
    task READ_STATUS (
        input logic [2:0] sel
    );

        if (sel == 0) begin
            status_var = EMPTY;
        end else if (sel == 1) begin
            status_var = FRACTIONAL_DECIMATOR;
        end else if (sel == 2) begin
            status_var = IIR_5_1;
        end else if (sel == 3) begin
            status_var = IIR_5_2;
        end else if (sel == 4) begin
            status_var = IIR_24;
        end else begin
            status_var = CIC;
        end

        // WR, last, ADDR, SELx, WDATA
        RW(1, 1, N_TAP + 3*NUM_DENUM + 8,'b1000, sel); // Write STATUS
    endtask

    task CHANGE_DECIMATION (
        input logic [4:0] rate
    );
        // WR, last, ADDR, SELx, WDATA
        RW(1, 1, N_TAP + 3*NUM_DENUM,'b100, rate); // Write CIC_R
    endtask

    task CHANGE_FAC_DECI_COEFF (
        input logic signed [COEFF_WIDTH-1:0] coeff [N_TAP - 1 : 0]
    );
        
        // WR, last, ADDR, SELx, WDATA
        for (int i = 0; i < N_TAP; i = i + 1) begin
            RW(1, 0, i,'b1, coeff[i]); // Write Frac_Deci Coeff
        end
    endtask

    task CHANGE_IIR24_COEFF (
        input logic signed [COEFF_WIDTH-1:0] coeff [NUM_DENUM - 1 : 0]
    );
        // WR, last, ADDR, SELx, WDATA
        for (int i = N_TAP; i < N_TAP + NUM_DENUM; i = i + 1) begin
            RW(1, 0, i,'b10, coeff[i - N_TAP]); // Write IIR 2.4 Coeff
        end
    endtask

    task CHANGE_IIR51_COEFF (
        input logic signed [COEFF_WIDTH-1:0] coeff [NUM_DENUM -1 : 0]
    );
        // WR, last, ADDR, SELx, WDATA
        for (int i = N_TAP + NUM_DENUM; i < N_TAP + 2*NUM_DENUM; i = i + 1) begin
            RW(1, 0, i,'b10, coeff[i - N_TAP - NUM_DENUM]); // Write IIR 5_1 Coeff
        end
    endtask

    task CHANGE_IIR52_COEFF (
        input logic signed [COEFF_WIDTH-1:0] coeff [NUM_DENUM -1 : 0]
    );
        // WR, last, ADDR, SELx, WDATA
        for (int i = N_TAP + 2*NUM_DENUM; i < N_TAP + 3*NUM_DENUM; i = i + 1) begin
            RW(1, 0, i,'b10, coeff[i - N_TAP - 2*NUM_DENUM]); // Write IIR 5_2 Coeff
        end
    endtask

    task update_config (
        input logic [8 : 0] config_stream 
    );
        // Floating Point       :   (config_stream[8])      :   Floating Point flag
        // f                    :   (config_stream[7])      :   Frequency randomization flag
        // a                    :   (config_stream[6])      :   Amplitude randomization flag
        // s                    :   (config_stream[5])      :   Shape randomization flag
        // cic_decf             :   (config_stream[4:0])    :   CIC decimation factor (5 bits)

        integer file_handle;
        string filename;

        // Construct full file path
        if (PATH == "") begin
            filename = CONFIG_FILE_NAME;  // Default to current directory if no path
        end else begin
            // Ensure path ends with slash
            if (PATH.substr(PATH.len()-1, PATH.len()-1) != "/") begin
                filename = {PATH, "/", CONFIG_FILE_NAME};
            end else begin
                filename = {PATH, CONFIG_FILE_NAME};
            end
        end

        // Open file for writing
        file_handle = $fopen(filename, "w");

        if (file_handle == 0) begin
            $display("Error: Cannot open file %s for writing", filename);
            $stop;
        end

        // Write signal configuration flags (bits 1-3)
        $fwrite(file_handle, "%09b", config_stream);

        // Close file
        $fclose(file_handle);

        $display("Configuration file '%s' created successfully", filename);
        $display("Arithmetic Data Type Floating Point = %b", config_stream[8]);
        $display("Configuration: f=%b, a=%b, s=%b", config_stream[7], config_stream[6], config_stream[5]);
        $display("CIC decf = %d (binary: %05b)", config_stream[4 : 0], config_stream[4 : 0]);
    endtask

    task run_matlab (
        input bit wait_for_completion    // 1 = wait, 0 = run in background
    );
        
        integer result;
        string command;
        string log_file;
        string timestamp;
        string full_script_path;
        string matlab_function_name;  // ADDED: Extract function name without .m

        // ADDED: Extract function name without .m extension
        if (MATLAB_FILE_NAME.len() > 2 && MATLAB_FILE_NAME.substr(MATLAB_FILE_NAME.len()-2, MATLAB_FILE_NAME.len()-1) == ".m") begin
            matlab_function_name = MATLAB_FILE_NAME.substr(0, MATLAB_FILE_NAME.len()-3);
        end else begin
            matlab_function_name = MATLAB_FILE_NAME;
        end

        // Create timestamp for unique log file
        $sformat(timestamp, "%0t", $realtime);

        // Construct log file path
        if (OUT_PATH == "") begin
            $sformat(log_file, "matlab_%s_%s.log", matlab_function_name, timestamp);
        end else begin
            if (OUT_PATH.substr(OUT_PATH.len()-1, OUT_PATH.len()-1) != "/") begin
                $sformat(log_file, "%s/matlab_%s_%s.log", OUT_PATH, matlab_function_name, timestamp);
            end else begin
                $sformat(log_file, "%smatlab_%s_%s.log", OUT_PATH, matlab_function_name, timestamp);
            end
        end

        // Build the MATLAB command - FIXED: Remove .m from function call
        if (wait_for_completion) begin
            // Synchronous execution
            $sformat(command, "matlab -batch \"addpath('%s'); %s;\" -logfile %s", 
                     PATH, matlab_function_name, log_file);  // CHANGED: Removed ('%s') argument and .m
        end else begin
            // Asynchronous execution (background)
            $sformat(command, "matlab -batch \"addpath('%s'); %s;\" -logfile %s &", 
                     PATH, matlab_function_name, log_file);  // CHANGED: Removed ('%s') argument and .m
        end

        $display("[%0t] Starting MATLAB execution:", $time);
        $display("[%0t]   Script: %s%s", $time, PATH, MATLAB_FILE_NAME);  // CHANGED: Show actual file path
        $display("[%0t]   Function: %s", $time, matlab_function_name);    // ADDED: Show function name being called
        $display("[%0t]   Log: %s", $time, log_file);
        $display("[%0t]   Command: %s", $time, command);

        // Execute the command
        result = $system(command);

        if (wait_for_completion) begin
            if (result == 0) begin
                $display("[%0t] MATLAB execution completed successfully", $time);
            end else begin
                $display("[%0t] ERROR: MATLAB execution failed with code %0d", $time, result);
                $display("[%0t] Please check:", $time);
                $display("[%0t]   1. MATLAB is installed and in system PATH", $time);
                $display("[%0t]   2. File exists: %s%s", $time, PATH, MATLAB_FILE_NAME);
                $display("[%0t]   3. MATLAB script has no syntax errors", $time);
            end
        end else begin
            $display("[%0t] MATLAB started in background", $time);
        end
    endtask

    task run_script (
        input logic [8 : 0] config_stream, 
        input bit wait_for_completion           // 1 = wait, 0 = run in background
    );
    
        // Create configuration file
        update_config(config_stream);

        // Run MATLAB script
        run_matlab(wait_for_completion);  
    endtask

    function automatic int calculate_depth (
        input bit bypass_frac_dec,
        input bit bypass_cic,
        input int cic_decf
    );
        int depth = N_SAMPLES_I;

        // Apply fractional decimator effect (if not bypassed)
        if (!bypass_frac_dec) begin
            // Fractional decimator reduces samples by factor (adjust based on your actual ratio)
            depth = depth * 2 / 3;  // Example: adjust this based on your actual decimation ratio
        end

        // Apply CIC decimator effect (if not bypassed)
        if (!bypass_cic) begin
            depth = depth / cic_decf;
        end

        return depth;
    endfunction

    task reset_idx ();
        input_idx = 0;
        frac_decimator_idx = 0;
        iir_24mhz_idx = 0;
        iir_5mhz_1_idx = 0;
        iir_5mhz_2_idx = 0;
        cic_idx = 0;
        output_idx = 0;
    endtask

    task automatic load_stage_file_fixed (
        ref logic signed [DATA_WIDTH-1:0] memory[$]     ,       // Reference to memory array
        input string filename                           ,       // File to load
        input string stage_name                                 // Stage name for logging
    );
        
        integer file_handle;
        integer i;
        logic [15:0] temp_data;

        file_handle = $fopen(filename, "r");
        if (file_handle == 0) begin
            $display("  Warning: Could not open %s for stage %s", filename, stage_name);
            return;
        end

        // Clear existing memory and load new data
        memory.delete();
        i = 0;
        while (!$feof(file_handle)) begin
            if ($fscanf(file_handle, "%b\n", temp_data) == 1) begin
                memory.push_back(temp_data);
                i++;
            end
        end
        $fclose(file_handle);

        // $display("  Stage %s: %0d samples from %s", stage_name, i, filename);
    endtask

    task automatic load_stage_file_float (
        ref real memory[$]               ,    // Reference to real memory array
        input string filename            ,    // File to load
        input string stage_name               // Stage name for logging
    );
        
        integer file_handle;
        integer i;
        real temp_data;

        file_handle = $fopen(filename, "r");
        if (file_handle == 0) begin
            $display("  Warning: Could not open %s for stage %s", filename, stage_name);
            return;
        end

        // Clear existing memory and load new data
        memory.delete();
        i = 0;
        while (!$feof(file_handle)) begin
            if ($fscanf(file_handle, "%f\n", temp_data) == 1) begin
                memory.push_back(temp_data);
                i++;
            end
        end
        $fclose(file_handle);

        // $display("  Stage %s: %0d samples from %s", stage_name, i, filename);
    endtask


    task automatic load_matlab_stages (
        input bit  fi_vs_floating ,
        input string bypass_cfg                         // Stage name for logging
    );
        if (fi_vs_floating == 1) begin
            load_stage_file_fixed(input_exp, {BASE_PATH, bypass_cfg, "/input.txt"}, "Input");
            load_stage_file_float(frac_decimator_float_exp, {BASE_PATH, bypass_cfg, "/frac_decimator.txt"}, "Fractional Decimator");
            load_stage_file_float(iir_24mhz_float_exp, {BASE_PATH, bypass_cfg, "/iir_24mhz.txt"}, "IIR 2.4MHz");
            load_stage_file_float(iir_5mhz_1_float_exp, {BASE_PATH, bypass_cfg, "/iir_5mhz_1.txt"}, "IIR 5MHz 1");
            load_stage_file_float(iir_5mhz_2_float_exp, {BASE_PATH, bypass_cfg, "/iir_5mhz_2.txt"}, "IIR 5MHz 2");
            load_stage_file_float(cic_float_exp, {BASE_PATH, bypass_cfg, "/cic.txt"}, "CIC");
            load_stage_file_float(output_float_exp, {BASE_PATH, bypass_cfg, "/output.txt"}, "Final Output");
        end else begin
            load_stage_file_fixed(input_exp, {BASE_PATH, bypass_cfg, "/input.txt"}, "Input");
            load_stage_file_fixed(frac_decimator_exp, {BASE_PATH, bypass_cfg, "/frac_decimator.txt"}, "Fractional Decimator");
            load_stage_file_fixed(iir_24mhz_exp, {BASE_PATH, bypass_cfg, "/iir_24mhz.txt"}, "IIR 2.4MHz");
            load_stage_file_fixed(iir_5mhz_1_exp, {BASE_PATH, bypass_cfg, "/iir_5mhz_1.txt"}, "IIR 5MHz 1");
            load_stage_file_fixed(iir_5mhz_2_exp, {BASE_PATH, bypass_cfg, "/iir_5mhz_2.txt"}, "IIR 5MHz 2");
            load_stage_file_fixed(cic_exp, {BASE_PATH, bypass_cfg, "/cic.txt"}, "CIC");
            load_stage_file_fixed(output_exp, {BASE_PATH, bypass_cfg, "/output.txt"}, "Final Output");
        end
            
    endtask

    task automatic load_matlab_output (
        input bit  fi_vs_floating   ,
        input bit bypass_frac_dec   ,
        input bit bypass_iir_24     ,
        input bit bypass_iir_5      , 
        input bit bypass_cic        ,
        input int cic_decf
    );

        int expected_depth;

        expected_depth = calculate_depth(bypass_frac_dec, bypass_cic, cic_decf);

        // Load each stage using the generic task
        if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b0000) begin
            load_matlab_stages(fi_vs_floating, "frac0_iir240_iir50_cic0");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b0001) begin
            load_matlab_stages(fi_vs_floating, "frac0_iir240_iir50_cic1");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b0010) begin
            load_matlab_stages(fi_vs_floating, "frac0_iir240_iir51_cic0");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b0011) begin
            load_matlab_stages(fi_vs_floating, "frac0_iir240_iir51_cic1");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b0100) begin
            load_matlab_stages(fi_vs_floating, "frac0_iir241_iir50_cic0");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b0101) begin
            load_matlab_stages(fi_vs_floating, "frac0_iir241_iir50_cic1");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b0110) begin
            load_matlab_stages(fi_vs_floating, "frac0_iir241_iir51_cic0");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b0111) begin
            load_matlab_stages(fi_vs_floating, "frac0_iir241_iir51_cic1");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b1000) begin
            load_matlab_stages(fi_vs_floating, "frac1_iir240_iir50_cic0");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b1001) begin
            load_matlab_stages(fi_vs_floating, "frac1_iir240_iir50_cic1");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b1010) begin
            load_matlab_stages(fi_vs_floating, "frac1_iir240_iir51_cic0");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b1011) begin
            load_matlab_stages(fi_vs_floating, "frac1_iir240_iir51_cic1");  
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b1100) begin
            load_matlab_stages(fi_vs_floating, "frac1_iir241_iir50_cic0");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b1101) begin
            load_matlab_stages(fi_vs_floating, "frac1_iir241_iir50_cic1");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b1110) begin
            load_matlab_stages(fi_vs_floating, "frac1_iir241_iir51_cic0");
        end else if ({bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic}== 4'b1111) begin
            load_matlab_stages(fi_vs_floating, "frac1_iir241_iir51_cic1");
        end

        // Verify final output depth
        if (output_exp.size() != expected_depth) begin
            $display("  Note: Actual depth (%0d) differs from expected (%0d)", 
                     output_exp.size(), expected_depth);
        end

        // $display("Loading complete for configuration %b%b%b%b (CIC_DecF=%0d)",
        //          bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic, cic_decf);
    endtask

    task TC_cfg (
        input logic [8 : 0] config_stream       ,
        input bit   [3 : 0] bypass_config       ,
        input logic         run_matlab_script   , 
        input bit           wait_for_completion        // 1 = wait, 0 = run in background
    );

        assert_reset ();
        
        trig = 0;
        // Run the script to generate outputs
        if (run_matlab_script) run_script(config_stream, wait_for_completion);

        load_matlab_output(
            config_stream [8]        , 
            bypass_config [3]        , 
            bypass_config [2]        , 
            bypass_config [1]        , 
            bypass_config [0]        , 
            config_stream[4 : 0]
        );

        $display("Bypasses: %0b, %0b, %0b, %0b", bypass_config [3], bypass_config [2], bypass_config [1], bypass_config [0]);

        BYPASS(2'b00, bypass_config [3]); // Fractional Decimator
        BYPASS(2'b01, bypass_config [2]); // IIR 2.4MHz
        BYPASS(2'b10, bypass_config [1]); // IIR 5MHz
        BYPASS(2'b11, bypass_config [0]); // CIC

        CHANGE_DECIMATION(config_stream[4 : 0]);

        if (config_stream[4 : 0] == 1) begin
            dec_factor = CIC_1;
        end else if (config_stream[4 : 0] == 2) begin
            dec_factor = CIC_2;
        end else if (config_stream[4 : 0] == 4) begin
            dec_factor = CIC_4;
        end else if (config_stream[4 : 0] == 8) begin
            dec_factor = CIC_8;
        end else if (config_stream[4 : 0] == 16) begin
            dec_factor = CIC_16;
        end

        $readmemb("signal_shape_code.txt", input_shape);

        repeat (1) @(negedge clk_tb);
        
        reset_idx();
        trig = 1;
    endtask

endmodule