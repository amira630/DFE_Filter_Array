%% CIC Decimator Test with s16.15 Fixed-Point Input (Full Output)
clc; clear; close all;

% Parameters
R = 1;                % Decimation factor
M = 1;                % Differential delay
N = 1;                % Number of stages
Fs = 6e6;             % Input sampling frequency
numSamples = 64;      % Use 64 samples so full output is readable

%% Generate s16.15 fixed-point random input
x = randn(numSamples, 1) * 0.5;   % scaled to avoid overflow
x_fixed = fi(x, 1, 16, 15, 'RoundingMethod', 'Floor', 'OverflowAction', 'Wrap'); % s16.15 fixed point

disp('--- Input samples (s16.15 format, full list) ---');
for i = 1:numSamples
    %fprintf('x_fixed(%02d) = %+.6f   (hex: %s)\n', i, double(x_fixed(i)), hex(x_fixed(i)));
    fprintf('%s\n', hex(x_fixed(i)));
end

%% Create CIC Decimator
cicDecim = dsp.CICDecimator(R, M, N);
% % cic.FixedPointDataType = 'Custom';
% % cic.OutputWordLength = 16;
% % cic.OutputFractionLength = 15;

%% Apply CIC Decimator
y_fixed = cicDecim(x_fixed);

%% Gain compensation
G = (R * M)^N;          % CIC gain
y_comp = double(y_fixed) / G;   % scale down by gain
y_fixed_comp = fi(y_comp, 1, 16, 15);  % back to s16.15 fixed-point

disp(' ');
disp('--- Output samples (s16.15 format, full list) ---');
for i = 1:length(y_fixed)
    %fprintf('y_fixed(%02d) = %+.6f   (hex: %s)\n', i, double(y_fixed_comp(i)), hex(y_fixed_comp(i)));
    fprintf('%s\n', hex(y_fixed_comp(i)));
end

%% Time-domain plots
t_in = (0:numSamples-1) / Fs;
t_out = (0:length(y_fixed)-1) / (Fs/R);

figure('Name', 'Time Domain');
subplot(2,1,1);
plot(t_in*1e6, double(x_fixed), 'b');
title('Input Signal (Time Domain)');
xlabel('Time (\mus)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(t_out*1e6, double(y_fixed), 'r');
title(sprintf('Output Signal (Time Domain) (Decimated by %d)', R));
xlabel('Time (\mus)');
ylabel('Amplitude');
grid on;

%% Frequency-domain plots
Nfft = 1024;
Xf = fftshift(20*log10(abs(fft(double(x_fixed), Nfft))));
Yf = fftshift(20*log10(abs(fft(double(y_fixed), Nfft))));
f_in = linspace(-Fs/2, Fs/2, Nfft);
f_out = linspace(-Fs/(2*R), Fs/(2*R), Nfft);

figure('Name', 'Frequency Domain');
subplot(2,1,1);
plot(f_in/1e6, Xf);
title('Input Spectrum');
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
grid on;

subplot(2,1,2);
plot(f_out/1e6, Yf);
title(sprintf('Output Spectrum (After CIC, R=%d)', R));
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
grid on;
