module fractional_decimator #(
    parameter DATA_WIDTH    = 16         ,
    parameter COEFF_WIDTH   = 20         ,
    parameter L             = 2          ,
    parameter M             = 3          ,
    localparam ACC_WIDTH    = 42         ,         
    localparam N_TAP        = 72         ,
    localparam PHASE_N_TAP  = N_TAP / 2  ,
    localparam OUT_FRAC     = 15              
) (
    input  logic                                    clk                             ,
    input  logic                                    clk_enable                      ,
    input  logic                                    rst_n                           ,   

    input  logic         			                coeff_wr_en                     ,
    input  logic signed [COEFF_WIDTH - 1 : 0]       coeff_data_in  [N_TAP - 1 : 0]  , 

    input  logic signed [DATA_WIDTH - 1 : 0]        filter_in                       ,
    output logic signed [DATA_WIDTH - 1 : 0]        filter_out                      ,

    output logic                                    overflow                        ,
    output logic                                    underflow                       ,
  
    output logic                                    ce_in                           ,
    output logic                                    ce_out
);
  
    // Counter for decimation phases
    logic [1:0] cur_count;

    logic ce_out_reg ;

    logic signed [ACC_WIDTH - 1 : 0]        acc;

    logic signed [COEFF_WIDTH - 1 : 0]      coeff_bank;
    
    logic signed [DATA_WIDTH - 1 : 0]       result;

    logic signed [COEFF_WIDTH - 1 : 0] coeff        [N_TAP - 1 : 0]       ;
    logic signed [COEFF_WIDTH - 1 : 0] coeff_phase1 [PHASE_N_TAP - 1 : 0] ;
    logic signed [COEFF_WIDTH - 1 : 0] coeff_phase2 [PHASE_N_TAP - 1 : 0] ;

    // Delay line for last 38 samples
    logic signed [DATA_WIDTH - 1 : 0] delayline [PHASE_N_TAP - 1 : 0];

    logic phase_enable;

    logic trig;

    logic signed [DATA_WIDTH:0]     q_ext           ;
    logic signed [DATA_WIDTH-1:0]   q               ;
    logic                           lower_nonzero   ;
    
    assign phase_enable = ((cur_count == 2'b00) || (cur_count == 2'b10)) ? 1'b1 : 1'b0;

    // Coefficient initialization 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            coeff_init();
        end else if(!clk_enable && coeff_wr_en) begin
            coeff_edit();
        end
    end
    
    // Control logic: update counter and clock enable registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || coeff_wr_en) begin
            cur_count <= 2'b00;
            ce_in     <= 1'b0;
        end else if (clk_enable) begin
            ce_in <= 1'b1;  // echo enable
            cur_count <= (cur_count == (M-1)) ? 2'd0 : cur_count + 1;
        end else begin
            ce_in <= 1'b0;
        end
    end

    // Delay pipeline: shift in new sample
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || coeff_wr_en) begin
            for (int i = 0 ; i < PHASE_N_TAP ; i++) begin
                delayline[i] <= 16'sh0000 ;
            end
        end else if (clk_enable) begin
            delayline[0] <= filter_in;
            for (int i = 0 ; i < (PHASE_N_TAP - 1) ; i++) begin
                delayline[i + 1] <= delayline[i];
            end
        end
    end

    // FIR accumulation on valid phases
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || coeff_wr_en) begin
            filter_out <= {DATA_WIDTH{1'b0}};
            ce_out_reg     <= 1'b0;
        end else if (clk_enable) begin
            if (phase_enable) begin
                filter_out <= result;
                ce_out_reg <= 1'b1;
                ce_out <= ce_out_reg;
            end else begin
                ce_out_reg <= 1'b0;
                ce_out <= ce_out_reg;
            end
        end
    end

    always_comb begin
        acc = {ACC_WIDTH{1'b0}};
        trig = 0;
        coeff_bank = 16'sh0000;
        if (clk_enable) begin

            for (int j = 0 ; j < PHASE_N_TAP ; j = j + 1) begin                    
                if (cur_count == 2'b01) begin
                    coeff_bank = coeff_phase1[j];
                end else begin
                    coeff_bank = coeff_phase2[j];
                end
                acc = acc + (delayline[j] * coeff_bank);
            end

            trig = 1'b1;

        end
    end

    rounding_overflow_arith #(
        .ACC_WIDTH(42),
        .ACC_FRAC(32),
        .OUT_WIDTH(16),
        .OUT_FRAC(15),
        .PROD_WIDTH(35),
        .PROD_FRAC(32)
    ) ARITHMETIC_HANDLER (
        .data_in    (acc             ),
        .valid_in   (trig  ),
        .data_out   (result            ),
        .overflow   (overflow           ),
        .underflow  (underflow          ), 
        .valid_out  (          )
    );

    task coeff_init ();
        $readmemb("fir_coeff.txt", coeff);

        for (int i = 0 ; i < PHASE_N_TAP ; i++) begin
            coeff_phase1[i] = coeff[i * 2];
            coeff_phase2[i] = coeff[i * 2 + 1];
        end
    endtask

    task coeff_edit ();
        for (int i = 0 ; i < N_TAP ; i++) begin
            coeff[i] = coeff_data_in[i];
        end

        for (int i = 0 ; i < PHASE_N_TAP ; i++) begin
            coeff_phase1[i] = coeff[i * 2];
            coeff_phase2[i] = coeff[i * 2 + 1];
        end
    endtask
endmodule