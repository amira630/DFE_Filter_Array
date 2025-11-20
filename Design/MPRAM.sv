module MPRAM #(
    parameter ADDR_WIDTH  = 7    ,
    parameter DATA_WIDTH  = 32   ,
    parameter TAPS        = 72   ,
    parameter COEFF_WIDTH = 20   ,
    parameter NUM_DENUM   = 5    ,
    parameter COMP        = 5
)(
    input logic                         clk                                   ,
    input logic                         rst_n                                 ,
        
    input logic                         FRAC_DECI_EN                          ,
    input logic                         IIR_EN                                ,
    input logic                         CTRL_EN                               ,
    input logic                         CIC_EN                                ,
    input logic                         FIR_EN                                ,
            
    input logic                         PWRITE                                ,
    input logic                         PENABLE                               ,
    input logic        [ADDR_WIDTH-1:0] DATA_ADDR                             ,
    input logic signed [DATA_WIDTH-1:0] DATA_IN                               ,
        
    output logic                         PREADY                               ,
    output logic [DATA_WIDTH-1:0]        PRDATA                               ,

    output logic                          FRAC_DECI_VLD                       ,      // Fractional Decimator Coefficients Valid
    output logic signed [COEFF_WIDTH-1:0] FRAC_DECI_OUT    [TAPS-1:0]         ,      // Fractional Decimator Coefficients

    output logic                          IIR_24_VLD                          ,      // IIR 2.4MHz Notch Coefficients Valid
    output logic signed [COEFF_WIDTH-1:0] IIR_24_OUT       [NUM_DENUM-1:0]    ,      // IIR 2.4MHz Notch Coefficients
    output logic                          IIR_5_1_VLD                         ,      // IIR 1MHz Notch Coefficients Valid
    output logic signed [COEFF_WIDTH-1:0] IIR_5_1_OUT      [NUM_DENUM-1:0]    ,      // IIR 1MHz Notch Coefficients
    output logic                          IIR_5_2_VLD                         ,      // IIR 2MHz Notch Coefficients Valid
    output logic signed [COEFF_WIDTH-1:0] IIR_5_2_OUT      [NUM_DENUM-1:0]    ,      // IIR 2MHz Notch Coefficients

    output logic                          CIC_R_VLD                           ,      // CIC Decimation Factor Valid
    output logic signed [4:0]             CIC_R_OUT                           ,      // CIC Decimation Factor

    output logic                          CTRL_OUT         [4:0]              ,      // [0]Frac_Deci, [1] IIR_Notch_2.4, [2] IIR_Notch_5, [3] CIC, [4] FIR, ON/OFF
    
    output logic        [1:0]             OUT_SEL                             ,      // Allow the output of a certain block 

    output logic                          FRAC_DECI_STATUS [1:0]              ,      // Overflow[0], Underflow[1] ON/OFF for Fractional Decimator
    output logic                          IIR_24_STATUS    [1:0]              ,      // Overflow[0], Underflow[1] ON/OFF for IIR Notch 2.4MHz
    output logic                          IIR_5_1_STATUS   [1:0]              ,      // Overflow[0], Underflow[1] ON/OFF for IIR Notch 1MHz  
    output logic                          IIR_5_2_STATUS   [1:0]              ,      // Overflow[0], Underflow[1] ON/OFF for IIR Notch 2MHz  
    output logic                          CIC_STATUS       [1:0]              ,      // Overflow[0], Underflow[1] ON/OFF for CIC Filter
    output logic                          FIR_STATUS       [1:0]                     // Overflow[0], Underflow[1] ON/OFF for FIR
);

int i;

logic [COMP-1:0] ENABLES;

assign  ENABLES = {FRAC_DECI_EN, IIR_EN, CTRL_EN, CIC_EN, FIR_EN};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        FRAC_DECI_VLD <= 1'b0;
        IIR_24_VLD    <= 1'b0;
        IIR_5_1_VLD   <= 1'b0;
        IIR_5_2_VLD   <= 1'b0;
        CIC_R_VLD     <= 1'b0;
        CIC_R_OUT     <= 5'b0;
        OUT_SEL       <= 2'b0;
        PREADY        <= 1'b0;
        PRDATA        <= 'b0; 
        for (i = 0; i < TAPS; i++)
            FRAC_DECI_OUT [i] <= 'b0;
        for (i = 0; i < NUM_DENUM; i++) begin
            IIR_24_OUT [i] <= 'b0;
            IIR_5_1_OUT [i] <= 'b0;
            IIR_5_2_OUT [i] <= 'b0;
        end
        for (i = 0; i < 5; i++)
            CTRL_OUT [i] <= 'b0;
        for (i = 0; i < 2; i++) begin
            FRAC_DECI_STATUS[i] <= 1'b0;
            IIR_24_STATUS[i]    <= 1'b0;
            IIR_5_1_STATUS[i]   <= 1'b0;
            IIR_5_2_STATUS[i]   <= 1'b0;
            CIC_STATUS[i]       <= 1'b0;
            FIR_STATUS[i]       <= 1'b0;
        end 
    end
    else if (PWRITE) begin
        if (|ENABLES && !PENABLE)
            PREADY <= 1'b1;
        else 
            PREADY <= 1'b0;
        FRAC_DECI_VLD <= 1'b0;
        CIC_R_VLD <= 1'b0;
        IIR_24_VLD    <= 1'b0;
        IIR_5_1_VLD   <= 1'b0;
        IIR_5_2_VLD   <= 1'b0;
        if (PENABLE) begin
            case (ENABLES)
                5'b10000: begin
                    FRAC_DECI_OUT [DATA_ADDR] <= DATA_IN;
                    if (DATA_ADDR == (TAPS - 1))
                        FRAC_DECI_VLD <= 1'b1;
                    FRAC_DECI_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7] <= DATA_IN;
                end
                5'b01000: begin
                    IIR_24_OUT [DATA_ADDR-TAPS] <= DATA_IN;
                    IIR_5_1_OUT [DATA_ADDR-TAPS - NUM_DENUM] <= DATA_IN;
                    IIR_5_2_OUT [DATA_ADDR-TAPS - 2*NUM_DENUM] <= DATA_IN;
                    if (DATA_ADDR == (TAPS + NUM_DENUM - 1))
                        IIR_24_VLD <= 1'b1;
                    else if (DATA_ADDR == (TAPS + 2*NUM_DENUM - 1))
                        IIR_5_1_VLD <= 1'b1;
                    else if (DATA_ADDR == (TAPS + 3*NUM_DENUM - 1))
                        IIR_5_2_VLD <= 1'b1;
                    IIR_24_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2] <= DATA_IN;
                    IIR_5_1_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2 -2] <= DATA_IN;
                    IIR_5_2_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2 -2 -2] <= DATA_IN;
                end
                5'b00100: begin
                    if (DATA_ADDR == (TAPS + 3*NUM_DENUM)) begin
                        CIC_R_OUT <= DATA_IN;
                        CIC_R_VLD <= 1'b1;
                    end
                    CIC_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2 -2 -2 -2] <= DATA_IN;
                end
                5'b00010: begin
                    CTRL_OUT [DATA_ADDR - TAPS - 3*NUM_DENUM - 1] <= DATA_IN;
                    if (DATA_ADDR == (TAPS + 3*NUM_DENUM + 1 + 5))
                        OUT_SEL <= DATA_IN;
                end
                5'b00001: begin
                    FIR_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2 -2 -2 -2 -2] <= DATA_IN;
                end
            endcase
        end
    end else begin
        if (|ENABLES && !PENABLE) begin
            PREADY <= 1'b1;
            if (DATA_ADDR < TAPS)
                PRDATA <= FRAC_DECI_OUT [DATA_ADDR];
            else if (DATA_ADDR < TAPS + NUM_DENUM)
                PRDATA <= IIR_24_OUT [DATA_ADDR-TAPS];
            else if (DATA_ADDR < TAPS + 2*NUM_DENUM)
                PRDATA <= IIR_5_1_OUT [DATA_ADDR-TAPS - NUM_DENUM];
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM)   
                PRDATA <= IIR_5_2_OUT [DATA_ADDR-TAPS - 2*NUM_DENUM];
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM +1)
                PRDATA <= CIC_R_OUT;
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM +1 +5)
                PRDATA <= CTRL_OUT [DATA_ADDR - TAPS - 3*NUM_DENUM - 1];
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM +1 +5 +1)
                PRDATA <= OUT_SEL;
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM +7 +2)
                PRDATA <= FRAC_DECI_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7];
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM +7 +2+2)
                PRDATA <= IIR_24_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2];
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM +7 +2+2+2)
                PRDATA <= IIR_5_1_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2 -2];
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM +7 +2+2+2+2)
                PRDATA <= IIR_5_2_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2 -2 -2];
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM +7 +2+2+2+2+2)
                PRDATA <= CIC_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2 -2 -2 -2];
            else if (DATA_ADDR < TAPS + 3*NUM_DENUM +7 +2+2+2+2+2+2)
                PRDATA <= FIR_STATUS [DATA_ADDR- TAPS - 3*NUM_DENUM - 7 - 2 -2 -2 -2 -2];
            else 
                PRDATA <= {(DATA_WIDTH>>1){2'b10}}; //show an error
        end
        else begin
            PREADY <= 1'b0;
            PRDATA <= 'b0; 
        end
    end
end

endmodule