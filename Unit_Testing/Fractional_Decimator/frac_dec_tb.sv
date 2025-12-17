module top_tb ();

    // Fractional Decimator Parameters
    parameter   DATA_WIDTH      = 16  ;
    parameter   DATA_FRAC       = 15  ;
    parameter   COEFF_WIDTH     = 20  ;
    parameter   COEFF_FRAC      = 18  ;
    parameter   M               = 3   ;
    parameter   N_TAP           = 146 ;

    // Testbench Parameters
    parameter N_SAMPLES_I   = 48000                     ;
    parameter FREQ_CLK      = 9_000_000                 ;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK  ;

    // Fractional Decimator Signals
    logic                                clk                             ;
    logic                                valid_in                        ;
    logic                                rst_n                           ;
    logic                                bypass                          ;  
    logic         			             coeff_wr_en                     ;
    logic signed [COEFF_WIDTH - 1 : 0]   coeff_data_in  [N_TAP - 1 : 0]  ;
    logic signed [COEFF_WIDTH - 1 : 0]   coeff_data_out [N_TAP - 1 : 0]  ;
    logic signed [DATA_WIDTH - 1 : 0]    filter_in                       ;
    logic signed [DATA_WIDTH - 1 : 0]    filter_out                      ;
    logic                                overflow                        ;
    logic                                underflow                       ;
    logic                                valid_out                       ;
    logic                                ce_out                          ;

    // Signals for monitoring output
    integer                     i                           = 0             ;
    integer                     j                           = 0             ;
    integer                     number_of_output_samples    = 1             ;
    integer                     error_count                 = 0             ;
    integer                     pass_count                  = 0             ;

    real                        input_sig                                   ;
    real                        frac_output_sig                             ;
    real                        output_sig_exp                              ;
    real                        error_tolerance             = 0.001         ;
    real                        max_error                   = 0.0           ;
    real                        current_error                               ;

    logic [DATA_WIDTH - 1 : 0]  input_samples        [N_SAMPLES_I - 1 : 0]  ;
    logic [DATA_WIDTH - 1 : 0]  output_exp_samples   [32000 - 1 : 0]  ;

    fractional_decimator #(
        .DATA_WIDTH  (DATA_WIDTH)       ,
        .DATA_FRAC   (DATA_FRAC)        ,
        .COEFF_WIDTH (COEFF_WIDTH)      ,
        .COEFF_FRAC  (COEFF_FRAC)       
    ) fractional_Decimator (
        .clk           (clk)            ,
        .valid_in      (valid_in)       ,
        .rst_n         (rst_n)          ,
        .bypass        (bypass)         ,
        .coeff_wr_en   (coeff_wr_en)    ,
        .coeff_data_in (coeff_data_in)  ,
        .coeff_data_out(coeff_data_out) ,
        .filter_in     (filter_in)      ,
        .filter_out    (filter_out)     ,
        .overflow      (overflow)       ,
        .underflow     (underflow)      ,
        .valid_out     (valid_out)      
    );

    initial begin
        clk = 0;
        forever #(T_CLK/2) clk = ~clk;
    end
 
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frac_output_sig <= 0;
        end else if (valid_in) begin
            frac_output_sig <= $itor($signed(filter_out)) / 32768.0;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_sig_exp <= 0;
        end else if (valid_out) begin
            output_sig_exp <= $itor($signed(output_exp_samples[j])) / 32768.0;
            j = j + 1;
        end
    end

    // Self-checking mechanism - validates at valid_out
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            error_count <= 0;
            pass_count  <= 0;
            max_error   <= 0.0;
        end else if (valid_out && !bypass) begin
            // Calculate absolute error between expected and actual
            current_error = (frac_output_sig > output_sig_exp) ? 
                           (frac_output_sig - output_sig_exp) : 
                           (output_sig_exp - frac_output_sig);
            
            // Track maximum error
            if (current_error > max_error) begin
                max_error = current_error;
            end
            
            // Check if output matches expected within tolerance
            if (current_error <= error_tolerance) begin
                pass_count = pass_count + 1;
            end else begin
                error_count = error_count + 1;
                $display("[ERROR] Time %0t, Sample %0d: Expected = %f, Actual = %f, Error = %f", 
                         $time, j - 1, output_sig_exp, frac_output_sig, current_error);
            end
        end
    end

    // Monitor overflow and underflow conditions
    always_ff @(posedge clk) begin
        if (overflow) begin
            $display("[WARNING] Time %0t: Overflow detected at input sample %0d", $time, i);
        end
        if (underflow) begin
            $display("[WARNING] Time %0t: Underflow detected at input sample %0d", $time, i);
        end
    end

    initial begin
        $display("=============================================================================");
        $display("           FRACTIONAL DECIMATOR TESTBENCH");
        $display("=============================================================================");
        $display("Test Configuration:");
        $display("  - Input Samples       : %0d", N_SAMPLES_I);
        $display("  - Decimation Factor   : %0d", M);
        $display("  - Filter Taps         : %0d", N_TAP);
        $display("  - Data Width          : %0d bits (S%0d.%0d)", DATA_WIDTH, DATA_WIDTH-DATA_FRAC, DATA_FRAC);
        $display("  - Coefficient Width   : %0d bits (S%0d.%0d)", COEFF_WIDTH, COEFF_WIDTH-COEFF_FRAC, COEFF_FRAC);
        $display("  - Clock Frequency     : %0d Hz", FREQ_CLK);
        $display("  - Error Tolerance     : %f", error_tolerance);
        $display("=============================================================================");
        
        init();

        $display("\n[INFO] Applying reset...");
        assert_reset();

        $display("[INFO] Starting fractional decimation test...");
        start_frac_dec();

        repeat (5) @(negedge clk);
        
        print_test_summary();

        $display("[INFO] Starting bypass mode test...");

        bypass = 1;
        valid_in = 1;

        start_frac_dec();
        
        $stop;
    end

    task init ();
        $display("[INFO] Initializing testbench...");
        $readmemb("input_wave.txt", input_samples);
        $readmemb("output_wave_exp.txt", output_exp_samples);
        rst_n           = 1;
        valid_in        = 0;
        bypass          = 0;
        coeff_wr_en     = 0;
        for(int k = 0; k < N_TAP; k++) begin
            coeff_data_in[k] = 0;
        end
        filter_in       = 0;  
        repeat (1) @(negedge clk);
        $display("[INFO] Initialization complete.");
    endtask

    task assert_reset ();
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
        $display("[INFO] Reset released.");
    endtask

    task start_frac_dec ();
        valid_in    = 1;
        rst_n       = 1;
        i           = 0;

        repeat (N_SAMPLES_I ) begin
            filter_in = input_samples[i];
            input_sig = $itor($signed(input_samples[i])) / 32768.0;
            
            i = i + 1;
            @(negedge clk);
        end

        @(negedge clk);

        valid_in = 0;
        $display("[INFO] All input samples processed.");
    endtask

    task print_test_summary ();
        integer expected_output_samples;
        real pass_percentage;
        
        expected_output_samples = N_SAMPLES_I * 2 / M;
        
        $display("\n=============================================================================");
        $display("                        TEST SUMMARY");
        $display("=============================================================================");
        $display("Input Samples Processed     : %0d", i);
        $display("Output Samples Generated    : %0d", j);
        $display("Expected Output Samples     : %0d", expected_output_samples);
        $display("-----------------------------------------------------------------------------");
        $display("Passing Samples             : %0d", pass_count);
        $display("Failing Samples             : %0d", error_count);
        $display("Maximum Error Observed      : %f", max_error);
        $display("Error Tolerance             : %f", error_tolerance);
        
        if (pass_count + error_count > 0) begin
            pass_percentage = (100.0 * pass_count) / (pass_count + error_count);
            $display("Pass Percentage             : %0.2f%%", pass_percentage);
        end
        
        $display("=============================================================================");
        
        if (error_count == 0 && j == expected_output_samples) begin
            $display("                    ***** TEST PASSED *****");
        end else begin
            $display("                    ***** TEST FAILED *****");
            if (j != expected_output_samples) begin
                $display("  - Output sample count mismatch!");
            end
            if (error_count > 0) begin
                $display("  - %0d sample(s) exceeded error tolerance!", error_count);
            end
        end
        $display("=============================================================================\n");
    endtask

endmodule