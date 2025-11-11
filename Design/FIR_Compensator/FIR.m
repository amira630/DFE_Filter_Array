%% FIR-Only Verification using CIC Compensation FIR Coefficients
clc; clear; close all;

%% --- Parameters ---
R = 2;       % Decimation factor used in CIC design
M = 1;        % CIC differential delay
N = 1;        % CIC order
Fs = 6e6;     % Input sample rate
numSamples = 128;  % Number of input samples

% Choose num for pass/stop band calculation
if R == 16
    num = 60;
else
    num = 30;
end

%% --- Create CIC decimator (used to design FIR compensator) ---
cicDecim = dsp.CICDecimator(R, M, N);

%% --- Design FIR Compensation Filter ---
cicCompDecim = dsp.CICCompensationDecimator( ...
    cicDecim, ...
    'DecimationFactor', R, ...
    'PassbandFrequency', ((0.5/R) - (1/num)), ...
    'StopbandFrequency', ((0.5/R) + (1/num)), ...
    'PassbandRipple', 0.2, ...
    'StopbandAttenuation', 65, ...
    'SampleRate', 1 ... % normalized for MATLAB design
);

%% --- Extract FIR coefficients (numerator) ---
b = tf(cicCompDecim);  % MATLAB returns floating-point numerator coefficients
b = b(:).';             % row vector

% Quantize coefficients to s16.15
b_q = round(b * 2^15);
b_q = max(min(b_q, 32767), -32768);

%% --- Generate random input in s16.15 ---
x = 2*rand(numSamples,1) - 1;   % float [-1,1]
x_q = round(x * 2^15);          % s16.15
x_q = max(min(x_q, 32767), -32768);

%% --- FIR Filtering in s16.15 fixed-point arithmetic ---
y_q = zeros(size(x_q), 'int32'); % accumulate in a larger width

for n = 1:length(x_q)
    acc = 0;
    for k = 1:length(b_q)
        if n-k+1 > 0
            acc = acc + int32(x_q(n-k+1)) * int32(b_q(k)); % full precision multiply
        end
    end
    % Shift down by fractional bits (15) and saturate
    y_q(n) = min(max(bitshift(acc, -15), -32768), 32767);
end


%% --- Print inputs and outputs line by line ---
disp('--- Input samples (s16.15, hex) ---');
for i = 1:length(x_q)
    val_hex = x_q(i);
    if val_hex < 0
        val_hex = 2^16 + val_hex;    % two's complement for hex
    end
    fprintf('%04X\n', val_hex);
end

disp('--- Output samples (s16.15, hex) ---');
for i = 1:length(y_q)
    val_hex = y_q(i);
    if val_hex < 0
        val_hex = 2^16 + val_hex;    % two's complement for hex
    end
    fprintf('%04X\n', val_hex);
end


%% --- Plot Time-Domain Input vs Output ---
figure('Name','FIR Only: Time-Domain');
subplot(2,1,1);
stem(x_q/2^15,'b','filled'); title('Input Signal (s16.15)'); grid on;
ylabel('Amplitude');
subplot(2,1,2);
stem(y_q/2^15,'r','filled'); title('Filtered Output (s16.15)'); grid on;
ylabel('Amplitude'); xlabel('Sample Index');

%% --- Plot Frequency-Domain Input vs Output ---
figure('Name','FIR Only: Frequency-Domain');
X = fftshift(abs(fft(double(x_q)/2^15,1024)));
Y = fftshift(abs(fft(double(y_q)/2^15,1024)));
f_axis = linspace(-Fs/2, Fs/2,length(X))/1e6; % MHz
plot(f_axis, 20*log10(X/max(X)),'b','DisplayName','Input'); hold on;
plot(f_axis, 20*log10(Y/max(Y)),'r','DisplayName','Output');
xlabel('Frequency (MHz)'); ylabel('Magnitude (dB)');
title('Input vs Output Spectrum (FIR Only)');
legend show; grid on;

%% --- Optional: Print FIR taps in s16.15 hex ---
% disp('--- FIR compensation coefficients (s16.15 hex) ---');
% for i = 1:length(b_q)
%     val = b_q(i);
%     if val < 0, val = 2^16 + val; end
%     fprintf('%04X\n', val);
% end
