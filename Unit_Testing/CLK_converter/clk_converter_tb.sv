`timescale 1ns/1ps

module top_tb;

    // Parameters
    parameter INPUT_CYCLES = 2;
    parameter OUTPUT_PULSES = 1;
    parameter CLK_PERIOD = 10;  // 100MHz testbench clock (10ns period)
    
    // Testbench signals
    logic clk;
    logic rst_n;
    logic clk_enable;
    
    // Counter for verification
    integer input_cycle_count;
    integer output_pulse_count;
    integer total_cycles;
    
    // DUT instantiation
    clk_converter #(
        .INPUT_CYCLES(INPUT_CYCLES),
        .OUTPUT_PULSES(OUTPUT_PULSES)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .clk_enable(clk_enable)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        input_cycle_count = 0;
        output_pulse_count = 0;
        total_cycles = 0;
        
        // Display test information
        $display("=================================================");
        $display("Clock Converter Testbench");
        $display("INPUT_CYCLES = %0d, OUTPUT_PULSES = %0d", INPUT_CYCLES, OUTPUT_PULSES);
        $display("Expected: %0d output pulses every %0d input cycles", OUTPUT_PULSES, INPUT_CYCLES);
        $display("=================================================");
        
        // Apply reset
        #(CLK_PERIOD * 2);
        rst_n = 1;
        $display("[%0t] Reset released", $time);
        
        // Monitor for several cycles
        repeat(30) begin
            @(posedge clk);
            total_cycles++;
            
            if (clk_enable) begin
                output_pulse_count++;
                $display("[%0t] Cycle %0d: clk_enable = 1 (Output pulse #%0d)", 
                         $time, total_cycles, output_pulse_count);
            end else begin
                $display("[%0t] Cycle %0d: clk_enable = 0", $time, total_cycles);
            end
            
            // Check pattern every INPUT_CYCLES
            if (total_cycles % INPUT_CYCLES == 0) begin
                if (output_pulse_count == OUTPUT_PULSES) begin
                    $display("    [PASS] Correct: %0d pulses in %0d cycles", 
                             output_pulse_count, INPUT_CYCLES);
                end else begin
                    $display("    [FAIL] Error: Expected %0d pulses, got %0d in %0d cycles", 
                             OUTPUT_PULSES, output_pulse_count, INPUT_CYCLES);
                end
                output_pulse_count = 0;
            end
        end
        
        // Test with reset during operation
        $display("\n=================================================");
        $display("Testing reset during operation...");
        $display("=================================================");
        
        repeat(5) @(posedge clk);
        rst_n = 0;
        $display("[%0t] Reset asserted", $time);
        
        repeat(3) @(posedge clk);
        if (clk_enable) begin
            $display("    [FAIL] clk_enable should be 0 during reset");
        end else begin
            $display("    [PASS] clk_enable correctly held at 0 during reset");
        end
        
        rst_n = 1;
        $display("[%0t] Reset released", $time);
        
        // Continue monitoring
        output_pulse_count = 0;
        repeat(12) begin
            @(posedge clk);
            if (clk_enable) begin
                output_pulse_count++;
                $display("[%0t] clk_enable = 1 (Output pulse #%0d)", $time, output_pulse_count);
            end
        end
        
        // Final statistics
        $display("\n=================================================");
        $display("Test completed successfully!");
        $display("=================================================");
        
        #(CLK_PERIOD * 5);
        $stop;
    end
endmodule
