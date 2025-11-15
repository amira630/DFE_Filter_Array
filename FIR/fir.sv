module FIR_Filter #(
    parameter N_TAPS = 72,
    parameter DATA_WIDTH = 16,
    parameter DATA_FRAC = 15,
    parameter COEFF_WIDTH = 20,
    parameter COEFF_FRAC = 18,
    parameter PRODUCT_WIDTH = 35,
    parameter PRODUCT_FRAC = 32,
    parameter ACC_WIDTH = 42,
    parameter ACC_FRAC = 32
)(
    input   logic                               clk         ,
    input   logic                               rst_n       ,
    input   logic signed [DATA_WIDTH - 1 : 0]   fir_in      ,
    input   logic                               valid_in    ,
    output  logic signed [DATA_WIDTH - 1 : 0]   fir_out     ,
    output  logic                               valid_out   ,
    output  logic                               underflow   ,
    output  logic                               overflow
);

    logic signed [COEFF_WIDTH - 1 : 0] coeff_ram_default [N_TAPS - 1 : 0];

    logic signed [COEFF_WIDTH - 1 : 0] coeff_ram [N_TAPS - 1 : 0];

    logic signed [DATA_WIDTH - 1 : 0] delay_reg [N_TAPS - 1 : 0];

    logic signed [PRODUCT_WIDTH - 1 : 0] prod;

    logic signed [ACC_WIDTH - 1 : 0] acc;

    logic signed [ACC_WIDTH - 1 : 0] result;

    logic rounding_valid_in;

    logic valid_in_reg;

    // Coefficient initialization (example coefficients, replace with actual values)
    initial begin
        $readmemb("fir_coeff.txt", coeff_ram_default);
    end

    // Copy default coefficients to working RAM
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0 ; i < N_TAPS ; i++) begin 
                coeff_ram[i] <= coeff_ram_default[i];
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_in_reg <= 1'b0;
        end else begin
            valid_in_reg <= valid_in;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0 ; i < N_TAPS ; i++) begin 
                delay_reg[i] <= '0;
            end
        end else if (valid_in) begin
            delay_reg[0] <= fir_in;
            for (int j = 1 ; j < N_TAPS ; j++) begin
                delay_reg[j] <= delay_reg[j - 1];
            end
        end
    end

    always_comb begin
        if (!rst_n) begin
            acc = 'sh0;
            prod = 'sh0;
            result = 'sh0;
            rounding_valid_in = 1'b0;
        end else if (valid_in_reg) begin
            acc = 'sh0;

            for (int k = 0 ; k < N_TAPS ; k++) begin
                prod = delay_reg[k] * coeff_ram[k];
                acc = acc + {{(ACC_WIDTH - PRODUCT_WIDTH){prod[PRODUCT_WIDTH - 1]}}, prod};
            end

            result = acc;
            rounding_valid_in = 1'b1;
        end else begin
            result = 'sh0;
            rounding_valid_in = 1'b0;
            acc = 'sh0;
            prod = 'sh0;
        end
    end

    //rounding_overflow_arith #(
    //    .ACC_WIDTH(ACC_WIDTH),
    //    .ACC_FRAC(ACC_FRAC),
    //    .OUT_WIDTH(DATA_WIDTH),
    //    .OUT_FRAC(DATA_FRAC),
    //    .PROD_WIDTH(PRODUCT_WIDTH),
    //    .PROD_FRAC(PRODUCT_FRAC)
    //) ARITHMETIC_HANDLER (
    //    .acc_in(result),
    //    .valid_in(rounding_valid_in),
    //    .data_out(fir_out),
    //    .overflow(overflow),
    //    .underflow(underflow),
    //    .valid_out(valid_out)
    //);

    rounding_overflow_arith #(
        .ACC_WIDTH(ACC_WIDTH),
        .ACC_FRAC(ACC_FRAC),
        .OUT_WIDTH(DATA_WIDTH),
        .OUT_FRAC(DATA_FRAC),
        .PROD_WIDTH(PRODUCT_WIDTH),
        .PROD_FRAC(PRODUCT_FRAC)
    ) ARITHMETIC_HANDLER (
        .data_in    (result             ),
        .valid_in   (rounding_valid_in  ),
        .data_out   (fir_out            ),
        .overflow   (overflow           ),
        .underflow  (underflow          ), 
        .valid_out  (valid_out          )
    );

endmodule