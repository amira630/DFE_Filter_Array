`timescale 1ns/1fs
module APB_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter CLOCK_PERIOD = 111.111111; //9MHz
    parameter PDATA_WIDTH  = 32        ;
    parameter ADDR_WIDTH   = 7         ;
    parameter COEFF_WIDTH  = 20        ;
    parameter N_TAP        = 72        ;
    parameter NUM_DENUM    = 5         ;
    parameter COMP         = 4         ;

    int i, n;

    /////////////////////////////////////////////////////////
    /////////// Testbench Signal Declaration ////////////////
    /////////////////////////////////////////////////////////

    logic                          clk_tb                          ;
    logic                          rst_n_tb                        ;
    logic                          MTRANS_tb                       ; 
    logic                          MWRITE_tb                       ;
    logic        [COMP-1:0]        MSELx_tb                        ;
    logic        [ADDR_WIDTH-1:0]  MADDR_tb                        ;
    logic signed [COEFF_WIDTH-1:0] MWDATA_tb                       ; 
    logic        [PDATA_WIDTH-1:0] MRDATA_tb                       ;
    logic                          FRAC_DECI_VLD_tb                ;
    logic signed [COEFF_WIDTH-1:0] FRAC_DECI_OUT_tb [N_TAP-1:0]    ;
    logic                          IIR_24_VLD_tb                   ;
    logic signed [COEFF_WIDTH-1:0] IIR_24_OUT_tb [NUM_DENUM-1:0]   ;
    logic                          IIR_5_1_VLD_tb                  ;
    logic signed [COEFF_WIDTH-1:0] IIR_5_1_OUT_tb [NUM_DENUM-1:0]  ;
    logic                          IIR_5_2_VLD_tb                  ;
    logic signed [COEFF_WIDTH-1:0] IIR_5_2_OUT_tb [NUM_DENUM-1:0]  ;
    logic                          CTRL_tb        [4:0]            ;
    logic        [4:0]             CIC_R_OUT_tb                    ;
    logic        [1:0]             OUT_SEL_tb                      ;
    logic        [2:0]             COEFF_SEL_tb                    ;
    logic        [2:0]             STATUS_tb                       ;

    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    APB #(
        .ADDR_WIDTH  (ADDR_WIDTH),
        .PDATA_WIDTH (PDATA_WIDTH),
        .COEFF_WIDTH (COEFF_WIDTH),
        .N_TAP       (N_TAP),
        .COMP        (COMP)    
    ) DUT (
        .clk             (clk_tb),
        .rst_n           (rst_n_tb),   
        .MTRANS          (MTRANS_tb), 
        .MWRITE          (MWRITE_tb),
        .MSELx           (MSELx_tb),
        .MADDR           (MADDR_tb),
        .MWDATA          (MWDATA_tb), 
        .MRDATA          (MRDATA_tb),
        .FRAC_DECI_VLD   (FRAC_DECI_VLD_tb),
        .FRAC_DECI_OUT   (FRAC_DECI_OUT_tb),
        .IIR_24_VLD      (IIR_24_VLD_tb),
        .IIR_24_OUT      (IIR_24_OUT_tb),
        .IIR_5_1_VLD     (IIR_5_1_VLD_tb),
        .IIR_5_1_OUT     (IIR_5_1_OUT_tb),
        .IIR_5_2_VLD     (IIR_5_2_VLD_tb),
        .IIR_5_2_OUT     (IIR_5_2_OUT_tb),
        .CTRL            (CTRL_tb),
        .CIC_R_OUT       (CIC_R_OUT_tb),
        .OUT_SEL         (OUT_SEL_tb),         
        .COEFF_SEL       (COEFF_SEL_tb),
        .STATUS          (STATUS_tb)
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

        #15;
        // WR, last, ADDR, SELx, WDATA

        for (i = 0; i < N_TAP; i = i + 1) begin
            RW(1, 0, i,'b1, $random()); // Write Frac_Deci Coeff
        end
        // RW(1, 1, i,'b1, $random()); // Write
        
        for (i = N_TAP; i < N_TAP + NUM_DENUM; i = i + 1) begin
            RW(1, 0, i,'b10, $random()); // Write IIR 2.4 Coeff
        end

        for (i = N_TAP + NUM_DENUM; i < N_TAP + 2*NUM_DENUM; i = i + 1) begin
            RW(1, 0, i,'b10, $random()); // Write IIR 5_1 Coeff
        end

        for (i = N_TAP + 2*NUM_DENUM; i < N_TAP + 3*NUM_DENUM; i = i + 1) begin
            RW(1, 0, i,'b10, $random()); // Write IIR 5_2 Coeff
        end

        // RW(1, 1, i,'b10, $random()); // Write

        RW(1, 0, N_TAP + 3*NUM_DENUM,'b100, $random()); // Write CIC_R

        RW(0, 0, N_TAP-1,'b1, $random()); // READ Final Frac coeff

        for (i = N_TAP + 3*NUM_DENUM +1; i < N_TAP + 3*NUM_DENUM + 6; i = i + 1) begin
            RW(1, 0, i,'b1000, $random()); // Write CTRLs
        end

        RW(1, 0, N_TAP + 3*NUM_DENUM + 6,'b1000, $random()); // Write OUT_SEL

        RW(1, 0, N_TAP + 3*NUM_DENUM + 7,'b1000, $random()); // Write COEFF_SEL

        RW(1, 1, N_TAP + 3*NUM_DENUM + 8,'b1000, $random()); // Write STATUS

        RW(0, 1, N_TAP + 2*NUM_DENUM -1,'b1, $random()); // READ Final IIR 5_1 coeff

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
            MTRANS_tb = 1'b0;
            MWRITE_tb = 1'b0;
            MSELx_tb  = 'b10;
            MADDR_tb  = $random();
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
        input logic                          WR;
        input logic                          last;
        input logic        [ADDR_WIDTH-1:0]  ADDR;
        input logic        [COMP-1:0]        SELx;
        input logic signed [COEFF_WIDTH-1:0] WDATA;
        begin
            n = 0;
            MWRITE_tb = WR;
            MADDR_tb  = ADDR;
            MTRANS_tb = 1'b1;
            MSELx_tb  = SELx;
            $display("MTRANS_tb is asserted at %0t", $realtime);
            if (WR) begin
                MWDATA_tb = WDATA;
                // PRDATA_tb = 'b0;
            end
            else begin
                // MWDATA_tb = 'b0;
                // PRDATA_tb = $random();
            end
            #(2*CLOCK_PERIOD)
            MTRANS_tb = 1'b0;
            $display("MTRANS_tb is de-asserted at %0t", $realtime);
            if (last)
                @(negedge clk_tb);
            // MSELx_tb  = 'b0;
        end
    endtask
    
    ////////////////// Check Out Response  ////////////////////


endmodule