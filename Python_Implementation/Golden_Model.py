from math import log
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

# --- FFT Plot ---
def plot_fft(x, Fs, title):
    N = len(x)
    X = np.fft.fftshift(np.fft.fft(x)) / N
    f = np.fft.fftshift(np.fft.fftfreq(N, 1/Fs))
    plt.plot(f/1e6, 20*np.log10(np.abs(X)+1e-12))
    plt.title(title)
    plt.xlabel('Frequency (MHz)')
    plt.ylabel('Magnitude (dB)')
    plt.grid(True)

# --- Combined Signal ---
x = x_main + x_int1 + x_int2

########################################################################
######################### Fractional Decimator #########################
########################################################################

# --- Resampling using polyphase filtering (2/3 rate) ---
x_fd = sig.resample_poly(x, up=2, down=3, window=('kaiser', 16.0))

####################################################################
######################### IIR Notch Filter #########################
####################################################################

fcB = 2e6  # 4 MHz alias at 9MHz -> 2 MHz at 6 MHz sampling

# normalized frequencies
wcA = 2 * Fi1 / Fs_new
wcB = 2 * fcB / Fs_new

# desired 3dB bandwidths (Hz) 
BW_A = 500_000.0
BW_B = 100_000.0

Q_A = Fi1/BW_A
Q_B = fcB/BW_B

# Two notches: 2.4 MHz and 1 MHz
[b1, a1] = sig.iirnotch(w0=wcA, Q=Q_A)
[b2, a2] = sig.iirnotch(w0=wcB, Q=Q_B)

# cascading the two filters
[b_c, a_c] = np.convolve(b1, b2), np.convolve(a1, a2)

x_filtered = sig.filtfilt(b_c, a_c, x_fd)

# --- Compare Before/After (time domain) --- #

 # Left plot: Before Decimation
plt.figure(1)
plt.plot(x[:1000])
plt.title('Before Decimation')
plt.xlabel('Sample Index')
plt.ylabel('Amplitude')
plt.grid(True)

 # Middle plot: After Decimation
plt.figure(2)
plt.plot(x_fd[:1000])
plt.title('After Decimation')
plt.xlabel('Sample Index')
plt.ylabel('Amplitude')
plt.grid(True)

# Right plot: After Notch Filter
plt.figure(3)
plt.plot(x_filtered[:1000])
plt.title('After Notch Filter')
plt.xlabel('Sample Index')
plt.ylabel('Amplitude')
plt.grid(True)

# --- Compare Before/After (freq domain) ---

plt.figure(4)
plot_fft(x, Fs, 'Original 100 KHz Spectrum (Fs = 9 MHz)')
plt.figure(5)
plot_fft(x_fd, Fs_new, 'After Fractional Decimation (Fs = 6 MHz)')
plt.figure(6)
plot_fft(x_filtered, Fs_new, 'After Cascaded IIR Notch Filter (Fs = 6 MHz)')

#######################################################
######################### CIC #########################
#######################################################

x_filtered = np.fft.fftshift(np.fft.fft(x_filtered)) / len(x_filtered)
np.seterr(divide='ignore', invalid='ignore')
print("Shape of x_filtered:", len(x_filtered))

#plt.figure(7)
def CICResponse(R, M, N, cutOff, numTaps, calcRes = len(x_filtered)):
    w = np.arange(calcRes) * np.pi / (calcRes - 1)
    Hcomp = lambda w: ((M * R) ** N) * (np.abs((np.sin(w / (2. * R))) / (np.sin((w * M) / 2.))) ** N)
    cicCompResponse = np.array(list(map(Hcomp, w)))
    # Set DC response to 1 as it is calculated as 'nan' by Hcomp
    cicCompResponse[0] = 1

    # In getFIRCompensationFilter, add after setting stopband response:
    if numTaps % 2 == 0:
        cicCompResponse[-1] = 0
    cicCompResponse[int(calcRes * cutOff * 2):] = 0
    normFreq = np.arange(calcRes) / (calcRes - 1)
    taps = sig.firwin2(numTaps, normFreq, cicCompResponse)
    return taps

def FIRCombinedFilter(R, M, N, taps, wideband=False):
    if wideband:
        interp = np.zeros(len(taps) * R)
        interp[::R] = taps
        freqs, response = sig.freqz(interp, worN=12000)
    else:
        freqs, response = sig.freqz(taps, worN=12000)

    if wideband:
        w = np.arange(len(freqs)) * np.pi / len(freqs) * R
    else:
        w = np.arange(len(freqs)) * np.pi / len(freqs)

    Hcic = lambda w: (1 / ((M * R) ** N)) * np.abs((np.sin((w * M) / 2.)) / (np.sin(w / (2. * R)))) ** N
    cicMagResponse = np.array(list(map(Hcic, w)))
    combinedResponse = cicMagResponse * response
    return (20 * np.log10(abs(combinedResponse)))

taps = CICResponse(R=16, M=2, N=3, cutOff=0.5, numTaps=120)
buf = FIRCombinedFilter(R=16, M=2, N=3, taps = taps, wideband=False)
buf[0] = 0
final = x_filtered * buf

#print("func = ", (buf))

# --- Inverse FFT to recover time-domain signal ---
x_reconstructed = np.fft.ifft(np.fft.ifftshift(final))
x_reconstructed = np.real(x_reconstructed)  # remove small imaginary parts

print("x = ", x)

print("x_reconstructed = ", x_reconstructed)

# --- Create corresponding time vector for the reconstructed signal ---
t_new = np.arange(0, len(x_reconstructed)) / Fs_new

# --- Plot time-domain waveform ---
plt.figure(8)
plt.plot(x_reconstructed[:1000])
plt.title('Reconstructed Signal (After Inverse FFT)')
plt.xlabel('Time (ms)')
plt.ylabel('Amplitude')
plt.grid(True)

# --- Optional: plot spectrum to verify ---
plt.figure(9)
f_axis = np.linspace(-Fs_new/2, Fs_new/2, len(final))
plt.plot(f_axis/1e6, 20*np.log10(np.abs(final)))
plt.title('Spectrum of Final Signal')
plt.xlabel('Frequency (MHz)')
plt.ylabel('Magnitude (dB)')
plt.grid(True)
plt.show()