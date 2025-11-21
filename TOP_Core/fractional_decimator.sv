module fractional_decimator #(
    parameter   DATA_WIDTH      = 16                                ,
    parameter   DATA_FRAC       = 15                                ,
    parameter   COEFF_WIDTH     = 20                                ,
    parameter   COEFF_FRAC      = 18                                ,
    parameter   N_TAP           = 72                                ,
    localparam  M               = 3                                 ,
    localparam  PHASE_N_TAP     = N_TAP / 2                         ,
    localparam  PROD_WIDTH      = DATA_WIDTH + COEFF_WIDTH          ,
    localparam  PROD_FRAC       = DATA_FRAC + COEFF_FRAC            ,
    localparam  ACC_WIDTH       = PROD_WIDTH + $clog2(PHASE_N_TAP)  ,
    localparam  ACC_FRAC        = PROD_FRAC                         ,
    localparam  COUNTER_WIDTH   = $clog2(M)                         ,
    localparam  SCALE           = 1                                 
) (
    input  logic                                clk                             ,
    input  logic                                valid_in                        ,
    input  logic                                rst_n                           ,
    input  logic                                bypass                          ,
    input  logic         			            coeff_wr_en                     ,
    input  logic signed [COEFF_WIDTH - 1 : 0]   coeff_data_in  [N_TAP - 1 : 0]  ,
    input  logic signed [DATA_WIDTH - 1 : 0]    filter_in                       ,
    output logic signed [COEFF_WIDTH - 1 : 0]    coeff_data_out [N_TAP - 1 : 0]  ,
    output logic signed [DATA_WIDTH - 1 : 0]    filter_out                      ,
    output logic                                overflow                        ,
    output logic                                underflow                       ,
    output logic                                valid_out                       
);

    // Default Coefficient Values (S20.18 format)
    // Coefficients generated using MATLAB's firpm function
    localparam COEFF0   = 20'shfff76  ;    localparam COEFF18  = 20'shff4c4  ;
    localparam COEFF1   = 20'shffcac  ;    localparam COEFF19  = 20'sh00898  ;
    localparam COEFF2   = 20'shffada  ;    localparam COEFF20  = 20'sh0054b  ;
    localparam COEFF3   = 20'shfff7d  ;    localparam COEFF21  = 20'shfefcc  ;
    localparam COEFF4   = 20'sh00309  ;    localparam COEFF22  = 20'sh00a01  ;
    localparam COEFF5   = 20'shffe7b  ;    localparam COEFF23  = 20'sh00a1c  ;
    localparam COEFF6   = 20'shffe50  ;    localparam COEFF24  = 20'shfe8d4  ;
    localparam COEFF7   = 20'sh00341  ;    localparam COEFF25  = 20'sh00b42  ;
    localparam COEFF8   = 20'shffede  ;    localparam COEFF26  = 20'sh01214  ;
    localparam COEFF9   = 20'shffd19  ;    localparam COEFF27  = 20'shfde19  ;
    localparam COEFF10  = 20'sh0044f  ;    localparam COEFF28  = 20'sh00c46  ;
    localparam COEFF11  = 20'shfff5e  ;    localparam COEFF29  = 20'sh02101  ;
    localparam COEFF12  = 20'shffb2b  ;    localparam COEFF30  = 20'shfc9d4  ;
    localparam COEFF13  = 20'sh005a7  ;    localparam COEFF31  = 20'sh00cfe  ;
    localparam COEFF14  = 20'sh0006b  ;    localparam COEFF32  = 20'sh047c8  ;
    localparam COEFF15  = 20'shff873  ;    localparam COEFF33  = 20'shf8a18  ;
    localparam COEFF16  = 20'sh0071e  ;    localparam COEFF34  = 20'sh00d5d  ;
    localparam COEFF17  = 20'sh00246  ;    localparam COEFF35  = 20'sh22d87  ;
   
    logic           [COUNTER_WIDTH - 1 : 0]  cur_count                               ;

    logic signed    [ACC_WIDTH - 1 : 0]      acc                                     ;

    logic signed    [PROD_WIDTH - 1 : 0]     prod_result                             ;

    logic signed    [DATA_WIDTH - 1 : 0]     result                                  ;
    logic                                    result_valid                            ;
    logic                                    result_overflow                         ;
    logic                                    result_underflow                        ;

    logic signed    [COEFF_WIDTH - 1 : 0]    coeff_phase1    [PHASE_N_TAP - 1 : 0]   ;
    logic signed    [COEFF_WIDTH - 1 : 0]    coeff_phase2    [PHASE_N_TAP - 1 : 0]   ;

    
    logic signed    [DATA_WIDTH - 1 : 0]     delayline       [PHASE_N_TAP - 1 : 0]   ;

    logic                                    phase_enable                            ;
    
    assign phase_enable = ((cur_count == {{(COUNTER_WIDTH-1){1'b0}}, 1'b1}) || (cur_count == (M - 1))) ? 1'b1 : 1'b0;

    // Continuously output all coefficients
    always_comb begin
        for (int k = 0; k < PHASE_N_TAP; k++) begin
            coeff_data_out[k * 2]     = coeff_phase1[k][COEFF_WIDTH - 1 : 0];
            coeff_data_out[k * 2 + 1] = coeff_phase2[k][COEFF_WIDTH - 1 : 0];
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin    : COEFF_INIT_EDIT_PROC
        if (!rst_n) begin
            // Initialize coefficients directly in reset
            coeff_phase1[0]  <= COEFF0   ;   coeff_phase2[0]  <= COEFF1   ;
            coeff_phase1[1]  <= COEFF2   ;   coeff_phase2[1]  <= COEFF3   ;
            coeff_phase1[2]  <= COEFF4   ;   coeff_phase2[2]  <= COEFF5   ;
            coeff_phase1[3]  <= COEFF6   ;   coeff_phase2[3]  <= COEFF7   ;
            coeff_phase1[4]  <= COEFF8   ;   coeff_phase2[4]  <= COEFF9   ;
            coeff_phase1[5]  <= COEFF10  ;   coeff_phase2[5]  <= COEFF11  ;
            coeff_phase1[6]  <= COEFF12  ;   coeff_phase2[6]  <= COEFF13  ;
            coeff_phase1[7]  <= COEFF14  ;   coeff_phase2[7]  <= COEFF15  ;
            coeff_phase1[8]  <= COEFF16  ;   coeff_phase2[8]  <= COEFF17  ;
            coeff_phase1[9]  <= COEFF18  ;   coeff_phase2[9]  <= COEFF19  ;
            coeff_phase1[10] <= COEFF20  ;   coeff_phase2[10] <= COEFF21  ;
            coeff_phase1[11] <= COEFF22  ;   coeff_phase2[11] <= COEFF23  ;
            coeff_phase1[12] <= COEFF24  ;   coeff_phase2[12] <= COEFF25  ;
            coeff_phase1[13] <= COEFF26  ;   coeff_phase2[13] <= COEFF27  ;
            coeff_phase1[14] <= COEFF28  ;   coeff_phase2[14] <= COEFF29  ;
            coeff_phase1[15] <= COEFF30  ;   coeff_phase2[15] <= COEFF31  ;
            coeff_phase1[16] <= COEFF32  ;   coeff_phase2[16] <= COEFF33  ;
            coeff_phase1[17] <= COEFF34  ;   coeff_phase2[17] <= COEFF35  ;
            coeff_phase1[18] <= COEFF35  ;   coeff_phase2[18] <= COEFF34  ;
            coeff_phase1[19] <= COEFF33  ;   coeff_phase2[19] <= COEFF32  ;
            coeff_phase1[20] <= COEFF31  ;   coeff_phase2[20] <= COEFF30  ;
            coeff_phase1[21] <= COEFF29  ;   coeff_phase2[21] <= COEFF28  ;
            coeff_phase1[22] <= COEFF27  ;   coeff_phase2[22] <= COEFF26  ;
            coeff_phase1[23] <= COEFF25  ;   coeff_phase2[23] <= COEFF24  ;
            coeff_phase1[24] <= COEFF23  ;   coeff_phase2[24] <= COEFF22  ;
            coeff_phase1[25] <= COEFF21  ;   coeff_phase2[25] <= COEFF20  ;
            coeff_phase1[26] <= COEFF19  ;   coeff_phase2[26] <= COEFF18  ;
            coeff_phase1[27] <= COEFF17  ;   coeff_phase2[27] <= COEFF16  ;
            coeff_phase1[28] <= COEFF15  ;   coeff_phase2[28] <= COEFF14  ;
            coeff_phase1[29] <= COEFF13  ;   coeff_phase2[29] <= COEFF12  ;
            coeff_phase1[30] <= COEFF11  ;   coeff_phase2[30] <= COEFF10  ;
            coeff_phase1[31] <= COEFF9   ;   coeff_phase2[31] <= COEFF8   ;
            coeff_phase1[32] <= COEFF7   ;   coeff_phase2[32] <= COEFF6   ;
            coeff_phase1[33] <= COEFF5   ;   coeff_phase2[33] <= COEFF4   ;
            coeff_phase1[34] <= COEFF3   ;   coeff_phase2[34] <= COEFF2   ;
            coeff_phase1[35] <= COEFF1   ;   coeff_phase2[35] <= COEFF0   ;
        end else if(coeff_wr_en) begin
            for (int i = 0 ; i < PHASE_N_TAP ; i++) begin
                coeff_phase1[i] <= coeff_data_in[i * 2];
                coeff_phase2[i] <= coeff_data_in[i * 2 + 1];
            end
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin  : COUNTER_PROC
        if (!rst_n) begin
            cur_count <= {COUNTER_WIDTH{1'b0}};
        end else if (valid_in) begin
            if (cur_count == (M - 1)) begin
                cur_count <= {COUNTER_WIDTH{1'b0}};
            end else begin
                cur_count <= cur_count + 1'b1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin    : DELAYLINE_PROC
        if (!rst_n) begin
            for (int i = 0 ; i < PHASE_N_TAP ; i++) begin
                delayline[i] <= {DATA_WIDTH{1'sb0}};
            end
        end else if (valid_in) begin
            delayline[0] <= filter_in;
            for (int i = 0 ; i < (PHASE_N_TAP - 1) ; i = i + 1) begin
                delayline[i + 1] <= delayline[i];
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin    : OUTPUT_AND_STATUS_PROC 
        if (!rst_n) begin
            filter_out  <= {DATA_WIDTH{1'sb0}}  ;
            overflow    <= 1'b0                 ;
            underflow   <= 1'b0                 ;
            valid_out   <= 1'b0                 ;
        end else if (valid_in) begin
            if (bypass) begin
                filter_out  <= filter_in            ;
                overflow    <= 1'b0                 ;
                underflow   <= 1'b0                 ;
                valid_out   <= 1'b1                 ;
            end else if (phase_enable) begin
                filter_out  <= result               ;
                overflow    <= result_overflow      ;
                underflow   <= result_underflow     ;
                valid_out   <= result_valid         ;
            end else begin
                overflow    <= 1'b0                 ;
                underflow   <= 1'b0                 ;
                valid_out   <= 1'b0                 ;
            end
        end
    end

    always_comb begin
        acc = {ACC_WIDTH{1'sb0}};
        prod_result = {PROD_WIDTH{1'sb0}};

        if (valid_in) begin
            for (int j = 0 ; j < PHASE_N_TAP ; j = j + 1) begin      
                if (cur_count == {{(COUNTER_WIDTH-1){1'b0}}, 1'b1}) begin
                    prod_result = {{(PROD_WIDTH - DATA_WIDTH){delayline[j][DATA_WIDTH - 1]}}, delayline[j]} * 
                                  {{(PROD_WIDTH - COEFF_WIDTH){coeff_phase1[j][COEFF_WIDTH - 1]}}, coeff_phase1[j]};
                end else begin
                    prod_result = {{(PROD_WIDTH - DATA_WIDTH){delayline[j][DATA_WIDTH - 1]}}, delayline[j]} * 
                                  {{(PROD_WIDTH - COEFF_WIDTH){coeff_phase2[j][COEFF_WIDTH - 1]}}, coeff_phase2[j]};
                end
                acc = acc + $signed({{(ACC_WIDTH - PROD_WIDTH){prod_result[PROD_WIDTH - 1]}}, prod_result});
            end
        end
    end

    rounding_overflow_arith #(
        .ACC_WIDTH  (ACC_WIDTH) ,
        .ACC_FRAC   (ACC_FRAC)  ,
        .OUT_WIDTH  (DATA_WIDTH),
        .OUT_FRAC   (DATA_FRAC) ,
        .SCALE      (SCALE)
    ) ARITHMETIC_HANDLER (
        .data_in    (acc),
        .valid_in   (valid_in),
        .data_out   (result),
        .overflow   (result_overflow),
        .underflow  (result_underflow), 
        .valid_out  (result_valid)
    );

endmodule