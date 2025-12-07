////////////////////////////////////////////////////////////////////////////////
// Design Author: Amira Atef
// Verified by Mustaf EL-Sherif
// --> Linting check
// --> Synthesis
// --> Functional Simulation
// Design: APB Bridge
// Date: 02-11-2025
////////////////////////////////////////////////////////////////////////////////

module APB_Bridge #(
    parameter   int ADDR_WIDTH  = 32'd32    ,       //  Max number of addres bits
    parameter   int DATA_WIDTH  = 32'd32    ,       //  Can be 8, 16, or 32 bits
                                                    //  USER_REQ_WIDTH = 128 --> Max number of user attribute bits
                                                    //  USER_DATA_WIDTH = 16 --> DATA_WIDTH/2 max
                                                    //  USER_RESP_WIDTH = 16 --> DATA_WIDTH/2 max
    parameter   int COMP        = 32'd4             //  Total number of Completers (aka APB Peripherals)
)(
    input   logic                           PCLK     ,
    input   logic                           PRESETn  ,

    input   logic                           PREADY   ,
    input   logic                           MTRANS   ,   // Signal from Master or TB requesting the start of a transaction
    input   logic                           MWRITE   ,
    input   logic [COMP - 1 : 0]            MSELx    ,
    input   logic [ADDR_WIDTH - 1 : 0]      MADDR    ,
    input   logic [DATA_WIDTH - 1 : 0]      PRDATA   ,   // Data read by the master/TB
    input   logic [DATA_WIDTH - 1 : 0]      MWDATA   ,   // Data requested to be written by the Master/TB

    output  logic                           PENABLE  ,
    output  logic                           PWRITE   ,   // WRITE_REQ (=1), READ_REQ (=0)
    output  logic [ADDR_WIDTH - 1 : 0]      PADDR    ,
    
    output  logic [COMP - 1 : 0]            PSELx    ,
    output  logic [DATA_WIDTH - 1 : 0]      PWDATA   ,
    output  logic [DATA_WIDTH - 1 : 0]      MRDATA       // Data requested to be read by the Master/TB
);

    // Moore FSM
    // Gray State encoding
    localparam logic [1 : 0] IDLE     = 2'b00 ; 
    localparam logic [1 : 0] SETUP    = 2'b01 ;
    localparam logic [1 : 0] ACCESS   = 2'b11 ;

    logic [1 : 0] current_state   ;
    logic [1 : 0] next_state      ;

    logic [COMP - 1 : 0]        SELx_reg    ;
    logic [ADDR_WIDTH - 1 : 0]  ADDR_reg    ;
    logic [DATA_WIDTH - 1 : 0]  WDATA_reg   ;
    logic                       WRITE_reg   ;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            SELx_reg    <= {(COMP){1'b0}}       ;
            WRITE_reg   <= 1'b0                 ;
            ADDR_reg    <= {(ADDR_WIDTH){1'b0}} ;
            WDATA_reg   <= {(DATA_WIDTH){1'b0}} ;
        end
        else begin
            if ((current_state == IDLE) || (current_state == ACCESS && PREADY && MTRANS)) begin
                WRITE_reg   <= MWRITE   ;
                SELx_reg    <= MSELx    ;
                ADDR_reg    <= MADDR    ;
                WDATA_reg   <= MWDATA   ;
            end
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
        PENABLE = 1'b0                  ;
        PWRITE  = MWRITE                ;
        PADDR   = MADDR                 ;
        PWDATA  = MWDATA                ;
        MRDATA  = {(DATA_WIDTH){1'b0}}  ;
        PSELx   = {(COMP){1'b0}}        ;
        case (current_state)
            SETUP: begin
                PWRITE  = WRITE_reg ;
                PSELx   = SELx_reg  ;
                PADDR   = ADDR_reg  ;

                if (PWRITE) PWDATA = WDATA_reg;
            end
            ACCESS: begin
                PENABLE = 1'b1      ;
                PSELx   = SELx_reg  ;
                PWRITE  = WRITE_reg ;
                PADDR   = ADDR_reg  ;

                if (PWRITE) PWDATA = WDATA_reg  ;
                if (PREADY) MRDATA = PRDATA     ;
            end
            default: ;
        endcase
    end
endmodule