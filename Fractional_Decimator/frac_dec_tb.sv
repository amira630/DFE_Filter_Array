module top_tb ();

    // Fractional Decimator Parameters
    parameter   DATA_WIDTH      = 16  ;
    parameter   DATA_FRAC       = 15  ;
    parameter   COEFF_WIDTH     = 20  ;
    parameter   COEFF_FRAC      = 18  ;
    parameter   M               = 3   ;
    parameter   N_TAP           = 72  ;

    // Testbench Parameters
    parameter N_SAMPLES_I   = 48000                     ;
    parameter FREQ_CLK      = 18_000_000                ;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK  ;

    // Fractional Decimator Signals
    logic                                clk                             ;
    logic                                valid_in                        ;
    logic                                rst_n                           ;
    logic         			             coeff_wr_en                     ;
    logic signed [COEFF_WIDTH - 1 : 0]   coeff_data_in  [N_TAP - 1 : 0]  ;
    logic signed [DATA_WIDTH - 1 : 0]    filter_in                       ;
    logic signed [DATA_WIDTH - 1 : 0]    filter_out                      ;
    logic                                overflow                        ;
    logic                                underflow                       ;
    logic                                valid_out                       ;
    logic                                ce_out                          ;

    // Signals for monitoring output
    integer                     i                           = 0             ;
    integer                     j                           = 0             ;  // Skipped initial samples distortion due to filter settling
    integer                     number_of_output_samples    = 0             ;

    real                        input_sig                                   ;
    real                        frac_output_sig                             ;
    real                        output_sig_exp                              ;

    logic [DATA_WIDTH - 1 : 0]  input_samples        [N_SAMPLES_I - 1 : 0]  ;
    logic [DATA_WIDTH - 1 : 0]  output_exp_samples   [N_SAMPLES_I - 1 : 0]  ;

    fractional_decimator #(
        .DATA_WIDTH  (DATA_WIDTH)       ,
        .DATA_FRAC   (DATA_FRAC)        ,
        .COEFF_WIDTH (COEFF_WIDTH)      ,
        .COEFF_FRAC  (COEFF_FRAC)       ,
        .M           (M)                ,
        .N_TAP       (N_TAP)            
    ) fractional_Decimator (
        .clk           (clk)            ,
        .valid_in      (valid_in)       ,
        .rst_n         (rst_n)          ,
        .coeff_wr_en   (coeff_wr_en)    ,
        .coeff_data_in (coeff_data_in)  ,
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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            number_of_output_samples <= 0;
        end else if(valid_out) begin
            number_of_output_samples <= number_of_output_samples + 1;
            $display("Sample %0d: Output = %b", number_of_output_samples, filter_out);
        end
    end

    initial begin
        init();

        assert_reset();

        start_frac_dec();

        repeat (5) @(negedge clk);
        
        $stop;
    end

    task init ();
        $readmemb("input_wave.txt", input_samples);
        $readmemb("output_wave_exp.txt", output_exp_samples);
        rst_n           = 1;
        valid_in        = 0;
        coeff_wr_en     = 0;
        for(int k = 0; k < N_TAP; k++) begin
            coeff_data_in[k] = 0;
        end
        filter_in       = 0;  
        repeat (1) @(negedge clk);
    endtask

    task assert_reset ();
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
    endtask

    task start_frac_dec ();
        valid_in    = 1;
        rst_n       = 1;

        repeat (N_SAMPLES_I ) begin
            filter_in = input_samples[i];
            input_sig = $itor($signed(input_samples[i])) / 32768.0;
            
            i = i + 1;
            @(negedge clk);
        end

        @(negedge clk);

        valid_in = 0;
    endtask

endmodule