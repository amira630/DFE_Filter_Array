`timescale 1ns/1fs
module Cascaded_IIR_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter CLOCK_PERIOD = 55.555556;
    parameter CLOCK_PERIOD_6 = CLOCK_PERIOD * 3;
    parameter DATA_WIDTH = 16;
    parameter DATA_DEPTH = 667;

    /////////////////////////////////////////////////////////
    /////////// Testbench Signal Declaration ////////////////
    /////////////////////////////////////////////////////////

    reg clk_6;
    reg clk_tb, rst_n_tb;
    reg signed [DATA_WIDTH-1:0] x_in_tb; // s16.15 format
    wire signed [DATA_WIDTH-1:0] x_out_tb; // s16.15 format
    reg signed [DATA_WIDTH-1:0] x_out_expec; // s16.15 format
    // reg signed [DATA_WIDTH-1:0] coeff;

    reg signed [DATA_WIDTH-1:0] mem_in [0:DATA_DEPTH-1]; // memory to store input samples
    reg signed [DATA_WIDTH-1:0] mem_out [0:DATA_DEPTH-1]; // memory to store output samples
    // reg signed [DATA_WIDTH-1:0] mem_coeff [0:17]; 

    integer i;

    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    Cascaded_IIR #(.DATA_WIDTH(DATA_WIDTH)) DUT (.clk(clk_tb), .rst_n(rst_n_tb), .x_in(x_in_tb), .x_out(x_out_tb));

    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    always #(CLOCK_PERIOD/2) clk_tb = ~clk_tb;
    always #(CLOCK_PERIOD_6/2) clk_6 = ~clk_6;

    ////////////////////////////////////////////////////////
    /////////// Applying Stimulus on Inputs //////////////// 
    ////////////////////////////////////////////////////////

    initial begin
        // System Functions
        $dumpfile("IIR.vcd");
        $dumpvars;
        // Load input samples from file
        $readmemh("inputs_IIR.txt", mem_in);
        $readmemh("outputs_IIR.txt", mem_out);
        // $readmemb("coeff.txt", mem_coeff);

        // initialization
        initialize();
        
        // for (i = 0; i < 18; i = i + 1) begin
        //     coeff = mem_coeff[i];
        //     #(CLOCK_PERIOD_6); // for 6MHz input rate
        // end

        for (i = 0; i < DATA_DEPTH; i = i + 1) begin
            x_in_tb = mem_in[i];
            x_out_expec = mem_out[i];
            #(CLOCK_PERIOD_6); // for 6MHz input rate
        end

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
            clk_6         = 1'b0;
            // x_in_tb       = 16'sd16384; // 0.5 in s16.15 format
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