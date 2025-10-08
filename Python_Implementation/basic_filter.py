# import matplotlib.pyplot as plt
# import scipy.signal as sig
# import numpy as np
# from math import pi

# plt.close('all')

# # Design IIR butterworth filter
# Fs = 1000;
# n = 5;
# fc = 200;

# w_c = 2*fc/Fs;
# [b,a] = sig.butter(n, w_c)

# # Frequency response
# [w,h] = sig.freqz(b,a,worN = 2000)
# w = Fs*w/(2*pi)

# h_db = 20 * np.log10(np.maximum(abs(h), 1e-12))

# plt.figure()
# plt.plot(w, h_db); plt.xlabel('Frequency (Hz)')
# plt.ylabel('Magnitude(dB)')
# plt.grid('on')

# # Design FIR filter
# N = 21
# fc = np.array([100, 200])
# w_c = 2 * fc / Fs
# t = sig.firwin(N, w_c, pass_zero=False)

# [w,h] = sig.freqz(t, worN = 2000)
# w = Fs*w/(2*pi)

# h_db = 20*np.log10(abs(h))

# plt.figure(2)
# plt.plot(w,h_db);plt.title('FIR filter Response')
# plt.xlabel('Frequency(Hz)'); plt.ylabel('Magnitude(dB)')
# plt.grid('on')

# fs = 200.0  # Sample frequency (Hz)
# f0 = 60.0  # Frequency to be removed from signal (Hz)
# Q = 30.0  # Quality factor
# # Design notch filter
# b, a = sig.iirnotch(f0, Q, fs)
# # Frequency response
# freq, h = sig.freqz(b, a, fs=fs)
# # Plot
# fig, ax = plt.subplots(2, 1, figsize=(8, 6))
# ax[0].plot(freq, 20*np.log10(abs(h)), color='blue')
# ax[0].set_title("Frequency Response")
# ax[0].set_ylabel("Amplitude [dB]", color='blue')
# ax[0].set_xlim([0, 100])
# ax[0].set_ylim([-25, 10])
# ax[0].grid(True)
# ax[1].plot(freq, np.unwrap(np.angle(h))*180/np.pi, color='green')
# ax[1].set_ylabel("Phase [deg]", color='green')
# ax[1].set_xlabel("Frequency [Hz]")
# ax[1].set_xlim([0, 100])
# ax[1].set_yticks([-90, -60, -30, 0, 30, 60, 90])
# ax[1].set_ylim([-90, 90])
# ax[1].grid(True)
# plt.show()

# import numpy as np
# import scipy.signal as sig
# import matplotlib.pyplot as plt

# # --- Parameters ---
# Fs_in = 100e6          # Original sampling rate (100 MHz)
# Fc = 9e6               # Signal frequency (9 MHz)
# duration = 10e-6       # Signal duration (10 microseconds)
# t = np.arange(0, duration, 1/Fs_in)

# # --- Generate the 9 MHz signal ---
# x = np.cos(2 * np.pi * Fc * t)

# # --- Rational resampling (decimation by 3, interpolation by 2) ---
# # This converts Fs_in -> Fs_out = Fs_in * 2/3
# x_fd = sig.resample_poly(x, up=2, down=3)
# Fs_out = Fs_in * 2/3

# # --- Time vector for new signal ---
# t_fd = np.arange(len(x_fd)) / Fs_out

# # --- Plot comparison ---
# plt.figure(figsize=(10, 5))
# plt.plot(t[:1000]*1e6, x[:1000], label='Original 9 MHz Signal (Fs=100 MHz)')
# plt.plot(t_fd[:1000]*1e6, x_fd[:1000], label='After Fractional Decimation → 6 MHz', linestyle='--')
# plt.xlabel('Time (µs)')
# plt.ylabel('Amplitude')
# plt.title('Fractional Frequency Decimation: 9 MHz → 6 MHz')
# plt.legend()
# plt.grid(True)
# plt.show()

# # --- Print sampling rates ---
# print(f"Original Fs = {Fs_in/1e6:.1f} MHz")
# print(f"New Fs = {Fs_out/1e6:.1f} MHz")

# 


import numpy as np
import matplotlib.pyplot as plt

# --- Make a small fake FFT ---
x = np.zeros(16)
x[1] = 1   # pretend a frequency spike at bin 1 (low freq)
x[-2] = 1  # and one near the end (high freq / negative freq)

# --- Do fftshift ---
x_shifted = np.fft.fftshift(x)

# --- Plot before and after ---
plt.figure(figsize=(8,4))

plt.subplot(1,2,1)
plt.stem(range(len(x)), x)
plt.title("Before fftshift")
plt.xlabel("Bin index")
plt.ylabel("Amplitude")

plt.subplot(1,2,2)
plt.stem(range(len(x_shifted)), x_shifted)
plt.title("After fftshift")
plt.xlabel("Bin index")
plt.ylabel("Amplitude")

plt.tight_layout()
plt.show()
