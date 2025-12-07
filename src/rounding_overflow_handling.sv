////////////////////////////////////////////////////////////////////////////////
// Design Author: Mustaf EL-Sherif
// Verified by Mustaf EL-Sherif
// --> Linting check
// --> Synthesis
// --> Functional Simulation
// Design: Rounding and Overflow Arithemetic Handler
// Date: 02-11-2025
////////////////////////////////////////////////////////////////////////////////

module rounding_overflow_arith #(
    parameter ACC_WIDTH     = 32'd42    ,
    parameter ACC_FRAC      = 32'd32    ,
    parameter OUT_WIDTH     = 32'd16    ,
    parameter OUT_FRAC      = 32'd15    ,
    parameter SCALE         = 32'd1     
) (
    input  logic signed [ACC_WIDTH - 1 : 0]     data_in     ,
    input  logic                                valid_in    ,

    output logic signed [OUT_WIDTH - 1 : 0]     data_out    ,
    output logic                                overflow    ,
    output logic                                underflow   ,
    output logic                                valid_out
);
    localparam int                          OUT_MAX_INT = (1 << (OUT_WIDTH - 1)) - 1    ;     // 32767 for 16-bit signed
    localparam int                          OUT_MIN_INT = - (1 << (OUT_WIDTH - 1))      ;     // -32768 for 16-bit signed

    localparam signed [OUT_WIDTH - 1 : 0]   MAX_VAL     = OUT_MAX_INT[OUT_WIDTH - 1 : 0];
    localparam signed [OUT_WIDTH - 1 : 0]   MIN_VAL     = OUT_MIN_INT[OUT_WIDTH - 1 : 0];

    localparam int                          FRAC_DIFF   = ACC_FRAC - OUT_FRAC           ;

    localparam int                          RAW_WIDTH   = ACC_WIDTH - FRAC_DIFF         ;

    logic signed [ACC_WIDTH - 1 : 0]    acc_in          ;

    // rounding bits
    logic                               guard_bit       ;
    logic                               round_bit       ;
    logic                               sticky_bit      ;

    logic signed [RAW_WIDTH - 1 : 0]    raw             ;

    logic                               increment       ;

    logic signed [OUT_WIDTH - 1 : 0]    result          ;
    logic signed [RAW_WIDTH : 0]        result_interm   ;

    assign acc_in = data_in >>> $clog2(SCALE);

    // ---------- safe compile-time branching to avoid illegal bit-slices ----------
    generate
        if (FRAC_DIFF >= 3) begin : GEN1_GE3
            logic signed [ACC_WIDTH - 1 : 0] raw_intrm;

            // original, full rounding behavior
            assign guard_bit    = acc_in[FRAC_DIFF - 1]         ;
            assign round_bit    = acc_in[FRAC_DIFF - 2]         ;
            assign sticky_bit   = |acc_in[FRAC_DIFF - 3 : 0]    ;
            assign raw_intrm    = acc_in >>> FRAC_DIFF          ;
            assign raw          = raw_intrm[RAW_WIDTH - 1 : 0]  ;
        end
        else if (FRAC_DIFF == 2) begin : GEN1_EQ2
            logic signed [ACC_WIDTH - 1 : 0] raw_intrm;

            // guard = bit1, round = bit0, no sticky bits below
            assign guard_bit    = acc_in[1]                     ;
            assign round_bit    = acc_in[0]                     ;
            assign sticky_bit   = 1'b0                          ;
            assign raw_intrm    = acc_in >>> FRAC_DIFF          ;
            assign raw          = raw_intrm[RAW_WIDTH - 1 : 0]  ;
        end
        else if (FRAC_DIFF == 1) begin : GEN1_EQ1
            logic signed [ACC_WIDTH - 1 : 0] raw_intrm;

            // guard = bit0, no round or sticky bits
            assign guard_bit    = acc_in[0]                     ;
            assign round_bit    = 1'b0                          ;
            assign sticky_bit   = 1'b0                          ;
            assign raw_intrm    = acc_in >>> FRAC_DIFF          ;
            assign raw          = raw_intrm[RAW_WIDTH - 1 : 0]  ;
        end
        else begin : GEN1_LE0
            // FRAC_DIFF == 0: no fractional bits, no rounding
            assign guard_bit  = 1'b0                        ;
            assign round_bit  = 1'b0                        ;
            assign sticky_bit = 1'b0                        ;
            assign raw        = acc_in [RAW_WIDTH - 1 : 0]  ;
        end
    endgenerate

    generate
        if (FRAC_DIFF <= 0) begin : GEN2_LE0
            // ---------- main rounding & saturation logic (kept from your original) ----------
            always_comb begin
                overflow    = 1'b0 ;
                underflow   = 1'b0 ;
                valid_out   = 1'b0 ;

                if (valid_in) begin
                    valid_out = 1'b1;

                    // rounding: sticky/round/guard logic exactly as original
                    increment   = guard_bit && (round_bit || sticky_bit || raw[0]);

                    // raw + increment
                    // Note: raw may be wider than OUT_WIDTH; result is declared as OUT_WIDTH signed
                    result_interm   = raw + $signed({{(RAW_WIDTH - 1){1'b0}},increment});
                    result          = result_interm[OUT_WIDTH - 1 : 0]                  ;

                    // saturation / clipping
                    if (result > MAX_VAL) begin
                        data_out    = MAX_VAL   ;
                        overflow    = 1'b1      ;
                        underflow   = 1'b0      ;
                    end else if (result < MIN_VAL) begin
                        data_out    = MIN_VAL   ;
                        underflow   = 1'b1      ;
                        overflow    = 1'b0      ;
                    end else begin
                        data_out    = result    ;
                        underflow   = 1'b0      ;
                        overflow    = 1'b0      ;
                    end
                end else begin
                    data_out        = {OUT_WIDTH{1'sb0}}    ;
                    overflow        = 1'b0                  ;
                    underflow       = 1'b0                  ;
                    valid_out       = 1'b0                  ;
                    increment       = 1'b0                  ;
                    result_interm   = {RAW_WIDTH{1'sb0}}    ;
                    result          = {OUT_WIDTH{1'sb0}}    ;
                end
            end
        end
        else begin : GEN2_G0
            // ---------- main rounding & saturation logic (kept from your original) ----------
            always_comb begin
                overflow    = 1'b0 ;
                underflow   = 1'b0 ;
                valid_out   = 1'b0 ;

                if (valid_in) begin
                    valid_out = 1'b1;

                    // rounding: sticky/round/guard logic exactly as original
                    increment   = guard_bit && (round_bit || sticky_bit || raw[0]);

                    // raw + increment
                    // Note: raw may be wider than OUT_WIDTH; result is declared as OUT_WIDTH signed
                    result_interm   = raw + $signed({{(RAW_WIDTH - 1){1'b0}},increment});
                    result          = result_interm[OUT_WIDTH - 1 : 0]                  ;

                    // saturation / clipping
                    if (result_interm > MAX_VAL) begin
                        data_out    = MAX_VAL   ;
                        overflow    = 1'b1      ;
                        underflow   = 1'b0      ;
                    end else if (result_interm < MIN_VAL) begin
                        data_out    = MIN_VAL   ;
                        underflow   = 1'b1      ;
                        overflow    = 1'b0      ;
                    end else begin
                        data_out    = result    ;
                        overflow    = 1'b0      ;
                        underflow   = 1'b0      ;
                    end
                end else begin
                    data_out        = {OUT_WIDTH{1'sb0}}    ;
                    overflow        = 1'b0                  ;
                    underflow       = 1'b0                  ;
                    valid_out       = 1'b0                  ;
                    increment       = 1'b0                  ;
                    result_interm   = {RAW_WIDTH{1'sb0}}    ;
                    result          = {OUT_WIDTH{1'sb0}}    ;
                end
            end
        end
    endgenerate
endmodule
