import scipy.signal as sig
import numpy as np
import matplotlib.pyplot as plt

# --- Signal Parameters ---
Fs = 9e6          # Sampling frequency (9 MHz)
Fs_new = 6e6      # New sampling frequency after decimation (6 MHz)
Fc = 100e3        # Signal frequency (100 KHz)
duration = 2e-3 # Signal duration (2 milliseconds)

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

# --- Resample using polyphase filtering (2/3 rate) ---
x_fd = sig.resample_poly(x, up=2, down=3, window=('kaiser', 100.0))

# Compute the new sampling frequency and time vector
t_new = np.arange(0, len(x_fd)) / Fs_new

# --- Plot both signals ---
plt.figure(1)
plt.plot(t * 1e3, x, 'b', label='Original (9 MHz)')
plt.plot(t_new * 1e3, x_fd, 'r--', label='Resampled (≈6 MHz)')

plt.title("100 KHz Cosine Wave - Original vs Resampled (x2/3 Rate)")
plt.xlabel("Time (ms)")
plt.ylabel("Amplitude")
plt.legend()
plt.grid()

# --- FFT helper ---
def plot_fft(x, Fs, title):
    N = len(x)
    X = np.fft.fftshift(np.fft.fft(x)) / N
    f = np.fft.fftshift(np.fft.fftfreq(N, 1/Fs))
    plt.plot(f/1e6, 20*np.log10(np.abs(X)+1e-12))
    plt.title(title)
    plt.xlabel('Frequency (MHz)')
    plt.ylabel('Magnitude (dB)')
    plt.grid(True)

plt.figure(2)
plot_fft(x, Fs, 'Original 100 KHz Spectrum (Fs = 9 MHz)')
plt.figure(3)
plot_fft(x_fd, Fs_new, 'After Fractional Decimation (Fs = 6 MHz)')

plt.show()