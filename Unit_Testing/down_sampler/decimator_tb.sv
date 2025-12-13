module top_tb ();

    parameter DATA_WIDTH = 16;
    parameter DECIMATION_FACTOR = 1;

    parameter N_SAMPLES_I     = 48000;

    parameter FREQ_CLK      = 9_000_000;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK;

    localparam COUNTER_WIDTH = $clog2(DECIMATION_FACTOR);

    logic clk;
    logic clk_enable;
    logic rst_n;
    logic signed [DATA_WIDTH - 1 : 0] dec_in;
    logic signed [DATA_WIDTH - 1 : 0] dec_out;

    logic [DATA_WIDTH - 1 : 0] input_samples [N_SAMPLES_I - 1 : 0];
    
    logic [COUNTER_WIDTH - 1 : 0] counter = 0;

    logic done = 0;
    logic done_reg = 0;

    integer i = 0;
    
    integer number_of_output_samples = 0;

    real input_sig;
    real output_sig;
    
    decimator #(
       .DATA_WIDTH(DATA_WIDTH),
       .DECIMATION_FACTOR(DECIMATION_FACTOR)
    ) DUT (
        .clk(clk),
        .clk_enable(clk_enable),
        .rst_n(rst_n),
        .dec_in(dec_in),
        .dec_out(dec_out)
    );

    initial begin
        clk = 0;
        forever #(T_CLK/2) clk = ~clk;
    end
   
    // Output monitoring - sequential logic  
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_sig <= 0;
        end else if (clk_enable) begin
            output_sig <= $itor($signed(dec_out)) / 32768.0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            number_of_output_samples <= 0;
        end else if((counter == DECIMATION_FACTOR - 1) && (done_reg == 0)) begin
            done_reg <= done;
            number_of_output_samples <= number_of_output_samples + 1;
            $display("Sample %0d: Output = %b (%f)", number_of_output_samples, dec_out, output_sig);
        end
    end

    initial begin
        init();

        assert_reset();

        start_decimation();

        repeat (5) @(negedge clk);
        
        $stop;
    end

    task init ();
        $readmemb("input_wave.txt", input_samples);

        clk_enable      = 0;
        rst_n           = 1;
        dec_in          = 0;
    endtask

    task assert_reset ();
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
    endtask

    task start_decimation ();
        clk_enable    = 1;
        rst_n         = 1;

        repeat (N_SAMPLES_I - 1) begin
            dec_in = input_samples[i];
            input_sig = $itor($signed(input_samples[i])) / 32768.0;
            if(counter == DECIMATION_FACTOR - 1) begin
                counter = 0;
            end else begin
                counter = counter + 1;
            end
            i = i + 1;
            @(negedge clk);
        end

        done = 1;

        // repeat (N_SAMPLES_I) @(negedge clk);
    endtask

endmodule