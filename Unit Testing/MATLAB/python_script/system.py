import numpy as np
import os

# Ensure output directory exists
os.makedirs("outputs", exist_ok=True)

# Helper functions for fixed-point arithmetic

def round_convergent(value, shift):
    """
    Round 'value' to nearest with ties to even, by right-shifting 'shift' bits.
    Operates on an integer 'value'. Returns the rounded integer.
    """
    if shift <= 0:
        return value
    sign = 1
    if value < 0:
        sign = -1
        value = -value
    half = 1 << (shift - 1)  # half-unit for rounding
    extra = value & ((1 << shift) - 1)  # remainder bits
    integer_part = value >> shift
    # Apply rounding decision
    if extra > half:
        integer_part += 1
    elif extra == half:
        # Tie: round to even
        if integer_part & 1:
            integer_part += 1
    return sign * integer_part

def saturate_int16(val):
    """Saturate an integer to signed 16-bit range (-32768..32767)."""
    if val >  32767: return 32767
    if val < -32768: return -32768
    return val

# 1. Generate Input Signal

fs = 9_000_000  # Sampling rate: 9 MHz
N = 48000       # Number of samples
t = np.arange(N) / fs
# Frequencies in Hz
f_desired = 100e3
f_int1 = 2.4e6
f_int2 = 5e6

# Create the continuous-time signals (floating point)
sig = np.sin(2*np.pi*f_desired*t) + np.sin(2*np.pi*f_int1*t) + np.sin(2*np.pi*f_int2*t)

# 2. Quantize to s16.15 fixed-point (Q15)
# Multiply by 2^15, round-to-nearest (ties-to-even), then saturate to int16 range.
x_int = []
for v in sig:
    fixed_val = round_convergent(int(np.round(v * (1<<15))), 0)  # initial round to integer
    fixed_val = saturate_int16(fixed_val)
    x_int.append(fixed_val)
# Now x_int is a list of int16 values (s16.15) representing the input signal.

# 3. Fractional Decimation (Interp=2, Decim=3) with a 72-tap FIR filter
# FIR coefficients (s20.18) provided by user as 72 hex values (placeholder example here).
# Assume 'fir_coeffs_hex' list of 72 strings like '0x12345...'
fir_coeffs_hex = [
'fff76',
'ffcac',
'ffada',
'fff7d',
'00309',
'ffe7b',
'ffe50',
'00341',
'ffede',
'ffd19',
'0044f',
'fff5e',
'ffb2b',
'005a7',
'0006b',
'ff873',
'0071e',
'00246',
'ff4c4',
'00898',
'0054b',
'fefcc',
'00a01',
'00a1c',
'fe8d4',
'00b42',
'01214',
'fde19',
'00c46',
'02101',
'fc9d4',
'00cfe',
'047c8',
'f8a18',
'00d5d',
'22d87',
'22d87',
'00d5d',
'f8a18',
'047c8',
'00cfe',
'fc9d4',
'02101',
'00c46',
'fde19',
'01214',
'00b42',
'fe8d4',
'00a1c',
'00a01',
'fefcc',
'0054b',
'00898',
'ff4c4',
'00246',
'0071e',
'ff873',
'0006b',
'005a7',
'ffb2b',
'fff5e',
'0044f',
'ffd19',
'ffede',
'00341',
'ffe50',
'ffe7b',
'00309',
'fff7d',
'ffada',
'ffcac',
'fff76']
# Convert hex coefficients to integers (s20.18 format)
h = [int(hx, 16) for hx in fir_coeffs_hex]  # each is signed 20-bit with 18 frac bits

# Upsample by 2: insert zeros between samples
x_up = [0]*(2*N)
for i, sample in enumerate(x_int):
    x_up[2*i] = sample  # actual sample at even indices; odd indices remain 0

# Apply FIR filter to upsampled signal (direct convolution, then decimate)
num_taps = len(h)  # should be 72
y_frac_int = []  # output of fractional decimation (int16)

# For each output sample k of the decimated sequence:
#   original upsampled index = n = 3*k
for k in range(int(np.ceil((2*N) / 3))):
    n = 3 * k
    acc = 0
    # Compute convolution sum: sum_{i=0..num_taps-1} h[i] * x_up[n-i], if indices valid
    for i in range(num_taps):
        j = n - i
        if j < 0 or j >= len(x_up):
            continue
        val = x_up[j]  # sample value (already 0 if j is odd index as we set above)
        if val == 0:
            # If upsampled index is odd, x_up[j] is 0; skip multiplication
            continue
        # Multiply-coefficient: h[i] (s20.18) * val (s16.15) => product is s(20+16).(18+15) = s36.33
        acc += h[i] * val
    # Now 'acc' is in s36.33 format (roughly, but we'll treat it as scaled int).
    # Convert back to s16.15: shift right by 18 (subtracting frac bits), with rounding:
    y_q15 = round_convergent(acc, 18)
    # Saturate to signed 16-bit
    y_q15 = saturate_int16(y_q15)
    y_frac_int.append(y_q15)

# Convert FIR output to floating-point for export: divide by 2^15
y_frac_fp = [val / float(1<<15) for val in y_frac_int]

# 4. Three IIR Notch Filters (DF-II Transposed, single-section)

# IIR filter coefficient blocks (b0, b1, b2, a1, a2) in s20.18 and a scale factor in s20.18.
# Values provided as hex (from user instructions):
iir2p4_coefs = [0x40000, 0x678de, 0x40000, 0x5907c, 0x2e0c3]  # 2.4 MHz notch
scale2p4 = 0x37061
iir2_coefs  = [0x40000, 0x40000, 0x40000, 0x37061, 0x2e0c3]  # 2.0 MHz notch
scale2     = 0x37061
iir1_coefs  = [0x40000, 0xc0000, 0x40000, 0xc8f9f, 0x2e0c3]  # 1.0 MHz notch
scale1     = 0x37061

# Helper function to apply one biquad section in Direct Form II Transposed
def iir_df2t_section(x_in, b_coef, a_coef, scale):
    """
    Applies one biquad (single section) to an input list x_in (s16.15 integers).
    b_coef: [b0, b1, b2], a_coef: [a1, a2], all in s20.18 integers.
    scale: overall stage scale in s20.18.
    Returns a list of output samples (s16.15 ints).
    """
    state1 = 0  # s38.33 internal state
    state2 = 0  # s38.33 internal state
    b0, b1, b2 = b_coef
    a1, a2 = a_coef
    y_out = []
    for x_n in x_in:
        # Multiply and accumulate for output
        # b0*x + state1 (state1 is s38.33, b0*x is s36.33 -> align to Q33 by no shift needed, as described)
        p0 = b0 * x_n         # s36.33
        y_acc = state1 + p0  # s38.33 (both operands effectively Q33)
        # Convert to s16.15 with rounding
        y_int = round_convergent(y_acc, 18)
        # Apply overall scale (s20.18 * s16.15 -> s36.33)
        scaled = scale * y_int  # s36.33
        # Shift back to s16.15
        y_scaled = round_convergent(scaled, 18)
        # Saturate output to int16
        y_scaled = saturate_int16(y_scaled)
        y_out.append(y_scaled)
        # Feedback to update states (use y_scaled in place of y[n])
        Q1 = a1 * y_scaled   # s36.33
        Q2 = a2 * y_scaled   # s36.33
        p1 = b1 * x_n       # s36.33
        p2 = b2 * x_n       # s36.33
        # Update states (still s38.33 after aligning; but p1, Q1 are 36.33, state2 was 38.33)
        # To align for addition/subtraction, we simply treat all as Q33 (effectively no shift needed in representation).
        state1 = state2 + p1 - Q1
        state2 = p2 - Q2
        # (States remain in high precision, but we keep them as Python ints.)
    return y_out

# Apply the three IIR stages sequentially
notch24_int = iir_df2t_section(y_frac_int, iir2p4_coefs[:3], iir2p4_coefs[3:], scale2p4)
notch2_int  = iir_df2t_section(notch24_int, iir2_coefs[:3],  iir2_coefs[3:],  scale2)
notch1_int  = iir_df2t_section(notch2_int,  iir1_coefs[:3],  iir1_coefs[3:],  scale1)

# Convert each notch output to floating-point lists
notch24_fp = [val / float(1<<15) for val in notch24_int]
notch2_fp  = [val / float(1<<15) for val in notch2_int]
notch1_fp  = [val / float(1<<15) for val in notch1_int]

# 5. CIC Decimation (Decimation=2, Differential Delay=1, Sections=1)

# Perform 1st-order integrator with saturation (s16.15 accumulates in 16-bit, though could overflow)
cic_integrator = 0
integrator_out = []
for sample in notch1_int:
    cic_integrator = saturate_int16(cic_integrator + sample)
    integrator_out.append(cic_integrator)
# Downsample by 2: pick every 2nd sample (starting with index 1 for the comb)
decimated = integrator_out[1::2]

# Comb (differentiator) with delay=1
cic_out_int = []
prev = 0
for val in decimated:
    diff = saturate_int16(val - prev)
    cic_out_int.append(diff)
    prev = val
# Convert CIC output to float
cic_out_fp = [val / float(1<<15) for val in cic_out_int]

# 6. Export intermediate outputs to text files (floating-point, int, binary)

def write_output(data_int, filepath_base):
    """
    Writes three files for the given data list of int16:
     - <name>_fp.txt: floating point values (one per line)
     - <name>_int.txt: integer values (one per line)
     - <name>_bin.txt: binary strings of 16 bits (two's complement)
    """
    # Floating-point file
    with open(f"{filepath_base}_fp.txt", "w") as f_fp:
        for val in data_int:
            f_fp.write(f"{val/float(1<<15):.6f}\n")
    # Integer file
    with open(f"{filepath_base}_int.txt", "w") as f_int:
        for val in data_int:
            f_int.write(f"{val}\n")
    # Binary file (2's complement 16-bit)
    with open(f"{filepath_base}_bin.txt", "w") as f_bin:
        for val in data_int:
            # Convert to unsigned 16-bit representation for formatting
            if val < 0:
                val = (1<<16) + val
            binstr = format(val, '016b')
            f_bin.write(f"{binstr}\n")

# Write outputs for each stage
write_output(y_frac_int,  "outputs/fracdecim")
write_output(notch24_int, "outputs/notch2p4MHz")
write_output(notch2_int,  "outputs/notch2MHz")
write_output(notch1_int,  "outputs/notch1MHz")
write_output(cic_out_int, "outputs/cic")
