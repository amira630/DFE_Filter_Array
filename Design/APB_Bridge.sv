module APB_Bridge #(
    parameter ADDR_WIDTH = 32,      // Max number of addres bits
              DATA_WIDTH = 32,      // Can be 8, 16, or 32 bits
              USER_REQ_WIDTH = 128, // Max number of user attribute bits
              USER_DATA_WIDTH = 16, // DATA_WIDTH/2 max
              USER_RESP_WIDTH = 16, // DATA_WIDTH/2 max
              COMP = 4              // Total number of Completers (aka APB Peripherals)
)(
    input logic                        PCLK,
    input logic                        PRESETn,
    // input logic                        PSLVRR,  // OPTIONAL
    input logic                        PREADY,
    input logic                        MTRANS,     // Signal from Master or TB requesting the start of a transaction
    input logic                        MWRITE,
    input logic [COMP-1:0]             MSELx,
    input logic [ADDR_WIDTH-1:0]       MADDR,
    input logic [DATA_WIDTH-1:0]       PRDATA,
    input logic [DATA_WIDTH-1:0]       MWDATA,     // Data requested to be written by the Master/TB
    // input logic [USER_DATA_WIDTH-1:0]  PRUSER,  // User read data attribute. (OPTIONAL)
    // input logic [USER_RESP_WIDTH-1:0]  PBUSER,  // User response attribute. (OPTIONAL)

    // output logic                       PWAKEUP, // OPTIONAL
    output logic                       PENABLE,
    output logic                       PWRITE,  // WRITE_REQ (=1), READ_REQ (=0)
    output logic [ADDR_WIDTH-1:0]      PADDR,
    // output logic [2:0]                 PPROT,   // OPTIONAL
    output logic [COMP-1:0]            PSELx,
    output logic [DATA_WIDTH-1:0]      PWDATA,
    output logic [DATA_WIDTH-1:0]      MRDATA,     // Data requested to be read by the Master/TB
    // output logic [(DATA_WIDTH>>3)-1:0] PSTRB,   // OPTIONAL
    // output logic [USER_REQ_WIDTH-1:0]  PAUSER,  // User request attribute. (OPTIONAL)
    // output logic [USER_DATA_WIDTH-1:0] PWUSER   // User write data attribute. (OPTIONAL)
);

    // Moore FSM
    // Gray State encoding
    localparam [1:0] IDLE = 2'b00, 
                     SETUP = 2'b01,
                     ACCESS = 2'b11;

    reg [1:0] current_state, next_state;

    reg [COMP-1:0] SELx_reg;
    reg [ADDR_WIDTH-1:0] ADDR_reg;
    reg [DATA_WIDTH-1:0] WDATA_reg;
    reg WRITE_reg;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            SELx_reg <= 'b0;
            WRITE_reg <= 1'b0;
            ADDR_reg <= 'b0;
        end
        else if (current_state == SETUP) begin
            SELx_reg <= MSELx;
            WRITE_reg <= MWRITE;
            ADDR_reg <= PADDR;
        end
    end

    // State transition logic
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            current_state <= IDLE; // Reset to IDLE State
        end
        else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if(MTRANS) 
                    next_state = SETUP;
                else 
                    next_state = IDLE;
            end
            SETUP: begin
                next_state = ACCESS;
            end
            ACCESS: begin
                if (!PREADY) 
                    next_state = ACCESS;
                else if (MTRANS)
                    next_state = SETUP;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE; // Default state
        endcase
    end

    // Output logic 
    always @(*) begin
        PENABLE = 1'b0;
        PWRITE = 1'b0;
        PADDR = MADDR;
        PSELx = 'b0;
        PWDATA = MWDATA;
        MRDATA = PRDATA;
        case (current_state)
            SETUP: begin
                PWRITE = MWRITE;
                PSELx = MSELx;
                if (MWRITE)
                    PWDATA = MWDATA;
                else
                    MRDATA = PRDATA;
            end
            ACCESS: begin
                PENABLE = 1'b1;
                PSELx = SELx_reg;
                PWRITE = WRITE_reg;
                PADDR = ADDR_reg;
                if (PWRITE)
                    PWDATA = WDATA_reg;
            end

        endcase
    end
endmodule