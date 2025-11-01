import matplotlib.pyplot as plt
import scipy.signal as sig
import numpy as np
from math import pi

plt.close('all')

# from __future__ import print_function
# from __future__ import division

# import numpy as np

# # Configuration.
# L = 2
# M = 3
# fS = 9e6 * L  # Sampling rate.
# fT = 0.4e6  # Transition bandwidth.
# fL = 2.8e6  # Cutoff frequency.
# atten = 80.0  # Desired attenuation in dB.

# N = (atten - 7.95) / (2.285 * (2 * np.pi * (fT / fS)))

# N = np.ceil(N)
# # if N % 2 == 0:
# #     N += 1  # Make sure that N is odd.
# N = int(N)
# print("Filter length N =", N)

# beta = 0.1102 * (atten - 8.7)  # Kaiser window beta.
# print("Kaiser window beta =", beta)

# # Compute sinc filter.
# h = np.sinc(2 * fL / fS * (np.arange(N) - (N - 1) / 2))

# # Apply window.
# h *= np.kaiser(N, beta)

# # Normalize to get unity gain.
# h /= np.sum(h)

# print(h)

# # Applying the filter to a signal s 
# # s = np.convolve(s, h)

# # ------------------------------
# # Function to convert flaot to s16.15
# # ------------------------------
# def float_to_s16_15(vec):
#     scale = 2**15
#     fixed = np.round(np.clip(vec, -1.0, 1.0 - 1/scale) * scale).astype(np.int16)
#     return fixed

# # ------------------------------
# # Function to Print Verilog ROM style
# # ------------------------------
# def print_rom_style(fixed_vec):
#     for i, val in enumerate(fixed_vec):
#         hex_val = format(np.uint16(val), '04X')  # 4-digit hex
#         print(f"assign ROM[{i}] = 16'h{hex_val};")

# def s16_15_to_float(fixed_vec):
#     """
#     Convert S16.15 fixed-point vector back to float
#     """
#     scale = 2**15
#     return fixed_vec.astype(np.float64) / scale

# # ------------------------------
# # coefficients
# # ------------------------------
# fixed_vec = float_to_s16_15(h)
# print_rom_style(fixed_vec)

# # ------------------------------
# # Test conversion back to float
# restored_vec = s16_15_to_float(fixed_vec)
# print("Restored floats: ", restored_vec)

import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig

# -------------------------------------------------
# Configuration
# -------------------------------------------------
L = 2
M = 3
fS = 9e6 * L  # Sampling rate (intermediate rate after upsampling)
fT = 0.4e6    # Transition bandwidth
fL = 2.8e6    # Cutoff frequency
atten = 80.0  # Desired attenuation in dB

N = (atten - 7.95) / (2.285 * (2 * np.pi * (fT / fS)))
N = int(np.ceil(N))
print("Filter length N =", N)

beta = 0.1102 * (atten - 8.7)
print("Kaiser window beta =", beta)

# -------------------------------------------------
# FIR filter design (low-pass)
# -------------------------------------------------
h = np.sinc(2 * fL / fS * (np.arange(N) - (N - 1) / 2))
h *= np.kaiser(N, beta)
h /= np.sum(h)
print("Filter coefficients:", h)

# -------------------------------------------------
# Functions for S16.15 conversion
# -------------------------------------------------
def float_to_s16_15(vec):
    scale = 2**15
    fixed = np.round(np.clip(vec, -1.0, 1.0 - 1/scale) * scale).astype(np.int16)
    return fixed

def s16_15_to_float(fixed_vec):
    scale = 2**15
    return fixed_vec.astype(np.float64) / scale

def print_rom_style(fixed_vec):
    for i, val in enumerate(fixed_vec):
        hex_val = format(np.uint16(val), '04X')
        print(f"assign ROM[{i}] = 16'h{hex_val};")

# -------------------------------------------------
# Generate random input signal at 9 MHz
# -------------------------------------------------
fs_in = 9e6
t = np.arange(0, 100e-6, 1/fs_in)

np.random.seed(0)
base_signal = np.random.randn(len(t)) * 0.1
interf1 = 0.5 * np.sin(2 * np.pi * 2.4e6 * t)
interf2 = 0.5 * np.sin(2 * np.pi * 5e6 * t)
s_in = base_signal + interf1 + interf2

# Normalize before fixed-point conversion
s_in_norm = s_in / np.max(np.abs(s_in))

# -------------------------------------------------
# Convert input to S16.15
# -------------------------------------------------
s_in_fixed = float_to_s16_15(s_in_norm)

# Convert back to float for arithmetic (simulating DSP hardware behavior)
s_in_fp = s16_15_to_float(s_in_fixed)

# -------------------------------------------------
# Fractional decimation (applied on fixed-point domain)
# -------------------------------------------------
# Upsample by 2
s_up = np.zeros(len(s_in_fp) * L)
s_up[::L] = s_in_fp

# Filter (still float math, but representing fixed-point values)
s_filt = np.convolve(s_up, h, mode='same')

# Downsample by 3
s_dec = s_filt[::M]

fs_out = fs_in * L / M
print(f"Output sampling rate = {fs_out/1e6:.2f} MHz")

# -------------------------------------------------
# Convert output back to S16.15
# -------------------------------------------------
s_out_fixed = float_to_s16_15(s_dec / np.max(np.abs(s_dec)))

# -------------------------------------------------
# Print ROM-style samples
# -------------------------------------------------
print("\n--- Input Signal in S16.15 Format ---")
for val in s_in_fixed:
    print(f"{np.uint16(val):04X}")

print("\n--- Output Signal in S16.15 Format ---")
for val in s_out_fixed:
    print(f"{np.uint16(val):04X}")

# -------------------------------------------------
# Plot results
# -------------------------------------------------
plt.figure(figsize=(12,6))
plt.subplot(2,1,1)
plt.plot(t[:500], s_in_fp[:500])
plt.title("Input Signal (S16.15 domain, with 2.4 & 5 MHz interference)")
plt.xlabel("Time [s]")
plt.ylabel("Amplitude")

plt.subplot(2,1,2)
plt.plot(s_dec[:500])
plt.title("Output Signal after Fractional Decimation (9→6 MHz)")
plt.xlabel("Sample index")
plt.ylabel("Amplitude")
plt.tight_layout()

# -------------------------------------------------
# Frequency response
# -------------------------------------------------
f, H = sig.freqz(h, worN=2048, fs=fS)
plt.figure()
plt.plot(f/1e6, 20*np.log10(np.abs(H)))
plt.title("FIR Lowpass Filter Frequency Response")
plt.xlabel("Frequency [MHz]")
plt.ylabel("Magnitude [dB]")
plt.grid(True)
plt.show()