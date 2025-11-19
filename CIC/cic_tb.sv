module top_tb ();

    // DUT Parameters
    parameter DATA_WIDTH = 16;
    parameter DATA_FRAC  = 15;
    parameter Q = 1;
    parameter N = 1;

    // Testbench Parameters
    localparam MAX_DEC_FACTOR = 16;
    localparam DEC_WIDTH = $clog2(MAX_DEC_FACTOR);

    parameter N_SAMPLES_I   = 32000                     ;
    parameter FREQ_CLK      = 18_000_000                ;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK  ;

    // Signals for monitoring output
    integer                     i                                           ;
    integer                     j                                           ;  // Skipped initial samples distortion due to filter settling
    integer                     number_of_output_samples                    ;

    real                        input_sig                                   ;
    real                        output_sig                                  ;
    real                        output_sig_exp                              ;

    logic [DATA_WIDTH - 1 : 0]  input_samples        [N_SAMPLES_I - 1 : 0]  ;
    logic [DATA_WIDTH - 1 : 0]  output_exp_samples   [N_SAMPLES_I - 1 : 0]  ;

    // DUT Signals
    logic                           clk         ;
    logic                           rst_n       ;
    logic                           valid_in    ;
    logic        [DEC_WIDTH : 0]    dec_factor  ;
    logic signed [DATA_WIDTH-1:0]   cic_in      ;
    logic signed [DATA_WIDTH-1:0]   cic_out     ;
    logic                           valid_out   ;
    logic                           overflow    ;
    logic                           underflow   ;

    CIC #(
        .DATA_WIDTH(DATA_WIDTH) , 
        .DATA_FRAC(DATA_FRAC)  ,
        .Q(Q) , 
        .N(N)
    ) DUT (
        .clk        (clk)         ,
        .rst_n      (rst_n)       ,
        .valid_in   (valid_in)    ,
        .dec_factor (dec_factor)  ,  
        .cic_in     (cic_in)      ,
        .cic_out    (cic_out)     ,
        .valid_out  (valid_out)   ,   
        .overflow   (overflow)    ,
        .underflow  (underflow) 

    );

    initial begin
        clk = 0;
        forever #(T_CLK/2) clk = ~clk;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_sig <= 0;
        end else if (valid_out) begin
            output_sig <= $itor($signed(cic_out)) / 32768.0;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_sig_exp <= 0;
            j <= 0;
        end else if (valid_out) begin
            output_sig_exp <= $itor($signed(output_exp_samples[j])) / 32768.0;
            j <= j + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            number_of_output_samples <= 1;
        end else if(valid_out) begin
            number_of_output_samples <= number_of_output_samples + 1;
            $display("Sample %0d: Output = %b", number_of_output_samples, cic_out);
        end
    end

    initial begin

        dec_factor = 1;

        init();

        assert_reset();

        start_CIC();

        assert_reset();

        dec_factor = 2;

        init();

        start_CIC();

        assert_reset();

        dec_factor = 4;

        init();

        start_CIC();

        assert_reset();

        dec_factor = 8;

        init();

        start_CIC();

        assert_reset();

        dec_factor = 16;

        init();

        start_CIC();

        repeat (5) @(negedge clk);

        $stop;
    end

    task init ();
        $readmemb("input_wave.txt", input_samples);

        if(dec_factor == 1) begin
            $readmemb("output_D1_wave_exp.txt", output_exp_samples);
        end else if (dec_factor == 2) begin
            $readmemb("output_D2_wave_exp.txt", output_exp_samples);
        end else if (dec_factor == 4) begin
            $readmemb("output_D4_wave_exp.txt", output_exp_samples);
        end else if (dec_factor == 8) begin
            $readmemb("output_D8_wave_exp.txt", output_exp_samples);
        end else if (dec_factor == 16) begin
            $readmemb("output_D16_wave_exp.txt", output_exp_samples);
        end else
        $readmemb("output_wave_exp.txt", output_exp_samples);
        
        rst_n      = 1;
        cic_in     = 'd0;
        valid_in   = 1'b0;
        
        repeat (1) @(negedge clk);
    endtask

    task assert_reset ();
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
    endtask

    task start_CIC ();
        valid_in    = 1;
        rst_n       = 1;

        i = 0;

        repeat (N_SAMPLES_I ) begin
            cic_in = input_samples[i];
            input_sig = $itor($signed(input_samples[i])) / 32768.0;
            
            i = i + 1;
            @(negedge clk);
        end

        @(negedge clk);
        valid_in   = 0;

    endtask

endmodule