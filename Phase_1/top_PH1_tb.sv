module top_tb ();

    // DUT Parameters
    parameter   DATA_WIDTH      = 16;
    parameter   DATA_FRAC       = 15;
    parameter   COEFF_WIDTH     = 20;
    parameter   COEFF_FRAC      = 18;
    parameter   N_TAP           = 72;
    parameter  NUM_COEFF_DEPTH  = 3 ;
    parameter  DEN_COEFF_DEPTH  = 2 ;

    // Testbench Parameters
    parameter  IIR_USED     = 3                         ;

    parameter N_SAMPLES_I   = 48000                     ;
    parameter FREQ_CLK      = 18_000_000                 ;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK  ;

    // Signals for monitoring output
    integer                     i                           = 0             ;
    integer                     j                           = 0             ;  // Skipped initial samples distortion due to filter settling
    integer                     number_of_output_samples    = 1             ;

    logic                               valid_out_tb  ;
    logic                               valid_in_tb   ;
    logic signed [DATA_WIDTH - 1 : 0]   filter_out_tb ;


    real                        input_sig                                   ;
    real                        ph1_output_sig                              ;
    real                        output_sig_exp                              ;

    logic [DATA_WIDTH - 1 : 0]  input_samples        [N_SAMPLES_I - 1 : 0]  ;
    logic [DATA_WIDTH - 1 : 0]  output_exp_samples   [N_SAMPLES_I - 1 : 0]  ;

    // DUT Signals
    logic                               clk                                                     ;
    logic                               rst_n                                                   ;
    logic                               valid_in                                                ;
    logic signed [DATA_WIDTH - 1 : 0]   ph1_chain_in                                            ;
    logic         			            frac_dec_coeff_wr_en                                    ;
    logic signed [COEFF_WIDTH - 1 : 0]   frac_dec_coeff_data_in     [N_TAP - 1 : 0]             ;
    logic                               iir_bypass_2_4                                          ;
    logic                               iir_bypass_2                                            ;
    logic                               iir_bypass_1                                            ;
    logic         			            iir_num_coeff_2_4_wr_en                                 ;
    logic         			            iir_den_coeff_2_4_wr_en                                 ;
    logic signed [COEFF_WIDTH - 1 : 0]  iir_num_coeff_2_4_in        [NUM_COEFF_DEPTH - 1 : 0]   ;
    logic signed [COEFF_WIDTH - 1 : 0]  iir_den_coeff_2_4_in        [DEN_COEFF_DEPTH - 1 : 0]   ;
    logic         			            iir_num_coeff_2_wr_en                                   ;
    logic         			            iir_den_coeff_2_wr_en                                   ;
    logic signed [COEFF_WIDTH - 1 : 0]  iir_num_coeff_2_in          [NUM_COEFF_DEPTH - 1 : 0]   ;
    logic signed [COEFF_WIDTH - 1 : 0]  iir_den_coeff_2_in          [DEN_COEFF_DEPTH - 1 : 0]   ;
    logic         			            iir_num_coeff_1_wr_en                                   ;
    logic         			            iir_den_coeff_1_wr_en                                   ;
    logic signed [COEFF_WIDTH - 1 : 0]  iir_num_coeff_1_in          [NUM_COEFF_DEPTH - 1 : 0]   ;
    logic signed [COEFF_WIDTH - 1 : 0]  iir_den_coeff_1_in          [DEN_COEFF_DEPTH - 1 : 0]   ;
    logic signed [DATA_WIDTH - 1 : 0]   ph1_chain_out                                           ;
    logic                               iir_overflow_2_4                                        ;
    logic                               iir_underflow_2_4                                       ;
    logic                               iir_overflow_2                                          ;
    logic                               iir_underflow_2                                         ;
    logic                               iir_overflow_1                                          ;
    logic                               iir_underflow_1                                         ;
    logic                               frac_dec_overflow                                       ;
    logic                               frac_dec_underflow                                      ;
    logic                               valid_out                                               ;

    FRAC_DEC_in_IIR_out #(
        .DATA_WIDTH   (DATA_WIDTH)  ,
        .DATA_FRAC    (DATA_FRAC)   ,
        .COEFF_WIDTH  (COEFF_WIDTH) ,
        .COEFF_FRAC   (COEFF_FRAC)  ,
        .N_TAP        (N_TAP)
    ) PHASE_1_DUT(
        .clk                     (clk)                      ,
        .rst_n                   (rst_n)                    ,
        .valid_in                (valid_in)                 ,
        .ph1_chain_in            (ph1_chain_in)             ,
        .frac_dec_coeff_wr_en    (frac_dec_coeff_wr_en)     ,
        .frac_dec_coeff_data_in  (frac_dec_coeff_data_in)   ,
        .iir_bypass_2_4          (iir_bypass_2_4)           ,
        .iir_bypass_2            (iir_bypass_2)             ,
        .iir_bypass_1            (iir_bypass_1)             ,
        .iir_num_coeff_2_4_wr_en (iir_num_coeff_2_4_wr_en)  ,
        .iir_den_coeff_2_4_wr_en (iir_den_coeff_2_4_wr_en)  ,
        .iir_num_coeff_2_4_in    (iir_num_coeff_2_4_in)     ,
        .iir_den_coeff_2_4_in    (iir_den_coeff_2_4_in)     ,
        .iir_num_coeff_2_wr_en   (iir_num_coeff_2_wr_en)    ,
        .iir_den_coeff_2_wr_en   (iir_den_coeff_2_wr_en)    ,
        .iir_num_coeff_2_in      (iir_num_coeff_2_in)       ,
        .iir_den_coeff_2_in      (iir_den_coeff_2_in)       ,
        .iir_num_coeff_1_wr_en   (iir_num_coeff_1_wr_en)    ,
        .iir_den_coeff_1_wr_en   (iir_den_coeff_1_wr_en)    ,
        .iir_num_coeff_1_in      (iir_num_coeff_1_in)       ,
        .iir_den_coeff_1_in      (iir_den_coeff_1_in)       ,
        .ph1_chain_out           (ph1_chain_out)            ,
        .iir_overflow_2_4        (iir_overflow_2_4)         ,
        .iir_underflow_2_4       (iir_underflow_2_4)        ,
        .iir_overflow_2          (iir_overflow_2)           ,
        .iir_underflow_2         (iir_underflow_2)          ,
        .iir_overflow_1          (iir_overflow_1)           ,
        .iir_underflow_1         (iir_underflow_1)          ,
        .frac_dec_overflow       (frac_dec_overflow)        ,
        .frac_dec_underflow      (frac_dec_underflow)       ,
        .valid_out               (valid_out)
    );

    initial begin
        clk = 0;
        forever #(T_CLK/2) clk = ~clk;
    end

    assign valid_out_tb = (IIR_USED == 0) ? PHASE_1_DUT.frac_dec_valid_out :
                          (IIR_USED == 1) ? PHASE_1_DUT.IIR_CHAIN_STAGE.valid_out_2_4 :
                          (IIR_USED == 2) ? PHASE_1_DUT.IIR_CHAIN_STAGE.valid_out_1 :
                          (IIR_USED == 3) ? valid_out : 1'b0;

    assign filter_out_tb =  (IIR_USED == 0) ? PHASE_1_DUT.frac_dec_out :
                            (IIR_USED == 1) ? PHASE_1_DUT.IIR_CHAIN_STAGE.iir_out_2_4MHz :
                            (IIR_USED == 2) ? PHASE_1_DUT.IIR_CHAIN_STAGE.iir_out_1MHz :
                            (IIR_USED == 3) ? ph1_chain_out : 1'b0;

    assign valid_in_tb   =  (IIR_USED == 0) ? valid_in :
                            (IIR_USED == 1) ? PHASE_1_DUT.IIR_CHAIN_STAGE.valid_out_2_4 :
                            (IIR_USED == 2) ? PHASE_1_DUT.IIR_CHAIN_STAGE.valid_out_1 :
                            (IIR_USED == 3) ? PHASE_1_DUT.IIR_CHAIN_STAGE.valid_out_1 : 1'b0;
 
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ph1_output_sig <= 0;
        end else if (valid_out_tb) begin
            ph1_output_sig <= $itor($signed(filter_out_tb)) / 32768.0;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_sig_exp <= 0;
        end else if (valid_out_tb) begin
            output_sig_exp <= $itor($signed(output_exp_samples[j])) / 32768.0;
            j = j + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            number_of_output_samples <= 1;
        end else if(valid_out_tb) begin
            number_of_output_samples <= number_of_output_samples + 1;
            $display("Sample %0d: Output = %b", number_of_output_samples, filter_out_tb);
        end
    end

    initial begin
        init();

        assert_reset();

        start_PH1();

        repeat (5) @(negedge clk);
        
        $stop;
    end

    task init ();
        $readmemb("input_wave.txt", input_samples);

        if(IIR_USED == 0) begin
            $readmemb("output_frac_wave_exp.txt", output_exp_samples);
        end else if (IIR_USED == 1) begin
            $readmemb("output_2_4_wave_exp.txt", output_exp_samples);
        end else if (IIR_USED == 2) begin
            $readmemb("output_5_1_wave_exp.txt", output_exp_samples);
        end else if (IIR_USED == 3) begin
            $readmemb("output_5_2_wave_exp.txt", output_exp_samples);
        end
        rst_n                   = 1;
        valid_in                = 0;
        ph1_chain_in            = 0;
        frac_dec_coeff_wr_en    = 0;
        frac_dec_coeff_data_in  = '{default:0};
        iir_bypass_2_4          = 0;
        iir_bypass_2            = 0;
        iir_bypass_1            = 0;
        iir_num_coeff_2_4_wr_en = 0;
        iir_den_coeff_2_4_wr_en = 0;
        iir_num_coeff_2_4_in    = '{default:0};
        iir_den_coeff_2_4_in    = '{default:0};
        iir_num_coeff_2_wr_en   = 0;
        iir_den_coeff_2_wr_en   = 0;
        iir_num_coeff_2_in      = '{default:0};
        iir_den_coeff_2_in      = '{default:0};
        iir_num_coeff_1_wr_en   = 0;
        iir_den_coeff_1_wr_en   = 0;
        iir_num_coeff_1_in      = '{default:0};
        iir_den_coeff_1_in      = '{default:0};
        
        repeat (1) @(negedge clk);
    endtask

    task assert_reset ();
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
    endtask

    task start_PH1 ();
        valid_in    = 1;
        rst_n       = 1;

        repeat (N_SAMPLES_I ) begin
            ph1_chain_in = input_samples[i];
            input_sig = $itor($signed(input_samples[i])) / 32768.0;
            
            i = i + 1;
            @(negedge clk);
        end

        @(negedge clk);
        valid_in   = 0;

    endtask

endmodule