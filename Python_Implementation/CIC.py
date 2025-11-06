import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import freqz, firwin2, lfilter

def cic_decimator(x, R=8, D=1, Q=3):
    if D is None:
        D = R
    # Integrator
    integrator = np.copy(x)
    for _ in range(Q):
        integrator = np.cumsum(integrator)
    # Downsample
    downsampled = integrator[::R]
    # Comb
    comb = np.copy(downsampled)
    for _ in range(Q):
        comb = comb[D:] - comb[:-D]
    return comb

# -------------------------------------------------
# Configuration
# -------------------------------------------------
fs_in = 6e6    # Input rate
R = 8         # Decimation factor
Q = 5          # CIC order
N = 5          # Number of sections
D = N*R        # Differential delay

# -------------------------------------------------
# Input signal
# -------------------------------------------------
t = np.arange(0, 2000) / fs_in
f_tone = 100e3
x = np.sin(2 * np.pi * f_tone * t)

# -------------------------------------------------
# Apply CIC
# -------------------------------------------------
y = cic_decimator(x, R=R, D=D, Q=Q)
fs_out = fs_in / R
print(f"Input rate:  {fs_in/1e6:.1f} MHz")
print(f"Output rate: {fs_out/1e6:.3f} MHz, Decimation R={R}, Order Q={Q}, Delay D={D}")
print(f"Input length: {len(x)}  ->  Output length: {len(y)}")


f = np.linspace(0, 0.5, 4096) 
num = np.sin(np.pi * N * f * R * D) 
den = np.sin(np.pi * f * D) 
H = np.divide(num, den, out=np.ones_like(num), where=den!=0) # safe divide 
H = (H ** Q) / ((N*R) ** Q) 
H_db = 20 * np.log10(np.abs(H) + 1e-12)
# ------------------------------------------------- 
# Plot Results 
# ------------------------------------------------- 
# plt.figure(figsize=(10,6)) 
# plt.plot(f * fs_in / 1e6, H_db) 
# plt.title(f'CIC Decimator Frequency Response (R={R}, D={D}, Q={Q})') 
# plt.xlabel('Frequency [MHz]') 
# plt.ylabel('Magnitude [dB]') 
# plt.grid(True) 
# # ------------------------------------------------- 
# # Time-domain plots for input and output 
# # ------------------------------------------------- 
# # Time vectors (in microseconds for readability) 
# t_in = np.arange(len(x)) / fs_in * 1e6 
# t_out = np.arange(len(y)) / (fs_in / R) * 1e6 
# plt.figure(figsize=(12, 6)) 
# # Plot input 
# plt.subplot(2, 1, 1) 
# plt.plot(t_in, x, label='Input (6 MHz)') 
# plt.title('CIC Input Signal') 
# plt.xlabel('Time [µs]') 
# plt.ylabel('Amplitude') 
# plt.grid(True) 
# # Plot output 
# plt.subplot(2, 1, 2) 
# plt.plot(t_out, y, label=f'Output ({fs_in/R/1e6:.3f} MHz)', color='orange') 
# plt.title(f'CIC Output Signal (Decimated by R={R})') 
# plt.xlabel('Time [µs]') 
# plt.ylabel('Amplitude') 
# plt.grid(True) 
# plt.tight_layout() 
# plt.show()

# -------------------------------------------------
# FIR Compensation Filter
# -------------------------------------------------
def getFIRCompensationFilter(R, N, Q, cutOff, numTaps, calcRes=1024):
    w = np.arange(calcRes) * np.pi / (calcRes - 1)
    numerator = ((N*R)**Q) * np.abs(np.sin(w / (2.0 * R)))**Q
    denominator = np.abs(np.sin((N*w) / 2.0))**Q
    Hcomp = np.divide(numerator, denominator, out=np.ones_like(numerator), where=denominator != 0)
    cicCompResponse = Hcomp.copy()
    cicCompResponse[0] = 1.0
    cicCompResponse[int(calcRes * cutOff * 2):] = 0.0
    if numTaps % 2 == 0:  # ensure valid Nyquist behavior
        cicCompResponse[-1] = 0.0
    normFreq = np.arange(calcRes) / (calcRes - 1)
    taps = firwin2(numTaps, normFreq, cicCompResponse)
    return taps

taps = getFIRCompensationFilter(R=R, N=N, Q=Q, cutOff=1/(2*R), numTaps=65)

# -------------------------------------------------
# Apply FIR filter to CIC output
# -------------------------------------------------
# y_comp = lfilter(taps, 1.0, y)

# -------------------------------------------------
# Frequency Response comparison
# -------------------------------------------------
def plotFIRCompFilter(R, N, Q, cutOff, taps, xMin, xMax, yMin, yMax, wideband=False):    
    plt.figure(figsize=(12,4))
    if wideband:
        interp = np.zeros(len(taps)*R)
        interp[::R] = taps
        freqs, response = freqz(interp)
    else:
        freqs, response = freqz(taps)
    if wideband:
        w = np.arange(len(freqs)) * np.pi/len(freqs) * R
    else:
        w = np.arange(len(freqs)) * np.pi/len(freqs)
    Hcic = lambda w : (1/((N*R)**Q))*np.abs((np.sin((N*w)/2.)) / (np.sin(w/(2.*R))))**Q
    cicMagResponse = np.array(list(map(Hcic, w)))
    combinedResponse = cicMagResponse * response
    plt.plot(freqs/(2*np.pi),20*np.log10(abs(cicMagResponse)), label="CIC Filter")
    plt.plot(freqs/(2*np.pi),20*np.log10(abs(response)), label="FIR Compensation")
    plt.plot(freqs/(2*np.pi),20*np.log10(abs(combinedResponse)), label="Combined (Equalized)")
    axes = plt.gca(); axes.set_xlim([xMin,xMax]); axes.set_ylim([yMin,yMax])
    plt.grid(); plt.legend()
    plt.title(f"CIC Compensation (Q={Q}, R={R}, Cutoff={cutOff}fs, Taps={len(taps)})")
    plt.xlabel('Normalized Frequency (×π rad/sample)')
    plt.ylabel('Magnitude [dB]')

plotFIRCompFilter(R=R, N=N, Q=Q, cutOff=1/(2*R), taps=taps, xMin=0, xMax=0.5, yMin=-200, yMax=5)
plotFIRCompFilter(R=R, N=N, Q=Q, cutOff=1/(2*R), taps=taps, xMin=0, xMax=0.2, yMin=-0.5, yMax=0.5)

# -------------------------------------------------
# Time-domain comparison
# -------------------------------------------------
# t_out = np.arange(len(y)) / fs_out * 1e6
# plt.figure(figsize=(12,6))
# plt.subplot(2,1,1)
# plt.plot(t_out, y, label='CIC Output', color='orange')
# plt.title('CIC Output (Before Compensation)')
# plt.xlabel('Time [µs]')
# plt.ylabel('Amplitude')
# plt.grid(True)

# plt.subplot(2,1,2)
# plt.plot(t_out, y_comp, label='After FIR Compensation', color='green')
# plt.title('CIC Output After FIR Compensation')
# plt.xlabel('Time [µs]')
# plt.ylabel('Amplitude')
# plt.grid(True)
# plt.tight_layout()
plt.show()