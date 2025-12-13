////////////////////////////////////////////////////////////////////////////////
// Design Author: Mustaf EL-Sherif
// Verified by Mustaf EL-Sherif
// --> Linting check
// --> Synthesis
// --> Functional Simulation
// Design: Fractional Decimator
// Date: 02-11-2025
////////////////////////////////////////////////////////////////////////////////

module fractional_decimator #(
    parameter  int DATA_WIDTH      = 32'd16                             ,
    parameter  int DATA_FRAC       = 32'd15                             ,
    parameter  int COEFF_WIDTH     = 32'd20                             ,
    parameter  int COEFF_FRAC      = 32'd18                             ,
    localparam int N_TAP           = 32'd72                             ,
    localparam int M               = 32'd3                              ,
    localparam int PHASE_N_TAP     = N_TAP / 2                          ,
    localparam int PROD_WIDTH      = DATA_WIDTH + COEFF_WIDTH           ,
    localparam int PROD_FRAC       = DATA_FRAC + COEFF_FRAC             ,
    localparam int ACC_WIDTH       = PROD_WIDTH + $clog2(PHASE_N_TAP)   ,
    localparam int ACC_FRAC        = PROD_FRAC                          ,
    localparam int COUNTER_WIDTH   = $clog2(M)                          ,
    localparam int SCALE           = 32'd1                                 
) (
    input  logic                                clk                             ,
    input  logic                                valid_in                        ,
    input  logic                                rst_n                           ,
    input  logic                                bypass                          ,
    input  logic         			            coeff_wr_en                     ,
    input  logic signed [COEFF_WIDTH - 1 : 0]   coeff_data_in  [N_TAP - 1 : 0]  ,
    input  logic signed [DATA_WIDTH - 1 : 0]    filter_in                       ,
    output logic signed [COEFF_WIDTH - 1 : 0]   coeff_data_out [N_TAP - 1 : 0]  ,
    output logic signed [DATA_WIDTH - 1 : 0]    filter_out                      ,
    output logic                                overflow                        ,
    output logic                                underflow                       ,
    output logic                                valid_out                       
);

    // Default Coefficient Values (S20.18 format)
    // Coefficients generated using MATLAB's firpm function
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF0   = 20'shfff76  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF18  = 20'shff4c4  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF1   = 20'shffcac  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF19  = 20'sh00898  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF2   = 20'shffada  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF20  = 20'sh0054b  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF3   = 20'shfff7d  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF21  = 20'shfefcc  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF4   = 20'sh00309  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF22  = 20'sh00a01  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF5   = 20'shffe7b  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF23  = 20'sh00a1c  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF6   = 20'shffe50  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF24  = 20'shfe8d4  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF7   = 20'sh00341  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF25  = 20'sh00b42  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF8   = 20'shffede  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF26  = 20'sh01214  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF9   = 20'shffd19  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF27  = 20'shfde19  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF10  = 20'sh0044f  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF28  = 20'sh00c46  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF11  = 20'shfff5e  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF29  = 20'sh02101  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF12  = 20'shffb2b  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF30  = 20'shfc9d4  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF13  = 20'sh005a7  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF31  = 20'sh00cfe  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF14  = 20'sh0006b  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF32  = 20'sh047c8  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF15  = 20'shff873  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF33  = 20'shf8a18  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF16  = 20'sh0071e  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF34  = 20'sh00d5d  ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF17  = 20'sh00246  ;    localparam logic signed [COEFF_WIDTH - 1 : 0] COEFF35  = 20'sh22d87  ;
   
    logic           [COUNTER_WIDTH - 1 : 0]                 cur_count                                   ;

    logic signed    [ACC_WIDTH - 1 : 0]                     acc                                         ;

    logic signed    [PROD_WIDTH - 1 : 0]                    prod_result         [PHASE_N_TAP - 1 : 0]   ;
    logic signed    [ACC_WIDTH - 1 : 0]                     prod_res_ext        [PHASE_N_TAP - 1 : 0]   ;

    logic signed    [DATA_WIDTH - 1 : 0]                    result                                      ;
    logic                                                   result_valid                                ;
    logic                                                   result_overflow                             ;
    logic                                                   result_underflow                            ;

    logic signed    [COEFF_WIDTH - 1 : 0]                   coeff_phase1        [PHASE_N_TAP - 1 : 0]   ;
    logic signed    [COEFF_WIDTH - 1 : 0]                   coeff_phase2        [PHASE_N_TAP - 1 : 0]   ;
    logic signed    [COEFF_WIDTH - 1 : 0]                   coeff_select        [PHASE_N_TAP - 1 : 0]   ;

    
    logic           [(PHASE_N_TAP * DATA_WIDTH) - 1 : 0]    delay_line                                  ;
    logic signed    [DATA_WIDTH - 1 : 0]                    delay_line_sliced   [PHASE_N_TAP - 1 : 0]   ;

    logic                                                   phase_enable                                ;

    
    assign phase_enable = (((cur_count == {{(COUNTER_WIDTH - 1){1'b0}}, 1'b1}) || (cur_count == (M - 1))) && valid_in) ? 1'b1 : 1'b0;

    genvar slice_idx;
    generate
        for(slice_idx = 0 ; slice_idx < PHASE_N_TAP ; slice_idx++) begin
            assign delay_line_sliced[slice_idx] = delay_line[(slice_idx * DATA_WIDTH) +: DATA_WIDTH];
            
            assign coeff_select[slice_idx] = (cur_count == {{(COUNTER_WIDTH-1){1'b0}}, 1'b1}) ? coeff_phase1[slice_idx] : coeff_phase2[slice_idx];

            assign prod_result[slice_idx] = {{(PROD_WIDTH - DATA_WIDTH){delay_line_sliced[slice_idx][DATA_WIDTH - 1]}}, delay_line_sliced[slice_idx]} *

                                            {{(PROD_WIDTH - COEFF_WIDTH){coeff_select[slice_idx][COEFF_WIDTH - 1]}}, coeff_select[slice_idx]};
        end
    endgenerate

    genvar ext_idx;
    generate
        for (ext_idx = 0 ; ext_idx < PHASE_N_TAP ; ext_idx++) begin : sign_ext_gen
            assign prod_res_ext[ext_idx] = {{(ACC_WIDTH - PROD_WIDTH){prod_result[ext_idx][PROD_WIDTH - 1]}}, prod_result[ext_idx]};
        end
    endgenerate

    generate       
        /*************** LEVEL_1 ****************/
        localparam int LEVEL1_DEPTH = PHASE_N_TAP >> 1;

        logic signed [ACC_WIDTH - 1 : 0] acc_L1 [LEVEL1_DEPTH - 1 : 0];

        for (genvar node = 0 ; node < LEVEL1_DEPTH ; node++) begin
            assign acc_L1[node] = prod_res_ext[2 * node] + prod_res_ext[(2 * node) + 1];
        end
            
        /*************** LEVEL_2 ****************/
        localparam int LEVEL2_DEPTH = LEVEL1_DEPTH >> 1;
        
        logic signed [ACC_WIDTH - 1 : 0] acc_L2 [LEVEL2_DEPTH - 1 : 0];
        
        for (genvar node = 0 ; node < LEVEL2_DEPTH ; node++) begin
            assign acc_L2[node] = acc_L1[2 * node] + acc_L1[(2 * node) + 1];
        end

        /*************** LEVEL_3 ****************/  
        localparam int LEVEL3_DEPTH = (LEVEL2_DEPTH >> 1) + 1;
        
        logic signed [ACC_WIDTH - 1 : 0] acc_L3 [LEVEL3_DEPTH - 1 : 0];
        
        for (genvar node = 0 ; node < LEVEL3_DEPTH ; node++) begin
            if (node == (LEVEL3_DEPTH - 1)) begin
                assign acc_L3[node] = acc_L2[2 * node];
            end else begin
                assign acc_L3[node] = acc_L2[2 * node] + acc_L2[(2 * node) + 1];
            end
        end
            
        /*************** LEVEL_4 ****************/
        localparam int LEVEL4_DEPTH = (LEVEL3_DEPTH >> 1) + 1;
        
        logic signed [ACC_WIDTH - 1 : 0] acc_L4 [LEVEL4_DEPTH - 1 : 0];
        
        for (genvar node = 0 ; node < LEVEL4_DEPTH ; node++) begin
            if (node == (LEVEL4_DEPTH - 1)) begin
                assign acc_L4[node] = acc_L3[2 * node];
            end else begin
                assign acc_L4[node] = acc_L3[2 * node] + acc_L3[(2 * node) + 1];
            end
        end

        /*************** LEVEL_5 ****************/   
        localparam int LEVEL5_DEPTH = (LEVEL4_DEPTH >> 1) + 1;
        
        logic signed [ACC_WIDTH - 1 : 0] acc_L5 [LEVEL5_DEPTH - 1 : 0];
        
        for (genvar node = 0 ; node < LEVEL5_DEPTH ; node++) begin
            if (node == (LEVEL5_DEPTH - 1)) begin
                assign acc_L5[node] = acc_L4[2 * node];
            end else begin
                assign acc_L5[node] = acc_L4[2 * node] + acc_L4[(2 * node) + 1];
            end
        end
       
        always_comb begin
            acc = {ACC_WIDTH{1'sb0}};
            if (valid_in) begin
                acc = acc_L5[0] + acc_L5[1];
            end
        end
    endgenerate

    // Continuously output all coefficients
    always_comb begin
        for (int k = 0; k < PHASE_N_TAP; k++) begin
            coeff_data_out[k * 2]     = coeff_phase1[k];
            coeff_data_out[k * 2 + 1] = coeff_phase2[k];
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
                coeff_phase1[i] <= coeff_data_in[i * 2]         ;
                coeff_phase2[i] <= coeff_data_in[(i * 2) + 1]   ;
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

    always_ff @(posedge clk or negedge rst_n) begin    : DELAYLINE_PROC
        if (!rst_n) begin
            delay_line <= {(PHASE_N_TAP * DATA_WIDTH){1'b0}};
        end else if (valid_in) begin

            delay_line <= {delay_line[0 +: ((PHASE_N_TAP - 1) * DATA_WIDTH)], filter_in};
            
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin    : OUTPUT_AND_STATUS_PROC 
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
                valid_out   <= valid_in             ;
            end else if (phase_enable) begin
                filter_out  <= result               ;
                overflow    <= result_overflow      ;
                underflow   <= result_underflow     ;
                valid_out   <= result_valid         ;
            end else begin
                valid_out   <= 1'b0;
            end
        end else begin
            valid_out   <= 1'b0;
        end
    end

    rounding_overflow_arith #(
        .ACC_WIDTH  (ACC_WIDTH) ,
        .ACC_FRAC   (ACC_FRAC)  ,
        .OUT_WIDTH  (DATA_WIDTH),
        .OUT_FRAC   (DATA_FRAC) ,
        .SCALE      (SCALE)
    ) ARITHMETIC_HANDLER (
        .data_in    (acc)               ,
        .valid_in   (valid_in)          ,
        .data_out   (result)            ,
        .overflow   (result_overflow)   ,
        .underflow  (result_underflow)  , 
        .valid_out  (result_valid)
    );

endmodule

