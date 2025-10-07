import scipy.signal as sig
import numpy as np
import matplotlib.pyplot as plt

# --- Signal Parameters ---
Fs = 9e6          # Sampling frequency (9 MHz)
Fs_new = 6e6      # New sampling frequency after decimation (6 MHz)
Fc = 100e3        # Signal frequency (100 KHz)
duration = 2e-3   # Signal duration (2 milliseconds)

# --- Interference Parameters ---
Fi1 = 2.4e6       # First interference frequency (2.4 MHz)
Fi2 = 5e6         # Second interference frequency (5 MHz)
A_i1 = 0.5        # Amplitude of interference 1
A_i2 = 0.3        # Amplitude of interference 2

# --- Time and Signal Generation ---
t = np.arange(0, duration, 1/Fs)   # Time vector
x_main = np.cos(2 * np.pi * Fc * t)                # 100 KHz cosine wave
x_int1 = A_i1 * np.cos(2 * np.pi * Fi1 * t)        # 2.4 MHz interference
x_int2 = A_i2 * np.cos(2 * np.pi * Fi2 * t)        # 5 MHz interference

# --- Combined Signal ---
x = x_main + x_int1 + x_int2

# --- Resampling using polyphase filtering (2/3 rate) ---
x_fd = sig.resample_poly(x, up=2, down=3, window=('kaiser', 100.0))

fcB = 1e6  # 5 MHz alias -> 1 MHz at 6 MHz sampling

# normalized frequencies
wcA = 2 * Fi1 / Fs_new
wcB = 2 * fcB / Fs_new

# desired 3dB bandwidths (Hz) 
BW_A = 85_000.0
BW_B = 100_000.0

Q_A = Fi1/BW_A
Q_B = fcB/BW_B

# Two notches: 2.4 MHz and 1 MHz
[b1, a1] = sig.iirnotch(w0=wcA, Q=Q_A)
[b2, a2] = sig.iirnotch(w0=wcB, Q=Q_B)

# cascading the two filters
[b_c, a_c] = np.convolve(b1, b2), np.convolve(a1, a2)

x_filtered = sig.filtfilt(b_c, a_c, x_fd)

# --- Compare Before/After (time domain) ---

# Left plot: Before Decimation
plt.figure(1)
# plt.subplot(1, 3, 1)
plt.plot(x[:1000])
plt.title('Before Decimation')
plt.xlabel('Sample Index')
plt.ylabel('Amplitude')
plt.grid(True)

# Middle plot: After Decimation
plt.figure(2)
# plt.subplot(1, 3, 2)
plt.plot(x_fd[:1000])
plt.title('After Decimation')
plt.xlabel('Sample Index')
plt.ylabel('Amplitude')
plt.grid(True)

# Right plot: After Notch Filter
plt.figure(3)
# plt.subplot(1, 3, 3)
plt.plot(x_filtered[:1000])
plt.title('After Notch Filter')
plt.xlabel('Sample Index')
plt.ylabel('Amplitude')
plt.grid(True)

plt.show()