module DFE_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter N_SAMPLES_I   = 48000                     ;
    parameter FREQ_CLK      = 9_000_000                 ;
    parameter T_CLK         = 1_000_000_000 / FREQ_CLK  ;

    parameter string CONFIG_FILE_NAME = "cfg.txt"  ;
    parameter string MATLAB_FILE_NAME = "System_run.m";
    parameter string PATH = "../MATLAB/";
    parameter string OUT_PATH = "";
    parameter string BASE_PATH = ".";           // Path where MATLAB output files are located

    parameter DATA_WIDTH   = 16        ;
    parameter DATA_FRAC    = 15        ;
    parameter PDATA_WIDTH  = 32        ;
    parameter ADDR_WIDTH   = 7         ;
    parameter COEFF_WIDTH  = 20        ;
    parameter COEFF_FRAC   = 18        ;
    parameter N_TAP        = 72        ;
    parameter NUM_DENUM    = 5         ;
    parameter COMP         = 4         ;

    int i; 
    int n;

    bit trig;

    integer j = 0;
  
    real input_sig;
    real frac_decimator_sig;
    real iir_24mhz_sig;
    real iir_5mhz_1_sig;
    real iir_5mhz_2_sig;
    real cic_sig;
    real output_sig;

    real block_out_sig;
    real core_out_sig;

    /////////////////////////////////////////////////////////
    /////////// Testbench Signal Declaration ////////////////
    /////////////////////////////////////////////////////////

    logic                                clk_tb                          ;
    logic                                rst_n_tb                        ;
    logic                                MTRANS_tb                       ; 
    logic                                MWRITE_tb                       ;
    logic        [COMP-1:0]              MSELx_tb                        ;
    logic        [ADDR_WIDTH-1:0]        MADDR_tb                        ;
    logic signed [COEFF_WIDTH-1:0]       MWDATA_tb                       ; 
    logic        [PDATA_WIDTH-1:0]       MRDATA_tb                       ;
    logic                                valid_in_tb                     ;   
    logic signed [DATA_WIDTH - 1 : 0]    core_in_tb                      ;   
    logic                                valid_out_tb                    ;   
    logic signed [DATA_WIDTH - 1 : 0]    core_out_tb                     ;   
    logic                                overflow_tb                     ;   
    logic                                underflow_tb                    ;   
    logic                                block_overflow_tb               ;   
    logic                                block_underflow_tb              ;   
    logic                                block_valid_out_tb              ;   
    logic signed [DATA_WIDTH - 1 : 0]    block_out_tb                    ;   
    logic signed [COEFF_WIDTH - 1 : 0]   coeff_out_tb [N_TAP - 1 : 0]    ;



    // Memory arrays with calculated depths based on bypass combinations
    logic signed [DATA_WIDTH - 1 : 0] input_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] frac_decimator_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] iir_24mhz_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] iir_5mhz_1_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] iir_5mhz_2_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] cic_exp [$];
    logic signed [DATA_WIDTH - 1 : 0] output_exp [$];


    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    DFE_TOP #(
        //********************** General Parameters ********************//
        .DATA_WIDTH (DATA_WIDTH)                          ,
        .DATA_FRAC  (DATA_FRAC)                           ,
        .COEFF_WIDTH(COEFF_WIDTH)                         ,
        .COEFF_FRAC (COEFF_FRAC)                          ,
        //******************** Fractional Decimator Parameters **********//
        .N_TAP      (N_TAP)                               ,

        //********************** APB Parameters ********************//
        .ADDR_WIDTH  (ADDR_WIDTH)                         ,
        .PDATA_WIDTH (PDATA_WIDTH)                        ,
        .COMP        (COMP)
    ) DUT (
        .clk               (clk_tb)                       ,
        .rst_n             (rst_n_tb)                     ,

        .MTRANS            (MTRANS_tb)                    , 
        .MWRITE            (MWRITE_tb)                    ,
        .MSELx             (MSELx_tb)                     ,
        .MADDR             (MADDR_tb)                     ,
        .MWDATA            (MWDATA_tb)                    , 
        .MRDATA            (MRDATA_tb)                    ,

        .valid_in          (valid_in_tb)                  ,
        .core_in           (core_in_tb)                   ,
        
        .valid_out         (valid_out_tb)                 ,
        .core_out          (core_out_tb)                  ,
        .overflow          (overflow_tb)                  ,
        .underflow         (underflow_tb)                 ,

        .block_overflow    (block_overflow_tb)            ,
        .block_underflow   (block_underflow_tb)           ,
        .block_valid_out   (block_valid_out_tb)           ,
        .block_out         (block_out_tb)                 ,

        .coeff_out(coeff_out_tb)             
    );

    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    initial begin
        clk_tb = 0;
        forever #(T_CLK/2) clk_tb = ~clk_tb;
    end
 
    ////////////////////////////////////////////////////////
    /////////// Applying Stimulus on Inputs //////////////// 
    ////////////////////////////////////////////////////////

    //////////////////  Response  ////////////////////

    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            j <= 0;
            input_sig               <= 0;
            frac_decimator_sig      <= 0;
            iir_24mhz_sig           <= 0;
            iir_5mhz_1_sig          <= 0;
            iir_5mhz_2_sig          <= 0;
            cic_sig                 <= 0;
            output_sig              <= 0;
        end else if (trig) begin
            input_sig               <= $itor($signed(input_exp[j])) / 32768.0;
            frac_decimator_sig      <= $itor($signed(frac_decimator_exp[j])) / 32768.0;
            iir_24mhz_sig           <= $itor($signed(iir_24mhz_exp[j])) / 32768.0;
            iir_5mhz_1_sig          <= $itor($signed(iir_5mhz_1_exp[j])) / 32768.0;
            iir_5mhz_2_sig          <= $itor($signed(iir_5mhz_2_exp[j])) / 32768.0;
            cic_sig                 <= $itor($signed(cic_exp[j])) / 32768.0;
            output_sig              <= $itor($signed(output_exp[j])) / 32768.0;
            j = j + 1;
        end
    end

        // Output monitoring - sequential logic  
    always_ff @(posedge clk_tb or negedge rst_n_tb) begin
        if (!rst_n_tb) begin
            block_out_sig <= 'b0;
            core_out_sig  <= 'b0;
        end else if (valid_in_tb) begin
            block_out_sig <=  $itor($signed(block_out_tb)) / 32768.0;
            core_out_sig  <= $itor($signed(core_out_tb)) / 32768.0;
        end
    end

    initial begin
        // System Functions
        $dumpfile("DFE.vcd");
        $dumpvars;

        // initialization
        init();
        
        repeat (N_SAMPLES_I) @(negedge clk_tb);
        $stop;
    end

    ////////////////////////////////////////////////////////
    /////////////////////// TASKS //////////////////////////
    ////////////////////////////////////////////////////////

    /////////////// Signals Initialization //////////////////

    task init ;
        begin
            // Default Configuration
            // f = 0, a = 0, s = 0, bypass_frac_dec = 0, bypass_iir_24 = 0, bypass_iir_5 = 0, bypass_cic = 0, cic_decf = 4
            TC_cfg(12'b0_0_0_0_0_0_0_00100, 1);  
            
            MTRANS_tb = 1'b0;
            MWRITE_tb = 1'b0;
            MSELx_tb  = 'b10;
            MADDR_tb  = $random();
            MWDATA_tb = $random();
            valid_in_tb = 1'b1;
            core_in_tb = $random();
            assert_reset();
        end	
    endtask

    ///////////////////////// RESET /////////////////////////

    task assert_reset;
        begin
            rst_n_tb = 1'b0;
            valid_in_tb = 1'b0;
            repeat (2) @(negedge clk_tb);
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
            end
            repeat (1) @(negedge clk_tb);
            MTRANS_tb = 1'b0;
            $display("MTRANS_tb is de-asserted at %0t", $realtime);
            if (last)
                @(negedge clk_tb);
            // MSELx_tb  = 'b0;
        end
    endtask

    task BYPASS ;
        input logic [1:0] sel; 
        input logic off;
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM +1 +sel,'b1000, off); // Write CTRLs
        end
    endtask

    task SET_OUTPUT ;
        input logic [1:0] sel; 
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM + 6,'b1000, sel); // Write OUT_SEL
        end
    endtask

    task SET_COEFF ;
        input logic [2:0] sel;
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM + 7,'b1000, sel); // Write COEFF_SEL
        end
    endtask
    
    task READ_STATUS ;
        input logic [2:0] sel;
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM + 8,'b1000, sel); // Write STATUS
        end
    endtask

    task CHANGE_DECIMATION ;
        input logic [4:0] rate;
        begin
            // WR, last, ADDR, SELx, WDATA
            RW(1, 1, N_TAP + 3*NUM_DENUM,'b100, rate); // Write CIC_R
        end
    endtask

    task CHANGE_FAC_DECI_COEFF ;
        input logic signed [COEFF_WIDTH-1:0] coeff [N_TAP - 1 : 0];
        begin
            // WR, last, ADDR, SELx, WDATA
            for (i = 0; i < N_TAP; i = i + 1) begin
                RW(1, 0, i,'b1, coeff[i]); // Write Frac_Deci Coeff
            end
        end
    endtask

    task CHANGE_IIR24_COEFF ;
        input logic signed [COEFF_WIDTH-1:0] coeff [NUM_DENUM - 1 : 0];
        begin
            // WR, last, ADDR, SELx, WDATA
            for (i = N_TAP; i < N_TAP + NUM_DENUM; i = i + 1) begin
                RW(1, 0, i,'b10, coeff[i - N_TAP]); // Write IIR 2.4 Coeff
            end
        end         
    endtask

    task CHANGE_IIR51_COEFF ;
        input logic signed [COEFF_WIDTH-1:0] coeff [NUM_DENUM -1 : 0];
        begin
            // WR, last, ADDR, SELx, WDATA
            for (i = N_TAP + NUM_DENUM; i < N_TAP + 2*NUM_DENUM; i = i + 1) begin
                RW(1, 0, i,'b10, coeff[i - N_TAP - NUM_DENUM]); // Write IIR 5_1 Coeff
            end
        end
    endtask

    task CHANGE_IIR52_COEFF ;
        input logic signed [COEFF_WIDTH-1:0] coeff [NUM_DENUM -1 : 0];
        begin
            // WR, last, ADDR, SELx, WDATA
            for (i = N_TAP + 2*NUM_DENUM; i < N_TAP + 3*NUM_DENUM; i = i + 1) begin
                RW(1, 0, i,'b10, coeff[i - N_TAP - 2*NUM_DENUM]); // Write IIR 5_2 Coeff
            end
        end
    endtask

    task update_config ;
        input logic [11 : 0] config_stream; 
        // (f, a, s, bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic, cic_decf)                   
        // Frequency randomization flag
        // Amplitude randomization flag
        // Shape randomization flag
        // Fractional decimator bypass
        // IIR 2.4MHz bypass
        // IIR 5MHz bypass
        // CIC bypass
        // CIC decimation factor (5 bits)

        integer file_handle;
        string filename;

        begin

            // Construct full file path
            if (PATH == "") begin
                filename = CONFIG_FILE_NAME;  // Default to current directory if no path
            end else begin
                // Ensure path ends with slash
                if (PATH.substr(PATH.len()-1, PATH.len()-1) != "/") begin
                    filename = {PATH, "/", CONFIG_FILE_NAME};
                end else begin
                    filename = {PATH, CONFIG_FILE_NAME};
                end
            end

            // Open file for writing
            file_handle = $fopen(filename, "w");

            if (file_handle == 0) begin
                $display("Error: Cannot open file %s for writing", filename);
                $stop;
            end

            // Write signal configuration flags (bits 1-3)
            $fwrite(file_handle, "%012b", config_stream);

            // Close file
            $fclose(file_handle);

            $display("Configuration file '%s' created successfully", filename);
            $display("Configuration: f=%b, a=%b, s=%b", config_stream[0], config_stream[1], config_stream[2]);
            $display("Bypass flags: frac_dec=%b, iir_24=%b, iir_5=%b, cic=%b", 
                     config_stream[3], config_stream[4], config_stream[5], config_stream[6]);
            $display("CIC decf = %d (binary: %05b)", config_stream[11 : 7], config_stream[11 : 7]);
        end
    endtask

    task run_matlab_advanced;
        input bit wait_for_completion;    // 1 = wait, 0 = run in background

        integer result;
        string command;
        string log_file;
        string timestamp;
        string full_script_path;
        string matlab_function_name;  // ADDED: Extract function name without .m

        begin
            // ADDED: Extract function name without .m extension
            if (MATLAB_FILE_NAME.len() > 2 && MATLAB_FILE_NAME.substr(MATLAB_FILE_NAME.len()-2, MATLAB_FILE_NAME.len()-1) == ".m") begin
                matlab_function_name = MATLAB_FILE_NAME.substr(0, MATLAB_FILE_NAME.len()-3);
            end else begin
                matlab_function_name = MATLAB_FILE_NAME;
            end

            // Create timestamp for unique log file
            $sformat(timestamp, "%0t", $realtime);

            // Construct log file path
            if (OUT_PATH == "") begin
                $sformat(log_file, "matlab_%s_%s.log", matlab_function_name, timestamp);
            end else begin
                if (OUT_PATH.substr(OUT_PATH.len()-1, OUT_PATH.len()-1) != "/") begin
                    $sformat(log_file, "%s/matlab_%s_%s.log", OUT_PATH, matlab_function_name, timestamp);
                end else begin
                    $sformat(log_file, "%smatlab_%s_%s.log", OUT_PATH, matlab_function_name, timestamp);
                end
            end

            // Build the MATLAB command - FIXED: Remove .m from function call
            if (wait_for_completion) begin
                // Synchronous execution
                $sformat(command, "matlab -batch \"addpath('%s'); %s;\" -logfile %s", 
                         PATH, matlab_function_name, log_file);  // CHANGED: Removed ('%s') argument and .m
            end else begin
                // Asynchronous execution (background)
                $sformat(command, "matlab -batch \"addpath('%s'); %s;\" -logfile %s &", 
                         PATH, matlab_function_name, log_file);  // CHANGED: Removed ('%s') argument and .m
            end

            $display("[%0t] Starting MATLAB execution:", $time);
            $display("[%0t]   Script: %s%s", $time, PATH, MATLAB_FILE_NAME);  // CHANGED: Show actual file path
            $display("[%0t]   Function: %s", $time, matlab_function_name);    // ADDED: Show function name being called
            $display("[%0t]   Log: %s", $time, log_file);
            $display("[%0t]   Command: %s", $time, command);

            // Execute the command
            result = $system(command);

            if (wait_for_completion) begin
                if (result == 0) begin
                    $display("[%0t] MATLAB execution completed successfully", $time);
                end else begin
                    $display("[%0t] ERROR: MATLAB execution failed with code %0d", $time, result);
                    // ADDED: More specific error information
                    $display("[%0t] Please check:", $time);
                    $display("[%0t]   1. MATLAB is installed and in system PATH", $time);
                    $display("[%0t]   2. File exists: %s%s", $time, PATH, MATLAB_FILE_NAME);
                    $display("[%0t]   3. MATLAB script has no syntax errors", $time);
                end
            end else begin
                $display("[%0t] MATLAB started in background", $time);
            end
        end
    endtask

    task run_script ;
        input logic [11 : 0] config_stream; 
        input bit wait_for_completion;    // 1 = wait, 0 = run in background

        begin
            // Create configuration file
            update_config(config_stream);

            // Run MATLAB script
            run_matlab_advanced(wait_for_completion);
        end
    endtask

    function automatic int calculate_depth(
        input bit bypass_frac_dec,
        input bit bypass_cic,
        input int cic_decf
    );
        int depth = N_SAMPLES_I;

        // Apply fractional decimator effect (if not bypassed)
        if (!bypass_frac_dec) begin
            // Fractional decimator reduces samples by factor (adjust based on your actual ratio)
            depth = depth * 2 / 3;  // Example: adjust this based on your actual decimation ratio
        end

        // Apply CIC decimator effect (if not bypassed)
        if (!bypass_cic) begin
            depth = depth / cic_decf;
        end

        return depth;
    endfunction

    task automatic load_stage_file ;
        ref logic signed [DATA_WIDTH-1:0] memory[$];  // Reference to memory array
        input string filename;                        // File to load
        input string stage_name;                      // Stage name for logging

        integer file_handle;
        integer i;
        logic [15:0] temp_data;

        begin
            file_handle = $fopen(filename, "r");
            if (file_handle == 0) begin
                $display("  Warning: Could not open %s for stage %s", filename, stage_name);
                return;
            end

            // Clear existing memory and load new data
            memory.delete();
            i = 0;
            while (!$feof(file_handle)) begin
                if ($fscanf(file_handle, "%b\n", temp_data) == 1) begin
                    memory.push_back(temp_data);
                    i++;
                end
            end
            $fclose(file_handle);

            $display("  Stage %s: %0d samples from %s", stage_name, i, filename);
        end
    endtask

    task automatic load_matlab_output ;
        input bit bypass_frac_dec;
        input bit bypass_iir_24;
        input bit bypass_iir_5; 
        input bit bypass_cic;
        input int cic_decf;
   
        int expected_depth;

        begin
            $display("Loading MATLAB outputs for configuration:");
            $display("  Frac_Dec:%b, IIR_24:%b, IIR_5:%b, CIC:%b, CIC_DecF:%0d", 
                     bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic, cic_decf);

            expected_depth = calculate_depth(bypass_frac_dec, bypass_cic, cic_decf);

            // Load each stage using the generic task
            load_stage_file(input_exp, {BASE_PATH, "/input.txt"}, "Input");
            load_stage_file(frac_decimator_exp, {BASE_PATH, "/frac_decimator.txt"}, "Fractional Decimator");
            load_stage_file(iir_24mhz_exp, {BASE_PATH, "/iir_24mhz.txt"}, "IIR 2.4MHz");
            load_stage_file(iir_5mhz_1_exp, {BASE_PATH, "/iir_5mhz_1.txt"}, "IIR 5MHz 1");
            load_stage_file(iir_5mhz_2_exp, {BASE_PATH, "/iir_5mhz_2.txt"}, "IIR 5MHz 2");
            load_stage_file(cic_exp, {BASE_PATH, "/cic.txt"}, "CIC");
            load_stage_file(output_exp, {BASE_PATH, "/output.txt"}, "Final Output");

            // Verify final output depth
            if (output_exp.size() != expected_depth) begin
                $display("  Note: Actual depth (%0d) differs from expected (%0d)", 
                         output_exp.size(), expected_depth);
            end

            $display("Loading complete for configuration %b%b%b%b (CIC_DecF=%0d)",
                     bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic, cic_decf);
        end
    endtask

    task TC_cfg ;
        input logic [11 : 0] config_stream; 
        input bit wait_for_completion;    // 1 = wait, 0 = run in background

        begin
            trig = 0;
            // Run the script to generate outputs
            run_script(config_stream, wait_for_completion);

            load_matlab_output(
                config_stream[3], 
                config_stream[4], 
                config_stream[5], 
                config_stream[6], 
                config_stream[11 : 7]
            );

            repeat (1) @(negedge clk_tb);

            trig = 1;
        end
    endtask
endmodule