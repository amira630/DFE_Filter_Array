Fs = 9e6;                 % Sampling frequency (Hz)
N  = 48000;               % Number of samples

% Generate random real values in the valid range [-1, 1)
x_real = 1.98*rand(N,1) - 0.99;   % Uniform random between -1 and +1

% Quantize to s16.15 (Q16.15) fixed-point format
WL = 16;  % word length
FL = 15;  % fractional length

% --- Option A: as fi object (requires Fixed-Point Designer) ---
adc_s16_15 = fi(x_real, 1, WL, FL);


% instantiate the rate-converter object
Hd_fractional = Fractional_Decimator();

% process (single-shot). Output will be fi with the object's OutputDataType (s16.15)
y_fractional = step(Hd_fractional, adc_s16_15);

% === Create your IIR notch filter ===
Hd_iir2_4 = IIR2_4();

% === Apply the filter ===
y = filter(Hd_iir2_4, y_fractional);

% === 4. Inspect results ===
fvtool(Hd_iir2_4);      % View frequency response
whos x_fp y             % Check fixed-point properties