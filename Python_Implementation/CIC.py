import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import freqz

def cic_decimator(x, R=8, D=None, Q=3):
    """
    CIC Decimator Simulation
    -------------------------
    x : np.ndarray
        Input signal (1D)
    R : int
        Decimation factor
    D : int or None
        Differential delay (default = R)
    Q : int
        Number of integrator/comb stages (filter order)
    Returns:
        y : decimated output signal
    """
    if D is None:
        D = R

    # --- Integrator section (running sum)
    integrator = np.copy(x)
    for _ in range(Q):
        integrator = np.cumsum(integrator)

    # --- Downsample
    downsampled = integrator[::R]

    # --- Comb section (differencing)
    comb = np.copy(downsampled)
    for _ in range(Q):
        comb = comb[D:] - comb[:-D]

    return comb

# -------------------------------------------------
# Configuration
# -------------------------------------------------
fs_in = 6e6               # Input sample rate = 6 MHz
R = 8                     # Decimation factor
Q = 4                     # CIC order
D = R                     # Differential delay

# -------------------------------------------------
# Example input signal (100 kHz tone at 6 MHz sample rate)
# -------------------------------------------------
t = np.arange(0, 2000) / fs_in
f_tone = 100e3  # 100 kHz
x = np.sin(2 * np.pi * f_tone * t)

# -------------------------------------------------
# Apply CIC decimator
# -------------------------------------------------
y = cic_decimator(x, R=R, D=D, Q=Q)
fs_out = fs_in / R
t_out = np.arange(len(y)) / fs_out

print(f"Input rate:  {fs_in/1e6:.1f} MHz")
print(f"Output rate: {fs_out/1e6:.3f} MHz, Decimation R={R}, Order Q={Q}, Delay D={D}")
print(f"Input length: {len(x)}  ->  Output length: {len(y)}")

# -------------------------------------------------
# Frequency Response (theoretical)
# -------------------------------------------------
w, h = freqz(np.ones(R*D)**Q, worN=4096)
# The above freqz line only approximates, we'll compute directly:
f = np.linspace(0, 0.5, 4096)
num = np.sin(np.pi * f * R * D)
den = np.sin(np.pi * f * D)
H = np.divide(num, den, out=np.ones_like(num), where=den!=0)  # safe divide
H = (H ** Q) / (R ** Q)
H_db = 20 * np.log10(np.abs(H) + 1e-12)

# -------------------------------------------------
# Plot Results
# -------------------------------------------------
plt.figure(figsize=(10,6))
plt.plot(f * fs_in / 1e6, H_db)
plt.title(f'CIC Decimator Frequency Response (R={R}, D={D}, Q={Q})')
plt.xlabel('Frequency [MHz]')
plt.ylabel('Magnitude [dB]')
plt.grid(True)

# -------------------------------------------------
# Time-domain plots for input and output
# -------------------------------------------------

# Time vectors (in microseconds for readability)
t_in = np.arange(len(x)) / fs_in * 1e6
t_out = np.arange(len(y)) / (fs_in / R) * 1e6

plt.figure(figsize=(12, 6))

# Plot input
plt.subplot(2, 1, 1)
plt.plot(t_in, x, label='Input (6 MHz)')
plt.title('CIC Input Signal')
plt.xlabel('Time [µs]')
plt.ylabel('Amplitude')
plt.grid(True)

# Plot output
plt.subplot(2, 1, 2)
plt.plot(t_out, y, label=f'Output ({fs_in/R/1e6:.3f} MHz)', color='orange')
plt.title(f'CIC Output Signal (Decimated by R={R})')
plt.xlabel('Time [µs]')
plt.ylabel('Amplitude')
plt.grid(True)

plt.tight_layout()
plt.show()