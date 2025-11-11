%% Cascaded Notch Filters with Valid Frequencies
clc; clear; close all;

Fs = 6e6;              % Sampling frequency
f_notch1 = 2.4e6;      % First interferer
f_notch2 = 1.0e6;      % Aliased version of 5 MHz (5 -> 1 MHz after folding)
BW = 100e3;           % 100 kHz bandwidth

% Create dsp.NotchPeakFilter objects
np1 = dsp.NotchPeakFilter( ...
    'CenterFrequency', f_notch1, ...
    'Bandwidth', BW, ...
    'SampleRate', Fs);

np2 = dsp.NotchPeakFilter( ...
    'CenterFrequency', f_notch2, ...
    'Bandwidth', BW, ...
    'SampleRate', Fs);

% Test signal: tones + noise
t = (0:1/Fs:1e-3).';
x = sin(2*pi*f_notch1*t) + sin(2*pi*5.0e6*t) + 0.3*sin(2*pi*0.8e6*t);

% Filter cascaded
y1 = np1(x);
y2 = np2(y1);

% Frequency response visualization
%% Plot cascaded filter frequency response
% Get individual transfer functions
[b1, a1] = tf(np1);
[b2, a2] = tf(np2);

% Cascade = convolution of numerator & denominator coefficients
b_casc = conv(b1, b2);
a_casc = conv(a1, a2);

% Display combined response
fvtool(b_casc, a_casc, 'Fs', Fs);

%% Plot input vs. filtered signal (time domain)
figure;
subplot(2,1,1);
plot(t*1e3, x);
title('Input Signal (with 2.4 MHz and 5 MHz Interference)');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;
xlim([0 0.2]);  % zoom in for readability

subplot(2,1,2);
plot(t*1e3, y2);
title('Filtered Output Signal (After Two Notches)');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;
xlim([0 0.2]);

%% Plot spectra to verify notch removal
nfft = 2^16;
f = (-nfft/2:nfft/2-1)*(Fs/nfft);
X = fftshift(fft(x, nfft));
Y = fftshift(fft(y2, nfft));

figure;
plot(f/1e6, 20*log10(abs(X)/max(abs(X))), 'DisplayName', 'Input'); hold on;
plot(f/1e6, 20*log10(abs(Y)/max(abs(X))), 'DisplayName', 'Output');
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB, normalized)');
title('Spectrum Before and After Cascaded Notch Filters');
legend;
grid on;
xlim([0 3]);  % baseband (0–3 MHz)
ylim([-80 5]);

%% Function to convert floating-point coefficients to s16.15 hex
function hexArray = float2s16_15hex(coeff)
    coeff_fixed = round(coeff * 2^15);  % scale to S16.15
    % Handle negative numbers for two's complement
    coeff_fixed(coeff_fixed < 0) = coeff_fixed(coeff_fixed < 0) + 2^16;
    hexArray = dec2hex(coeff_fixed,4);  % 4-digit hex for 16-bit
end

%% Convert b and a coefficients for both notch filters
b1_hex = float2s16_15hex(b1);
a1_hex = float2s16_15hex(a1);

b2_hex = float2s16_15hex(b2);
a2_hex = float2s16_15hex(a2);

%% Display results
disp('Notch 1 numerator coefficients (b1) in s16.15 hex:');
disp(b1_hex);
disp('Notch 1 denominator coefficients (a1) in s16.15 hex:');
disp(a1_hex);

disp('Notch 2 numerator coefficients (b2) in s16.15 hex:');
disp(b2_hex);
disp('Notch 2 denominator coefficients (a2) in s16.15 hex:');
disp(a2_hex);

%% Optional: cascaded coefficients in s16.15 hex
b_casc_hex = float2s16_15hex(b_casc);
a_casc_hex = float2s16_15hex(a_casc);

disp('Cascaded numerator coefficients (b_casc) in s16.15 hex:');
disp(b_casc_hex);
disp('Cascaded denominator coefficients (a_casc) in s16.15 hex:');
disp(a_casc_hex);