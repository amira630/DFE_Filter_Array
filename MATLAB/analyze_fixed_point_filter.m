function analyze_fixed_point_filter(Hd, fs, input_signal, rate_change, rate_converter, figName)
    % Quick analysis for fixed-point filter objects
    % Hd: Filter object
    % fs: Input sampling frequency
    % input_signal: Input signal
    % rate_change: (optional) Rate change factor for decimators/interpolators
    %              e.g., 0.5 for decimation by 2, 2 for interpolation by 2
    
    if nargin < 4
        rate_change = 1; % No rate change by default
    end

    if nargin < 5
        rate_converter = 0; % No rate change by default
    end

    if nargin < 6
        figName = 'NAN'; % No rate change by default
    end
    
    % 1. Basic info
    fprintf('Filter Type: %s\n', class(Hd));
    try
        fprintf('Filter Order: %d', order(Hd));
    catch
        fprintf('Filter Order: N/A');
    end
    
    if rate_converter == 1
        fprintf('Rate Change Factor: %.4f\n', rate_change);
        fprintf('Input Fs: %.2f Hz\n', fs);
        fprintf('Output Fs: %.2f Hz', fs * rate_change);
    end
    
    % 2. Apply filter - use step for rate converters
    
    if rate_converter == 1
        try
            output = step(Hd, input_signal);
        catch
            try
                output = filter(Hd, input_signal);
            catch
                warning('Filter operation failed, using input as output');
                output = double(input_signal);
            end
        end
    else
        try
            output = filter(Hd, double(input_signal));
        catch
            warning('Filter operation failed, using input as output');
            output = double(input_signal);
        end
    end
    
    % Calculate output sampling frequency
    % Auto-detect rate change if not specified or verify if specified
    actual_rate_change = length(output) / length(input_signal);
    
    if nargin < 4 || rate_change == 1
        % Auto-detect from actual output length
        rate_change = actual_rate_change;
        if abs(rate_change - 1) > 0.01
            fprintf('Auto-detected rate change: %.4f\n', rate_change);
        end
    else
        % Verify specified rate matches actual
        if abs(actual_rate_change - rate_change) > 0.01
            warning('Specified rate change (%.4f) differs from actual (%.4f). Using actual.', ...
                rate_change, actual_rate_change);
            rate_change = actual_rate_change;
        end
    end
    
    fs_out = fs * rate_change;
    
    % Print signal level diagnostics
    fprintf('\nSignal Levels:\n');
    fprintf('Input range: [%.6f, %.6f], RMS: %.6f\n', ...
        min(double(input_signal)), max(double(input_signal)), rms(double(input_signal)));
    fprintf('Output range: [%.6f, %.6f], RMS: %.6f\n', ...
        min(output), max(output), rms(output));
    fprintf('Output length: %d samples (Input: %d)\n', length(output), length(input_signal));
    
    % 3. Create plots
    figure('Name', figName);
    
    % Frequency response
    subplot(2,2,1);
    try
        [h, f] = freqz(Hd, 2048, fs);
        plot(f, 20*log10(abs(h)));
        xlabel('Frequency (Hz)'); 
        ylabel('Magnitude (dB)');
        grid on;
        title('Frequency Response');
    catch
        text(0.5, 0.5, 'Frequency response not available', ...
            'HorizontalAlignment', 'center');
        title('Frequency Response (N/A)');
    end
    
    % Time domain comparison
    subplot(2,2,2);
    % Plot against actual time, not sample index
    n_samples = min(500, length(input_signal));
    t_in = (0:n_samples-1) / fs;
    
    n_samples_out = min(floor(n_samples * rate_change), length(output));
    t_out = (0:n_samples_out-1) / fs_out;
    
    plot(t_in, input_signal(1:n_samples), 'b'); 
    hold on;
    plot(t_out, output(1:n_samples_out), 'r');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('Input', 'Filtered');
    title('Time Domain');
    grid on;
    
    % Spectrum comparison
    subplot(2,2,3);
    try
        % Plot input and output spectra with correct sampling frequencies
        [pxx_in, f_in] = pwelch(double(input_signal), [], [], [], fs);
        [pxx_out, f_out] = pwelch(double(output), [], [], [], fs_out);
        plot(f_in, 10*log10(pxx_in), 'b', 'LineWidth', 1.5); 
        hold on;
        plot(f_out, 10*log10(pxx_out), 'r', 'LineWidth', 1.5);
        xlabel('Frequency (Hz)');
        ylabel('Power/Frequency (dB/Hz)');
        legend('Input', 'Output');
        grid on;
        title('Power Spectral Density');
        
        % Add Nyquist frequency markers
        if rate_change ~= 1
            xline(fs/2, 'b--', 'Input Nyquist', 'LabelHorizontalAlignment', 'left');
            xline(fs_out/2, 'r--', 'Output Nyquist', 'LabelHorizontalAlignment', 'left');
        end
    catch
        text(0.5, 0.5, 'Spectrum not available', ...
            'HorizontalAlignment', 'center');
        title('Spectrum (N/A)');
    end
    
    % Impulse response
    subplot(2,2,4);
    try
        impz(Hd, 50);
        title('Impulse Response');
    catch
        text(0.5, 0.5, 'Impulse response not available', ...
            'HorizontalAlignment', 'center');
        title('Impulse Response (N/A)');
    end

    fprintf ('\n-------------------------------------------------------\n\n')
end
