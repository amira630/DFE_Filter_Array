`timescale 1ns/1fs
module FIR_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter CLOCK_PERIOD_6 = 166.666667; // 6MHz
    parameter R = 1;
    parameter CLOCK_PERIOD = CLOCK_PERIOD_6 *R;
    parameter DATA_WIDTH = 16;
    parameter DATA_DEPTH = 128;

    /////////////////////////////////////////////////////////
    /////////// Testbench Signal Declaration ////////////////
    /////////////////////////////////////////////////////////

    reg clk_tb, rst_n_tb;
    reg [4:0] R_tb;
    reg valid_in_tb;
    reg signed [DATA_WIDTH-1:0] x_input_tb; // s16.15 format
    wire signed [DATA_WIDTH-1:0] y_output_tb; // s16.15 format
    wire valid_out_tb;

    reg signed [DATA_WIDTH-1:0] mem_in [0:DATA_DEPTH-1]; // memory to store input samples

    integer i;

    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    FIR_Filter #(.N_MAX(92), .WIDTH (DATA_WIDTH), .COEFF_WIDTH(DATA_WIDTH)) DUT (.clk(clk_tb), .rst_n(rst_n_tb), .R(R_tb), .x_input(x_input_tb), .valid_in(valid_in_tb), .y_output(y_output_tb), .valid_out(valid_out_tb));

    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    always #(CLOCK_PERIOD/2) clk_tb = ~clk_tb;

    ////////////////////////////////////////////////////////
    /////////// Applying Stimulus on Inputs //////////////// 
    ////////////////////////////////////////////////////////

    initial begin
        // System Functions
        $dumpfile("FIR.vcd");
        $dumpvars;
        // Load input samples from file
        $readmemh("inputs_FIR.txt", mem_in);

        // initialization
        initialize();
        
        for (i = 0; i < DATA_DEPTH; i = i + 1) begin
            x_input_tb = mem_in[i];
            #(CLOCK_PERIOD);
        end
        #(CLOCK_PERIOD);
        valid_in_tb = 1'b0;
        #(500*CLOCK_PERIOD)
        $stop;
    end

    ////////////////////////////////////////////////////////
    /////////////////////// TASKS //////////////////////////
    ////////////////////////////////////////////////////////

    /////////////// Signals Initialization //////////////////

    task initialize;
        begin
            clk_tb  	  = 1'b0;
            R_tb          = R;
            x_input_tb    = 16'sd16384; // 0.5 in s16.15 format
            valid_in_tb   = 1'b1;
            reset();
        end	
    endtask

    ///////////////////////// RESET /////////////////////////

    task reset;
        begin
            rst_n_tb = 1'b1;
            #(CLOCK_PERIOD)
            rst_n_tb = 1'b0;
            #(CLOCK_PERIOD)
            rst_n_tb = 1'b1;
        end
    endtask

    ////////////////// Check Out Response  ////////////////////

endmodule