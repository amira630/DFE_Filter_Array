module top_tb ();

    parameter N_TAPS = 71;
    parameter DATA_WIDTH = 16;
    parameter DATA_FRAC = 15;
    parameter COEFF_WIDTH = 20;
    parameter COEFF_FRAC = 18;
    parameter PRODUCT_WIDTH = 35;
    parameter PRODUCT_FRAC = 32;
    parameter ACC_WIDTH = 42;
    parameter ACC_FRAC = 32;

    parameter N_SAMPLES_I     = 48000;

    parameter FREQ_CLK      = 9_000_000;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK;

    logic                               clk         ;
    logic                               rst_n       ;
    logic signed [DATA_WIDTH - 1 : 0]   fir_in      ;
    logic                               valid_in    ;
    logic signed [DATA_WIDTH - 1 : 0]   fir_out     ;
    logic                               valid_out   ;
    logic                               underflow   ;
    logic                               overflow    ;
    
    logic [DATA_WIDTH - 1 : 0] input_samples [N_SAMPLES_I - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] output_exp_samples [N_SAMPLES_I - 1 : 0];
    
    logic done = 0;
    logic done_reg = 0;

    integer i = 0;
    integer j = 0;
    
    integer number_of_output_samples = 0;

    real input_sig;
    real output_sig;
    real output_sig_exp;
    
    FIR_Filter #(
        .N_TAPS         (N_TAPS       ),
        .DATA_WIDTH     (DATA_WIDTH   ),
        .DATA_FRAC      (DATA_FRAC    ),
        .COEFF_WIDTH    (COEFF_WIDTH  ),
        .COEFF_FRAC     (COEFF_FRAC   ),
        .PRODUCT_WIDTH  (PRODUCT_WIDTH),
        .PRODUCT_FRAC   (PRODUCT_FRAC ),
        .ACC_WIDTH      (ACC_WIDTH    ),
        .ACC_FRAC       (ACC_FRAC     )
    ) DUT (
        .clk        (clk)         ,
        .rst_n      (rst_n)       ,
        .fir_in     (fir_in)      ,
        .valid_in   (valid_in)    ,
        .fir_out    (fir_out)     ,
        .valid_out  (valid_out)   ,
        .underflow  (underflow)   ,
        .overflow   (overflow)
    );

    initial begin
        clk = 0;
        forever #(T_CLK/2) clk = ~clk;
    end
   
    // Output monitoring - sequential logic  
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_sig <= 0;
        end else if (valid_in) begin
            output_sig <= $itor($signed(fir_out)) / 32768.0;
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
        end else if((done_reg == 0)) begin
            done_reg <= done;
            number_of_output_samples <= number_of_output_samples + 1;
            $display("Sample %0d: Output = %b", number_of_output_samples, fir_out);
        end
    end

    initial begin
        init();

        assert_reset();

        start_fir();

        repeat (5) @(negedge clk);
        
        $stop;
    end

    task init ();
        $readmemb("input_wave.txt", input_samples);
        $readmemb("output_wave_exp.txt", output_exp_samples);
        rst_n   = 1;
        fir_in  = 0;
        valid_in= 0;
        repeat (1) @(negedge clk);
    endtask

    task assert_reset ();
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
    endtask

    task start_fir ();
        valid_in    = 1;
        rst_n         = 1;

        repeat (N_SAMPLES_I ) begin
            fir_in = input_samples[i];
            input_sig = $itor($signed(input_samples[i])) / 32768.0;
            
            i = i + 1;
            @(negedge clk);
        end

        done = 1;
        // repeat (N_SAMPLES_I) @(negedge clk);
    endtask

endmodule