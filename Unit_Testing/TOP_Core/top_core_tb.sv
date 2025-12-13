module top_tb ();

    parameter   DATA_WIDTH      = 16        ;
    parameter   DATA_FRAC       = 15        ;
    parameter   COEFF_WIDTH     = 20        ;
    parameter   COEFF_FRAC      = 18        ;
    parameter   N_TAP           = 72        ;
    parameter   Q = 1                       ;
    parameter   N = 1                       ;

    localparam MAX_DEC_FACTOR = 16;
    localparam DEC_WIDTH = $clog2(MAX_DEC_FACTOR);
    

    parameter N_SAMPLES_I     = 48000;

    parameter FREQ_CLK      = 9_000_000;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK;

    logic                                clk                                                ;
    logic                                valid_in                                           ;
    logic                                rst_n                                              ;
    logic signed [DATA_WIDTH - 1 : 0]    core_in                                            ;
    logic                                valid_out                                          ;
    logic                                overflow                                           ;
    logic                                underflow                                          ;
    logic signed [DATA_WIDTH - 1 : 0]    core_out                                           ;
    logic                                frac_dec_bypass                                    ;
    logic                                frac_dec_overflow                                  ;
    logic                                frac_dec_underflow                                 ;
    logic signed [DATA_WIDTH - 1 : 0]    frac_dec_out                                       ;
    logic                                frac_dec_valid_out                                 ;
    logic                                iir_bypass_5MHz                                    ;
    logic                                iir_overflow_1MHz                                  ;
    logic                                iir_underflow_1MHz                                 ;
    logic                                iir_overflow_2MHz                                  ;
    logic                                iir_underflow_2MHz                                 ;
    logic                                iir_bypass_2_4MHz                                  ;
    logic                                iir_overflow_2_4MHz                                ;
    logic                                iir_underflow_2_4MHz                               ;
    logic signed [DATA_WIDTH - 1 : 0]    iir_out                                            ;
    logic                                iir_valid_out                                      ;
    logic                                cic_bypass                                         ;
    logic        [DEC_WIDTH : 0]         cic_dec_factor                                     ;
    logic                                cic_overflow                                       ;
    logic                                cic_underflow                                      ;   
    
    logic signed [DATA_WIDTH - 1 : 0] input_samples [N_SAMPLES_I - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_0000_D2_exp  [16000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_0001_D2_exp  [16000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_0010_D2_exp  [16000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_0011_D2_exp  [16000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_0100_D4_exp  [8000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_0101_D4_exp  [8000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_0110_D4_exp  [8000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_0111_D4_exp  [8000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_1000_D8_exp  [6000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_1001_D8_exp  [6000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_1010_D8_exp  [6000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_1011_D8_exp  [6000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_1100_D16_exp [3000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_1101_D16_exp [3000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_1110_D16_exp [3000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] output_1111_D16_exp [3000 - 1 : 0];
    logic signed [DATA_WIDTH - 1 : 0] test [10666 - 1 : 0];

    integer i = 0;
    integer j = 0;
  
    real input_sig;
    real iir_out_sig ;
    real frac_out_sig;
    real core_out_sig;
    real core_out_sig_exp;
    
    core CORE_DUT(
        .clk                    (clk),
        .valid_in               (valid_in),
        .rst_n                  (rst_n),
        .core_in                (core_in),
        .overflow               (overflow),
        .underflow              (underflow),
        .valid_out              (valid_out),
        .core_out               (core_out),
        .frac_dec_bypass        (frac_dec_bypass) ,
        .frac_dec_coeff_wr_en   (),
        .frac_dec_coeff_data_in (),
        .frac_dec_coeff_data_out(),
        .frac_dec_overflow      (frac_dec_overflow),
        .frac_dec_underflow     (frac_dec_underflow),
        .frac_dec_out           (frac_dec_out),
        .frac_dec_valid_out     (frac_dec_valid_out),
        .iir_bypass_5MHz        (iir_bypass_5MHz),
        .iir_coeff_wr_en_1MHz   (),
        .iir_coeff_in_1MHz      (),
        .iir_coeff_out_1MHz     (),
        .iir_overflow_1MHz      (iir_overflow_1MHz),
        .iir_underflow_1MHz     (iir_underflow_1MHz),
        .iir_coeff_wr_en_2MHz   (),
        .iir_coeff_in_2MHz      (),
        .iir_coeff_out_2MHz     (),
        .iir_overflow_2MHz      (iir_overflow_2MHz),
        .iir_underflow_2MHz     (iir_underflow_2MHz),
        .iir_bypass_2_4MHz      (iir_bypass_2_4MHz), 
        .iir_coeff_wr_en_2_4MHz (),
        .iir_coeff_in_2_4MHz    (),
        .iir_coeff_out_2_4MHz   (),
        .iir_overflow_2_4MHz    (iir_overflow_2_4MHz),
        .iir_underflow_2_4MHz   (iir_underflow_2_4MHz),
        .iir_out                (iir_out),
        .iir_valid_out          (iir_valid_out) ,
        .cic_bypass             (cic_bypass),
        .cic_dec_factor         (cic_dec_factor),
        .cic_overflow           (cic_overflow),
        .cic_underflow          (cic_underflow)

    );

    initial begin
        clk = 0;
        forever #(T_CLK/2) clk = ~clk;
    end
   
    // Output monitoring - sequential logic  
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            iir_out_sig <= 0;
            frac_out_sig <=0;
            core_out_sig <=0;
        end else if (valid_in) begin
            iir_out_sig <=  $itor($signed(iir_out)) / 32768.0;
            frac_out_sig <= $itor($signed(frac_dec_out)) / 32768.0;
            core_out_sig <= $itor($signed(core_out)) / 32768.0;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            j <= 0;
            core_out_sig_exp <= 0;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (valid_out) begin
            //core_out_sig_exp <= $itor($signed(output_0000_D2_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_0001_D2_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_0010_D2_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_0011_D2_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_0100_D4_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_0101_D4_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_0110_D4_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_0111_D4_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_1000_D8_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_1001_D8_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_1010_D8_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_1011_D8_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_1100_D16_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_1101_D16_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_1110_D16_exp[j])) / 32768.0;
            //core_out_sig_exp <= $itor($signed(output_1111_D16_exp[j])) / 32768.0;
            core_out_sig_exp <= $itor($signed(test[j])) / 32768.0;

            j = j + 1;
        end
    end

    always_ff @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            core_in <= 0;
            input_sig <= 0;
            valid_in <= 0;
            i <= 0;
        end else begin
            valid_in <= 1;
            core_in <= input_samples[i];
            input_sig <= $itor($signed(input_samples[i])) / 32768.0;
            if (i == (N_SAMPLES_I - 1)) begin
                i <= 0;
            end else begin
                i <= i + 1;
            end
        end
    end

    initial begin
        init();

        assert_reset();

        frac_dec_bypass        = 0;
        iir_bypass_2_4MHz      = 0;
        iir_bypass_5MHz        = 0;
        cic_bypass             = 0;
        cic_dec_factor         = 2;
        repeat (N_SAMPLES_I) @(negedge clk);

        // frac_dec_bypass        = 0;
        // iir_bypass_2_4MHz      = 0;
        // iir_bypass_5MHz        = 0;
        // cic_bypass             = 1;
        // cic_dec_factor         = 2;
        // repeat (N_SAMPLES_I) @(negedge clk);

        // frac_dec_bypass        = 0;
        // iir_bypass_2_4MHz      = 0;
        // iir_bypass_5MHz        = 1;
        // cic_bypass             = 0;
        // cic_dec_factor         = 2;
        // repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 0;
        //iir_bypass_2_4MHz      = 0;
        //iir_bypass_5MHz        = 1;
        //cic_bypass             = 1;
        //cic_dec_factor         = 2;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 0;
        //iir_bypass_2_4MHz      = 1;
        //iir_bypass_5MHz        = 0;
        //cic_bypass             = 0;
        //cic_dec_factor         = 4;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 0;
        //iir_bypass_2_4MHz      = 1;
        //iir_bypass_5MHz        = 0;
        //cic_bypass             = 1;
        //cic_dec_factor         = 4;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 0;
        //iir_bypass_2_4MHz      = 1;
        //iir_bypass_5MHz        = 1;
        //cic_bypass             = 0;
        //cic_dec_factor         = 4;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 0;
        //iir_bypass_2_4MHz      = 1;
        //iir_bypass_5MHz        = 1;
        //cic_bypass             = 1;
        //cic_dec_factor         = 4;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 1;
        //iir_bypass_2_4MHz      = 0;
        //iir_bypass_5MHz        = 0;
        //cic_bypass             = 0;
        //cic_dec_factor         = 8;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 1;
        //iir_bypass_2_4MHz      = 0;
        //iir_bypass_5MHz        = 0;
        //cic_bypass             = 1;
        //cic_dec_factor         = 8;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 1;
        //iir_bypass_2_4MHz      = 0;
        //iir_bypass_5MHz        = 1;
        //cic_bypass             = 0;
        //cic_dec_factor         = 8;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 1;
        //iir_bypass_2_4MHz      = 0;
        //iir_bypass_5MHz        = 1;
        //cic_bypass             = 1;
        //cic_dec_factor         = 8;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 1;
        //iir_bypass_2_4MHz      = 1;
        //iir_bypass_5MHz        = 0;
        //cic_bypass             = 0;
        //cic_dec_factor         = 16;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 1;
        //iir_bypass_2_4MHz      = 1;
        //iir_bypass_5MHz        = 0;
        //cic_bypass             = 1;
        //cic_dec_factor         = 16;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 1;
        //iir_bypass_2_4MHz      = 1;
        //iir_bypass_5MHz        = 1;
        //cic_bypass             = 0;
        //cic_dec_factor         = 16;
        //repeat (N_SAMPLES_I) @(negedge clk);

        //frac_dec_bypass        = 1;
        //iir_bypass_2_4MHz      = 1;
        //iir_bypass_5MHz        = 1;
        //cic_bypass             = 1;
        //cic_dec_factor         = 16;
        //repeat (N_SAMPLES_I) @(negedge clk);

        repeat (5) @(negedge clk);
        
        $stop;
    end

    task init ();
        $readmemb("input_wave.txt", input_samples);
        $readmemb("output_0000_D2_exp.txt"  ,   output_0000_D2_exp      );
        $readmemb("output_0001_D2_exp.txt"  ,   output_0001_D2_exp      );
        $readmemb("output_0010_D2_exp.txt"  ,   output_0010_D2_exp      );
        $readmemb("output_0011_D2_exp.txt"  ,   output_0011_D2_exp      );
        $readmemb("output_0100_D4_exp.txt"  ,   output_0100_D4_exp      );
        $readmemb("output_0101_D4_exp.txt"  ,   output_0101_D4_exp      );
        $readmemb("output_0110_D4_exp.txt"  ,   output_0110_D4_exp      );
        $readmemb("output_0111_D4_exp.txt"  ,   output_0111_D4_exp      );
        $readmemb("output_1000_D8_exp.txt"  ,   output_1000_D8_exp      );
        $readmemb("output_1001_D8_exp.txt"  ,   output_1001_D8_exp      );
        $readmemb("output_1010_D8_exp.txt"  ,   output_1010_D8_exp      );
        $readmemb("output_1011_D8_exp.txt"  ,   output_1011_D8_exp      );
        $readmemb("output_1100_D16_exp.txt" ,   output_1100_D16_exp     );
        $readmemb("output_1101_D16_exp.txt" ,   output_1101_D16_exp     );
        $readmemb("output_1110_D16_exp.txt" ,   output_1110_D16_exp     );
        $readmemb("output_1111_D16_exp.txt" ,   output_1111_D16_exp     );
        $readmemb("output_frac.txt", test);
        valid_in               = 0;
        rst_n                  = 1;
        core_in                = 0;
        frac_dec_bypass        = 0;
        iir_bypass_5MHz        = 0;
        iir_bypass_2_4MHz      = 0;
        cic_bypass             = 0;
        cic_dec_factor         = 4;
        
        repeat (1) @(negedge clk);
    endtask

    task assert_reset ();
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
    endtask

endmodule