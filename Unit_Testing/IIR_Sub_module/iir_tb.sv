module top_tb ();

    // IIR Parameters
    parameter   DATA_WIDTH      = 16    ;
    parameter   DATA_FRAC       = 15    ;
    parameter   COEFF_WIDTH     = 20    ;
    parameter   COEFF_FRAC      = 18    ;
    parameter   IIR_NOTCH_FREQ  = 0     ;// 0: 1MHz, 1: 2MHz, 2:2.4MHz

    // Testbench Parameters
    parameter N_SAMPLES_I   = 32000                     ;
    parameter FREQ_CLK      = 6_000_000                ;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK  ;
    parameter TOLERANCE     = 5                         ; // Maximum allowed bit difference

    // IIR Signals
    logic                               clk                         ;
    logic                               rst_n                       ;
    logic                               valid_in                    ;
    logic                               bypass                      ;
    logic         			            coeff_wr_en                 ;
    logic signed [COEFF_WIDTH - 1 : 0]  coeff_in        [4 : 0]     ;
    logic signed [DATA_WIDTH - 1 : 0]   iir_in                      ;
    logic signed [DATA_WIDTH - 1 : 0]   iir_out                     ;
    logic signed [COEFF_WIDTH - 1 : 0]  coeff_out       [4 : 0]     ;
    logic                               overflow                    ;
    logic                               underflow                   ;
    logic                               valid_out                   ;
    
    // Signals for monitoring output
    integer                     i                           = 0             ;
    integer                     j                           = 0             ;  // Skipped initial samples distortion due to filter settling
    integer                     number_of_output_samples    = 1             ;

    real                        input_sig                                   ;
    real                        iir_output_sig                             ;
    real                        output_sig_exp                              ;

    logic [DATA_WIDTH - 1 : 0]  input_samples        [N_SAMPLES_I - 1 : 0]  ;
    logic [DATA_WIDTH - 1 : 0]  output_exp_samples   [N_SAMPLES_I - 1 : 0]  ;

    // Self-checking signals
    integer                     error_count                 = 0             ;
    integer                     mismatch_count              = 0             ;
    integer                     bypass_mismatch_count       = 0             ;
    integer                     overflow_count              = 0             ;
    integer                     underflow_count             = 0             ;
    integer                     max_error                   = 0             ;
    integer                     samples_checked             = 0             ;
    integer                     bypass_samples_checked      = 0             ;
    logic signed [DATA_WIDTH : 0] error_diff                                ;
    integer                     abs_error_diff                              ;
    real                        total_error                 = 0.0           ;
    real                        avg_error                   = 0.0           ;
    
    // Test status
    bit                         test_passed                 = 1'b1          ;
    bit                         bypass_test_passed          = 1'b1          ;
    bit                         filter_test_passed          = 1'b1          ;
    string                      filter_type                                 ;
    bit                         bypass_mode                 = 1'b0          ;

    IIR #(
        .DATA_WIDTH     (DATA_WIDTH)      ,
        .DATA_FRAC      (DATA_FRAC)       ,
        .COEFF_WIDTH    (COEFF_WIDTH)     ,
        .COEFF_FRAC     (COEFF_FRAC)      ,
        .IIR_NOTCH_FREQ (IIR_NOTCH_FREQ)  // 0: 1MHz, 1: 2MHz, 2:2.4MHz
    ) IIR_DUT (
        .clk              (clk)             ,
        .rst_n            (rst_n)           ,
        .valid_in         (valid_in)        ,
        .bypass           (bypass)          , 
        .coeff_wr_en      (coeff_wr_en)     ,
        .coeff_in         (coeff_in)        ,
        .iir_in           (iir_in)          ,
        .iir_out          (iir_out)         ,
        .coeff_out        (coeff_out)       ,
        .overflow         (overflow)        ,
        .underflow        (underflow)       ,
        .valid_out        (valid_out)
    );

    initial begin
        clk = 0;
        forever #(T_CLK/2) clk = ~clk;
    end
 
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            iir_output_sig <= 0;
        end else if (valid_out) begin
            iir_output_sig <= $itor($signed(iir_out)) / 32768.0;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_sig_exp <= 0;
            j <= 0;
        end else if (valid_out) begin
            if (bypass_mode) begin
                output_sig_exp <= input_sig;
            end else begin
            output_sig_exp <= $itor($signed(output_exp_samples[j])) / 32768.0;
            j <= j + 1;
            end
        end
    end

    // Self-checking mechanism
    always @(posedge clk) begin
        if (valid_out && j > 0) begin
            if (bypass_mode) begin
                // In bypass mode, output should equal input (same cycle due to combinational path)
                error_diff = $signed(iir_out) - $signed(input_samples[j]);
                
                if (error_diff != 0) begin
                    bypass_mismatch_count = bypass_mismatch_count + 1;
                    bypass_test_passed = 1'b0;
                    test_passed = 1'b0;
                    $display("[ERROR] Bypass Sample %0d: Output != Input!", j);
                    $display("        Input: %h, Output: %h, Diff: %0d", 
                             input_samples[j], iir_out, error_diff);
                end
                bypass_samples_checked = bypass_samples_checked + 1;
            end else begin
                // In filter mode, compare with expected output
                error_diff = $signed(iir_out) - $signed(output_exp_samples[j]);
                abs_error_diff = (error_diff < 0) ? -error_diff : error_diff;
                
                // Check if error is within tolerance
                if (abs_error_diff > TOLERANCE) begin
                    mismatch_count = mismatch_count + 1;
                    filter_test_passed = 1'b0;
                    test_passed = 1'b0;
                    $display("[ERROR] Filter Sample %0d: Mismatch detected!", j);
                    $display("        Expected: %h (%f), Got: %h (%f), Diff: %0d", 
                             output_exp_samples[j], output_sig_exp, 
                             iir_out, iir_output_sig, error_diff);
                end
                
                // Track statistics
                total_error = total_error + abs_error_diff;
                if (abs_error_diff > max_error) begin
                    max_error = abs_error_diff;
                end
                samples_checked = samples_checked + 1;
            end
        end
    end

    // Monitor overflow/underflow
    always @(posedge clk) begin
        if (overflow) begin
            overflow_count = overflow_count + 1;
            $display("[WARNING] Overflow detected at sample %0d", j);
        end
        if (underflow) begin
            underflow_count = underflow_count + 1;
            $display("[WARNING] Underflow detected at sample %0d", j);
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            number_of_output_samples <= 0;
        end else if(valid_out) begin
            number_of_output_samples <= number_of_output_samples + 1;
        end
    end

    initial begin
        init();
        assert_reset();
        
        // Test 1: Bypass Mode
        $display("\n========================================");
        $display("TEST 1: BYPASS MODE");
        $display("========================================\n");
        test_bypass_mode();
        
        // Wait for outputs to complete
        wait(number_of_output_samples >= N_SAMPLES_I);
        repeat(10) @(posedge clk);
        
        // Reset for next test
        reset_counters();
        assert_reset();
        
        // Test 2: Filter Mode
        $display("\n========================================");
        $display("TEST 2: FILTER MODE");
        $display("========================================\n");
        test_filter_mode();
        
        // Wait for all samples to be processed
        wait(number_of_output_samples >= (2 * N_SAMPLES_I));
        repeat(10) @(posedge clk);
        
        // Generate final report
        generate_report();
        
        $stop;
    end

    task init ();
        if (IIR_NOTCH_FREQ == 0) begin
            filter_type = "1MHz Notch Filter";
            $display("========================================");
            $display("IIR Notch Filter Frequency: 1MHz");
            $display("========================================");

            $readmemb("input_5_1_wave.txt", input_samples);
            $readmemb("output_5_1_wave_exp.txt", output_exp_samples);
        end else if (IIR_NOTCH_FREQ == 1) begin
            filter_type = "2MHz Notch Filter";
            $display("========================================");
            $display("IIR Notch Filter Frequency: 2MHz");
            $display("========================================");
            
            $readmemb("input_5_2_wave.txt", input_samples);
            $readmemb("output_5_2_wave_exp.txt", output_exp_samples);
        end else if (IIR_NOTCH_FREQ == 2) begin
            filter_type = "2.4MHz Notch Filter";
            $display("========================================");
            $display("IIR Notch Filter Frequency: 2.4MHz");
            $display("========================================");
            
            $readmemb("input_2_4_wave.txt", input_samples);
            $readmemb("output_2_4_wave_exp.txt", output_exp_samples);
        end else begin
            $display("[ERROR] IIR Notch Filter Frequency: Unknown");
            $stop;
        end
        
        rst_n           = 1;
        valid_in        = 0;
        coeff_wr_en     = 0;
        bypass          = 0;
        for(int k = 0; k < 5; k++) begin
            coeff_in[k] = 0;
        end
        iir_in          = 0;  
        repeat (1) @(negedge clk);
    endtask

    task assert_reset ();
        $display("Asserting Reset...");
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
        repeat (2) @(negedge clk);
        $display("Reset Released.\n");
    endtask

    task reset_counters ();
        number_of_output_samples = 0;
        i = 0;
        j = 0;
    endtask

    task test_bypass_mode ();
        $display("Starting Bypass Mode Test...");
        bypass_mode = 1'b1;
        bypass      = 1'b1;
        valid_in    = 1'b1;
        rst_n       = 1'b1;
        i           = 0;

        repeat (N_SAMPLES_I) begin
            iir_in = input_samples[i];
            input_sig = $itor($signed(input_samples[i])) / 32768.0;
            
            i = i + 1;
            @(negedge clk);
        end
        
        valid_in = 0;
        $display("All samples processed in Bypass Mode.\n");
    endtask

    task test_filter_mode ();
        $display("Starting Filter Mode Test...");
        bypass_mode = 1'b0;
        bypass      = 1'b0;
        valid_in    = 1'b1;
        rst_n       = 1'b1;
        i           = 0;

        repeat (N_SAMPLES_I) begin
            iir_in = input_samples[i];
            input_sig = $itor($signed(input_samples[i])) / 32768.0;
            
            i = i + 1;
            @(negedge clk);
        end
        
        valid_in = 0;
        $display("All samples processed in Filter Mode.\n");
    endtask

    task generate_report ();
        real pass_percentage;
        real bypass_pass_percentage;
        
        $display("\n");
        $display("========================================");
        $display("    IIR FILTER TEST FINAL REPORT");
        $display("========================================");
        $display("Filter Type      : %s", filter_type);
        $display("Clock Frequency  : %0d Hz", FREQ_CLK);
        $display("Data Width       : %0d bits", DATA_WIDTH);
        $display("Coefficient Width: %0d bits", COEFF_WIDTH);
        $display("----------------------------------------");
        $display("TEST CONFIGURATION:");
        $display("  Total Samples      : %0d", N_SAMPLES_I);
        $display("  Tolerance          : %0d LSBs", TOLERANCE);
        $display("----------------------------------------");
        $display("BYPASS MODE RESULTS:");
        $display("  Samples Checked    : %0d", bypass_samples_checked);
        $display("  Mismatches         : %0d", bypass_mismatch_count);
        
        if (bypass_samples_checked > 0) begin
            bypass_pass_percentage = ((bypass_samples_checked - bypass_mismatch_count) * 100.0) / bypass_samples_checked;
            $display("  Pass Rate          : %0.2f%%", bypass_pass_percentage);
            
            if (bypass_test_passed) begin
                $display("  Status             : PASSED");
            end else begin
                $display("  Status             : FAILED");
            end
        end
        
        $display("----------------------------------------");
        $display("FILTER MODE RESULTS:");
        $display("  Samples Checked    : %0d", samples_checked);
        $display("  Mismatches         : %0d", mismatch_count);
        $display("  Overflow Count     : %0d", overflow_count);
        $display("  Underflow Count    : %0d", underflow_count);
        
        if (samples_checked > 0) begin
            avg_error = total_error / samples_checked;
            pass_percentage = ((samples_checked - mismatch_count) * 100.0) / samples_checked;
            
            $display("  Max Error          : %0d LSBs", max_error);
            $display("  Average Error      : %0.2f LSBs", avg_error);
            $display("  Pass Rate          : %0.2f%%", pass_percentage);
            
            if (filter_test_passed) begin
                $display("  Status             : PASSED ✓");
            end else begin
                $display("  Status             : FAILED ✗");
            end
        end else begin
            $display("  No samples checked!");
        end
        
        $display("----------------------------------------");
        $display("OVERALL TEST STATUS:");
        
        if (test_passed && bypass_test_passed && filter_test_passed) begin
            $display("  PASSED ");
            $display("  All tests completed successfully.");
        end else begin
            $display("  FAILED ");
            if (!bypass_test_passed) $display("  - Bypass mode test failed");
            if (!filter_test_passed) $display("  - Filter mode test failed");
        end
        
        $display("========================================\n");
    endtask

endmodule