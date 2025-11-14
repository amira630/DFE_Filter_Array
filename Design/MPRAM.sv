module MPRAM #(
    parameter ADDR_WIDTH = 7,
    parameter DATA_WIDTH = 32,
    parameter TAPS = 72,
    localparam NUM_DENUM = 5
)(
    input logic                         clk,
    input logic                         rst_n,

    input logic                         FRAC_DECI_EN,
    input logic                         IIR_EN,
    input logic                         CTRL_EN,
    input logic                         CIC_R_EN,
    
    input logic                         PWRITE,
    input logic                         PENABLE,
    input logic        [ADDR_WIDTH-1:0] DATA_ADDR,
    input logic signed [DATA_WIDTH-1:0] DATA_IN,

    output logic                         PREADY,

    output logic                         FRAC_DECI_VLD,
    output logic signed [DATA_WIDTH-1:0] FRAC_DECI_OUT [TAPS-1:0],

    output logic                         IIR_VLD,
    output logic signed [DATA_WIDTH-1:0] IIR_OUT [NUM_DENUM-1:0],

    output logic signed [DATA_WIDTH-1:0] CTRL_OUT [5:0],

    output logic                         CIC_R_VLD,
    output logic signed [DATA_WIDTH-1:0] CIC_R_OUT 
);

int i;

logic [3:0] ENABLES;

assign  ENABLES = {FRAC_DECI_EN, IIR_EN, CTRL_EN, CIC_R_EN};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        CIC_R_OUT <= 'b0;
        PREADY <= 1'b0;
        for (i = 0; i < TAPS; i++)
            FRAC_DECI_OUT [i] <= 'b0;
        for (i = 0; i < NUM_DENUM; i++)
            IIR_OUT [i] <= 'b0;
        for (i = 0; i < 6; i++)
            CTRL_OUT [i] <= 'b0;
    end
    else if (PWRITE) begin
        if (|ENABLES)
            PREADY <= 1'b1;
        else 
            PREADY <= 1'b0;
        if (PENABLE) begin
            case (ENABLES)
                4'b1000: begin
                    FRAC_DECI_OUT [DATA_ADDR] <= DATA_IN;
                end
                4'b0100: begin
                    IIR_OUT [DATA_ADDR-TAPS] <= DATA_IN;
                end
                4'b0010: begin
                    CTRL_OUT [DATA_ADDR-TAPS-NUM_DENUM] <= DATA_IN;
                end
                4'b0001: begin
                    CIC_R_OUT <= DATA_IN;
                end
            endcase
        end
    end
end

assign FRAC_DECI_VLD = (DATA_ADDR == (TAPS - 1)) ? 1'b1: 1'b0;
assign IIR_VLD = (DATA_ADDR == (TAPS + NUM_DENUM - 1)) ? 1'b1: 1'b0;
assign CIC_R_VLD = (CIC_R_EN) ? 1'b1 : 1'b0;
endmodule