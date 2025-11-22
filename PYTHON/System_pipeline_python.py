import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import lfilter, freqz

# --------------------------- Helpers ---------------------------
# --------------------- Fixed-point helper ---------------------
class FixedPoint:
    """Simple fixed-point helper supporting signed two's-complement
    representation with convergent (ties-to-even) rounding and saturation.


    Attributes
    ----------
    w : int
    Word length in bits (including sign)
    f : int
    Fractional bits
    """
    def __init__(self, w:int, f:int):
        assert w > f
        self.w = int(w)
        self.f = int(f)
        self.int_bits = w - f
        self.max_int = (1 << (w-1)) - 1
        self.min_int = - (1 << (w-1))


    def quantize(self, x):
        """Quantize numpy array or scalar x to fixed-point. Returns float value.
        Uses convergent rounding (numpy.round, ties to even) and saturation.
        """
        scale = 1 << self.f
        xr = np.round(np.array(x) * scale) / scale # ties-to-even
        # saturate
        xr = np.where(xr > self.max_float(), self.max_float(), xr)
        xr = np.where(xr < self.min_float(), self.min_float(), xr)
        return xr.astype(float)


    def max_float(self):
        return self.max_int / float(1 << self.f)


    def min_float(self):
        return self.min_int / float(1 << self.f)


    def to_twos_hex(self, x):
        """Return hexadecimal two's complement string for scalar x (float or int rep).
        """
        # quantize then get integer representation
        scale = 1 << self.f
        xi = int(np.round(float(x) * scale))
        # saturate integer
        xi = max(min(xi, self.max_int), self.min_int)
        if xi < 0:
            xi = (1 << self.w) + xi
        hex_width = np.ceil(self.w / 4)
        return format(xi & ((1<<self.w)-1), '0{}X'.format(hex_width))


    def float_to_int(self, x):
        scale = 1 << self.f
        xi = int(np.round(float(x) * scale))
        xi = max(min(xi, self.max_int), self.min_int)
        return xi


    def int_to_float(self, xi:int):
        if xi & (1 << (self.w-1)):
            xi = xi - (1 << self.w)
        return float(xi) / float(1 << self.f)

def twos_complement(val, bits=20):
    """Convert an integer in two's complement to signed int."""
    if val & (1 << (bits - 1)):
        val -= 1 << bits
    return val

def hex_to_s20_18_array(hex_array):
    """Convert hex coefficients to float in s20.18 format."""
    return np.array([twos_complement(h) / 2**18 for h in hex_array], dtype=np.float64)

# --------------------------- System Parameters ---------------------------

Fs = 9e6
N = 48000
t = np.arange(N) / Fs

# Original 100 kHz tone
f_sig = 1e5
x_clean = 0.25 * np.sin(2 * np.pi * f_sig * t)

# Interferences: 2.4 MHz and 5 MHz
f_intf = [2.4e6, 5e6]
A_intf = [0.2, 0.2]

intf_signal = A_intf[0]*np.sin(2*np.pi*f_intf[0]*t) + A_intf[1]*np.sin(2*np.pi*f_intf[1]*t)
x_noisy = x_clean + intf_signal

# quantize inputs to s16.15
in_q = FixedPoint(16,15)
x_quantized_clean = in_q.quantize(x_clean)
x_quantized_noisy = in_q.quantize(x_noisy)

signal_power_before = np.mean(x_clean**2)
intf_only = x_noisy - x_clean
interference_power_before = np.mean(intf_only**2)
if interference_power_before == 0:
    print('SIR Before filters: Infinite (no interference)')
else:
    SIR_dB_before = 10*np.log10(signal_power_before / interference_power_before)
    print(f'SIR Before filters = {SIR_dB_before:.2f} dB')

# --------------------------- Fractional Decimator (L=2, M=3) ---------------------------

# Simple FIR fractional decimator using polyphase (coeffs from MATLAB)
frac_dec_coeffs_hex = [
    0xfff76,0xffcac,0xffada,0xfff7d,0x00309,0xffe7b,0xffe50,0x00341,
    0xffede,0xffd19,0x0044f,0xfff5e,0xffb2b,0x005a7,0x0006b,0xff873,
    0x0071e,0x00246,0xff4c4,0x00898,0x0054b,0xfefcc,0x00a01,0x00a1c,
    0xfe8d4,0x00b42,0x01214,0xfde19,0x00c46,0x02101,0xfc9d4,0x00cfe,
    0x047c8,0xf8a18,0x00d5d,0x22d87,0x22d87,0x00d5d,0xf8a18,0x047c8,
    0x00cfe,0xfc9d4,0x02101,0x00c46,0xfde19,0x01214,0x00b42,0xfe8d4,
    0x00a1c,0x00a01,0xfefcc,0x0054b,0x00898,0xff4c4,0x00246,0x0071e,
    0xff873,0x0006b,0x005a7,0xffb2b,0xfff5e,0x0044f,0xffd19,0xffede,
    0x00341,0xffe50,0xffe7b,0x00309,0xfff7d,0xffada,0xffcac,0xfff76
]

frac_dec_coeffs = hex_to_s20_18_array(frac_dec_coeffs_hex)
L, M = 2, 3  # Interpolation, Decimation

# Upsample by L, then filter, then downsample by M
def fixed_point_fir_frac_dec(x, coeffs_hex, L=2, M=3, w=20, f=18):
    """
    Fractional decimator using s20.18 coefficients (fixed-point).
    x         : input signal (float or already quantized)
    coeffs_hex: hex coefficients (s20.18)
    L, M      : interpolation and decimation factors
    w, f      : fixed-point word/fraction bits
    """
    # Convert input to int
    scale = 1 << f
    x_int = np.round(np.array(x) * scale).astype(np.int64)
    
    # Convert coefficients to int
    b_int = np.array([twos_complement(h, w) for h in coeffs_hex], dtype=np.int64)

    # Upsample by L
    x_up = np.zeros(len(x_int)*L, dtype=np.int64)
    x_up[::L] = x_int

    # FIR filtering in integer arithmetic
    y_filt = np.zeros_like(x_up, dtype=np.int64)
    for n in range(len(x_up)):
        acc = 0
        for k in range(len(b_int)):
            if n - k >= 0:
                acc += b_int[k] * x_up[n - k]
        # Scale back to s20.18 (avoid overflow: shift right by f bits)
        y_filt[n] = acc >> f  

    # Downsample by M
    y_ds = y_filt[::M]

    # Convert back to float
    y_out = y_ds.astype(float) / scale
    return y_out

y_frac_noisy = fixed_point_fir_frac_dec(x_quantized_noisy, frac_dec_coeffs_hex, L, M)
y_frac_clean = fixed_point_fir_frac_dec(x_quantized_clean, frac_dec_coeffs_hex, L, M)
Fs_frac = Fs * L / M
t_frac = np.arange(len(y_frac_noisy)) / Fs_frac

# --------------------------- IIR Filters (Cascaded) ---------------------------
def fixed_point_iir(x, b_hex, a_hex, w=20, f=18):
    b_int = np.array([twos_complement(h,w) for h in b_hex], dtype=np.int64)
    a_int = np.array([twos_complement(h,w) for h in a_hex], dtype=np.int64)
    y_prev = np.zeros(len(a_int)-1, dtype=np.int64)
    x_prev = np.zeros(len(b_int)-1, dtype=np.int64)
    y_out = np.zeros(len(x), dtype=np.int64)
    scale = 1 << f
    
    # input in s20.18 int
    x_int = np.round(np.clip(x, -1.0, (scale-1)/scale) * scale).astype(np.int64)
    
    for n in range(len(x)):
        acc = b_int[0] * x_int[n]
        # FIR part
        for i in range(1, len(b_int)):
            if n - i >= 0:
                acc += b_int[i] * x_int[n-i]
        # IIR part
        for i in range(1, len(a_int)):
            acc -= a_int[i] * y_prev[i-1]
        # Shift back to s20.18
        acc_shifted = acc >> f
        # Saturate
        acc_shifted = max(min(acc_shifted, (1 << (w-1))-1), -(1 << (w-1)))
        # store output
        y_out[n] = acc_shifted
        # update y_prev
        if len(y_prev) > 0:
            y_prev = np.roll(y_prev, 1)
            y_prev[0] = acc_shifted
    # convert to float
    return y_out / scale


# Apply cascaded IIR: 2.4 MHz -> 1 MHz -> 2 MHz
# 2.4 MHz
y_2_4_noisy = fixed_point_iir(y_frac_noisy,
                              [0x37061,0x5907c,0x37061],
                              [0x40000,0x5907c,0x2e0c3])

y_2_4_clean = fixed_point_iir(y_frac_clean,
                              [0x37061,0x5907c,0x37061],
                              [0x40000,0x5907c,0x2e0c3])

# 1 MHz
y_1_noisy = fixed_point_iir(y_2_4_noisy,
                            [0x37061,0xC8F9F,0x37061],
                            [0x40000,0xC8F9F,0x2e0c3])

y_1_clean = fixed_point_iir(y_2_4_clean,
                            [0x37061,0xC8F9F,0x37061],
                            [0x40000,0xC8F9F,0x2e0c3])
# 2 MHz
y_2_noisy = fixed_point_iir(y_1_noisy,
                            [0x37061,0x37061,0x37061],
                            [0x40000,0x37061,0x2e0c3])

y_2_clean = fixed_point_iir(y_1_clean,
                            [0x37061,0x37061,0x37061],
                            [0x40000,0x37061,0x2e0c3])


# Section 8: post-filtering SIR
idx0 = 80
y1 = y_2_noisy[idx0:]
y2 = y_2_clean[idx0:]
# alignment using cross-correlation based delay estimate
# simple scaling factor
c = np.sum(y1 * y2) / np.sum(y2**2)
y2_aligned = y2 * c
remaining_intf = y1 - y2_aligned
signal_power_after = np.mean(y1**2)
interference_power_after = np.mean(remaining_intf**2)
print(f'signal_power_after = {signal_power_after:.14f}')
print(f'interference_power_after = {interference_power_after:.14f}')
if interference_power_after == 0:
    print('SIR After filters: Infinite (no interference)')
else:
    SIR_dB_after = 10*np.log10(signal_power_after / interference_power_after)
    print(f'SIR After filters = {SIR_dB_after:.2f} dB')
if interference_power_before != 0 and interference_power_after != 0:
    print(f'SIR Improvement = {SIR_dB_after - SIR_dB_before:.2f} dB')

# --------------------------- CIC Filter ---------------------------

# Simple integrator-comb CIC filter
def fixed_point_cic(x, R=16, N=1, w=20, f=18):
    """
    Fixed-point CIC filter with proper decimation and integer arithmetic.
    """
    scale = 1 << f
    x_int = np.round(np.array(x) * scale).astype(np.int64)

    # N-stage integrator
    y = x_int.copy()
    for _ in range(N):
        y = np.cumsum(y)
        # optional saturation if you want to simulate real hardware:
        # y = np.clip(y, -(1<<(w-1)), (1<<(w-1))-1)

    # Downsample
    y = y[::R]

    # N-stage comb
    for _ in range(N):
        y = np.diff(y, prepend=0)

    # scale back to float
    y_out = y.astype(float) / scale
    return y_out


R, N_cic = 16, 1
y_cic_noisy = fixed_point_cic(y_2_noisy, R, N_cic)
y_cic_clean = fixed_point_cic(y_2_clean, R, N_cic)
Fs_cic = Fs_frac / R
t_cic = np.arange(len(y_cic_noisy)) / Fs_cic

# --------------------------- Plots ---------------------------

def plot_signal_time_freq(y, Fs, title_prefix):
    plt.figure(figsize=(16,6))
    plt.subplot(1,2,1)
    plt.plot(np.arange(len(y))/Fs, y)
    plt.title(f'{title_prefix} (Time Domain)')
    plt.xlabel('Time (s)')
    plt.ylabel('Amplitude')

    plt.subplot(1,2,2)
    Yf = np.fft.fftshift(np.fft.fft(y))
    f_axis = np.linspace(-Fs/2, Fs/2, len(Yf))
    plt.plot(f_axis/1e6, np.abs(Yf), 'r')
    plt.title(f'{title_prefix} (Frequency Domain)')
    plt.xlabel('Frequency (MHz)')
    plt.ylabel('Magnitude')
    plt.tight_layout()

# Plot at each stage
plot_signal_time_freq(x_quantized_noisy, Fs, "Original Noisy Signal")
plot_signal_time_freq(y_frac_noisy, Fs_frac, "After Fractional Decimator")
plot_signal_time_freq(y_2_4_noisy, Fs_frac, "After 2.4 MHz Notch")
plot_signal_time_freq(y_1_noisy, Fs_frac, "After 1 MHz Notch")
plot_signal_time_freq(y_2_noisy, Fs_frac, "After 2 MHz Notch")
plot_signal_time_freq(y_cic_noisy, Fs_cic, "After CIC Filter")



# Convert float array (-1.0 to ~0.99997) to s16.15 binary string
def write_s16_15_bin(signal, filename):
    """
    Write a signal to a file as 16-bit binary.
    - If the signal is float, convert to s16.15 binary first.
    - If the signal is int16, write directly as 2's complement binary.
    """
    import numpy as np
    
    if np.issubdtype(signal.dtype, np.floating):
        # Saturate to [-1, 0.999969482421875]
        signal_sat = np.clip(signal, -1.0, 0.999969482421875)
        # Convert to signed 16-bit integer (s16.15)
        int_signal = np.round(signal_sat * (2**15)).astype(np.int16)
    elif np.issubdtype(signal.dtype, np.integer):
        # Already int16 or similar
        int_signal = signal.astype(np.int16)
    else:
        raise TypeError("Signal must be float or int16/uint16 array")
    
    # Convert to unsigned for proper 2's complement binary formatting
    uint_signal = int_signal.astype(np.uint16)
    
    # Convert to 16-bit binary strings
    bin_signal = [format(x, '016b') for x in uint_signal]
    
    # Write to file
    with open(filename, 'w') as f:
        for b in bin_signal:
            f.write(b + '\n')

write_s16_15_bin(x_quantized_noisy, "input_signal.txt")   # final output after CIC
write_s16_15_bin(y_cic_noisy, "output_signal.txt")   # final output after CIC