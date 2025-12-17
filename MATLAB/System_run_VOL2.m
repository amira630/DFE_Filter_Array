clear
clc

% Read binary configuration from file
config = readBinaryConfig('cfg.txt');

% Floating vs Fixed Point
fi_vs_float_var = config(1);

% Extract values from binary configuration
% CIC Configuration (bits 5-9 as 5-bit value)
cic_decf_binary = config(5:9);
cic_decf = binaryVectorToDecimal(cic_decf_binary);

% Define 16 test cases with different input characteristics
% Each test case has: frequency, amplitude, signal_shape
max_amplitude = 0.999969482421875; % Max amplitude for 16-bit signed fixed point

test_cases = {
    % TC_1 to TC_16: Different combinations of parameters
    struct('freq', 1e5, 'amp', 0.25         , 'shape', 'sine', 'inter', 0, 'tones', 0, 'noise', 0);     % TC_1
    struct('freq', 1e5, 'amp', 0.25         , 'shape', 'sine', 'inter', 1, 'tones', 0, 'noise', 0);     % TC_2
    struct('freq', 1e5, 'amp', 0.25         , 'shape', 'sine', 'inter', 1, 'tones', 1, 'noise', 0);     % TC_3
    struct('freq', 1e5, 'amp', 0.25         , 'shape', 'sine', 'inter', 0, 'tones', 0, 'noise', 1);     % TC_4
    struct('freq', 1e5, 'amp', 0.25         , 'shape', 'sine', 'inter', 1, 'tones', 0, 'noise', 1);     % TC_5
    struct('freq', 1e5, 'amp', 0.25         , 'shape', 'sine', 'inter', 1, 'tones', 1, 'noise', 1);     % TC_6
    struct('freq', 1e5, 'amp', max_amplitude, 'shape', 'sine', 'inter', 0, 'tones', 0, 'noise', 0);     % TC_7
    struct('freq', 1e5, 'amp', max_amplitude, 'shape', 'sine', 'inter', 1, 'tones', 0, 'noise', 0);     % TC_8
    struct('freq', 1e5, 'amp', max_amplitude, 'shape', 'sine', 'inter', 1, 'tones', 1, 'noise', 0);     % TC_9
    struct('freq', 1e5, 'amp', max_amplitude, 'shape', 'sine', 'inter', 0, 'tones', 0, 'noise', 1);     % TC_10
    struct('freq', 1e5, 'amp', max_amplitude, 'shape', 'sine', 'inter', 1, 'tones', 0, 'noise', 1);     % TC_11
    struct('freq', 1e5, 'amp', max_amplitude, 'shape', 'sine', 'inter', 1, 'tones', 1, 'noise', 1);     % TC_12
    struct('freq', 5e4, 'amp', 0.25         , 'shape', 'sine', 'inter', 1, 'tones', 0, 'noise', 1);     % TC_13
    struct('freq', 2e5, 'amp', 0.25         , 'shape', 'sine', 'inter', 1, 'tones', 0, 'noise', 1);     % TC_14
    struct('freq', 5e4, 'amp', max_amplitude, 'shape', 'sine', 'inter', 1, 'tones', 0, 'noise', 0);     % TC_15
    struct('freq', 2e5, 'amp', max_amplitude, 'shape', 'sine', 'inter', 1, 'tones', 0, 'noise', 0);     % TC_16
};

num_test_cases = length(test_cases);

% Display configuration
fprintf('Binary Configuration:\n');
fprintf('Raw bits: ');
fprintf('%d', config);
fprintf('\n\n');

fprintf('Parsed Configuration:\n');
fprintf('CIC decf (binary %s) = %d\n\n', ...
        num2str(cic_decf_binary), cic_decf);

% Sampling parameters
Fs = 9e6;
N  = 48000;      
t = (0 : N - 1)' / Fs;

% Interference parameters (constant for all test cases)
f_intf_2_4 = 2.4e6;
f_intf_5 = 5e6;

A_intf_2_4 = 0.2;
A_intf_5 = 0.2;

intf1 = (A_intf_2_4 * sin(2 * pi * f_intf_2_4 * t));
intf2 = (A_intf_5 * sin(2 * pi * f_intf_5 * t));
interference = intf1 + intf2;

% Tones
f_tone_1 = 2.8e6;
f_tone_2 = 3e6;
f_tone_3 = 3.2e6;
f_tone_4 = 4e6;
f_tone_5 = 4.5e6;

A_tones = 0.2;

tone_1 = A_tones * sin(2 * pi * f_tone_1 * t);
tone_2 = A_tones * sin(2 * pi * f_tone_2 * t);
tone_3 = A_tones * sin(2 * pi * f_tone_3 * t);
tone_4 = A_tones * sin(2 * pi * f_tone_4 * t);
tone_5 = A_tones * sin(2 * pi * f_tone_5 * t);

tones = tone_1 + tone_2 + tone_3 + tone_4 + tone_5;

% Wide-Band Noise parameters
% High quality (40-50 dB SNR): noise_variance = 1e-6 to 1e-5
% Medium quality (30-40 dB SNR): noise_variance = 1e-5 to 1e-4
% Low quality (20-30 dB SNR): noise_variance = 1e-4 to 1e-3
noise_variance = 1e-5; % Adjust based on desired SNR

% Generate all bypass combinations

% Based on your description, we have 4 stages that can be bypassed:
% 1. Fractional Decimator
% 2. IIR 2.4 MHz
% 3. IIR 5 MHz
% 4. CIC

% Create all possible bypass combinations (2^4 = 16 combinations)
bypass_combinations = dec2bin(0:15, 4) - '0'; % Convert to binary matrix
num_combinations = size(bypass_combinations, 1);

fprintf('Generating %d Test Cases, each with %d bypass scenarios...\n\n', num_test_cases, num_combinations);

if (fi_vs_float_var == 0)
    fprintf('Processing mode: Fixed Point\n\n');

    % Loop through each test case
    for tc_idx = 1:num_test_cases
        % Get current test case parameters
        tc = test_cases{tc_idx};
        f_sig = tc.freq;
        amplitude = tc.amp;
        signal_shape = tc.shape;
        add_interference = tc.inter;
        add_tones = tc.tones;
        add_noise = tc.noise;

        % Create test case directory
        tc_dir = sprintf('TC_%d', tc_idx);
        if ~exist(tc_dir, 'dir')
            mkdir(tc_dir);
        end

        fprintf('========================================\n');
        fprintf('Processing Test Case %d/%d: %s\n', tc_idx, num_test_cases, tc_dir);
        fprintf('  Signal parameters - Freq: %.2f kHz, Amp: %.3f, Shape: %s\n', ...
                f_sig/1000, amplitude, signal_shape);
        fprintf('========================================\n\n');

        % Generate clean signal based on test case parameters
        switch signal_shape
            case 'sine'
                x_real_clean = amplitude * sin(2 * pi * f_sig * t);
            case 'square'
                x_real_clean = amplitude * square(2 * pi * f_sig * t);
            case 'triangular'
                x_real_clean = amplitude * sawtooth(2 * pi * f_sig * t, 0.5);
        end

        x_real_noisy = x_real_clean;

        % Add interference (same for all test cases)
        if (add_interference == 1)
            fprintf('  Adding interference signals (2.4 MHz and 5 MHz)...\n');
            x_real_noisy = x_real_noisy + interference;
        end

        % Add tones
        if (add_tones == 1)
            fprintf('  Adding tone signals (2.8 MHz, 3 MHz, 3.2 MHz, 4 MHz, 4.5 MHz)...\n');
            x_real_noisy = x_real_noisy + tones;
        end

        % Add wide-band noise (generate unique noise for each test case)
        if (add_noise == 1)
            fprintf('  Adding wide-band noise (variance = %.1e)...\n', noise_variance);
            noise = sqrt(noise_variance) * randn(N, 1); % White Gaussian noise
            x_real_noisy = x_real_noisy + noise;
        end

        x_quantized_noisy = fi(x_real_noisy, 1, 16, 15);


        % Process each bypass combination for this test case
        for combo_idx = 1:num_combinations
            % Extract bypass flags for this combination
            bypass_frac_dec = bypass_combinations(combo_idx, 1);
            bypass_iir_24   = bypass_combinations(combo_idx, 2);
            bypass_iir_5    = bypass_combinations(combo_idx, 3);
            bypass_cic      = bypass_combinations(combo_idx, 4);

            % Create directory name for this scenario inside test case folder
            scenario_dir = fullfile(tc_dir, sprintf('scenario_frac%d_iir24%d_iir5%d_cic%d', ...
                                bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic));

            % Create directory if it doesn't exist
            if ~exist(scenario_dir, 'dir')
                mkdir(scenario_dir);
            end

            fprintf('  Processing scenario %d/%d: scenario_frac%d_iir24%d_iir5%d_cic%d\n', ...
                    combo_idx, num_combinations, bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic);
            fprintf('    Bypass flags - frac_dec:%d, iir_24:%d, iir_5:%d, cic:%d\n', ...
                    bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic);

            % Processing chain with current bypass options
            current_signal = x_quantized_noisy;

            % Write Stage 0: Input signal (after quantization)
            writeFixedPointBinary(current_signal, fullfile(scenario_dir, 'input.txt'), 16, 15);

            % Stage 1: Fractional Decimator
            if bypass_frac_dec == 0
                fprintf('    Applying Fractional Decimator...\n');
                Hd_Fractional_Decimator = Fractional_Decimator();
                current_signal = step(Hd_Fractional_Decimator, current_signal);

                % Write Stage 1: After fractional decimator
                writeFixedPointBinary(current_signal, fullfile(scenario_dir, 'frac_decimator.txt'), 16, 15);
            else
                fprintf('    Bypassing Fractional Decimator\n');
                copyfile(fullfile(scenario_dir, 'input.txt'), ...
                        fullfile(scenario_dir, 'frac_decimator.txt'));
            end

            % Stage 2: IIR 2.4MHz Notch Filter
            if bypass_iir_24 == 0
                fprintf('    Applying IIR 2.4MHz Notch Filter...\n');
                Hd_IIR_2_4 = IIR_2_4();
                current_signal = filter(Hd_IIR_2_4, current_signal);

                % Write Stage 2: After IIR 2.4MHz filter
                writeFixedPointBinary(current_signal, fullfile(scenario_dir, 'iir_24mhz.txt'), 16, 15);
            else
                fprintf('    Bypassing IIR 2.4MHz Notch Filter\n');
                copyfile(fullfile(scenario_dir, 'frac_decimator.txt'), ...
                        fullfile(scenario_dir, 'iir_24mhz.txt'));
            end

            % Stage 3: IIR 5MHz Notch Filter (both IIR_1 and IIR_2)
            if bypass_iir_5 == 0
                fprintf('    Applying IIR 5MHz Notch Filter...\n');
                Hd_IIR_1 = IIR_1();
                current_signal = filter(Hd_IIR_1, current_signal);

                % Write Stage 3.1: After first IIR 5MHz filter
                writeFixedPointBinary(current_signal, fullfile(scenario_dir, 'iir_5mhz_1.txt'), 16, 15);
            else
                fprintf('    Bypassing IIR 5MHz Notch Filter\n');
                copyfile(fullfile(scenario_dir, 'iir_24mhz.txt'), ...
                         fullfile(scenario_dir, 'iir_5mhz_1.txt'));
            end

            % Stage 4: CIC Filter
            if bypass_cic == 0
                fprintf('    Applying CIC Filter with decimation factor %d...\n', cic_decf);
                Hd_cic = CIC(cic_decf);
                current_signal = step(Hd_cic, current_signal);

                % Write Stage 4: After CIC filter
                writeFixedPointBinary(current_signal, fullfile(scenario_dir, 'cic.txt'), 16, 15);
            else
                fprintf('    Bypassing CIC Filter\n');
                copyfile(fullfile(scenario_dir, 'iir_5mhz_1.txt'), ...
                        fullfile(scenario_dir, 'cic.txt'));
            end

            % Final output
            output = current_signal;
            writeFixedPointBinary(output, fullfile(scenario_dir, 'output.txt'), 16, 15);

            fprintf('    Scenario complete!\n\n');
        end

        fprintf('Test Case %s complete!\n\n', tc_dir);
    end

else
    fprintf('Processing mode: Floating Point\n\n');

    % Loop through each test case
    for tc_idx = 1:num_test_cases
        % Get current test case parameters
        tc = test_cases{tc_idx};
        f_sig = tc.freq;
        amplitude = tc.amp;
        signal_shape = tc.shape;
        add_interference = tc.inter;
        add_tones = tc.tones;
        add_noise = tc.noise;

        % Create test case directory
        tc_dir = sprintf('TC_%d', tc_idx);
        if ~exist(tc_dir, 'dir')
            mkdir(tc_dir);
        end

        fprintf('========================================\n');
        fprintf('Processing Test Case %d/%d: %s\n', tc_idx, num_test_cases, tc_dir);
        fprintf('  Signal parameters - Freq: %.2f kHz, Amp: %.3f, Shape: %s\n', ...
                f_sig/1000, amplitude, signal_shape);
        fprintf('========================================\n\n');

        % Generate clean signal based on test case parameters
        switch signal_shape
            case 'sine'
                x_real_clean = amplitude * sin(2 * pi * f_sig * t);
            case 'square'
                x_real_clean = amplitude * square(2 * pi * f_sig * t);
            case 'triangular'
                x_real_clean = amplitude * sawtooth(2 * pi * f_sig * t, 0.5);
        end

        x_real_noisy = x_real_clean;

        % Add interference (same for all test cases)
        if (add_interference == 1)
            fprintf('  Adding interference signals (2.4 MHz and 5 MHz)...\n');
            x_real_noisy = x_real_noisy + interference;
        end

        % Add tones
        if (add_tones == 1)
            fprintf('  Adding tone signals (2.8 MHz, 3 MHz, 3.2 MHz, 4 MHz, 4.5 MHz)...\n');
            x_real_noisy = x_real_noisy + tones;
        end

        % Add wide-band noise (generate unique noise for each test case)
        if (add_noise == 1)
            fprintf('  Adding wide-band noise (variance = %.1e)...\n', noise_variance);
            noise = sqrt(noise_variance) * randn(N, 1); % White Gaussian noise
            x_real_noisy = x_real_noisy + noise;
        end

        x_quantized_noisy = fi(x_real_noisy, 1, 16, 15);

        % Process each bypass combination for this test case
        for combo_idx = 1:num_combinations
            % Extract bypass flags for this combination
            bypass_frac_dec = bypass_combinations(combo_idx, 1);
            bypass_iir_24   = bypass_combinations(combo_idx, 2);
            bypass_iir_5    = bypass_combinations(combo_idx, 3);
            bypass_cic      = bypass_combinations(combo_idx, 4);

            % Create directory name for this scenario inside test case folder
            scenario_dir = fullfile(tc_dir, sprintf('scenario_frac%d_iir24%d_iir5%d_cic%d', ...
                                bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic));

            % Create directory if it doesn't exist
            if ~exist(scenario_dir, 'dir')
                mkdir(scenario_dir);
            end

            fprintf('  Processing scenario %d/%d: scenario_frac%d_iir24%d_iir5%d_cic%d\n', ...
                    combo_idx, num_combinations, bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic);
            fprintf('    Bypass flags - frac_dec:%d, iir_24:%d, iir_5:%d, cic:%d\n', ...
                    bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic);

            % Processing chain with current bypass options
            current_signal = x_quantized_noisy;

            % Write Stage 0: Input signal (after quantization)
            writeFixedPointBinary(current_signal, fullfile(scenario_dir, 'input.txt'), 16, 15);

            current_signal = x_real_noisy;

            % Stage 1: Fractional Decimator
            if bypass_frac_dec == 0
                fprintf('    Applying Fractional Decimator...\n');
                Hd_Fractional_Decimator_float = Fractional_Decimator_float();
                current_signal = step(Hd_Fractional_Decimator_float, current_signal);

                % Write Stage 1: After fractional decimator
                writeFloatingDouble(current_signal, fullfile(scenario_dir, 'frac_decimator.txt'));
            else
                fprintf('    Bypassing Fractional Decimator\n');
                copyfile(fullfile(scenario_dir, 'input.txt'), ...
                        fullfile(scenario_dir, 'frac_decimator.txt'));
            end

            % Stage 2: IIR 2.4MHz Notch Filter
            if bypass_iir_24 == 0
                fprintf('    Applying IIR 2.4MHz Notch Filter...\n');
                Hd_IIR_2_4_float = IIR_2_4_float();
                current_signal = filter(Hd_IIR_2_4_float, current_signal);

                % Write Stage 2: After IIR 2.4MHz filter
                writeFloatingDouble(current_signal, fullfile(scenario_dir, 'iir_24mhz.txt'));
            else
                fprintf('    Bypassing IIR 2.4MHz Notch Filter\n');
                copyfile(fullfile(scenario_dir, 'frac_decimator.txt'), ...
                        fullfile(scenario_dir, 'iir_24mhz.txt'));
            end

            % Stage 3: IIR 5MHz Notch Filter (both IIR_1 and IIR_2)
            if bypass_iir_5 == 0
                fprintf('    Applying IIR 5MHz Notch Filter...\n');
                Hd_IIR_1_float = IIR_1_float();

                current_signal = filter(Hd_IIR_1_float, current_signal);

                % Write Stage 3.1: After first IIR 5MHz filter
                writeFloatingDouble(current_signal, fullfile(scenario_dir, 'iir_5mhz_1.txt'));
            else
                fprintf('    Bypassing IIR 5MHz Notch Filter\n');
                copyfile(fullfile(scenario_dir, 'iir_24mhz.txt'), ...
                         fullfile(scenario_dir, 'iir_5mhz_1.txt'));
            end

            % Stage 4: CIC Filter
            if bypass_cic == 0
                fprintf('    Applying CIC Filter with decimation factor %d...\n', cic_decf);
                Hd_cic_float = CIC_float(cic_decf);
                current_signal = step(Hd_cic_float, current_signal);

                % Write Stage 4: After CIC filter
                writeFloatingDouble(current_signal, fullfile(scenario_dir, 'cic.txt'));
            else
                fprintf('    Bypassing CIC Filter\n');
                copyfile(fullfile(scenario_dir, 'iir_5mhz_1.txt'), ...
                        fullfile(scenario_dir, 'cic.txt'));
            end

            % Final output
            output = current_signal;
            writeFloatingDouble(output, fullfile(scenario_dir, 'output.txt'));

            fprintf('    Scenario complete!\n\n');
        end

        fprintf('Test Case %s complete!\n\n', tc_dir);
    end
end

fprintf('========================================\n');
fprintf('All %d Test Cases with %d bypass scenarios each processed successfully!\n', num_test_cases, num_combinations);
fprintf('Total scenarios: %d\n', num_test_cases * num_combinations);
fprintf('========================================\n\n');
fprintf('Output Structure:\n');
for tc_idx = 1:num_test_cases
    fprintf('TC_%d/\n', tc_idx);
    for combo_idx = 1:num_combinations
        bypass_frac_dec = bypass_combinations(combo_idx, 1);
        bypass_iir_24   = bypass_combinations(combo_idx, 2);
        bypass_iir_5    = bypass_combinations(combo_idx, 3);
        bypass_cic      = bypass_combinations(combo_idx, 4);

        scenario_dir = sprintf('scenario_frac%d_iir24%d_iir5%d_cic%d', ...
                              bypass_frac_dec, bypass_iir_24, bypass_iir_5, bypass_cic);

        fprintf('  %s/\n', scenario_dir);
    end
    fprintf('\n');
end