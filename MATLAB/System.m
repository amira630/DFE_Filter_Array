clear;
close all;
clc;

%% ======================= SECTION 1: INITIALIZATION =======================

Fs = 9e6;              % Sampling freq  uency (Hz)
N  = 48000;            % Number of samples

% === 1. Generate sine-wave input (ADC-like signal) ===
f_sig = 1e5;                               % Signal frequency (100 kHz tone)
t = (0 : N - 1)' / Fs;                     % Time vector
input_sig_real_clean = 0.25 * sin(2 * pi * f_sig * t);    % Amplitude < 1 to avoid clipping in fixed-point

%% ======================= SECTION 2: INTERFERENCE GENERATION =======================

% Define interference tones to be filtered out
f_intf_2_4 = 2.4e6;     % 2.4 MHz interference tone
f_intf_5 = 5e6;         % 5 MHz interference tone

f_tone_1 = 2.8e6;
f_tone_2 = 3e6;
f_tone_3 = 3.2e6;
f_tone_4 = 4e6;
f_tone_5 = 4.5e6;

% Interference amplitudes (adjusted to avoid saturation in fixed-point)
A_intf_2_4 = 0.2;
A_intf_5 = 0.2;

A_tones = 0.2;

% Generate and add the interference signals
intf1 = (A_intf_2_4 * sin(2 * pi * f_intf_2_4 * t));
intf2 = (A_intf_5 * sin(2 * pi * f_intf_5 * t));

tone_1 = A_tones * sin(2 * pi * f_tone_1 * t);
tone_2 = A_tones * sin(2 * pi * f_tone_2 * t);
tone_3 = A_tones * sin(2 * pi * f_tone_3 * t);
tone_4 = A_tones * sin(2 * pi * f_tone_4 * t);
tone_5 = A_tones * sin(2 * pi * f_tone_5 * t);

interference = intf1 + intf2;

tones = tone_3 + tone_4 + tone_5;

% White band noise
% High quality (40-50 dB SNR): noise_variance = 1e-6 to 1e-5
% Medium quality (30-40 dB SNR): noise_variance = 1e-5 to 1e-4
% Low quality (20-30 dB SNR): noise_variance = 1e-4 to 1e-3
noise_variance = 1e-5; % Adjust based on desired SNR
noise = sqrt(noise_variance) * randn(N, 1); % White Gaussian noise

input_sig_real_noisy = input_sig_real_clean + interference + tones; % Combine desired signal with interference

impurities = input_sig_real_noisy - input_sig_real_clean;

input_sig_real_noisy = input_sig_real_noisy + noise; % Combine desired signal with interference

%% ======================= SECTION 3: FIXED-POINT COMPATIBILITY CHECK =======================

max_pos = 0.999969482421875;
max_neg = -1;

% Check if signals exceed s16.15 fixed-point range (±1.0 represents full scale)
fprintf('\n=== FIXED-POINT COMPATIBILITY CHECK ===\n');

if max(input_sig_real_noisy) > max_pos 
    fprintf('WARNING: x_real_noisy exceeds s16.15 range! (max value = %.4f)\n', max(input_sig_real_noisy));
elseif min(input_sig_real_noisy) < max_neg
    fprintf('WARNING: x_real_noisy exceeds s16.15 range! (min value = %.4f)\n', min(input_sig_real_noisy));
else
    fprintf('x_real_noisy is within s16.15 range ✓\n');
end

if max(intf1) > max_pos
    fprintf('WARNING: intf1 exceeds s16.15 range! (max value = %.4f)\n', max(intf1));
elseif min(intf1) < max_neg
    fprintf('WARNING: intf1 exceeds s16.15 range! (min value = %.4f)\n', min(intf1));
else
    fprintf('intf1 is within s16.15 range ✓\n');
end

if max(intf2) > max_pos
    fprintf('WARNING: intf2 exceeds s16.15 range! (max value = %.4f)\n', max(intf2));
elseif min(intf2) < max_neg
    fprintf('WARNING: intf2 exceeds s16.15 range! (min value = %.4f)\n', min(intf2));
else
    fprintf('intf2 is within s16.15 range ✓\n');
end

fprintf ('\n-------------------------------------------------------\n\n');

input_sig_quant_clean = fi(input_sig_real_clean, 1, 16, 15);
impurities_quant = fi(impurities, 1, 16, 15);
input_sig_quant_noisy = fi(input_sig_real_noisy, 1, 16, 15);

%% ======================= SECTION 4: Filters Handles =======================

Hd_Fractional_Decimator = Fractional_Decimator();%Fractional_Decimator();

% Filter Information
intr_factor = Hd_Fractional_Decimator.InterpolationFactor;
dec_factor = Hd_Fractional_Decimator.DecimationFactor;

Fs_frac = Fs * intr_factor / dec_factor;

Hd_IIR_2_4 = IIR_2_4();
Hd_IIR_2_4_obj = IIR_2_4_obj(); % For Filter Analyzer

Hd_IIR_1 = IIR_1();
Hd_IIR_1_obj = IIR_1_obj(); % For Filter Analyzer

Hd_IIR_2 = IIR_2();

Hd_cic_2 = CIC(2);
Fs_cic_2 = Fs_frac / 2;

Hd_cic_4 = CIC(4);
Fs_cic_4 = Fs_frac / 4;

Hd_cic_8 = CIC(8);
Fs_cic_8 = Fs_frac / 8;

Hd_cic_16 = CIC(16);
Fs_cic_16 = Fs_frac / 16;

% Combined cascaded filter for analysis (Fractional Decimator -> IIR 2.4 MHz -> IIR 5 MHz (1st) -> CIC R=2)
Hd_cascade_2 = dsp.FilterCascade(Hd_Fractional_Decimator, Hd_IIR_2_4_obj, Hd_IIR_1_obj, Hd_cic_2);

% Cascade for CIC R=4 path
Hd_cascade_4 = dsp.FilterCascade(Hd_Fractional_Decimator, Hd_IIR_2_4_obj, Hd_IIR_1_obj, Hd_cic_4);

% Cascade for CIC R=8 path
Hd_cascade_8 = dsp.FilterCascade(Hd_Fractional_Decimator, Hd_IIR_2_4_obj, Hd_IIR_1_obj, Hd_cic_8);

% Cascade for CIC R=16 path
Hd_cascade_16 = dsp.FilterCascade(Hd_Fractional_Decimator, Hd_IIR_2_4_obj, Hd_IIR_1_obj, Hd_cic_16);


Hd_cic_2_float = CIC_float(2);

Hd_cic_4_float = CIC_float(4);

Hd_cic_8_float = CIC_float(8);

Hd_cic_16_float = CIC_float(16);

Hd_FIR_comp = FIR_comp();
Hd_FIR_comp_obj = FIR_comp_obj();

% Combined cascaded filter for analysis (Fractional Decimator -> IIR 2.4 MHz -> IIR 5 MHz (1st) -> CIC R=2)
Hd_cascade_2_comp = dsp.FilterCascade(Hd_Fractional_Decimator, Hd_IIR_2_4_obj, Hd_IIR_1_obj, Hd_cic_2, Hd_FIR_comp_obj);

% Cascade for CIC R=4 path
Hd_cascade_4_comp = dsp.FilterCascade(Hd_Fractional_Decimator, Hd_IIR_2_4_obj, Hd_IIR_1_obj, Hd_cic_4, Hd_FIR_comp_obj);

% Cascade for CIC R=8 path
Hd_cascade_8_comp = dsp.FilterCascade(Hd_Fractional_Decimator, Hd_IIR_2_4_obj, Hd_IIR_1_obj, Hd_cic_8, Hd_FIR_comp_obj);

% Cascade for CIC R=16 path
Hd_cascade_16_comp = dsp.FilterCascade(Hd_Fractional_Decimator, Hd_IIR_2_4_obj, Hd_IIR_1_obj, Hd_cic_16, Hd_FIR_comp_obj);


%% ======================= SECTION 5: Filters Analysis =======================

% filters = {Hd_Fractional_Decimator, Hd_IIR_2_4, Hd_IIR_1, Hd_IIR_2, ...
%     Hd_cic_2, Hd_cic_4, Hd_cic_8, Hd_cic_16};
% names = {'Fractional Decimator (2/3)', 'IIR 2.4 MHz Notch', 'IIR 1 MHz Notch', 'IIR 2 MHz Notch', ...
%     'CIC R = 2', 'CIC R = 4', 'CIC R = 8', 'CIC R = 16'};
% 
% % Store all fvtool handles
% hfvt_array = cell(1, length(filters));
% 
% % Create all fvtool windows first
% for i = 1:length(filters)
%     hfvt_array{i} = fvtool(filters{i});
% end
% 
% % Now set all the names after all windows are created
% for i = 1:length(filters)
%     set(hfvt_array{i}, 'Name', sprintf('Filter Analysis: %s', names{i}));
%     set(hfvt_array{i}, 'NumberTitle', 'off');
% end

%% ======================= SECTION 6: Signal Propagation =======================

output_frac_sig = step(Hd_Fractional_Decimator, input_sig_quant_noisy);

output_iir24_sig = filter(Hd_IIR_2_4, output_frac_sig);

output_iir5_1_sig = filter(Hd_IIR_1, output_iir24_sig);

output_iir5_2_sig = filter(Hd_IIR_2, output_iir5_1_sig);

output_cic_2_sig = step(Hd_cic_2, output_iir5_2_sig);
output_cic_2_compensated_sig = filter(Hd_FIR_comp, output_cic_2_sig);

output_cic_4_sig = step(Hd_cic_4, output_iir5_2_sig);
output_cic_4_compensated_sig = filter(Hd_FIR_comp, output_cic_4_sig);

output_cic_8_sig = step(Hd_cic_8, output_iir5_2_sig);
output_cic_8_compensated_sig = filter(Hd_FIR_comp, output_cic_8_sig);

output_cic_16_sig = step(Hd_cic_16, output_iir5_2_sig);
output_cic_16_compensated_sig = filter(Hd_FIR_comp, output_cic_16_sig);

output_cic_2_sig_float = step(Hd_cic_2_float, output_iir5_2_sig);

output_cic_4_sig_float = step(Hd_cic_4_float, output_iir5_2_sig);

output_cic_8_sig_float = step(Hd_cic_8_float, output_iir5_2_sig);

output_cic_16_sig_float = step(Hd_cic_16_float, output_iir5_2_sig);

%% ======================= SECTION 7: Noise Propagation =======================
% This filter is needed for SNR calculations

output_frac_inter = step(Hd_Fractional_Decimator, impurities_quant);

output_iir24_inter = filter(Hd_IIR_2_4, output_frac_inter);

output_iir5_1_inter = filter(Hd_IIR_1, output_iir24_inter);

output_iir5_2_inter = filter(Hd_IIR_2, output_iir5_1_inter);

output_cic_2_inter = step(Hd_cic_2, output_iir5_2_inter);
output_cic_2_compensated_inter = filter(Hd_FIR_comp, output_cic_2_inter);

output_cic_4_inter = step(Hd_cic_4, output_iir5_2_inter);
output_cic_4_compensated_inter = filter(Hd_FIR_comp, output_cic_4_inter);

output_cic_8_inter = step(Hd_cic_8, output_iir5_2_inter);
output_cic_8_compensated_inter = filter(Hd_FIR_comp, output_cic_8_inter);

output_cic_16_inter = step(Hd_cic_16, output_iir5_2_inter);
output_cic_16_compensated_inter = filter(Hd_FIR_comp, output_cic_16_inter);

output_cic_2_inter_float = step(Hd_cic_2_float, output_iir5_2_inter);

output_cic_4_inter_float = step(Hd_cic_4_float, output_iir5_2_inter);

output_cic_8_inter_float = step(Hd_cic_8_float, output_iir5_2_inter);

output_cic_16_inter_float = step(Hd_cic_16_float, output_iir5_2_inter);

%% ======================= SECTION 8: Signal Propagation Analysis =======================

fprintf('(2 / 3) Fractional Decimator\n\n');
analyze_fixed_point_filter(Hd_Fractional_Decimator, Fs, input_sig_quant_noisy, 2/3, 1, '(2 / 3) Fractional Decimator');

fprintf('IIR 2.4 MHz Notch\n\n');
analyze_fixed_point_filter(Hd_IIR_2_4, Fs_frac, output_frac_sig, 1, 0, 'IIR 2.4 MHz Notch');

fprintf('IIR 1 MHz Notch\n\n');
analyze_fixed_point_filter(Hd_IIR_1, Fs_frac, output_iir24_sig, 1, 0, 'IIR 1 MHz Notch');

fprintf('IIR 2 MHz Notch\n\n');
analyze_fixed_point_filter(Hd_IIR_2, Fs_frac, output_iir5_1_sig, 1, 0, 'IIR 2 MHz Notch');

fprintf('CIC R = 2\n\n');
analyze_fixed_point_filter(Hd_cic_2_float, Fs_frac, output_iir5_2_sig, 1/2, 1, 'CIC R = 2');

fprintf('CIC R = 4\n\n');
analyze_fixed_point_filter(Hd_cic_4_float, Fs_frac, output_iir5_2_sig, 1/4, 1, 'CIC R = 4');

fprintf('CIC R = 8\n\n');
analyze_fixed_point_filter(Hd_cic_8_float, Fs_frac, output_iir5_2_sig, 1/8, 1, 'CIC R = 8');

fprintf('CIC R = 16\n\n');
analyze_fixed_point_filter(Hd_cic_16_float, Fs_frac, output_iir5_2_sig, 1/16, 1, 'CIC R = 16');

fprintf('FIR R = 2 Compensator\n\n');
analyze_fixed_point_filter(Hd_FIR_comp, Fs_cic_2, output_cic_2_sig, 1, 0, 'FIR R = 2 Compensator');

fprintf('FIR R = 4 Compensator\n\n');
analyze_fixed_point_filter(Hd_FIR_comp, Fs_cic_4, output_cic_4_sig, 1, 0, 'FIR R = 4 Compensator');

fprintf('FIR R = 8 Compensator\n\n');
analyze_fixed_point_filter(Hd_FIR_comp, Fs_cic_8, output_cic_8_sig, 1, 0, 'FIR R = 8 Compensator');

fprintf('FIR R = 16 Compensator\n\n');
analyze_fixed_point_filter(Hd_FIR_comp, Fs_cic_16, output_cic_16_sig, 1, 0, 'FIR R = 16 Compensator');

%% ======================= SECTION 9: SNR Calculations =======================

delay_samples = 35;
delay_samples_comp = 70;

snr_init = snr(double(input_sig_quant_noisy), double(impurities_quant));

snr_frac = snr(double(output_frac_sig), double(output_frac_inter));

snr_iir24 = snr(double(output_iir24_sig), double(output_iir24_inter));

snr_iir5_1 = snr(double(output_iir5_1_sig), double(output_iir5_1_inter));

snr_iir5_2 = snr(double(output_iir5_2_sig), double(output_iir5_2_inter));

snr_cic_2 = snr(double(output_cic_2_sig(delay_samples : end)), double(output_cic_2_inter(delay_samples : end)));
snr_cic_2_comp = snr(double(output_cic_2_compensated_sig(delay_samples_comp : end)), double(output_cic_2_compensated_inter(delay_samples_comp : end)));

snr_cic_4 = snr(double(output_cic_4_sig(delay_samples : end)), double(output_cic_4_inter(delay_samples : end)));
snr_cic_4_comp = snr(double(output_cic_4_compensated_sig(delay_samples_comp : end)), double(output_cic_4_compensated_inter(delay_samples_comp : end)));

snr_cic_8 = snr(double(output_cic_8_sig(delay_samples : end)), double(output_cic_8_inter(delay_samples : end)));
snr_cic_8_comp = snr(double(output_cic_8_compensated_sig(delay_samples_comp : end)), double(output_cic_8_compensated_inter(delay_samples_comp : end)));

snr_cic_16 = snr(double(output_cic_16_sig(delay_samples : end)), double(output_cic_16_inter(delay_samples : end)));
snr_cic_16_comp = snr(double(output_cic_16_compensated_sig(delay_samples_comp : end)), double(output_cic_16_compensated_inter(delay_samples_comp : end)));

snr_cic_2_float = snr(double(output_cic_2_sig_float(delay_samples : end)), double(output_cic_2_inter_float(delay_samples : end)));

snr_cic_4_float = snr(double(output_cic_4_sig_float(delay_samples : end)), double(output_cic_4_inter_float(delay_samples : end)));

snr_cic_8_float = snr(double(output_cic_8_sig_float(delay_samples : end)), double(output_cic_8_inter_float(delay_samples : end)));

snr_cic_16_float = snr(double(output_cic_16_sig_float(delay_samples : end)), double(output_cic_16_inter_float(delay_samples : end)));

snr_after = min(snr_cic_2, min(snr_cic_4, min(snr_cic_8, snr_cic_16))); % Worst Case SNR with no Compensator
snr_after_comp = min(snr_cic_2_comp, min(snr_cic_4_comp, min(snr_cic_8_comp, snr_cic_16_comp))); % Worst Case SNR with Compensator

total_snr_improvment = snr_after - snr_init; 

total_snr_improvment_comp = snr_after_comp - snr_init; 

fprintf('\n=== SNR ANALYSIS RESULTS ===\n');
fprintf('SNR Before = %.4f dB\n', snr_init);
fprintf('SNR After (no compensator) = %.4f dB\n', snr_after);
fprintf('SNR After (with compensator) = %.4f dB\n', snr_after_comp);
fprintf('Total SNR Improvement (no compensator) = %.4f dB\n', total_snr_improvment);
fprintf('Total SNR Improvement (with compensator) = %.4f dB\n', total_snr_improvment_comp);

fprintf('\n=== ATTENUATION CHECK ===\n');
if total_snr_improvment > 60
    fprintf('Attenuation (no compensator) = %.4f dB ✓\n', total_snr_improvment);
else
    fprintf('Attenuation (no compensator) = %.4f dB ✘\n', total_snr_improvment);
end

if total_snr_improvment_comp > 60
    fprintf('Attenuation (with compensator) = %.4f dB ✓\n', total_snr_improvment_comp);
else
    fprintf('Attenuation (with compensator) = %.4f dB ✘\n', total_snr_improvment_comp);
end

fprintf('\n=== INDIVIDUAL STAGE SNR ===\n');
fprintf('SNR after Fractional Decimator = %.4f dB\n', snr_frac);
fprintf('SNR after IIR 2.4 MHz = %.4f dB\n', snr_iir24);
fprintf('SNR after IIR 5 MHz (1st) = %.4f dB\n', snr_iir5_1);
fprintf('SNR after IIR 5 MHz (2nd) = %.4f dB\n', snr_iir5_2);
fprintf('SNR after CIC R=2 = %.4f dB  (Floating: %.4f dB) (compensated: %.4f dB)\n', snr_cic_2_float,  snr_cic_2, snr_cic_2_comp);
fprintf('SNR after CIC R=4 = %.4f dB  (Floating: %.4f dB) (compensated: %.4f dB)\n', snr_cic_4_float,  snr_cic_4, snr_cic_4_comp);
fprintf('SNR after CIC R=8 = %.4f dB  (Floating: %.4f dB) (compensated: %.4f dB)\n', snr_cic_8_float,  snr_cic_8, snr_cic_8_comp);
fprintf('SNR after CIC R=16 = %.4f dB (Floating: %.4f dB) (compensated: %.4f dB)\n', snr_cic_16_float, snr_cic_16, snr_cic_16_comp);
fprintf('\n-------------------------------------------------------\n');
