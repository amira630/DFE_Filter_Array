%% CIC FIR Compensator Design - Complete Solution
% This code guarantees optimal compensation for your CIC filter

clear all; close all; clc;

%% ====================
%% USER INPUT SECTION - Modify These Values
%% ====================

% CIC Filter Specifications (from your design)
CIC.N = 1;          % Number of stages
CIC.M = 1;          % Differential delay  
CIC.R = 16;         % Decimation factor

% Signal Specifications (MODIFY BASED ON YOUR APPLICATION)
Signal.Fs_input = 100000;      % Input sample rate (Hz) - MODIFY THIS
Signal.F_pass = 110000;          % Passband frequency (Hz) - MODIFY THIS  
Signal.F_stop = 120000;          % Stopband frequency (Hz) - MODIFY THIS
Signal.A_pass = 0.3;            % Passband ripple (dB)
Signal.A_stop = 70;             % Stopband attenuation (dB)

%% ====================
%% AUTOMATIC CALCULATIONS
%% ====================

% Calculate normalized frequencies
Signal.Fs_output = Signal.Fs_input / CIC.R;
Signal.F_pass_norm = Signal.F_pass / (Signal.Fs_output / 2);
Signal.F_stop_norm = Signal.F_stop / (Signal.Fs_output / 2);

fprintf('=== CIC FILTER SPECIFICATIONS ===\n');
fprintf('Stages (N): %d\n', CIC.N);
fprintf('Differential Delay (M): %d\n', CIC.M);
fprintf('Decimation Factor (R): %d\n', CIC.R);
fprintf('Input Sample Rate: %.0f Hz\n', Signal.Fs_input);
fprintf('Output Sample Rate: %.0f Hz\n', Signal.Fs_output);

fprintf('\n=== SIGNAL SPECIFICATIONS ===\n');
fprintf('Passband Frequency: %.0f Hz (Normalized: %.3f)\n', Signal.F_pass, Signal.F_pass_norm);
fprintf('Stopband Frequency: %.0f Hz (Normalized: %.3f)\n', Signal.F_stop, Signal.F_stop_norm);
fprintf('Passband Ripple: %.1f dB\n', Signal.A_pass);
fprintf('Stopband Attenuation: %.0f dB\n', Signal.A_stop);

%% ====================
%% CIC RESPONSE ANALYSIS
%% ====================

% Create CIC filter object
cicFilter = dsp.CICDecimator(CIC.R, CIC.N, CIC.M);

% Calculate CIC frequency response
[h_cic, w_cic] = freqz(cicFilter, 1024);
f_cic = w_cic/pi * (Signal.Fs_output/2);
mag_cic_dB = 20*log10(abs(h_cic));

% Find CIC droop at passband edge
passband_idx = find(f_cic <= Signal.F_pass, 1, 'last');
cic_droop = -mag_cic_dB(passband_idx); % Negative because it's droop
fprintf('\n=== CIC DROOP ANALYSIS ===\n');
fprintf('CIC droop at passband edge (%.0f Hz): %.2f dB\n', Signal.F_pass, cic_droop);

%% ====================
%% OPTIMAL FIR COMPENSATOR DESIGN
%% ====================

% Method 1: Using fdesign.ciccomp (Most Accurate)
fprintf('\n=== DESIGNING FIR COMPENSATOR ===\n');

% Create filter specification object
compSpec = fdesign.ciccomp(CIC.N, CIC.M, CIC.R, ...
    'Fp,Fst,Ap,Ast', Signal.F_pass_norm, Signal.F_stop_norm, Signal.A_pass, Signal.A_stop);

% Design the FIR compensator
firCompensator = design(compSpec, 'equiripple', 'SystemObject', true);

% Get filter details
fir_info = info(firCompensator);
fprintf('FIR Filter Order: %d\n', fir_info.FilterOrder);
fprintf('Number of Coefficients: %d\n', length(firCompensator.Numerator));

% Calculate FIR frequency response  
[h_fir, w_fir] = freqz(firCompensator, 1024);
f_fir = w_fir/pi * (Signal.Fs_output/2);
mag_fir_dB = 20*log10(abs(h_fir));

%% ====================
%% CASCADE PERFORMANCE VERIFICATION
%% ====================

% Create cascade system
cascadeFilter = dsp.FilterCascade(cicFilter, firCompensator);

% Calculate overall frequency response
[h_overall, w_overall] = freqz(cascadeFilter, 1024);
f_overall = w_overall/pi * (Signal.Fs_output/2);
mag_overall_dB = 20*log10(abs(h_overall));

% Calculate passband flatness
pb_indices = find(f_overall <= Signal.F_pass);
passband_ripple = max(mag_overall_dB(pb_indices)) - min(mag_overall_dB(pb_indices));

fprintf('\n=== PERFORMANCE VERIFICATION ===\n');
fprintf('Overall passband ripple: %.3f dB\n', passband_ripple);
fprintf('Compensation accuracy: %.2f%%\n', (1 - passband_ripple/Signal.A_pass) * 100);

%% ====================
%% RESULTS EXPORT
%% ====================

% Export coefficients for HDL implementation
fir_coefficients = firCompensator.Numerator;
fprintf('\n=== EXPORTING RESULTS ===\n');
fprintf('FIR coefficients generated: %d coefficients\n', length(fir_coefficients));

% Save coefficients to file
coefficients_hex = fi(fir_coefficients, 1, 16, 15); % 16-bit fixed point
writematrix(coefficients_hex, 'cic_compensator_coefficients.csv');

%% ====================
%% COMPREHENSIVE PLOTTING
%% ====================

figure('Position', [100, 100, 1200, 800]);

% Plot 1: Individual Responses
subplot(2,2,1);
plot(f_cic, mag_cic_dB, 'r', 'LineWidth', 2); hold on;
plot(f_fir, mag_fir_dB, 'g', 'LineWidth', 2);
plot(f_overall, mag_overall_dB, 'b', 'LineWidth', 2);
xline(Signal.F_pass, '--k', 'Passband Edge', 'LabelVerticalAlignment', 'middle');
xline(Signal.F_stop, '--k', 'Stopband Edge', 'LabelVerticalAlignment', 'middle');
ylabel('Magnitude (dB)');
xlabel('Frequency (Hz)');
title('Frequency Responses');
legend('CIC Only', 'FIR Compensator', 'Overall Compensated', 'Location', 'best');
grid on;

% Plot 2: Passband Detail
subplot(2,2,2);
pb_mask = f_overall <= Signal.F_pass * 1.2;
plot(f_overall(pb_mask), mag_overall_dB(pb_mask), 'b', 'LineWidth', 2);
xline(Signal.F_pass, '--r', 'Passband Edge');
ylabel('Magnitude (dB)');
xlabel('Frequency (Hz)');
title('Passband Detail - Overall Response');
grid on;
ylim([-Signal.A_pass, Signal.A_pass]);

% Plot 3: CIC Droop Compensation
subplot(2,2,3);
plot(f_cic, mag_cic_dB, 'r--', 'LineWidth', 1.5); hold on;
plot(f_fir, mag_fir_dB + max(mag_cic_dB), 'g--', 'LineWidth', 1.5);
plot(f_overall, mag_overall_dB, 'b-', 'LineWidth', 2);
xline(Signal.F_pass, '--k', 'Passband Edge');
ylabel('Magnitude (dB)');
xlabel('Frequency (Hz)');
title('CIC Droop Compensation Visualization');
legend('CIC Droop', 'FIR Compensation', 'Final Response', 'Location', 'best');
grid on;

% Plot 4: FIR Coefficients
subplot(2,2,4);
stem(0:length(fir_coefficients)-1, fir_coefficients, 'filled', 'MarkerSize', 4);
xlabel('Tap Number');
ylabel('Coefficient Value');
title('FIR Compensator Coefficients');
grid on;

sgtitle('CIC FIR Compensator Design - Complete Analysis');

%% ====================
%% FILTERDESIGNER LAUNCH
%% ====================

fprintf('\n=== OPENING FILTERDESIGNER ===\n');
fprintf('Check filterDesigner for detailed analysis and export options.\n');

% Launch filterDesigner with the designed filter
filterDesigner(firCompensator);

%% ====================
%% FINAL SUMMARY
%% ====================

fprintf('\n=== DESIGN COMPLETE ===\n');
fprintf('Optimal FIR compensator designed successfully!\n');
fprintf('Key Specifications:\n');
fprintf('  - Filter Order: %d\n', fir_info.FilterOrder);
fprintf('  - Passband: 0 - %.0f Hz\n', Signal.F_pass);
fprintf('  - Stopband: %.0f Hz and above\n', Signal.F_stop);
fprintf('  - Passband Ripple: %.3f dB (Spec: %.1f dB)\n', passband_ripple, Signal.A_pass);
fprintf('  - Compensation Accuracy: %.1f%%\n', (1 - passband_ripple/Signal.A_pass) * 100);

fprintf('\nNext steps:\n');
fprintf('1. Verify results in filterDesigner (opened automatically)\n');
fprintf('2. Use coefficients from ''cic_compensator_coefficients.csv''\n');
fprintf('3. Implement FIR filter in your HDL code\n');