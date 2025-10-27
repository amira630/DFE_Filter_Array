# import matplotlib.pyplot as plt
# import scipy.signal as sig
# import numpy as np
# from math import pi

# # plt.close('all')

# # # Design IIR butterworth filter
# # Fs = 1000;
# # n = 5;
# # fc = 200;

# # w_c = 2*fc/Fs;
# # [b,a] = sig.butter(n, w_c)

# # # Frequency response
# # [w,h] = sig.freqz(b,a,worN = 2000)
# # w = Fs*w/(2*pi)

# # h_db = 20 * np.log10(np.maximum(abs(h), 1e-12))

# # plt.figure()
# # plt.plot(w, h_db); plt.xlabel('Frequency (Hz)')
# # plt.ylabel('Magnitude(dB)')
# # plt.grid('on')

# # # Design FIR filter
# # N = 21
# # fc = np.array([100, 200])
# # w_c = 2 * fc / Fs
# # t = sig.firwin(N, w_c, pass_zero=False)

# # [w,h] = sig.freqz(t, worN = 2000)
# # w = Fs*w/(2*pi)

# # h_db = 20*np.log10(abs(h))

# # plt.figure(2)
# # plt.plot(w,h_db);plt.title('FIR filter Response')
# # plt.xlabel('Frequency(Hz)'); plt.ylabel('Magnitude(dB)')
# # plt.grid('on')

# # fs = 200.0  # Sample frequency (Hz)
# # f0 = 60.0  # Frequency to be removed from signal (Hz)
# # Q = 30.0  # Quality factor
# # # Design notch filter
# # b, a = sig.iirnotch(f0, Q, fs)
# # # Frequency response
# # freq, h = sig.freqz(b, a, fs=fs)
# # # Plot
# # fig, ax = plt.subplots(2, 1, figsize=(8, 6))
# # ax[0].plot(freq, 20*np.log10(abs(h)), color='blue')
# # ax[0].set_title("Frequency Response")
# # ax[0].set_ylabel("Amplitude [dB]", color='blue')
# # ax[0].set_xlim([0, 100])
# # ax[0].set_ylim([-25, 10])
# # ax[0].grid(True)
# # ax[1].plot(freq, np.unwrap(np.angle(h))*180/np.pi, color='green')
# # ax[1].set_ylabel("Phase [deg]", color='green')
# # ax[1].set_xlabel("Frequency [Hz]")
# # ax[1].set_xlim([0, 100])
# # ax[1].set_yticks([-90, -60, -30, 0, 30, 60, 90])
# # ax[1].set_ylim([-90, 90])
# # ax[1].grid(True)
# # plt.show()

# # import numpy as np
# # import scipy.signal as sig
# # import matplotlib.pyplot as plt

# # # --- Parameters ---
# # Fs_in = 100e6          # Original sampling rate (100 MHz)
# # Fc = 9e6               # Signal frequency (9 MHz)
# # duration = 10e-6       # Signal duration (10 microseconds)
# # t = np.arange(0, duration, 1/Fs_in)

# # # --- Generate the 9 MHz signal ---
# # x = np.cos(2 * np.pi * Fc * t)

# # # --- Rational resampling (decimation by 3, interpolation by 2) ---
# # # This converts Fs_in -> Fs_out = Fs_in * 2/3
# # x_fd = sig.resample_poly(x, up=2, down=3)
# # Fs_out = Fs_in * 2/3

# # # --- Time vector for new signal ---
# # t_fd = np.arange(len(x_fd)) / Fs_out

# # # --- Plot comparison ---
# # plt.figure(figsize=(10, 5))
# # plt.plot(t[:1000]*1e6, x[:1000], label='Original 9 MHz Signal (Fs=100 MHz)')
# # plt.plot(t_fd[:1000]*1e6, x_fd[:1000], label='After Fractional Decimation → 6 MHz', linestyle='--')
# # plt.xlabel('Time (µs)')
# # plt.ylabel('Amplitude')
# # plt.title('Fractional Frequency Decimation: 9 MHz → 6 MHz')
# # plt.legend()
# # plt.grid(True)
# # plt.show()

# # # --- Print sampling rates ---
# # print(f"Original Fs = {Fs_in/1e6:.1f} MHz")
# # print(f"New Fs = {Fs_out/1e6:.1f} MHz")

# from math import log
# import scipy.signal as sig
# import numpy as np
# import matplotlib.pyplot as plt

# # --- Signal Parameters ---
# Fs = 9e6
# Fs_new = 6e6
# Fc = 100e3
# duration = 2e-3

# Fi1 = 2.4e6
# Fi2 = 5e6
# A_i1 = 0.5
# A_i2 = 0.3

# t = np.arange(0, duration, 1/Fs)
# x_main = np.cos(2*np.pi*Fc*t)
# x_int1 = A_i1*np.cos(2*np.pi*Fi1*t)
# x_int2 = A_i2*np.cos(2*np.pi*Fi2*t)
# x = x_main + x_int1 + x_int2

# # --- FIR Filter Design ---
# f_pass = 2.8e6
# f_stop = 3.2e6
# ripple_db = 0.25
# atten_db = 80.0
# nyq = Fs / 2.0
# trans_width = (f_stop - f_pass) / nyq

# numtaps_est, beta = sig.kaiserord(atten_db, trans_width)
# numtaps = numtaps_est + 1 if numtaps_est % 2 == 0 else numtaps_est
# cutoff_hz = 0.5 * (f_pass + f_stop)

# taps = sig.firwin(numtaps, cutoff_hz/nyq, window=('kaiser', beta))
# print(f"Filter length = {len(taps)} taps")

# # --- Filter + Fractional Resample ---
# x_fd = sig.upfirdn(taps, x, up=2, down=3)

# # Remove group delay (compensate)
# delay = (len(taps) - 1) // 2
# x_fd = x_fd[delay:-delay or None]

# # New sampling frequency
# Fs_fd = Fs * 2 / 3
# t_fd = np.arange(len(x_fd)) / Fs_fd

# # --- FFT plot function ---
# def plot_fft(x, Fs, label):
#     N = len(x)
#     X = np.fft.fftshift(np.fft.fft(x))
#     f = np.fft.fftshift(np.fft.fftfreq(N, 1/Fs))
#     plt.plot(f/1e6, 20*np.log10(np.abs(X)/N + 1e-12), label=label)

# plt.figure(figsize=(9,4))
# plot_fft(x, Fs, "Original 9 MHz")
# plot_fft(x_fd, Fs_fd, "After 2/3 Resample")
# plt.xlabel("Frequency (MHz)")
# plt.ylabel("Magnitude (dB)")
# plt.legend()
# plt.grid()
# plt.title("Spectrum Before / After Fractional Decimation")
# plt.show()

from __future__ import print_function
from __future__ import division

import numpy as np

# Example code, computes the coefficients of a low-pass windowed-sinc filter.

# Configuration.
L = 2
M = 3
fS = 9e6 * L  # Sampling rate.
fT = 0.4e6  # Transition bandwidth.
fL = 2.8e6  # Cutoff frequency.
atten = 80.0  # Desired attenuation in dB.

N = (atten - 7.95) / (2.285 * (2 * np.pi * (fT / fS)))

N = np.ceil(N)
# if N % 2 == 0:
#     N += 1  # Make sure that N is odd.
N = int(N)
print("Filter length N =", N)

beta = 0.1102 * (atten - 8.7)  # Kaiser window beta.
print("Kaiser window beta =", beta)

# Compute sinc filter.
h = np.sinc(2 * fL / fS * (np.arange(N) - (N - 1) / 2))

# Apply window.
h *= np.kaiser(N, beta)

# Normalize to get unity gain.
h /= np.sum(h)

print(h)

# Applying the filter to a signal s 
# s = np.convolve(s, h)

# ------------------------------
# Function to convert flaot to s16.15
# ------------------------------
def float_to_s16_15(vec):
    scale = 2**15
    fixed = np.round(np.clip(vec, -1.0, 1.0 - 1/scale) * scale).astype(np.int16)
    return fixed

# ------------------------------
# Function to Print Verilog ROM style
# ------------------------------
def print_rom_style(fixed_vec):
    for i, val in enumerate(fixed_vec):
        hex_val = format(np.uint16(val), '04X')  # 4-digit hex
        print(f"assign ROM[{i}] = 16'h{hex_val};")

def s16_15_to_float(fixed_vec):
    """
    Convert S16.15 fixed-point vector back to float
    """
    scale = 2**15
    return fixed_vec.astype(np.float64) / scale

# ------------------------------
# coefficients
# ------------------------------
fixed_vec = float_to_s16_15(h)
print_rom_style(fixed_vec)

# ------------------------------
# Test conversion back to float
restored_vec = s16_15_to_float(fixed_vec)
print("Restored floats: ", restored_vec)