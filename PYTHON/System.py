import numpy as np
from scipy import signal

# -----------------------------
# 1. PARAMETERS & SIGNALS
# -----------------------------
Fs = 9e6
N = 48000
f_sig = 1e5
t = np.arange(N) / Fs

# Clean signal
x_real_clean = 0.25 * np.sin(2 * np.pi * f_sig * t)

# Interference
f_intf_2_4 = 2.4e6
f_intf_5 = 5e6
A_intf_2_4 = 0.2
A_intf_5 = 0.2

intf1 = A_intf_2_4 * np.sin(2 * np.pi * f_intf_2_4 * t)
intf2 = A_intf_5 * np.sin(2 * np.pi * f_intf_5 * t)
interference = intf1 + intf2

x_real_noisy = x_real_clean + interference

# -----------------------------
# 2. FIXED-POINT QUANTIZATION (s16.15)
# -----------------------------
def float_to_q15(x):
    raw = np.floor(x * (2**15) + 0.5).astype(np.int64)
    raw = np.clip(raw, -2**15, 2**15-1)
    return raw.astype(np.int16)

x_quantized_noisy = float_to_q15(x_real_noisy)

# -----------------------------
# 3. FRACTIONAL DECIMATOR
# -----------------------------
# Example: Interpolation=2, Decimation=3, with some example FIR Q18 coefficients
# Replace with your actual MATLAB coefficients
hex_coef = [
    "fff76","ffcac","ffada","fff7d","00309","ffe7b","ffe50","00341",
    "ffede","ffd19","0044f","fff5e","ffb2b","005a7","0006b","ff873",
    "0071e","00246","ff4c4","00898","0054b","fefcc","00a01","00a1c",
    "fe8d4","00b42","01214","fde19","00c46","02101","fc9d4","00cfe",
    "047c8","f8a18","00d5d","22d87","22d87","00d5d","f8a18","047c8",
    "00cfe","fc9d4","02101","00c46","fde19","01214","00b42","fe8d4",
    "00a1c","00a01","fefcc","0054b","00898","ff4c4","00246","0071e",
    "ff873","0006b","005a7","ffb2b","fff5e","0044f","ffd19","ffede",
    "00341","ffe50","ffe7b","00309","fff7d","ffada","ffcac","fff76"
]

def hex20_to_int(h):
    val = int(h,16)
    if val & (1<<19):
        val -= 1<<20
    return val

b = np.array([hex20_to_int(h) for h in hex_coef], dtype=np.int64)

# Apply fractional FIR decimator (polyphase upfirdn)
y_frac_noisy = signal.upfirdn(b, x_quantized_noisy.astype(np.int64), up=2, down=3)

# Convert back to Q15
def round_sat_q15(arr):
    out = np.zeros_like(arr, dtype=np.int16)
    half = 1 << 17
    mask = (1 << 18) - 1
    for i, v in enumerate(arr):
        v = int(v)
        sign = 1
        if v < 0:
            sign = -1
            v = -v
        int_part = v >> 18
        frac = v & mask
        if frac > half or (frac == half and (int_part & 1)):
            int_part += 1
        val = sign * int_part
        val = max(min(val, 2**15-1), -2**15)
        out[i] = np.int16(val)
    return out

y_frac_noisy = round_sat_q15(y_frac_noisy)

# -----------------------------
# 4. IIR NOTCH FILTERS
# -----------------------------
def hex_signed20(val):
    return val-(1<<20) if val&(1<<19) else val

def int_iir_q15(x_int,b_coeff,a_coeff,q_frac=18):
    N = len(x_int)
    y = np.zeros(N, dtype=np.int64)
    x_state = np.zeros(len(b_coeff), dtype=np.int64)
    y_state = np.zeros(len(a_coeff)-1, dtype=np.int64)
    for n in range(N):
        x_state = np.roll(x_state,1)
        x_state[0] = x_int[n]
        acc = 0
        for k in range(len(b_coeff)):
            acc += b_coeff[k]*x_state[k]
        for k in range(1,len(a_coeff)):
            acc -= a_coeff[k]*y_state[k-1]
        acc = (acc + (1<<(q_frac-1))) >> q_frac
        acc = max(min(acc, 2**15-1), -2**15)
        y_state = np.roll(y_state,1)
        y_state[0] = acc
        y[n] = acc
    return y.astype(np.int16)

# Example IIR 2.4 MHz notch (replace with actual coefficients)
num_24 = [hex_signed20(0x37061), hex_signed20(0x5907c), hex_signed20(0x37061)]
den_24 = [hex_signed20(0x40000), hex_signed20(0x5907c), hex_signed20(0x2e0c3)]
y_2_4_noisy = int_iir_q15(y_frac_noisy.astype(np.int64), num_24, den_24)

# Example IIR cascade for 5 MHz (replace with actual coefficients)
num1 = [hex_signed20(0x37061), hex_signed20(0xc8f9f), hex_signed20(0x37061)]
den1 = [hex_signed20(0x40000), hex_signed20(0xc8f9f), hex_signed20(0x2e0c3)]
num2 = [hex_signed20(0x37061), hex_signed20(0x37061), hex_signed20(0x37061)]
den2 = [hex_signed20(0x40000), hex_signed20(0x37061), hex_signed20(0x2e0c3)]

y_filtered_1 = int_iir_q15(y_2_4_noisy.astype(np.int64), num1, den1)
y_filtered = int_iir_q15(y_filtered_1.astype(np.int64), num2, den2)

# -----------------------------
# 5. CIC DECIMATOR
# -----------------------------
def cic_decimate_q15(x_int, R):
    integrator = np.cumsum(x_int, dtype=np.int64)
    y_int = integrator[::R]
    y_out = np.zeros_like(y_int)
    y_out[0] = y_int[0]
    y_out[1:] = y_int[1:] - y_int[:-1]
    return np.clip(y_out, -2**15, 2**15-1).astype(np.int16)

y_cic = cic_decimate_q15(y_filtered.astype(np.int64), 16)

# -----------------------------
# 6. WRITE INPUT & OUTPUT
# -----------------------------

with open('input_noisy.txt', 'w') as f_in:
    for v in x_quantized_noisy:
        v_int = int(v)  # convert numpy int16 to Python int
        # format as 16-bit binary string
        f_in.write(format(v_int & 0xFFFF, '016b') + '\n')

with open('output_cic.txt', 'w') as f:
    for v in y_cic:
        f.write(format(int(v)&0xFFFF,'016b')+'\n')
