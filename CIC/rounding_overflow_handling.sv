module rounding_overflow_arith #(
    parameter ACC_WIDTH     = 42    ,
    parameter ACC_FRAC      = 32    ,
    parameter OUT_WIDTH     = 16    ,
    parameter OUT_FRAC      = 15    ,
    parameter PROD_WIDTH    = 35    ,
    parameter PROD_FRAC     = 32    ,
    parameter SCALE         = 1

) (
    input  logic signed [ACC_WIDTH - 1 : 0]     data_in     ,
    input  logic                                valid_in    ,

    output logic signed [OUT_WIDTH - 1 : 0]     data_out    ,
    output logic                                overflow    ,
    output logic                                underflow   ,
    output logic                                valid_out
);
    localparam int      OUT_MAX_INT = (1 << (OUT_WIDTH - 1)) - 1;     // 32767 for 16-bit signed
    localparam int      OUT_MIN_INT = - (1 << (OUT_WIDTH - 1))  ;     // -32768 for 16-bit signed

    localparam signed   MAX_VAL     = OUT_MAX_INT               ;
    localparam signed   MIN_VAL     = OUT_MIN_INT               ;

    localparam int      FRAC_DIFF   = ACC_FRAC - OUT_FRAC       ;

    localparam int      RAW_WIDTH   = ACC_WIDTH - FRAC_DIFF     ;

    logic signed [ACC_WIDTH - 1 : 0]    acc_in;

    // rounding bits
    logic                               guard_bit   ;
    logic                               round_bit   ;
    logic                               sticky_bit  ;

    logic signed [RAW_WIDTH - 1 : 0]    raw         ;

    logic                               increment   ;

    logic signed [OUT_WIDTH - 1 : 0]    result      ;

    assign acc_in = data_in / SCALE;

    // ---------- safe compile-time branching to avoid illegal bit-slices ----------
    generate
        if (FRAC_DIFF >= 3) begin : GEN_GE3
            // original, full rounding behavior
            assign guard_bit  = acc_in[FRAC_DIFF - 1];
            assign round_bit  = acc_in[FRAC_DIFF - 2];
            assign sticky_bit = |acc_in[FRAC_DIFF - 3 : 0];
            assign raw        = acc_in >>> FRAC_DIFF;
        end
        else if (FRAC_DIFF == 2) begin : GEN_EQ2
            // guard = bit1, round = bit0, no sticky bits below
            assign guard_bit  = acc_in[1];
            assign round_bit  = acc_in[0];
            assign sticky_bit = 1'b0;
            assign raw        = acc_in >>> 2;
        end
        else if (FRAC_DIFF == 1) begin : GEN_EQ1
            // guard = bit0, no round or sticky bits
            assign guard_bit  = acc_in[0];
            assign round_bit  = 1'b0;
            assign sticky_bit = 1'b0;
            assign raw        = acc_in >>> 1;
        end
        else begin : GEN_EQ0
            // FRAC_DIFF == 0: no fractional bits, no rounding
            assign guard_bit  = 1'b0;
            assign round_bit  = 1'b0;
            assign sticky_bit = 1'b0;
            // raw width == ACC_WIDTH in this case, so direct assign
            assign raw        = acc_in;
        end
    endgenerate

    // ---------- main rounding & saturation logic (kept from your original) ----------
    always_comb begin
        //data_out    = {OUT_WIDTH{1'sb0}};
        overflow    = 1'b0 ;
        underflow   = 1'b0 ;
        valid_out   = 1'b0 ;

        if (valid_in) begin
            valid_out = 1'b1;

            // rounding: sticky/round/guard logic exactly as original
            increment   = guard_bit && (round_bit || sticky_bit || raw[0]);

            // raw + increment
            // Note: raw may be wider than OUT_WIDTH; result is declared as OUT_WIDTH signed
            result      = raw + increment;

            // saturation / clipping
            if (result > MAX_VAL) begin
                data_out    = MAX_VAL;
                overflow    = 1'b1;
                underflow   = 1'b0;
            end else if (result < MIN_VAL) begin
                data_out    = MIN_VAL;
                underflow   = 1'b1;
                overflow    = 1'b0;
            end else begin
                data_out    = result[OUT_WIDTH - 1 : 0];
            end

        end else begin
            //data_out    = {OUT_WIDTH{1'sb0}}  ;
            overflow    = 1'b0                ;
            underflow   = 1'b0                ;
            //valid_out   = 1'b0                ;
        end
    end

endmodule
