module clk_converter #(
    parameter INPUT_CYCLES = 3,                                  // 3 input cycles
    parameter OUTPUT_PULSES = 2,                                 // 2 output pulses
    localparam COUNTER_WIDTH = $clog2(INPUT_CYCLES),
    localparam OUTPUT_COUNTER_WIDTH = $clog2(OUTPUT_PULSES + 1)
)(
    input   logic clk,                                           // 9MHz clock
    input   logic rst_n,
    output  logic clk_enable                                     // Enable signal at 6MHz effective rate
);
    logic [COUNTER_WIDTH - 1 : 0]           counter;             // Counts 0 to INPUT_CYCLES-1
    logic [OUTPUT_COUNTER_WIDTH - 1 : 0]    output_counter;      // Tracks output pulses

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= '0;
            output_counter <= '0;
            clk_enable <= 1'b0;
        end else begin
            clk_enable <= 1'b0;  // Default to low
            
            if (counter == (INPUT_CYCLES - 1)) begin
                counter <= '0;
                output_counter <= '0;
            end else begin
                counter <= counter + 1'd1;
    
                if (output_counter < OUTPUT_PULSES) begin
                    if ((counter == '0) || (counter == 'd1)) begin
                        clk_enable <= 1'b1;
                        output_counter <= output_counter + 1'd1;
                    end
                end
            end
        end
    end
endmodule