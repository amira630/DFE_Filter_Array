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

    logic                               guard_bit   ;
    logic                               round_bit   ;
    logic                               sticky_bit  ;

    logic signed [RAW_WIDTH - 1 : 0]    raw         ;

    logic                               increment   ;

    logic signed [OUT_WIDTH - 1 : 0]    result      ;

    assign acc_in = data_in / SCALE;

    always_comb begin
        data_out    = {OUT_WIDTH{1'sb0}};
        overflow    = 'b0 ;
        underflow   = 'b0 ;
        valid_out   = 'b0 ;

        if (valid_in) begin
            valid_out = 'b1;

            guard_bit   = acc_in[FRAC_DIFF - 1]                             ;
            round_bit   = acc_in[FRAC_DIFF - 2]                             ;
            sticky_bit  = |acc_in[FRAC_DIFF - 3 : 0]                        ;

            raw         = acc_in >>> FRAC_DIFF                              ;

            increment   = guard_bit && (round_bit || sticky_bit || raw[0])  ;

            result      = raw + increment                                   ;

            if (result > MAX_VAL) begin
                data_out    = MAX_VAL                   ;
                overflow    = 1'b1                      ;
                underflow   = 1'b0                      ;
            end else if (result < MIN_VAL) begin
                data_out    = MIN_VAL                   ;
                underflow   = 1'b1                      ;
                overflow    = 1'b0                      ;
            end else begin
                data_out    = result[OUT_WIDTH - 1 : 0] ;
            end
            
        end else begin
            data_out    = {OUT_WIDTH{1'sb0}}                                ;
            overflow    = 1'b0                                              ;
            underflow   = 1'b0                                              ;
            valid_out   = 1'b0                                              ;
        end
    end
endmodule
