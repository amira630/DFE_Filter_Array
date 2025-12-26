clear;
close all;
clc;

%% ========================= Configuration =================================
test_cases = {'TC_1', 'TC_2', 'TC_3', 'TC_4', 'TC_5', 'TC_6', 'TC_7', 'TC_8', ...
              'TC_9', 'TC_10', 'TC_11', 'TC_12', 'TC_13', 'TC_14', 'TC_15', 'TC_16'};

% Filter stages in the processing chain
stages = {'cic_decf2', 'cic_decf4', 'cic_decf8', 'cic_decf16', ...
          'frac_decimator', 'iir_24mhz', 'iir_5mhz_1'};

% Signal types
signal_types = {'output', 'interference', 'noise', 'tones', 'clean'};

% Fixed-point format: S16.15 (1 sign bit, 16 integer bits, 15 fractional bits)
SCALE_FACTOR = 2^15;  % 32768.0 for S16.15 format

% Initialize data structure
signals = struct();

% Helper function to read binary file and convert S16.15 fixed-point to floating-point
% Reads binary strings from file and converts them to signed 32-bit integers (two's complement)
function result = read_and_convert_s16_15(filename)
    SCALE_FACTOR = 2^15;

    % Read the file as text lines
    lines = readlines(filename, 'EmptyLineRule', 'skip');

    % Preallocate result array
    result = zeros(length(lines), 1);

    % Process each line
    for i = 1:length(lines)
        bin_str = char(lines(i));

        % Skip empty lines
        if isempty(bin_str)
            result(i) = 0;
            continue;
        end

        % Convert binary string to decimal (unsigned)
        unsigned_val = bin2dec(bin_str);

        % Convert to signed using two's complement (16-bit for S16.15)
        % If MSB (bit 15) is 1, the number is negative
        if unsigned_val >= 2^15
            signed_val = unsigned_val - 2^16;
        else
            signed_val = unsigned_val;
        end

        % Scale to S16.15 format
        result(i) = double(signed_val) / SCALE_FACTOR;
    end
end

%% ======================= SECTION 1: Output Propagation ======================
fprintf('===== SECTION 1: Reading Output Signals from All Test Cases =====\n');

for tc_idx = 1:length(test_cases)
    tc_name = test_cases{tc_idx};
    tc_path = fullfile(tc_name, 'scenario_full_flow');

    fprintf('Processing %s...\n', tc_name);

    % Initialize structure for this test case
    signals.(tc_name) = struct();

    % Read output signals at each stage
    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};

        % Output signal (main signal) - S16.15 format
        output_file = fullfile(tc_path, [stage_name '.txt']);
        if isfile(output_file)
            signals.(tc_name).output.(stage_name) = read_and_convert_s16_15(output_file);
            fprintf('  ✓ Loaded output at stage: %s\n', stage_name);
        else
            fprintf('  ✗ Missing: %s\n', output_file);
        end

        % Clean signal (reference) - S16.15 format
        clean_file = fullfile(tc_path, ['clean_' stage_name '.txt']);
        if isfile(clean_file)
            signals.(tc_name).clean.(stage_name) = read_and_convert_s16_15(clean_file);
        end
    end

    % Read final outputs (decf stages) - S16.15 format
    for decf = [2, 4, 8, 16]
        output_decf_file = fullfile(tc_path, sprintf('output_decf%d.txt', decf));
        if isfile(output_decf_file)
            signals.(tc_name).output.(sprintf('decf%d', decf)) = read_and_convert_s16_15(output_decf_file);
        end
    end

    fprintf('  Completed %s\n\n', tc_name);
end

%% ======================= SECTION 2: Interference Propagation ================
fprintf('===== SECTION 2: Reading Interference Signals =====\n');

% TC_2, TC_3 have interference
interference_tcs = {'TC_2', 'TC_3', 'TC_5', 'TC_6', 'TC_8', 'TC_9', ...
    'TC_11', 'TC_12', 'TC_13', 'TC_14', 'TC_15', 'TC_16'};

for tc_idx = 1:length(interference_tcs)
    tc_name = interference_tcs{tc_idx};
    tc_path = fullfile(tc_name, 'scenario_full_flow');

    fprintf('Processing %s interference...\n', tc_name);

    % Read interference signals at each stage - S16.15 format
    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};

        interference_file = fullfile(tc_path, ['interference_' stage_name '.txt']);
        if isfile(interference_file)
            signals.(tc_name).interference.(stage_name) = read_and_convert_s16_15(interference_file);
            fprintf('  ✓ Loaded interference at stage: %s\n', stage_name);
        else
            fprintf('  ✗ Missing: %s\n', interference_file);
        end
    end

    % Read interference at decf stages - S16.15 format
    for decf = [2, 4, 8, 16]
        interference_decf_file = fullfile(tc_path, sprintf('interference_cic_decf%d.txt', decf));
        if isfile(interference_decf_file)
            signals.(tc_name).interference.(sprintf('cic_decf%d', decf)) = read_and_convert_s16_15(interference_decf_file);
        end
    end

    fprintf('  Completed %s interference\n\n', tc_name);
end

%% ======================= SECTION 3: Noise Propagation =======================
fprintf('===== SECTION 3: Reading Noise Signals =====\n');

% TC_4 has noise
noise_tcs = {'TC_4', 'TC_5', 'TC_6', 'TC_10', 'TC_11', 'TC_12'};

for tc_idx = 1:length(noise_tcs)
    tc_name = noise_tcs{tc_idx};
    tc_path = fullfile(tc_name, 'scenario_full_flow');

    fprintf('Processing %s noise...\n', tc_name);

    % Read noise signals at each stage - S16.15 format
    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};

        noise_file = fullfile(tc_path, ['noise_' stage_name '.txt']);
        if isfile(noise_file)
            signals.(tc_name).noise.(stage_name) = read_and_convert_s16_15(noise_file);
            fprintf('  ✓ Loaded noise at stage: %s\n', stage_name);
        else
            fprintf('  ✗ Missing: %s\n', noise_file);
        end
    end

    % Read noise at decf stages - S16.15 format
    for decf = [2, 4, 8, 16]
        noise_decf_file = fullfile(tc_path, sprintf('noise_cic_decf%d.txt', decf));
        if isfile(noise_decf_file)
            signals.(tc_name).noise.(sprintf('cic_decf%d', decf)) = read_and_convert_s16_15(noise_decf_file);
        end
    end

    fprintf('  Completed %s noise\n\n', tc_name);
end

%% ======================= SECTION 4: Tones Propagation =======================
fprintf('===== SECTION 4: Reading Tones Signals =====\n');

% TC_3 has tones
tones_tcs = {'TC_3', 'TC_6', 'TC_9', 'TC_12',};

for tc_idx = 1:length(tones_tcs)
    tc_name = tones_tcs{tc_idx};
    tc_path = fullfile(tc_name, 'scenario_full_flow');

    fprintf('Processing %s tones...\n', tc_name);

    % Read tones signals at each stage - S16.15 format
    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};

        tones_file = fullfile(tc_path, ['tones_' stage_name '.txt']);
        if isfile(tones_file)
            signals.(tc_name).tones.(stage_name) = read_and_convert_s16_15(tones_file);
            fprintf('  ✓ Loaded tones at stage: %s\n', stage_name);
        else
            fprintf('  ✗ Missing: %s\n', tones_file);
        end
    end

    % Read tones at decf stages - S16.15 format
    for decf = [2, 4, 8, 16]
        tones_decf_file = fullfile(tc_path, sprintf('tones_cic_decf%d.txt', decf));
        if isfile(tones_decf_file)
            signals.(tc_name).tones.(sprintf('cic_decf%d', decf)) = read_and_convert_s16_15(tones_decf_file);
        end
    end

    fprintf('  Completed %s tones\n\n', tc_name);
end

%% ======================= Summary ===========================================
fprintf('\n===== SUMMARY: Available Signals =====\n');
fprintf('Structure: signals.TC_X.{output, interference, noise, tones, clean}.{stage_name}\n\n');

fprintf('Example access patterns:\n');
fprintf('  - Output signal at CIC decf2:    signals.TC_1.output.cic_decf2\n');
fprintf('  - Clean signal at IIR 24MHz:     signals.TC_1.clean.iir_24mhz\n');
fprintf('  - Interference at frac_decimator: signals.TC_2.interference.frac_decimator\n');
fprintf('  - Noise at IIR 5MHz:             signals.TC_4.noise.iir_5mhz_1\n');
fprintf('  - Tones at CIC decf8:            signals.TC_3.tones.cic_decf8\n');
fprintf('\nAll signals loaded successfully!\n');

%% ======================= SECTION 5: INITIALIZATION =======================

Fs = 9e6;              % Sampling freq  uency (Hz)
N  = 48000;            % Number of samples

% === 1. Generate sine-wave input (ADC-like signal) ===
f_sig = 1e5;                               % Signal frequency (100 kHz tone)
t = (0 : N - 1)' / Fs;                     % Time vector

Fs_frac = Fs * 2 / 3;
N_frac = N * 2 / 3;

t_frac = (0 : N_frac - 1)' / Fs_frac;  % Time vector for fractional Fs

Fs_decf_2  = Fs_frac / 2;
Fs_decf_4  = Fs_frac / 4;
Fs_decf_8  = Fs_frac / 8;
Fs_decf_16 = Fs_frac / 16;

N_decf_2  = N_frac / 2;
N_decf_4  = N_frac / 4;
N_decf_8  = N_frac / 8;
N_decf_16 = N_frac / 16;

t_decf_2  = (0 : N_decf_2 - 1)' / Fs_decf_2;
t_decf_4  = (0 : N_decf_4 - 1)' / Fs_decf_4;
t_decf_8  = (0 : N_decf_8 - 1)' / Fs_decf_8;
t_decf_16 = (0 : N_decf_16 - 1)' / Fs_decf_16;

%% ======================= SECTION 6: Plot Output Propagations ==========================
% fprintf('\n===== SECTION 6: Plotting Output Signal Propagation =====\n');
% 
% % Define sampling frequencies for each stage
% stage_fs = struct();
% stage_fs.cic_decf2 = Fs_decf_2;
% stage_fs.cic_decf4 = Fs_decf_4;
% stage_fs.cic_decf8 = Fs_decf_8;
% stage_fs.cic_decf16 = Fs_decf_16;
% stage_fs.frac_decimator = Fs_frac;
% stage_fs.iir_24mhz = Fs_frac;
% stage_fs.iir_5mhz_1 = Fs_frac;
% 
% % Stage display names
% stage_names_display = {
%     'CIC Decimation (÷2)',
%     'CIC Decimation (÷4)',
%     'CIC Decimation (÷8)',
%     'CIC Decimation (÷16)',
%     'Fractional Decimator',
%     'IIR 24MHz Notch',
%     'IIR 5MHz Notch'
% };
% 
% % Plot each test case with tabbed interface
% for tc_idx = 1:length(test_cases)
%     tc_name = test_cases{tc_idx};
% 
%     if ~isfield(signals.(tc_name), 'output')
%         continue;
%     end
% 
%     fprintf('Creating tabbed figure for %s...\n', tc_name);
% 
%     % Create main figure
%     fig = figure('Name', sprintf('%s - Output Signal Propagation', tc_name), ...
%                  'Position', [50, 50, 1200, 700], ...
%                  'NumberTitle', 'off');
% 
%     % Create tab group
%     tabgroup = uitabgroup(fig);
% 
%     % Create one tab per stage
%     for stage_idx = 1:length(stages)
%         stage_name = stages{stage_idx};
% 
%         if ~isfield(signals.(tc_name).output, stage_name)
%             continue;
%         end
% 
%         % Create tab
%         tab = uitab(tabgroup, 'Title', stage_names_display{stage_idx});
% 
%         % Get signal data
%         output_signal = signals.(tc_name).output.(stage_name);
%         fs = stage_fs.(stage_name);
%         n_samples = length(output_signal);
%         t_vec = (0:n_samples-1)' / fs;
% 
%         % === Time Domain Plot ===
%         ax1 = subplot(2, 1, 1, 'Parent', tab);
%         plot(ax1, t_vec * 1e3, output_signal, 'b-', 'LineWidth', 1.2);
%         grid(ax1, 'on');
%         xlabel(ax1, 'Time (ms)', 'FontSize', 11, 'FontWeight', 'bold');
%         ylabel(ax1, 'Amplitude', 'FontSize', 11, 'FontWeight', 'bold');
%         title(ax1, sprintf('%s - Time Domain', stage_names_display{stage_idx}), ...
%               'FontSize', 12, 'FontWeight', 'bold');
%         xlim(ax1, [0, min(20, max(t_vec)*1e3)]);
%         set(ax1, 'FontSize', 10);
% 
%         % === Frequency Domain Plot ===
%         ax2 = subplot(2, 1, 2, 'Parent', tab);
%         nfft = 2^nextpow2(n_samples);
%         f_vec = (0:nfft-1) * (fs / nfft);
%         f_vec = f_vec(1:nfft/2);
% 
%         Y = fft(output_signal, nfft);
%         Y_mag = abs(Y(1:nfft/2)) / n_samples;
%         Y_mag(2:end) = 2 * Y_mag(2:end); % Single-sided spectrum
%         Y_db = 20*log10(Y_mag + 1e-12); % Convert to dB
% 
%         plot(ax2, f_vec / 1e6, Y_db, 'r-', 'LineWidth', 1.2);
%         grid(ax2, 'on');
%         xlabel(ax2, 'Frequency (MHz)', 'FontSize', 11, 'FontWeight', 'bold');
%         ylabel(ax2, 'Magnitude (dB)', 'FontSize', 11, 'FontWeight', 'bold');
%         title(ax2, sprintf('%s - Frequency Domain', stage_names_display{stage_idx}), ...
%               'FontSize', 12, 'FontWeight', 'bold');
%         ylim(ax2, [-120, max(Y_db) + 10]);
%         set(ax2, 'FontSize', 10);
% 
%         % Add signal info text
%         dim = [0.15 0.02 0.3 0.05];
%         str = sprintf('Fs = %.2f MHz  |  N = %d samples  |  Duration = %.2f ms', ...
%                      fs/1e6, n_samples, (n_samples-1)/fs*1e3);
%         annotation(tab, 'textbox', dim, 'String', str, ...
%                   'FitBoxToText', 'on', 'EdgeColor', 'none', ...
%                   'FontSize', 9, 'FontWeight', 'bold', ...
%                   'BackgroundColor', [0.95 0.95 0.95]);
%     end
% 
%     fprintf('  ✓ Created %d tabs for %s\n', length(stages), tc_name);
% end
% 
% fprintf('\n===== All Plots Generated Successfully! =====\n');

%% ======================= SECTION 7: Calculate SIR, SNR, and SNIR =======================
fprintf('\n===== SECTION 7: Calculating Signal Quality Metrics =====\n');

% Initialize results structure
metrics = struct();

% Helper function to calculate power in dB
calculate_power_db = @(signal) 10*log10(mean(signal.^2) + 1e-20);

% Helper function to calculate ratio in dB
calculate_ratio_db = @(signal_power, noise_power) signal_power - noise_power;

%% === Calculate SNR (Signal-to-Noise Ratio) ===
fprintf('\n--- Calculating SNR for Noise Test Cases ---\n');

buffer = 100;

for tc_idx = 1:length(noise_tcs)
    tc_name = noise_tcs{tc_idx};

    if ~isfield(signals.(tc_name), 'output') || ~isfield(signals.(tc_name), 'noise')
        continue;
    end

    fprintf('Processing %s for SNR...\n', tc_name);
    metrics.(tc_name).SNR = struct();

    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};

        if ~isfield(signals.(tc_name).output, stage_name) || ...
           ~isfield(signals.(tc_name).noise, stage_name)
            continue;
        end

        output_sig = signals.(tc_name).output.(stage_name);
        noise_sig = signals.(tc_name).noise.(stage_name);

        % Method 1: Using MATLAB's snr function (if clean signal available)
        if isfield(signals.(tc_name), 'clean') && ...
           isfield(signals.(tc_name).clean, stage_name)
            clean_sig = signals.(tc_name).clean.(stage_name);
            % SNR using MATLAB's built-in function
            snr_matlab = snr(output_sig(buffer : end), output_sig(buffer : end) - clean_sig(buffer : end));
            metrics.(tc_name).SNR.(stage_name).matlab = snr_matlab;
        end

        % Method 2: Calculate SNR from signal and noise components
        signal_power_db = calculate_power_db(output_sig(buffer : end));
        noise_power_db = calculate_power_db(noise_sig(buffer : end));
        snr_calculated = calculate_ratio_db(signal_power_db, noise_power_db);

        metrics.(tc_name).SNR.(stage_name).calculated = snr_calculated;
        metrics.(tc_name).SNR.(stage_name).signal_power_db = signal_power_db;
        metrics.(tc_name).SNR.(stage_name).noise_power_db = noise_power_db;

        fprintf('  %s: SNR = %.2f dB (Signal: %.2f dB, Noise: %.2f dB)\n', ...
                stage_name, snr_calculated, signal_power_db, noise_power_db);
    end
end

%% === Calculate SIR (Signal-to-Interference Ratio) ===
fprintf('\n--- Calculating SIR for Interference Test Cases ---\n');

for tc_idx = 1:length(interference_tcs)
    tc_name = interference_tcs{tc_idx};

    if ~isfield(signals.(tc_name), 'output') || ~isfield(signals.(tc_name), 'interference')
        continue;
    end

    fprintf('Processing %s for SIR...\n', tc_name);
    metrics.(tc_name).SIR = struct();

    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};

        if ~isfield(signals.(tc_name).output, stage_name) || ...
           ~isfield(signals.(tc_name).interference, stage_name)
            continue;
        end

        output_sig = signals.(tc_name).output.(stage_name);
        interference_sig = signals.(tc_name).interference.(stage_name);

        % Method 1: Using MATLAB's snr function (if clean signal available)
        if isfield(signals.(tc_name), 'clean') && ...
           isfield(signals.(tc_name).clean, stage_name)
            clean_sig = signals.(tc_name).clean.(stage_name);
            % SIR using MATLAB's built-in function (treating interference as noise)
            sir_matlab = snr(output_sig(buffer : end), output_sig(buffer : end) - clean_sig(buffer : end));
            metrics.(tc_name).SIR.(stage_name).matlab = sir_matlab;
        end

        % Method 2: Calculate SIR from signal and interference components
        signal_power_db = calculate_power_db(output_sig(buffer : end));
        interference_power_db = calculate_power_db(interference_sig(buffer : end));
        sir_calculated = calculate_ratio_db(signal_power_db, interference_power_db);

        metrics.(tc_name).SIR.(stage_name).calculated = sir_calculated;
        metrics.(tc_name).SIR.(stage_name).signal_power_db = signal_power_db;
        metrics.(tc_name).SIR.(stage_name).interference_power_db = interference_power_db;

        fprintf('  %s: SIR = %.2f dB (Signal: %.2f dB, Interference: %.2f dB)\n', ...
                stage_name, sir_calculated, signal_power_db, interference_power_db);
    end
end

%% === Calculate SNIR (Signal-to-Noise-and-Interference Ratio) ===
fprintf('\n--- Calculating SNIR for Combined Test Cases ---\n');

% Test cases with both noise and interference
combined_tcs = {'TC_5', 'TC_6', 'TC_11', 'TC_12'};

for tc_idx = 1:length(combined_tcs)
    tc_name = combined_tcs{tc_idx};

    if ~isfield(signals, tc_name) || ...
       ~isfield(signals.(tc_name), 'output') || ...
       ~isfield(signals.(tc_name), 'noise') || ...
       ~isfield(signals.(tc_name), 'interference')
        continue;
    end

    fprintf('Processing %s for SNIR...\n', tc_name);
    metrics.(tc_name).SNIR = struct();

    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};

        if ~isfield(signals.(tc_name).output, stage_name) || ...
           ~isfield(signals.(tc_name).noise, stage_name) || ...
           ~isfield(signals.(tc_name).interference, stage_name)
            continue;
        end

        output_sig = signals.(tc_name).output.(stage_name);
        noise_sig = signals.(tc_name).noise.(stage_name);
        interference_sig = signals.(tc_name).interference.(stage_name);

        % Method 1: Using MATLAB's snr function (if clean signal available)
        if isfield(signals.(tc_name), 'clean') && ...
           isfield(signals.(tc_name).clean, stage_name)
            clean_sig = signals.(tc_name).clean.(stage_name);
            % SNIR using MATLAB's built-in function
            snir_matlab = snr(output_sig(buffer : end), output_sig(buffer : end) - clean_sig(buffer : end));
            metrics.(tc_name).SNIR.(stage_name).matlab = snir_matlab;
        end

        % Method 2: Calculate SNIR from signal, noise, and interference components
        signal_power_db = calculate_power_db(output_sig(buffer : end));
        noise_power_db = calculate_power_db(noise_sig(buffer : end));
        interference_power_db = calculate_power_db(interference_sig(buffer : end));

        % Combined noise+interference power (linear domain addition)
        noise_power_linear = 10^(noise_power_db/10);
        interference_power_linear = 10^(interference_power_db/10);
        combined_power_linear = noise_power_linear + interference_power_linear;
        combined_power_db = 10*log10(combined_power_linear);

        snir_calculated = calculate_ratio_db(signal_power_db, combined_power_db);

        metrics.(tc_name).SNIR.(stage_name).calculated = snir_calculated;
        metrics.(tc_name).SNIR.(stage_name).signal_power_db = signal_power_db;
        metrics.(tc_name).SNIR.(stage_name).noise_power_db = noise_power_db;
        metrics.(tc_name).SNIR.(stage_name).interference_power_db = interference_power_db;
        metrics.(tc_name).SNIR.(stage_name).combined_power_db = combined_power_db;

        fprintf('  %s: SNIR = %.2f dB (Signal: %.2f dB, N+I: %.2f dB)\n', ...
                stage_name, snir_calculated, signal_power_db, combined_power_db);
        fprintf('         (Noise: %.2f dB, Interference: %.2f dB)\n', ...
                noise_power_db, interference_power_db);
    end
end

%% === Summary Tables ===
fprintf('\n===== METRIC SUMMARY =====\n');

% Create summary table for each metric type
fprintf('\n--- SNR Summary (dB) ---\n');
fprintf('%-10s', 'Test Case');
for stage_idx = 1:length(stages)
    fprintf(' | %-12s', stages{stage_idx});
end
fprintf('\n');
fprintf(repmat('-', 1, 10 + length(stages)*15));
fprintf('\n');

for tc_idx = 1:length(noise_tcs)
    tc_name = noise_tcs{tc_idx};
    if ~isfield(metrics, tc_name) || ~isfield(metrics.(tc_name), 'SNR')
        continue;
    end
    fprintf('%-10s', tc_name);
    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};
        if isfield(metrics.(tc_name).SNR, stage_name)
            fprintf(' | %12.2f', metrics.(tc_name).SNR.(stage_name).calculated);
        else
            fprintf(' | %12s', 'N/A');
        end
    end
    fprintf('\n');
end

fprintf('\n--- SIR Summary (dB) ---\n');
fprintf('%-10s', 'Test Case');
for stage_idx = 1:length(stages)
    fprintf(' | %-12s', stages{stage_idx});
end
fprintf('\n');
fprintf(repmat('-', 1, 10 + length(stages)*15));
fprintf('\n');

for tc_idx = 1:length(interference_tcs)
    tc_name = interference_tcs{tc_idx};
    if ~isfield(metrics, tc_name) || ~isfield(metrics.(tc_name), 'SIR')
        continue;
    end
    fprintf('%-10s', tc_name);
    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};
        if isfield(metrics.(tc_name).SIR, stage_name)
            fprintf(' | %12.2f', metrics.(tc_name).SIR.(stage_name).calculated);
        else
            fprintf(' | %12s', 'N/A');
        end
    end
    fprintf('\n');
end

fprintf('\n--- SNIR Summary (dB) ---\n');
fprintf('%-10s', 'Test Case');
for stage_idx = 1:length(stages)
    fprintf(' | %-12s', stages{stage_idx});
end
fprintf('\n');
fprintf(repmat('-', 1, 10 + length(stages)*15));
fprintf('\n');

for tc_idx = 1:length(combined_tcs)
    tc_name = combined_tcs{tc_idx};
    if ~isfield(metrics, tc_name) || ~isfield(metrics.(tc_name), 'SNIR')
        continue;
    end
    fprintf('%-10s', tc_name);
    for stage_idx = 1:length(stages)
        stage_name = stages{stage_idx};
        if isfield(metrics.(tc_name).SNIR, stage_name)
            fprintf(' | %12.2f', metrics.(tc_name).SNIR.(stage_name).calculated);
        else
            fprintf(' | %12s', 'N/A');
        end
    end
    fprintf('\n');
end

fprintf('\n===== Metric Calculations Complete! =====\n');
fprintf('\nAccess metrics via: metrics.TC_X.{SNR, SIR, SNIR}.{stage_name}\n');
fprintf('Example: metrics.TC_4.SNR.cic_decf2.calculated\n');

