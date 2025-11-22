`timescale 1ns/1fs
module APB_Bridge_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter CLOCK_PERIOD = 55.555556;
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 7;
    parameter COMP = 3;
    parameter DATA_DEPTH = 100;
    int i, n;

    /////////////////////////////////////////////////////////
    /////////// Testbench Signal Declaration ////////////////
    /////////////////////////////////////////////////////////
   logic                  clk_tb;
   logic                  rst_n_tb;
   logic                  PREADY_tb;
   logic                  MTRANS_tb; 
   logic                  MWRITE_tb;
   logic [COMP-1:0]       MSELx_tb;
   logic [ADDR_WIDTH-1:0] MADDR_tb;
   logic [DATA_WIDTH-1:0] PRDATA_tb;
   logic [DATA_WIDTH-1:0] MWDATA_tb; 
   logic                  PENABLE_tb;
   logic                  PWRITE_tb; 
   logic [ADDR_WIDTH-1:0] PADDR_tb;
   logic [COMP-1:0]       PSELx_tb;
   logic [DATA_WIDTH-1:0] PWDATA_tb;
   logic [DATA_WIDTH-1:0] MRDATA_tb;

    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    APB_Bridge #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),      
    .COMP(COMP)           
    ) DUT(
        .PCLK   (clk_tb),
        .PRESETn(rst_n_tb),
        .PREADY (PREADY_tb),
        .MTRANS (MTRANS_tb),
        .MWRITE (MWRITE_tb),
        .MSELx  (MSELx_tb),
        .MADDR  (MADDR_tb),
        .PRDATA (PRDATA_tb),
        .MWDATA (MWDATA_tb),
        .PENABLE(PENABLE_tb),
        .PWRITE (PWRITE_tb),  
        .PADDR  (PADDR_tb),
        .PSELx  (PSELx_tb),
        .PWDATA (PWDATA_tb),
        .MRDATA (MRDATA_tb)
    );

    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    always #(CLOCK_PERIOD/2) clk_tb = ~clk_tb;

    ////////////////////////////////////////////////////////
    /////////// Applying Stimulus on Inputs //////////////// 
    ////////////////////////////////////////////////////////

    initial begin
        // System Functions
        $dumpfile("APB.vcd");
        $dumpvars;

        // initialization
        initialize();
        
        // for (i = 0; i < DATA_DEPTH; i = i + 1) begin
            
        //     #(CLOCK_PERIOD); // for 6MHz input rate
        // end
        #15;
        RW(1, 0); // Write w/ 0 waits
        PREADY_tb = 1'b0;
        @(negedge clk_tb)
        RW(0, 0); // Read  w/ 0 waits
        PREADY_tb = 1'b0;
        @(negedge clk_tb)
        RW(1, 5); // Write w/ 5 waits
        RW(1, 3); // Write w/ 3 waits
        PREADY_tb = 1'b0;
        @(negedge clk_tb)
        RW(0, 5); // Read  w/ 5 waits
        PREADY_tb = 1'b0;
        @(negedge clk_tb)
        RW(1, 0); // Write w/ 0 waits
        RW(0, 3); // Read  w/ 3 waits
        #(5*CLOCK_PERIOD)
        $stop;
    end

    ////////////////////////////////////////////////////////
    /////////////////////// TASKS //////////////////////////
    ////////////////////////////////////////////////////////

    /////////////// Signals Initialization //////////////////

    task initialize;
        begin
            clk_tb    = 1'b0;
            PREADY_tb = 1'b0;
            MTRANS_tb = 1'b0;
            MWRITE_tb = 1'b0;
            MSELx_tb  = 'b0;
            MADDR_tb  = $random();
            PRDATA_tb = 'b0;
            MWDATA_tb = $random();
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

    /////////////////////// Operations ////////////////////////

    task RW ;
        input logic WR;
        input int waits;
        begin
            n = 0;
            MWRITE_tb = WR;
            MADDR_tb  = $random();
            MTRANS_tb = 1'b1;
            MSELx_tb  = 1<<$urandom_range(COMP-1, 0);
            $display("MTRANS_tb is asserted at %0t", $realtime);
            if (WR) begin
                MWDATA_tb = $random();
                PRDATA_tb = 'b0;
                do begin
                    PREADY_tb = 1'b0;
                    $display("PREADY_tb is de-asserted for WRITE at %0t", $realtime);
                    n++;
                    @(negedge clk_tb);
                    MSELx_tb  = 1<<$urandom_range(COMP-1, 0);
                    MWRITE_tb = !MWRITE_tb;
                    MTRANS_tb = 1'b0;
                    MADDR_tb  = $random();
                    MWDATA_tb = $random();
                    $display("MTRANS_tb is de-asserted for WRITE at %0t", $realtime);
                end while (n < waits);
            end
            else begin
                MWDATA_tb = 'b0;
                do begin
                    PREADY_tb = 1'b0;
                    $display("PREADY_tb is de-asserted for READ at %0t", $realtime);
                    n++;
                    @(negedge clk_tb);
                    MSELx_tb  = 1<<$urandom_range(COMP-1, 0);
                    MWRITE_tb = !MWRITE_tb;
                    MTRANS_tb = 1'b0;
                    MADDR_tb  = $random();
                    $display("MTRANS_tb is de-asserted for READ at %0t", $realtime);
                end while (n < waits);
                PRDATA_tb = $random();
            end
            PREADY_tb = 1'b1;
            $display("PREADY_tb is asserted at %0t", $realtime);
            @(negedge clk_tb);
            MADDR_tb  = $random();
            MSELx_tb  = 'b0;
        end
    endtask


    ////////////////// Check Out Response  ////////////////////


endmodule