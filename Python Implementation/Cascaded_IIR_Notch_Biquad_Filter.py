import scipy.signal as sig
import numpy as np
import matplotlib.pyplot as plt

Fs = 6_000_000  # 6 MHz

fcA = 2_400_000  # 2.4 MHz (native)
fcB = 1_000_000  # 5 MHz alias -> 1 MHz at 6 MHz sampling

# normalized frequencies
wcA = 2 * fcA / Fs
wcB = 2 * fcB / Fs

# desired 3dB bandwidths (Hz) 
BW_A = 50_000.0
BW_B = 50_000.0

Q_A = fcA / BW_A
Q_B = fcB / BW_B

# Two notches: 2.4 MHz and 1 MHz
[b1, a1] = sig.iirnotch(w0=wcA, Q=Q_A)
[b2, a2] = sig.iirnotch(w0=wcB, Q=Q_B)

# cascading the two filters
[b_c, a_c] = sig.convolve(b1, b2), sig.convolve(a1, a2)

# Frequency Response
# [w1, h1] = sig.freqz(b1, a1, worN=2048, fs=Fs)
# [w2, h2] = sig.freqz(b2, a2, worN=2048, fs=Fs)
[w_c, h_c] = sig.freqz(b_c, a_c, worN=2048, fs=Fs)

# plt.figure(1)
# plt.plot(w2, 20*np.log10(abs(h2)))
# plt.title("IIR Notch (1 MHz)")
# plt.xlabel("Frequency (Hz)")
# plt.ylabel("Magnitude (dB)")
# plt.grid()

# plt.figure(2)
# plt.plot(w1, 20*np.log10(abs(h1)))
# plt.title("IIR Notch (2.4 MHz)")
# plt.xlabel("Frequency (Hz)")
# plt.ylabel("Magnitude (dB)")
# plt.grid()

plt.figure(1)
plt.plot(w_c, 20*np.log10(abs(h_c)))
plt.title("Cascaded IIR Notches (1 MHz, 2.4 MHz)")
plt.xlabel("Frequency (Hz)")
plt.ylabel("Magnitude (dB)")
plt.grid()

plt.show()