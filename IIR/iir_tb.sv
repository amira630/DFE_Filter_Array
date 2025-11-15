module top_tb ();

    // IIR Parameters
    parameter   DATA_WIDTH      = 16    ;
    parameter   DATA_FRAC       = 15    ;
    parameter   COEFF_WIDTH     = 20    ;
    parameter   COEFF_FRAC      = 18    ;
    parameter   IIR_NOTCH_FREQ  = 0     ;// 0: 1MHz, 1: 2MHz, 2:2.4MHz

    // Testbench Parameters
    parameter N_SAMPLES_I   = 32000                     ;
    parameter FREQ_CLK      = 18_000_000                ;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK  ;

    // IIR Signals
    logic                               clk                         ;
    logic                               rst_n                       ;
    logic                               valid_in                    ;
    logic                               bypass                      ;
    logic         			            num_coeff_wr_en             ;
    logic         			            den_coeff_wr_en             ;
    logic signed [COEFF_WIDTH - 1 : 0]  num_coeff_in        [2 : 0] ;
    logic signed [COEFF_WIDTH - 1 : 0]  den_coeff_in        [1 : 0] ;
    logic signed [DATA_WIDTH - 1 : 0]   iir_in                      ;
    logic signed [DATA_WIDTH - 1 : 0]   iir_out                     ;
    logic                               overflow                    ;
    logic                               underflow                   ;
    logic                               valid_out                   ;
    
    // Signals for monitoring output
    integer                     i                           = 0             ;
    integer                     j                           = 0             ;  // Skipped initial samples distortion due to filter settling
    integer                     number_of_output_samples    = 0             ;

    real                        input_sig                                   ;
    real                        iir_output_sig                             ;
    real                        output_sig_exp                              ;

    logic [DATA_WIDTH - 1 : 0]  input_samples        [N_SAMPLES_I - 1 : 0]  ;
    logic [DATA_WIDTH - 1 : 0]  output_exp_samples   [N_SAMPLES_I - 1 : 0]  ;

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
        .num_coeff_wr_en  (num_coeff_wr_en) ,
        .den_coeff_wr_en  (den_coeff_wr_en) ,
        .num_coeff_in     (num_coeff_in)    ,
        .den_coeff_in     (den_coeff_in)    ,
        .iir_in           (iir_in)          ,
        .iir_out          (iir_out)         ,
        .overflow         (overflow)        ,
        .underflow        (underflow)       ,
        .valid_out        (valid_out)
    );

    // zarta DUT(
    //     .clk(clk),
    //     .clk_enable(valid_in),
    //     .reset(rst_n),
    //     .filter_in(iir_in),
    //     .filter_out(iir_out)
    // );

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
        end else if (valid_out) begin
            output_sig_exp <= $itor($signed(output_exp_samples[j])) / 32768.0;
            j = j + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            number_of_output_samples <= 0;
        end else if(valid_out) begin
            number_of_output_samples <= number_of_output_samples + 1;
            $display("Sample %0d: Output = %b", number_of_output_samples, iir_out);
        end
    end

    initial begin
        init();

        assert_reset();

        start_iir();
        
        $stop;
    end

    task init ();
        if (IIR_NOTCH_FREQ == 0) begin
            $display("IIR Notch Filter Frequency: 1MHz");

            $readmemb("input_5_1_wave.txt", input_samples);
            $readmemb("output_5_1_wave_exp.txt", output_exp_samples);
        end else if (IIR_NOTCH_FREQ == 1) begin
            $display("IIR Notch Filter Frequency: 2MHz");
            
            $readmemb("input_5_2_wave.txt", input_samples);
            $readmemb("output_5_2_wave_exp.txt", output_exp_samples);
        end else if (IIR_NOTCH_FREQ == 2) begin
            $display("IIR Notch Filter Frequency: 2.4MHz");
            
            $readmemb("input_2_4_wave.txt", input_samples);
            $readmemb("output_2_4_wave_exp.txt", output_exp_samples);
        end else begin
            $display("IIR Notch Filter Frequency: Unknown");
            $stop;
        end
        
        rst_n           = 1;
        valid_in        = 0;
        num_coeff_wr_en = 0;
        den_coeff_wr_en = 0;
        bypass          = 0;
        for(int k = 0; k < 3; k++) begin
            num_coeff_in[k] = 0;
        end
        for(int k = 0; k < 2; k++) begin
            den_coeff_in[k] = 0;
        end
        iir_in       = 0;  
        repeat (1) @(negedge clk);
    endtask

    task assert_reset ();
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
    endtask

    task start_iir ();
        valid_in    = 1;
        rst_n       = 1;

        repeat (N_SAMPLES_I ) begin
            iir_in = input_samples[i];
            input_sig = $itor($signed(input_samples[i])) / 32768.0;
            
            i = i + 1;
            @(negedge clk);
        end
    endtask

endmodule