import matplotlib.pyplot as plt
import scipy.signal as sig
import numpy as np
from math import pi

plt.close('all')

# Design IIR butterworth filter
Fs = 1000;
n = 5;
fc = 200;

w_c = 2*fc/Fs;
[b,a] = sig.butter(n, w_c)

# Frequency response
[w,h] = sig.freqz(b,a,worN = 2000)
w = Fs*w/(2*pi)

h_db = 20 * np.log10(np.maximum(abs(h), 1e-12))

plt.figure()
plt.plot(w, h_db); plt.xlabel('Frequency (Hz)')
plt.ylabel('Magnitude(dB)')
plt.grid('on')

# Design FIR filter
N = 21
fc = np.array([100, 200])
w_c = 2 * fc / Fs
t = sig.firwin(N, w_c, pass_zero=False)

[w,h] = sig.freqz(t, worN = 2000)
w = Fs*w/(2*pi)

h_db = 20*np.log10(abs(h))

plt.figure(2)
plt.plot(w,h_db);plt.title('FIR filter Response')
plt.xlabel('Frequency(Hz)'); plt.ylabel('Magnitude(dB)')
plt.grid('on')

fs = 200.0  # Sample frequency (Hz)
f0 = 60.0  # Frequency to be removed from signal (Hz)
Q = 30.0  # Quality factor
# Design notch filter
b, a = sig.iirnotch(f0, Q, fs)
# Frequency response
freq, h = sig.freqz(b, a, fs=fs)
# Plot
fig, ax = plt.subplots(2, 1, figsize=(8, 6))
ax[0].plot(freq, 20*np.log10(abs(h)), color='blue')
ax[0].set_title("Frequency Response")
ax[0].set_ylabel("Amplitude [dB]", color='blue')
ax[0].set_xlim([0, 100])
ax[0].set_ylim([-25, 10])
ax[0].grid(True)
ax[1].plot(freq, np.unwrap(np.angle(h))*180/np.pi, color='green')
ax[1].set_ylabel("Phase [deg]", color='green')
ax[1].set_xlabel("Frequency [Hz]")
ax[1].set_xlim([0, 100])
ax[1].set_yticks([-90, -60, -30, 0, 30, 60, 90])
ax[1].set_ylim([-90, 90])
ax[1].grid(True)
plt.show()