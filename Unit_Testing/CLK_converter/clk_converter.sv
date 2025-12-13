module dual_modulus_divider (
    input  clk_9MHz,
    input  rst_n,
    output reg clk_6MHz
);

reg [2:0] counter;
reg toggle;

// Divide by 1.5 pattern: 2 cycles, then 1 cycle alternately
always @(posedge clk_9MHz or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0;
        toggle <= 1'b0;
        clk_6MHz <= 1'b0;
    end else begin
        counter <= counter + 1'b1;
        
        if (toggle) begin
            // Divide by 2 pattern
            if (counter == 3'd1) begin
                counter <= 3'd0;
                toggle <= ~toggle;
                clk_6MHz <= ~clk_6MHz;
            end
        end else begin
            // Divide by 1 pattern  
            if (counter == 3'd0) begin
                toggle <= ~toggle;
                clk_6MHz <= ~clk_6MHz;
            end
        end
    end
end
endmodule