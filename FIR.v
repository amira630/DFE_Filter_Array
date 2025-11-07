module FIR_Filter #(
    parameter N = 116,
    parameter WIDTH = 16,
    parameter COEFF_WIDTH = 16
)(
    input clk,
    input rst_n,
    input wire [4:0] R,
    input signed [WIDTH-1:0] x_input,
    input valid_in,
    output reg signed [40:0] y_output,
    output reg valid_out
);

    reg signed [COEFF_WIDTH-1:0] coeff [0:N-1];
    initial begin
        coeff[0]=16'd1; coeff[1]=-16'd2; coeff[2]=16'd0;
        coeff[3]=16'd2; coeff[4]=-16'd3; coeff[5]=16'd0;
        coeff[6]=16'd5; coeff[7]=-16'd6; coeff[8]=16'd0;
        coeff[9]=16'd8; coeff[10]=-16'd10; coeff[11]=16'd0;
        coeff[12]=16'd14; coeff[13]=-16'd17; coeff[14]=16'd0;
        coeff[15]=16'd23; coeff[16]=-16'd26; coeff[17]=16'd0;
        coeff[18]=16'd35; coeff[19]=-16'd40; coeff[20]=16'd0;
        coeff[21]=16'd51; coeff[22]=-16'd58; coeff[23]=16'd0;
        coeff[24]=16'd73; coeff[25]=-16'd82; coeff[26]=16'd0;
        coeff[27]=16'd102; coeff[28]=-16'd113; coeff[29]=16'd0;
        coeff[30]=16'd140; coeff[31]=-16'd155; coeff[32]=16'd0;
        coeff[33]=16'd189; coeff[34]=-16'd208; coeff[35]=16'd0;
        coeff[36]=16'd252; coeff[37]=-16'd277; coeff[38]=16'd0;
        coeff[39]=16'd336; coeff[40]=-16'd369; coeff[41]=16'd0;
        coeff[42]=16'd449; coeff[43]=-16'd496; coeff[44]=16'd0;
        coeff[45]=16'd610; coeff[46]=-16'd681; coeff[47]=16'd0;
        coeff[48]=16'd863; coeff[49]=-16'd983; coeff[50]=16'd0;
        coeff[51]=16'd1328; coeff[52]=-16'd1590; coeff[53]=16'd0;
        coeff[54]=16'd2547; coeff[55]=-16'd3589; coeff[56]=16'd0;
        coeff[57]=16'd18061; coeff[58]=16'd18061; coeff[59]=16'd0;
        coeff[60]=-16'd3589; coeff[61]=16'd2547; coeff[62]=16'd0;
        coeff[63]=-16'd1590; coeff[64]=16'd1328; coeff[65]=16'd0;
        coeff[66]=-16'd983; coeff[67]=16'd863; coeff[68]=16'd0;
        coeff[69]=-16'd681; coeff[70]=16'd610; coeff[71]=16'd0;
        coeff[72]=-16'd496; coeff[73]=16'd449; coeff[74]=16'd0;
        coeff[75]=-16'd369; coeff[76]=16'd336; coeff[77]=16'd0;
        coeff[78]=-16'd277; coeff[79]=16'd252; coeff[80]=16'd0;
        coeff[81]=-16'd208; coeff[82]=16'd189; coeff[83]=16'd0;
        coeff[84]=-16'd155; coeff[85]=16'd140; coeff[86]=16'd0;
        coeff[87]=-16'd113; coeff[88]=16'd102; coeff[89]=16'd0;
        coeff[90]=-16'd82; coeff[91]=16'd73; coeff[92]=16'd0;
        coeff[93]=-16'd58; coeff[94]=16'd51; coeff[95]=16'd0;
        coeff[96]=-16'd40; coeff[97]=16'd35; coeff[98]=16'd0;
        coeff[99]=-16'd26; coeff[100]=16'd23; coeff[101]=16'd0;
        coeff[102]=-16'd17; coeff[103]=16'd14; coeff[104]=16'd0;
        coeff[105]=-16'd10; coeff[106]=16'd8; coeff[107]=16'd0;
        coeff[108]=-16'd6; coeff[109]=16'd5; coeff[110]=16'd0;
        coeff[111]=-16'd3; coeff[112]=16'd2; coeff[113]=16'd0;
        coeff[114]=-16'd2; coeff[115]=16'd1;
        case (R) 
            2: begin
                coeff[0]=16'd1; coeff[1]=-16'd2; coeff[2]=16'd0;
                coeff[3]=16'd2; coeff[4]=-16'd3; coeff[5]=16'd0;
                coeff[6]=16'd5; coeff[7]=-16'd6; coeff[8]=16'd0;
                coeff[9]=16'd8; coeff[10]=-16'd10; coeff[11]=16'd0;
                coeff[12]=16'd14; coeff[13]=-16'd17; coeff[14]=16'd0;
                coeff[15]=16'd23; coeff[16]=-16'd26; coeff[17]=16'd0;
                coeff[18]=16'd35; coeff[19]=-16'd40; coeff[20]=16'd0;
                coeff[21]=16'd51; coeff[22]=-16'd58; coeff[23]=16'd0;
                coeff[24]=16'd73; coeff[25]=-16'd82; coeff[26]=16'd0;
                coeff[27]=16'd102; coeff[28]=-16'd113; coeff[29]=16'd0;
                coeff[30]=16'd140; coeff[31]=-16'd155; coeff[32]=16'd0;
                coeff[33]=16'd189; coeff[34]=-16'd208; coeff[35]=16'd0;
                coeff[36]=16'd252; coeff[37]=-16'd277; coeff[38]=16'd0;
                coeff[39]=16'd336; coeff[40]=-16'd369; coeff[41]=16'd0;
                coeff[42]=16'd449; coeff[43]=-16'd496; coeff[44]=16'd0;
                coeff[45]=16'd610; coeff[46]=-16'd681; coeff[47]=16'd0;
                coeff[48]=16'd863; coeff[49]=-16'd983; coeff[50]=16'd0;
                coeff[51]=16'd1328; coeff[52]=-16'd1590; coeff[53]=16'd0;
                coeff[54]=16'd2547; coeff[55]=-16'd3589; coeff[56]=16'd0;
                coeff[57]=16'd18061; coeff[58]=16'd18061; coeff[59]=16'd0;
                coeff[60]=-16'd3589; coeff[61]=16'd2547; coeff[62]=16'd0;
                coeff[63]=-16'd1590; coeff[64]=16'd1328; coeff[65]=16'd0;
                coeff[66]=-16'd983; coeff[67]=16'd863; coeff[68]=16'd0;
                coeff[69]=-16'd681; coeff[70]=16'd610; coeff[71]=16'd0;
                coeff[72]=-16'd496; coeff[73]=16'd449; coeff[74]=16'd0;
                coeff[75]=-16'd369; coeff[76]=16'd336; coeff[77]=16'd0;
                coeff[78]=-16'd277; coeff[79]=16'd252; coeff[80]=16'd0;
                coeff[81]=-16'd208; coeff[82]=16'd189; coeff[83]=16'd0;
                coeff[84]=-16'd155; coeff[85]=16'd140; coeff[86]=16'd0;
                coeff[87]=-16'd113; coeff[88]=16'd102; coeff[89]=16'd0;
                coeff[90]=-16'd82; coeff[91]=16'd73; coeff[92]=16'd0;
                coeff[93]=-16'd58; coeff[94]=16'd51; coeff[95]=16'd0;
                coeff[96]=-16'd40; coeff[97]=16'd35; coeff[98]=16'd0;
                coeff[99]=-16'd26; coeff[100]=16'd23; coeff[101]=16'd0;
                coeff[102]=-16'd17; coeff[103]=16'd14; coeff[104]=16'd0;
                coeff[105]=-16'd10; coeff[106]=16'd8; coeff[107]=16'd0;
                coeff[108]=-16'd6; coeff[109]=16'd5; coeff[110]=16'd0;
                coeff[111]=-16'd3; coeff[112]=16'd2; coeff[113]=16'd0;
                coeff[114]=-16'd2; coeff[115]=16'd1;
            end
            4: begin
                coeff[0]=16'd1; coeff[1]=-16'd2; coeff[2]=16'd0;
                coeff[3]=16'd2; coeff[4]=-16'd3; coeff[5]=16'd0;
                coeff[6]=16'd5; coeff[7]=-16'd6; coeff[8]=16'd0;
                coeff[9]=16'd8; coeff[10]=-16'd10; coeff[11]=16'd0;
                coeff[12]=16'd14; coeff[13]=-16'd17; coeff[14]=16'd0;
                coeff[15]=16'd23; coeff[16]=-16'd26; coeff[17]=16'd0;
                coeff[18]=16'd35; coeff[19]=-16'd40; coeff[20]=16'd0;
                coeff[21]=16'd51; coeff[22]=-16'd58; coeff[23]=16'd0;
                coeff[24]=16'd73; coeff[25]=-16'd82; coeff[26]=16'd0;
                coeff[27]=16'd102; coeff[28]=-16'd113; coeff[29]=16'd0;
                coeff[30]=16'd140; coeff[31]=-16'd155; coeff[32]=16'd0;
                coeff[33]=16'd189; coeff[34]=-16'd208; coeff[35]=16'd0;
                coeff[36]=16'd252; coeff[37]=-16'd277; coeff[38]=16'd0;
                coeff[39]=16'd336; coeff[40]=-16'd369; coeff[41]=16'd0;
                coeff[42]=16'd449; coeff[43]=-16'd496; coeff[44]=16'd0;
                coeff[45]=16'd610; coeff[46]=-16'd681; coeff[47]=16'd0;
                coeff[48]=16'd863; coeff[49]=-16'd983; coeff[50]=16'd0;
                coeff[51]=16'd1328; coeff[52]=-16'd1590; coeff[53]=16'd0;
                coeff[54]=16'd2547; coeff[55]=-16'd3589; coeff[56]=16'd0;
                coeff[57]=16'd18061; coeff[58]=16'd18061; coeff[59]=16'd0;
                coeff[60]=-16'd3589; coeff[61]=16'd2547; coeff[62]=16'd0;
                coeff[63]=-16'd1590; coeff[64]=16'd1328; coeff[65]=16'd0;
                coeff[66]=-16'd983; coeff[67]=16'd863; coeff[68]=16'd0;
                coeff[69]=-16'd681; coeff[70]=16'd610; coeff[71]=16'd0;
                coeff[72]=-16'd496; coeff[73]=16'd449; coeff[74]=16'd0;
                coeff[75]=-16'd369; coeff[76]=16'd336; coeff[77]=16'd0;
                coeff[78]=-16'd277; coeff[79]=16'd252; coeff[80]=16'd0;
                coeff[81]=-16'd208; coeff[82]=16'd189; coeff[83]=16'd0;
                coeff[84]=-16'd155; coeff[85]=16'd140; coeff[86]=16'd0;
                coeff[87]=-16'd113; coeff[88]=16'd102; coeff[89]=16'd0;
                coeff[90]=-16'd82; coeff[91]=16'd73; coeff[92]=16'd0;
                coeff[93]=-16'd58; coeff[94]=16'd51; coeff[95]=16'd0;
                coeff[96]=-16'd40; coeff[97]=16'd35; coeff[98]=16'd0;
                coeff[99]=-16'd26; coeff[100]=16'd23; coeff[101]=16'd0;
                coeff[102]=-16'd17; coeff[103]=16'd14; coeff[104]=16'd0;
                coeff[105]=-16'd10; coeff[106]=16'd8; coeff[107]=16'd0;
                coeff[108]=-16'd6; coeff[109]=16'd5; coeff[110]=16'd0;
                coeff[111]=-16'd3; coeff[112]=16'd2; coeff[113]=16'd0;
                coeff[114]=-16'd2; coeff[115]=16'd1;
            end
            8: begin
                coeff[0]=16'd1; coeff[1]=-16'd2; coeff[2]=16'd0;
                coeff[3]=16'd2; coeff[4]=-16'd3; coeff[5]=16'd0;
                coeff[6]=16'd5; coeff[7]=-16'd6; coeff[8]=16'd0;
                coeff[9]=16'd8; coeff[10]=-16'd10; coeff[11]=16'd0;
                coeff[12]=16'd14; coeff[13]=-16'd17; coeff[14]=16'd0;
                coeff[15]=16'd23; coeff[16]=-16'd26; coeff[17]=16'd0;
                coeff[18]=16'd35; coeff[19]=-16'd40; coeff[20]=16'd0;
                coeff[21]=16'd51; coeff[22]=-16'd58; coeff[23]=16'd0;
                coeff[24]=16'd73; coeff[25]=-16'd82; coeff[26]=16'd0;
                coeff[27]=16'd102; coeff[28]=-16'd113; coeff[29]=16'd0;
                coeff[30]=16'd140; coeff[31]=-16'd155; coeff[32]=16'd0;
                coeff[33]=16'd189; coeff[34]=-16'd208; coeff[35]=16'd0;
                coeff[36]=16'd252; coeff[37]=-16'd277; coeff[38]=16'd0;
                coeff[39]=16'd336; coeff[40]=-16'd369; coeff[41]=16'd0;
                coeff[42]=16'd449; coeff[43]=-16'd496; coeff[44]=16'd0;
                coeff[45]=16'd610; coeff[46]=-16'd681; coeff[47]=16'd0;
                coeff[48]=16'd863; coeff[49]=-16'd983; coeff[50]=16'd0;
                coeff[51]=16'd1328; coeff[52]=-16'd1590; coeff[53]=16'd0;
                coeff[54]=16'd2547; coeff[55]=-16'd3589; coeff[56]=16'd0;
                coeff[57]=16'd18061; coeff[58]=16'd18061; coeff[59]=16'd0;
                coeff[60]=-16'd3589; coeff[61]=16'd2547; coeff[62]=16'd0;
                coeff[63]=-16'd1590; coeff[64]=16'd1328; coeff[65]=16'd0;
                coeff[66]=-16'd983; coeff[67]=16'd863; coeff[68]=16'd0;
                coeff[69]=-16'd681; coeff[70]=16'd610; coeff[71]=16'd0;
                coeff[72]=-16'd496; coeff[73]=16'd449; coeff[74]=16'd0;
                coeff[75]=-16'd369; coeff[76]=16'd336; coeff[77]=16'd0;
                coeff[78]=-16'd277; coeff[79]=16'd252; coeff[80]=16'd0;
                coeff[81]=-16'd208; coeff[82]=16'd189; coeff[83]=16'd0;
                coeff[84]=-16'd155; coeff[85]=16'd140; coeff[86]=16'd0;
                coeff[87]=-16'd113; coeff[88]=16'd102; coeff[89]=16'd0;
                coeff[90]=-16'd82; coeff[91]=16'd73; coeff[92]=16'd0;
                coeff[93]=-16'd58; coeff[94]=16'd51; coeff[95]=16'd0;
                coeff[96]=-16'd40; coeff[97]=16'd35; coeff[98]=16'd0;
                coeff[99]=-16'd26; coeff[100]=16'd23; coeff[101]=16'd0;
                coeff[102]=-16'd17; coeff[103]=16'd14; coeff[104]=16'd0;
                coeff[105]=-16'd10; coeff[106]=16'd8; coeff[107]=16'd0;
                coeff[108]=-16'd6; coeff[109]=16'd5; coeff[110]=16'd0;
                coeff[111]=-16'd3; coeff[112]=16'd2; coeff[113]=16'd0;
                coeff[114]=-16'd2; coeff[115]=16'd1;
            end
            16: begin
                coeff[0]=16'd1; coeff[1]=-16'd2; coeff[2]=16'd0;
                coeff[3]=16'd2; coeff[4]=-16'd3; coeff[5]=16'd0;
                coeff[6]=16'd5; coeff[7]=-16'd6; coeff[8]=16'd0;
                coeff[9]=16'd8; coeff[10]=-16'd10; coeff[11]=16'd0;
                coeff[12]=16'd14; coeff[13]=-16'd17; coeff[14]=16'd0;
                coeff[15]=16'd23; coeff[16]=-16'd26; coeff[17]=16'd0;
                coeff[18]=16'd35; coeff[19]=-16'd40; coeff[20]=16'd0;
                coeff[21]=16'd51; coeff[22]=-16'd58; coeff[23]=16'd0;
                coeff[24]=16'd73; coeff[25]=-16'd82; coeff[26]=16'd0;
                coeff[27]=16'd102; coeff[28]=-16'd113; coeff[29]=16'd0;
                coeff[30]=16'd140; coeff[31]=-16'd155; coeff[32]=16'd0;
                coeff[33]=16'd189; coeff[34]=-16'd208; coeff[35]=16'd0;
                coeff[36]=16'd252; coeff[37]=-16'd277; coeff[38]=16'd0;
                coeff[39]=16'd336; coeff[40]=-16'd369; coeff[41]=16'd0;
                coeff[42]=16'd449; coeff[43]=-16'd496; coeff[44]=16'd0;
                coeff[45]=16'd610; coeff[46]=-16'd681; coeff[47]=16'd0;
                coeff[48]=16'd863; coeff[49]=-16'd983; coeff[50]=16'd0;
                coeff[51]=16'd1328; coeff[52]=-16'd1590; coeff[53]=16'd0;
                coeff[54]=16'd2547; coeff[55]=-16'd3589; coeff[56]=16'd0;
                coeff[57]=16'd18061; coeff[58]=16'd18061; coeff[59]=16'd0;
                coeff[60]=-16'd3589; coeff[61]=16'd2547; coeff[62]=16'd0;
                coeff[63]=-16'd1590; coeff[64]=16'd1328; coeff[65]=16'd0;
                coeff[66]=-16'd983; coeff[67]=16'd863; coeff[68]=16'd0;
                coeff[69]=-16'd681; coeff[70]=16'd610; coeff[71]=16'd0;
                coeff[72]=-16'd496; coeff[73]=16'd449; coeff[74]=16'd0;
                coeff[75]=-16'd369; coeff[76]=16'd336; coeff[77]=16'd0;
                coeff[78]=-16'd277; coeff[79]=16'd252; coeff[80]=16'd0;
                coeff[81]=-16'd208; coeff[82]=16'd189; coeff[83]=16'd0;
                coeff[84]=-16'd155; coeff[85]=16'd140; coeff[86]=16'd0;
                coeff[87]=-16'd113; coeff[88]=16'd102; coeff[89]=16'd0;
                coeff[90]=-16'd82; coeff[91]=16'd73; coeff[92]=16'd0;
                coeff[93]=-16'd58; coeff[94]=16'd51; coeff[95]=16'd0;
                coeff[96]=-16'd40; coeff[97]=16'd35; coeff[98]=16'd0;
                coeff[99]=-16'd26; coeff[100]=16'd23; coeff[101]=16'd0;
                coeff[102]=-16'd17; coeff[103]=16'd14; coeff[104]=16'd0;
                coeff[105]=-16'd10; coeff[106]=16'd8; coeff[107]=16'd0;
                coeff[108]=-16'd6; coeff[109]=16'd5; coeff[110]=16'd0;
                coeff[111]=-16'd3; coeff[112]=16'd2; coeff[113]=16'd0;
                coeff[114]=-16'd2; coeff[115]=16'd1;
            end
        endcase
    end

    reg signed [WIDTH-1:0] int_reg [0:N-1];
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0;i<N;i=i+1) int_reg[i]<=0;
        end else if (valid_in) begin
            int_reg[0]<=x_input;
            for (i=1;i<N;i=i+1) int_reg[i]<=int_reg[i-1];
        end
    end

    reg signed [WIDTH+COEFF_WIDTH+8:0] acc;
    always @(*) begin
        acc=0;
        for (i=0;i<N;i=i+1)
            acc=acc+int_reg[i]*coeff[i];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y_output<=0;
            valid_out<=0;
        end else if (valid_in) begin
            y_output<=acc;
            valid_out<=1;
        end else begin
            valid_out<=0;
        end
    end
endmodule
