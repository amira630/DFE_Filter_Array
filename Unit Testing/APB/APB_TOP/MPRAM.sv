////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Design: An integrator module.
// Date: 02-11-2025
// Description: MPRAM for APB Adaptation
////////////////////////////////////////////////////////////////////////////////

module MPRAM #(
    parameter int ADDR_WIDTH  = 32'd7    ,
    parameter int DATA_WIDTH  = 32'd32   ,
    parameter int TAPS        = 32'd72   ,
    parameter int COEFF_WIDTH = 32'd20   ,
    parameter int NUM_DENUM   = 32'd5    ,
    parameter int COMP        = 32'd5
)(
    input   logic                                   clk                                     ,
    input   logic                                   rst_n                                   ,
        
    input   logic                                   FRAC_DECI_EN                            ,
    input   logic                                   IIR_EN                                  ,
    input   logic                                   CTRL_EN                                 ,
    input   logic                                   CIC_EN                                  ,

    input   logic                                   PWRITE                                  ,
    input   logic                                   PENABLE                                 ,
    input   logic           [ADDR_WIDTH - 1 : 0]    DATA_ADDR                               ,
    input   logic signed    [DATA_WIDTH - 1 : 0]    DATA_IN                                 ,
        
    output  logic                                   PREADY                                  ,
    output  logic           [DATA_WIDTH - 1 : 0]    PRDATA                                  ,

    output  logic                                   FRAC_DECI_VLD                           ,       // Fractional Decimator Coefficients Valid
    output  logic signed    [COEFF_WIDTH - 1 : 0]   FRAC_DECI_OUT    [TAPS - 1 : 0]         ,       // Fractional Decimator Coefficients

    output  logic                                   IIR_24_VLD                              ,       // IIR 2.4MHz Notch Coefficients Valid
    output  logic signed    [COEFF_WIDTH - 1 : 0]   IIR_24_OUT       [NUM_DENUM - 1 : 0]    ,       // IIR 2.4MHz Notch Coefficients
    output  logic                                   IIR_5_1_VLD                             ,       // IIR 1MHz Notch Coefficients Valid
    output  logic signed    [COEFF_WIDTH - 1 : 0]   IIR_5_1_OUT      [NUM_DENUM - 1 : 0]    ,       // IIR 1MHz Notch Coefficients
    output  logic                                   IIR_5_2_VLD                             ,       // IIR 2MHz Notch Coefficients Valid
    output  logic signed    [COEFF_WIDTH - 1 : 0]   IIR_5_2_OUT      [NUM_DENUM - 1 : 0]    ,       // IIR 2MHz Notch Coefficients

    output  logic signed    [4 : 0]                 CIC_R_OUT                               ,       // CIC Decimation Factor

    output  logic                                   CTRL             [4 : 0]                ,       // [0]Frac_Deci, [1] IIR_Notch_2.4, [2] IIR_Notch_5, [3] CIC, [4] FIR, ON/OFF
    
    output  logic           [1 : 0]                 OUT_SEL                                 ,       // Allow the output of a certain block 

    output  logic           [2 : 0]                 COEFF_SEL                               ,       // Allow the output of a certain block's coefficients can be 0 to 4

    output  logic           [2 : 0]                 STATUS                                          // Show Overflow, Underflow, Ready and valid_out for a certain block can be 0 to 5
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


    // Coefficients 1 MHz Notch Filter
    localparam logic signed [COEFF_WIDTH - 1 : 0] B0_1 = 20'sh37061     ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B1_1 = 20'shc8f9f     ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B2_1 = 20'sh37061     ;

    localparam logic signed [COEFF_WIDTH - 1 : 0] A1_1 = 20'shc8f9f     ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] A2_1 = 20'sh2e0c3     ;

    // Coefficients 2 MHz Notch Filter
    localparam logic signed [COEFF_WIDTH - 1 : 0] B0_2 = 20'sh37061     ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B1_2 = 20'sh37061     ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B2_2 = 20'sh37061     ;

    localparam logic signed [COEFF_WIDTH - 1 : 0] A1_2 = 20'sh37061     ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] A2_2 = 20'sh2e0c3     ;

    // Coefficients 2.4 MHz Notch Filter
    localparam logic signed [COEFF_WIDTH - 1 : 0] B0_2_4 = 20'sh37061   ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B1_2_4 = 20'sh5907c   ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] B2_2_4 = 20'sh37061   ;

    localparam logic signed [COEFF_WIDTH - 1 : 0] A1_2_4 = 20'sh5907c   ;
    localparam logic signed [COEFF_WIDTH - 1 : 0] A2_2_4 = 20'sh2e0c3   ;

    logic [COMP - 1 : 0]        ENABLES         ;

    logic [ADDR_WIDTH - 1 : 0]  iir_24_coeff_idx;
    logic [ADDR_WIDTH - 1 : 0]  iir_51_coeff_idx;
    logic [ADDR_WIDTH - 1 : 0]  iir_52_coeff_idx;

    logic [ADDR_WIDTH - 1 : 0]  ctrl_idx        ;

    assign iir_24_coeff_idx = DATA_ADDR - TAPS                          ;
    assign iir_51_coeff_idx = DATA_ADDR - TAPS - NUM_DENUM              ;
    assign iir_52_coeff_idx = DATA_ADDR - TAPS - 2 * NUM_DENUM          ;

    assign ctrl_idx         = DATA_ADDR - TAPS - 3 * NUM_DENUM - 1      ;

    assign  ENABLES         = {FRAC_DECI_EN, IIR_EN, CTRL_EN, CIC_EN}   ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            FRAC_DECI_VLD <= 1'b0;
            IIR_24_VLD    <= 1'b0;
            IIR_5_1_VLD   <= 1'b0;
            IIR_5_2_VLD   <= 1'b0;
            CIC_R_OUT     <= 5'd1;
            OUT_SEL       <= 2'b0;
            STATUS        <= 3'b0; 
            COEFF_SEL     <= 3'b0; 
            PREADY        <= 1'b0;
            PRDATA        <= {(DATA_WIDTH){1'b0}}; 
            
            FRAC_DECI_OUT [0]   <= COEFF0 ;      FRAC_DECI_OUT [36] <= COEFF35;
            FRAC_DECI_OUT [1]   <= COEFF1 ;      FRAC_DECI_OUT [37] <= COEFF34;
            FRAC_DECI_OUT [2]   <= COEFF2 ;      FRAC_DECI_OUT [38] <= COEFF33;
            FRAC_DECI_OUT [3]   <= COEFF3 ;      FRAC_DECI_OUT [39] <= COEFF32;
            FRAC_DECI_OUT [4]   <= COEFF4 ;      FRAC_DECI_OUT [40] <= COEFF31;
            FRAC_DECI_OUT [5]   <= COEFF5 ;      FRAC_DECI_OUT [41] <= COEFF30;
            FRAC_DECI_OUT [6]   <= COEFF6 ;      FRAC_DECI_OUT [42] <= COEFF29;
            FRAC_DECI_OUT [7]   <= COEFF7 ;      FRAC_DECI_OUT [43] <= COEFF28;
            FRAC_DECI_OUT [8]   <= COEFF8 ;      FRAC_DECI_OUT [44] <= COEFF27;
            FRAC_DECI_OUT [9]   <= COEFF9 ;      FRAC_DECI_OUT [45] <= COEFF26;
            FRAC_DECI_OUT [10]  <= COEFF10;      FRAC_DECI_OUT [46] <= COEFF25;
            FRAC_DECI_OUT [11]  <= COEFF11;      FRAC_DECI_OUT [47] <= COEFF24;
            FRAC_DECI_OUT [12]  <= COEFF12;      FRAC_DECI_OUT [48] <= COEFF23;
            FRAC_DECI_OUT [13]  <= COEFF13;      FRAC_DECI_OUT [49] <= COEFF22;
            FRAC_DECI_OUT [14]  <= COEFF14;      FRAC_DECI_OUT [50] <= COEFF21;
            FRAC_DECI_OUT [15]  <= COEFF15;      FRAC_DECI_OUT [51] <= COEFF20;
            FRAC_DECI_OUT [16]  <= COEFF16;      FRAC_DECI_OUT [52] <= COEFF19;
            FRAC_DECI_OUT [17]  <= COEFF17;      FRAC_DECI_OUT [53] <= COEFF18;
            FRAC_DECI_OUT [18]  <= COEFF18;      FRAC_DECI_OUT [54] <= COEFF17;
            FRAC_DECI_OUT [19]  <= COEFF19;      FRAC_DECI_OUT [55] <= COEFF16;
            FRAC_DECI_OUT [20]  <= COEFF20;      FRAC_DECI_OUT [56] <= COEFF15;
            FRAC_DECI_OUT [21]  <= COEFF21;      FRAC_DECI_OUT [57] <= COEFF14;
            FRAC_DECI_OUT [22]  <= COEFF22;      FRAC_DECI_OUT [58] <= COEFF13;
            FRAC_DECI_OUT [23]  <= COEFF23;      FRAC_DECI_OUT [59] <= COEFF12;
            FRAC_DECI_OUT [24]  <= COEFF24;      FRAC_DECI_OUT [60] <= COEFF11;
            FRAC_DECI_OUT [25]  <= COEFF25;      FRAC_DECI_OUT [61] <= COEFF10;
            FRAC_DECI_OUT [26]  <= COEFF26;      FRAC_DECI_OUT [62] <= COEFF9 ;
            FRAC_DECI_OUT [27]  <= COEFF27;      FRAC_DECI_OUT [63] <= COEFF8 ;
            FRAC_DECI_OUT [28]  <= COEFF28;      FRAC_DECI_OUT [64] <= COEFF7 ;
            FRAC_DECI_OUT [29]  <= COEFF29;      FRAC_DECI_OUT [65] <= COEFF6 ;
            FRAC_DECI_OUT [30]  <= COEFF30;      FRAC_DECI_OUT [66] <= COEFF5 ;
            FRAC_DECI_OUT [31]  <= COEFF31;      FRAC_DECI_OUT [67] <= COEFF4 ;
            FRAC_DECI_OUT [32]  <= COEFF32;      FRAC_DECI_OUT [68] <= COEFF3 ;
            FRAC_DECI_OUT [33]  <= COEFF33;      FRAC_DECI_OUT [69] <= COEFF2 ;
            FRAC_DECI_OUT [34]  <= COEFF34;      FRAC_DECI_OUT [70] <= COEFF1 ;
            FRAC_DECI_OUT [35]  <= COEFF35;      FRAC_DECI_OUT [71] <= COEFF0 ;
            
            
            IIR_5_1_OUT [0] <= B0_1;      IIR_5_1_OUT [3] <= A1_1;
            IIR_5_1_OUT [1] <= B1_1;      IIR_5_1_OUT [4] <= A2_1;
            IIR_5_1_OUT [2] <= B2_1;

            IIR_5_2_OUT [0] <= B0_2;      IIR_5_2_OUT [3] <= A1_2;
            IIR_5_2_OUT [1] <= B1_2;      IIR_5_2_OUT [4] <= A2_2;
            IIR_5_2_OUT [2] <= B2_2;
            
            IIR_24_OUT [0] <= B0_2_4;      IIR_24_OUT [3] <= A1_2_4;
            IIR_24_OUT [1] <= B1_2_4;      IIR_24_OUT [4] <= A2_2_4;
            IIR_24_OUT [2] <= B2_2_4;

            for (int i = 0; i < 5; i++) CTRL [i] <= 1'b0;
        end
        else if (PWRITE) begin
            if (|ENABLES && !PENABLE)
                PREADY <= 1'b1;
            else 
                PREADY        <= 1'b0;
                FRAC_DECI_VLD <= 1'b0;
                IIR_24_VLD    <= 1'b0;
                IIR_5_1_VLD   <= 1'b0;
                IIR_5_2_VLD   <= 1'b0;

            if (PENABLE) begin
                case (ENABLES)
                    4'b1000: begin
                        FRAC_DECI_OUT [DATA_ADDR] <= DATA_IN[COEFF_WIDTH - 1 : 0];

                        if (DATA_ADDR == (TAPS - 1)) FRAC_DECI_VLD <= 1'b1;
                    end
                    4'b0100: begin
                        IIR_24_OUT  [iir_24_coeff_idx] <= DATA_IN[COEFF_WIDTH - 1 : 0];
                        IIR_5_1_OUT [iir_51_coeff_idx] <= DATA_IN[COEFF_WIDTH - 1 : 0];
                        IIR_5_2_OUT [iir_52_coeff_idx] <= DATA_IN[COEFF_WIDTH - 1 : 0];

                        if (DATA_ADDR == (TAPS + NUM_DENUM - 1)) IIR_24_VLD <= 1'b1;
                        else if (DATA_ADDR == (TAPS + (2 * NUM_DENUM) - 1)) IIR_5_1_VLD <= 1'b1;
                        else if (DATA_ADDR == (TAPS + (3 * NUM_DENUM) - 1)) IIR_5_2_VLD <= 1'b1;
                    end
                    4'b0010: begin
                        if (DATA_ADDR == (TAPS + (3 * NUM_DENUM))) begin
                            CIC_R_OUT <= DATA_IN[4 : 0];
                        end
                    end
                    4'b0001: begin
                        CTRL [ctrl_idx[3 : 0]] <= DATA_IN[0];
                        
                        if (DATA_ADDR == (TAPS + (3 * NUM_DENUM) + 1 + 5)) OUT_SEL <= DATA_IN[1 : 0];
                        else if (DATA_ADDR == (TAPS + (3 * NUM_DENUM) + 1 + 5 +1)) COEFF_SEL <= DATA_IN[2 : 0];
                        else if (DATA_ADDR == (TAPS + (3 * NUM_DENUM) + 1 + 5 + 1 + 1)) TATUS <= DATA_IN[2 : 0];
                    end
                    default: ;
                endcase
            end
        end else begin
            FRAC_DECI_VLD <= 1'b0;
            IIR_24_VLD    <= 1'b0;
            IIR_5_1_VLD   <= 1'b0;
            IIR_5_2_VLD   <= 1'b0;
            
            if (|ENABLES && !PENABLE) begin
                PREADY <= 1'b1;
                if (DATA_ADDR < TAPS) begin
                    PRDATA <= {{(DATA_WIDTH - COEFF_WIDTH){FRAC_DECI_OUT [DATA_ADDR][COEFF_WIDTH - 1]}}, FRAC_DECI_OUT [DATA_ADDR]};
                end else if (DATA_ADDR < TAPS + NUM_DENUM) begin
                    PRDATA <= {{(DATA_WIDTH - COEFF_WIDTH){IIR_24_OUT [iir_24_coeff_idx][COEFF_WIDTH - 1]}}, IIR_24_OUT [iir_24_coeff_idx]};
                end else if (DATA_ADDR < TAPS + (2 * NUM_DENUM)) begin
                    PRDATA <= {{(DATA_WIDTH - COEFF_WIDTH){IIR_5_1_OUT [iir_51_coeff_idx][COEFF_WIDTH - 1]}}, IIR_5_1_OUT [iir_51_coeff_idx]};
                end else if (DATA_ADDR < TAPS + (3 * NUM_DENUM)) begin
                    PRDATA <= {{(DATA_WIDTH - COEFF_WIDTH){IIR_5_2_OUT [iir_52_coeff_idx][COEFF_WIDTH - 1]}}, IIR_5_2_OUT [iir_52_coeff_idx]};
                end else if (DATA_ADDR < TAPS + (3 * NUM_DENUM) + 1) begin
                    PRDATA <= {{(DATA_WIDTH - 5){1'b0}}, CIC_R_OUT};
                end else if (DATA_ADDR < TAPS + (3 * NUM_DENUM) + 1 + 5) begin
                    PRDATA <= {{(DATA_WIDTH - 1){1'b0}}, CTRL [ctrl_idx[3:0]]};
                end else if (DATA_ADDR < TAPS + (3 * NUM_DENUM) + 1 + 5 + 1) begin
                    PRDATA <= {{(DATA_WIDTH - 2){1'b0}}, OUT_SEL};
                end else if (DATA_ADDR < TAPS + (3 * NUM_DENUM) + 1 + 5 + 2) begin
                    PRDATA <= {{(DATA_WIDTH - 3){1'b0}}, COEFF_SEL};
                end else if (DATA_ADDR < TAPS + (3 * NUM_DENUM) + 1 + 5 + 3) begin
                    PRDATA <= {{(DATA_WIDTH - 3){1'b0}}, STATUS};
                end else begin
                    PRDATA <= {(DATA_WIDTH>>1){2'b10}};
                end
            end
            else begin
                PREADY <= 1'b0                  ;
                PRDATA <= {(DATA_WIDTH){1'b0}}  ; 
            end
        end
    end

endmodule