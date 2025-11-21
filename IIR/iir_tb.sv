module top_tb ();

    // IIR Chain Parameters
    parameter   DATA_WIDTH      = 16    ;
    parameter   DATA_FRAC       = 15    ;
    parameter   COEFF_WIDTH     = 20    ;
    parameter   COEFF_FRAC      = 18    ;
    parameter   COEFF_DEPTH     = 5     ;

    // Testbench Parameters
    parameter N_SAMPLES_I   = 32000                     ;
    parameter FREQ_CLK      = 6_000_000                 ;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK  ;

    // IIR Chain Signals
    logic                               clk             ;
    logic                               rst_n           ;
    logic                               valid_in        ;
    logic signed [DATA_WIDTH - 1 : 0]   iir_in          ;
    logic signed [DATA_WIDTH - 1 : 0]   iir_out         ;
    logic                               valid_out       ;
    
    // 1MHz Notch Filter signals
    logic                               bypass_1MHz                             ;
    logic                               coeff_wr_en_1MHz                        ;
    logic signed [COEFF_WIDTH - 1 : 0]  coeff_in_1MHz    [COEFF_DEPTH - 1 : 0] ;
    logic signed [COEFF_WIDTH - 1 : 0]  coeff_out_1MHz   [COEFF_DEPTH - 1 : 0] ;
    logic                               overflow_1MHz                           ;
    logic                               underflow_1MHz                          ;
    
    // 2MHz Notch Filter signals
    logic                               bypass_2MHz                             ;
    logic                               coeff_wr_en_2MHz                        ;
    logic signed [COEFF_WIDTH - 1 : 0]  coeff_in_2MHz    [COEFF_DEPTH - 1 : 0] ;
    logic signed [COEFF_WIDTH - 1 : 0]  coeff_out_2MHz   [COEFF_DEPTH - 1 : 0] ;
    logic                               overflow_2MHz                           ;
    logic                               underflow_2MHz                          ;
    
    // 2.4MHz Notch Filter signals
    logic                               bypass_2_4MHz                           ;
    logic                               coeff_wr_en_2_4MHz                      ;
    logic signed [COEFF_WIDTH - 1 : 0]  coeff_in_2_4MHz  [COEFF_DEPTH - 1 : 0] ;
    logic signed [COEFF_WIDTH - 1 : 0]  coeff_out_2_4MHz [COEFF_DEPTH - 1 : 0] ;
    logic                               overflow_2_4MHz                         ;
    logic                               underflow_2_4MHz                        ;
    
    // Signals for monitoring output
    integer                     i                           = 0             ;
    integer                     j                           = 0             ;
    integer                     output_sample_index         = 0             ;
    integer                     input_sample_index              = 0             ;
    integer                     number_of_output_samples    = 1             ;

    real                        input_sig                                   ;
    real                        iir_output_sig                              ;
    real                        output_sig_exp                              ;
    real                        output_sig_exp_reg                              ;

    logic signed [DATA_WIDTH - 1 : 0]  input_samples        [N_SAMPLES_I - 1 : 0]       ;
    logic signed [DATA_WIDTH - 1 : 0]  output_B5_exp_samples   [N_SAMPLES_I - 1 : 0]    ;
    logic signed [DATA_WIDTH - 1 : 0]  output_B2_4_exp_samples   [N_SAMPLES_I - 1 : 0]  ;
    logic signed [DATA_WIDTH - 1 : 0]  output_exp_samples   [N_SAMPLES_I - 1 : 0]       ;

    // DUT instantiation
    IIR_chain #(
        .DATA_WIDTH  (DATA_WIDTH),
        .DATA_FRAC   (DATA_FRAC),
        .COEFF_WIDTH (COEFF_WIDTH),
        .COEFF_FRAC  (COEFF_FRAC)
    ) DUT (
        .clk                (clk),
        .rst_n              (rst_n),
        .valid_in           (valid_in),
        .iir_in             (iir_in),
        .iir_out            (iir_out),
        .valid_out          (valid_out),
        .bypass_1MHz        (bypass_1MHz),
        .coeff_wr_en_1MHz   (coeff_wr_en_1MHz),
        .coeff_in_1MHz      (coeff_in_1MHz),
        .coeff_out_1MHz     (coeff_out_1MHz),
        .overflow_1MHz      (overflow_1MHz),
        .underflow_1MHz     (underflow_1MHz),
        .bypass_2MHz        (bypass_2MHz),
        .coeff_wr_en_2MHz   (coeff_wr_en_2MHz),
        .coeff_in_2MHz      (coeff_in_2MHz),
        .coeff_out_2MHz     (coeff_out_2MHz),
        .overflow_2MHz      (overflow_2MHz),
        .underflow_2MHz     (underflow_2MHz),
        .bypass_2_4MHz      (bypass_2_4MHz),
        .coeff_wr_en_2_4MHz (coeff_wr_en_2_4MHz),
        .coeff_in_2_4MHz    (coeff_in_2_4MHz),
        .coeff_out_2_4MHz   (coeff_out_2_4MHz),
        .overflow_2_4MHz    (overflow_2_4MHz),
        .underflow_2_4MHz   (underflow_2_4MHz)
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
            output_sig_exp_reg <= 0;
            output_sample_index <= 0;
        end else if (valid_out) begin
            // Account for pipeline delay - start comparing after pipeline fills
            if (bypass_1MHz && bypass_2MHz && !bypass_2_4MHz) begin
                output_sig_exp <= $itor($signed(output_B5_exp_samples[output_sample_index + 1])) / 32768.0;
            end else if (!bypass_1MHz && !bypass_2MHz && bypass_2_4MHz) begin
                output_sig_exp <= $itor($signed(output_B2_4_exp_samples[output_sample_index])) / 32768.0;
            end else if (bypass_1MHz && bypass_2MHz && bypass_2_4MHz) begin
                output_sig_exp_reg <= $itor($signed(input_samples[input_sample_index])) / 32768.0;
                output_sig_exp <= output_sig_exp_reg;
            end else begin
                output_sig_exp_reg <= $itor($signed(output_exp_samples[output_sample_index])) / 32768.0;
                output_sig_exp <= output_sig_exp_reg;
            end

            if (output_sample_index == N_SAMPLES_I - 1) begin
                output_sample_index <= 0;
            end else begin
                output_sample_index <= output_sample_index + 1; 
            end
            
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            input_sample_index <= 0;
            input_sig <= 0;
            iir_in <= 0;
        end else if (valid_in) begin
            iir_in <= input_samples[input_sample_index];

            input_sig <= $itor($signed(input_samples[input_sample_index])) / 32768.0;

            if (input_sample_index == N_SAMPLES_I - 1) begin
                input_sample_index <= 0;
            end else begin
                input_sample_index <= input_sample_index + 1; 
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            number_of_output_samples <= 0;
        end else if(valid_out) begin
            number_of_output_samples <= number_of_output_samples + 1;
        end
    end

    // Main test sequence
    initial begin
        init();


        assert_reset();

        valid_in = 1'b1;

        bypass_1MHz = 1'b0;
        bypass_2MHz = 1'b0;
        bypass_2_4MHz = 1'b0;
        repeat(N_SAMPLES_I) @(negedge clk);

        bypass_1MHz = 1'b1;
        bypass_2MHz = 1'b1;
        bypass_2_4MHz = 1'b0;
        repeat(N_SAMPLES_I) @(negedge clk);

        bypass_1MHz = 1'b0;
        bypass_2MHz = 1'b0;
        bypass_2_4MHz = 1'b1;
        repeat(N_SAMPLES_I) @(negedge clk);

        bypass_1MHz = 1'b1;
        bypass_2MHz = 1'b1;
        bypass_2_4MHz = 1'b1;
        repeat(N_SAMPLES_I) @(negedge clk);

        repeat (100) begin
            bypass_1MHz = $random;
            bypass_2MHz = bypass_1MHz;
            bypass_2_4MHz = $random;
            repeat(16000) @(negedge clk);
        end
     
        
        $display("\n========================================");
        $display("ALL TESTS COMPLETED");
        $display("========================================\n");
        
        $stop;
    end

    task init ();
        $display("========================================");
        $display("IIR CHAIN TESTBENCH");
        $display("========================================");
        $display("Chain Configuration:");
        $display("  - 1MHz Notch Filter");
        $display("  - 2MHz Notch Filter");
        $display("  - 2.4MHz Notch Filter");
        $display("========================================");

        $readmemb("input_wave.txt", input_samples);
        $readmemb("output_B5_wave_exp.txt", output_B5_exp_samples);
        $readmemb("output_B2_4_wave_exp.txt", output_B2_4_exp_samples);
        $readmemb("output_wave_exp.txt", output_exp_samples);
        
        rst_n           = 1;
        valid_in        = 0;
        coeff_wr_en_1MHz   = 0;
        coeff_wr_en_2MHz   = 0;
        coeff_wr_en_2_4MHz = 0;
        bypass_1MHz     = 0;
        bypass_2MHz     = 0;
        bypass_2_4MHz   = 0;
        
        for(int k = 0; k < COEFF_DEPTH; k++) begin
            coeff_in_1MHz[k]   = 0;
            coeff_in_2MHz[k]   = 0;
            coeff_in_2_4MHz[k] = 0;
        end
        repeat (1) @(negedge clk);
    endtask

    task assert_reset ();
        $display("Asserting Reset...");
        rst_n = 0;
        repeat (2) @(negedge clk);
        rst_n = 1;
        repeat (2) @(negedge clk);
        $display("Reset Released.\n");
    endtask

    task reset_counters ();
        number_of_output_samples = 0;
        i = 0;
        output_sample_index = 0;
        input_sample_index = 0;
    endtask
endmodule