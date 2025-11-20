%% CIC Decimator and Compensation Filter Comparison
clc; clear; close all;

% Parameters
R_values = [1, 2, 4, 8, 16];  % Decimation factors
M  = 1;                        % Differential delay
N  = 1;                        % Number of stages (Order)
Fs = 6e6;                      % Normalized input sample rate
Ap = 0.5;                      % Passband ripple (dB)
Ast = 60;                      % Stopband attenuation (dB)
f_signal = 100e3;              % Your signal of interest (100 kHz)
pass_margin = 1.10;            % 10% margin
fpass = f_signal * pass_margin;

%% Allocate cell arrays for storing filters and coefficients
CompFilters   = cell(length(R_values), 1);
CompCoefs     = cell(length(R_values), 1);
DecimatorObj  = cell(length(R_values), 1);

%% Plot CIC-only frequency responses
figure('Name', 'CIC Decimators');
hold on; grid on;

for i = 1:length(R_values)
    r = R_values(i);
    cicDecim = dsp.CICDecimator(r, M, N);
    [h, w] = freqz(cicDecim);
    plot(w/pi, 20*log10(abs(h)/abs(h(1))), ...
        'DisplayName', sprintf('R = %d', r), 'LineWidth', 1.5);
end

xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
title(sprintf('CIC Decimator Frequency Responses (M=%d, N=%d)', M, N));
legend('show', 'Location', 'southwest');
ylim([-120 5]);
hold off;

for i = 1:length(R_values)
    R  = R_values(i);

    fprintf('\n==== Decimation R = %d ====\n', R);

    %% Create CIC decimator
    cicDecim = dsp.CICDecimator(R, M, N);
    DecimatorObj{i} = cicDecim;

    %% Post-decimation rate
    Fs_post = Fs / R;
    Fn_post = Fs_post/2;  % Nyquist after decimation

    %% Choose fstop as 20% of post-Nyquist (safe margin)
    fstop = min(fpass + 0.2*Fn_post, 0.9*Fn_post);

    fprintf('fpass = %.2f kHz\n', fpass/1e3);
    fprintf('fstop = %.2f kHz\n', fstop/1e3);

    %% Design compensator FIR (operates at decimated rate)
    switch R
        case 1
            Hd_FIR = FIR_1();
        case 2
            Hd_FIR = FIR_2();
        case 4
            Hd_FIR = FIR_4();
        case 8
            Hd_FIR = FIR_8();
        case 16
            Hd_FIR = FIR_16();
        otherwise 
            Hd_FIR = FIR_1();
    end
    cicComp = Hd_FIR;
    % d = fdesign.ciccomp(M, N, ...
    %     'Fp,Fst,Ap,Ast', ...
    %     fpass, fstop, Ap, Ast, Fs_post);
    % cicComp = design(Hd_FIR, 'SystemObject', true);
    CompFilters{i} = cicComp;
    
    %% Plotting the CIC + FIR Compensators
    hvft = filterAnalyzer(cicDecim,cicComp,...
    cascade(cicDecim,cicComp),ReferenceFilter=false,SampleRates=[Fs Fs/R Fs],NormalizeMagnitude=true);
    showFilters(hvft,false,FilterNames=["Filter_3_Stage1","Filter_3_Stage2"]);
    setLegendStrings(hvft,["CIC Decimator","CIC Compensator","Resulting Cascade Filter"]);

    %% Extract coefficients
    b = Hd_FIR.Numerator;
    CompCoefs{i} = b;

    fprintf('Compensator length: %d taps\n', length(b));

    %% Save coefficients to file
    fname = sprintf('cic_comp_R%d_coeffs.txt', R);
    fid = fopen(fname, 'w');
    fprintf(fid, '%1.12f\n', b);
    fclose(fid);

    fprintf('Saved coefficients to %s\n', fname);
end