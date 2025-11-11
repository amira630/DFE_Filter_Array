`timescale 1ns/1fs
module Frac_Deci_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter CLOCK_PERIOD = 55.555556;
    parameter HALF_N = 113;
    parameter DATA_WIDTH = 16;

    /////////////////////////////////////////////////////////
    /////////// Testbench Signal Declaration ////////////////
    /////////////////////////////////////////////////////////

    reg clk_tb, rst_n_tb;
    reg signed [DATA_WIDTH-1:0] x_in_tb; // s16.15 format
    wire signed [DATA_WIDTH-1:0] x_out_tb; // s16.15 format

    reg signed [DATA_WIDTH-1:0] mem_in [0:900]; // memory to store input samples

    integer i;

    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    Frac_Deci #(.HALF_N(HALF_N), .DATA_WIDTH(DATA_WIDTH)) DUT (.clk(clk_tb), .rst_n(rst_n_tb), .x_in(x_in_tb), .x_out(x_out_tb));
    
    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    always #(CLOCK_PERIOD/2) clk_tb = ~clk_tb;

    ////////////////////////////////////////////////////////
    /////////// Applying Stimulus on Inputs //////////////// 
    ////////////////////////////////////////////////////////
    
    initial begin
        // System Functions
        $dumpfile("Fractional_Decimator.vcd");
        $dumpvars;
        // Load input samples from file
        $readmemh("inputs_F_D.txt", mem_in);

        // initialization
        initialize();
        
        for (i = 0; i < 901; i = i + 1) begin
            x_in_tb = mem_in[i];
            #(2*CLOCK_PERIOD); // for 9MHz input rate
        end

        #(100*CLOCK_PERIOD)
        $stop;
    end

    ////////////////////////////////////////////////////////
    /////////////////////// TASKS //////////////////////////
    ////////////////////////////////////////////////////////

    /////////////// Signals Initialization //////////////////

    task initialize;
        begin
            clk_tb  	  = 1'b0;
            x_in_tb       = 16'sd16384; // 0.5 in s16.15 format
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