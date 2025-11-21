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
    localparam  FRAC_DIFF   = ACC_FRAC - OUT_FRAC       ;
    localparam  RAW_WIDTH   = ACC_WIDTH - FRAC_DIFF     ;

    localparam logic signed [RAW_WIDTH - 1 : 0]  MAX_VAL     = {{(RAW_WIDTH - OUT_WIDTH){1'b0}}, {1'b0, {(OUT_WIDTH - 1){1'b1}}}};
    localparam logic signed [RAW_WIDTH - 1 : 0]  MIN_VAL     = {{(RAW_WIDTH - OUT_WIDTH){1'b1}}, {1'b1, {(OUT_WIDTH - 1){1'b0}}}};

    logic signed [ACC_WIDTH - 1 : 0]    acc_in;

    // rounding bits
    logic                               guard_bit   ;
    logic                               round_bit   ;
    logic                               sticky_bit  ;

    logic signed [RAW_WIDTH - 1 : 0]    raw         ;

    logic                               increment   ;

    logic signed [RAW_WIDTH - 1 : 0]    result_interm ;
    logic signed [ACC_WIDTH - 1 : 0]    shifted_acc   ;

    assign acc_in = data_in >>> $clog2(SCALE);

    // ---------- safe compile-time branching to avoid illegal bit-slices ----------
    generate
        if (FRAC_DIFF >= 3) begin : GEN_GE3
            // original, full rounding behavior
            assign guard_bit  = acc_in[FRAC_DIFF - 1];
            assign round_bit  = acc_in[FRAC_DIFF - 2];
            assign sticky_bit = |acc_in[FRAC_DIFF - 3 : 0];
            assign shifted_acc = acc_in >>> FRAC_DIFF;
            assign raw        = shifted_acc[RAW_WIDTH - 1 : 0];
        end
        else if (FRAC_DIFF == 2) begin : GEN_EQ2
            // guard = bit1, round = bit0, no sticky bits below
            assign guard_bit  = acc_in[1];
            assign round_bit  = acc_in[0];
            assign sticky_bit = 1'b0;
            assign shifted_acc = acc_in >>> FRAC_DIFF;
            assign raw        = shifted_acc[RAW_WIDTH - 1 : 0];
        end
        else if (FRAC_DIFF == 1) begin : GEN_EQ1
            // guard = bit0, no round or sticky bits
            assign guard_bit  = acc_in[0];
            assign round_bit  = 1'b0;
            assign sticky_bit = 1'b0;
            assign shifted_acc = acc_in >>> FRAC_DIFF;
            assign raw        = shifted_acc[RAW_WIDTH - 1 : 0];
        end
        else begin : GEN_EQ0
            // FRAC_DIFF == 0: no fractional bits, no rounding
            assign guard_bit  = 1'b0;
            assign round_bit  = 1'b0;
            assign sticky_bit = 1'b0;
            assign raw        = acc_in[RAW_WIDTH - 1 : 0];
        end
    endgenerate

    // ---------- main rounding & saturation logic (kept from your original) ----------
    always_comb begin
        if (valid_in) begin
            valid_out = 1'b1;

            // rounding: sticky/round/guard logic exactly as original
            increment   = guard_bit && (round_bit || sticky_bit || raw[0]);

            // raw + increment
            result_interm = raw + $signed({{(RAW_WIDTH - 1){1'sb0}}, increment});

            // saturation / clipping - compare full width result_interm
            if (result_interm > MAX_VAL) begin
                data_out    = MAX_VAL[OUT_WIDTH - 1 : 0];
                overflow    = 1'b1;
                underflow   = 1'b0;
            end else if (result_interm < MIN_VAL) begin
                data_out    = MIN_VAL[OUT_WIDTH - 1 : 0];
                underflow   = 1'b1;
                overflow    = 1'b0;
            end else begin
                data_out    = result_interm[OUT_WIDTH - 1 : 0];
                underflow   = 1'b0 ;
                overflow    = 1'b0 ;
            end
        end else begin
            overflow    = 1'b0 ;
            underflow   = 1'b0 ;
            valid_out   = 1'b0 ;
            data_out    = {OUT_WIDTH{1'sb0}};
            increment   = 1'b0 ;
            result_interm = {RAW_WIDTH{1'sb0}} ;
        end
    end

endmodule
