def saturate_to_int16(x):
    """Saturate integer x to signed 16-bit range [-32768, 32767]."""
    if x > 0x7FFF:
        return 0x7FFF
    if x < -0x8000:
        return -0x8000
    return int(x)


def round_ties_to_even(x, frac_bits):
    """
    Perform round-to-nearest (ties to even) on integer x shifting right by frac_bits.
    Returns signed integer truncated with 16-bit saturation applied by caller.
    """
    if frac_bits <= 0:
        # No fractional bits: no rounding needed
        return x

    sign = -1 if x < 0 else 1
    abs_x = abs(x)

    # Extract bits for rounding
    guard = (abs_x >> (frac_bits - 1)) & 1
    round_bit = (abs_x >> (frac_bits - 2)) & 1 if frac_bits >= 2 else 0
    # Sticky bit: OR of all less significant bits
    if frac_bits > 2:
        mask = (1 << (frac_bits - 2)) - 1
        sticky = 1 if (abs_x & mask) != 0 else 0
    else:
        sticky = 0

    # Raw truncated result (floor division for positive)
    raw = abs_x >> frac_bits
    # Ties-to-even increment condition
    if guard and (round_bit or sticky or (raw & 1)):
        raw += 1

    result = sign * raw
    return result

# Example parsing (adjust format to actual file layout)
fir_taps = []
iir_sections = []  # List of dicts with b[], a[], scale
with open("Matlab_FixedPoint_Filter_Coeffs.txt", "r") as f:
    for line in f:
        line = line.strip()
        # Skip blanks/comments
        if not line or line.startswith("#"):
            continue
        # Detect sections by header keywords
        if line.startswith("FIR"):
            # Next lines contain 72 hex values, one per line or space-separated
            # This is a placeholder; actual parsing depends on file format.
            continue
        # Example: lines like "0x1234ABCD"
        if line.startswith("0x") or line.startswith("-0x"):
            val = int(line, 16)  # Python handles sign in hex
            fir_taps.append(val)
        # Similarly parse IIR SOS coefficients and scale...
        # Here we just outline the process:
        if line.startswith("Notch"):
            parts = line.split()
            if parts[0] == "Notch":
                # parts: ["Notch", "1MHz", "b0=0x...", ... "scale=0x..."]
                # Extract hex values and store in iir_sections
                sec = {"b":[], "a":[], "scale": 1}
                for token in parts[2:]:
                    key,val = token.split('=')
                    val_int = int(val, 16)
                    if key.startswith("b"):
                        sec["b"].append(val_int)
                    elif key.startswith("a"):
                        sec["a"].append(val_int)
                    elif key == "scale":
                        sec["scale"] = val_int
                iir_sections.append(sec)
# Placeholder: if no file, one might manually define example coefficients, e.g.:
# fir_taps = [0x1234, 0xABCD, ...]  # 72 entries
# iir_sections = [{"b":[...], "a":[..., ...], "scale": ...}, ...]

def fir_fractional_decimator(x_in, coeffs):
    """
    Perform fractional decimation: interpolate by 2, filter, then decimate by 3.
    x_in: list of Q15 integers (signed 16-bit).
    coeffs: list of 72 integers (Q20.18 fixed-point).
    Returns list of Q15 integers (after decimation).
    """
    # Step 1: Upsample by 2 (zero insertion)
    up = []
    for sample in x_in:
        up.append(sample)  # actual sample
        up.append(0)  # inserted zero

    # Step 2: FIR convolution (integer arithmetic)
    N = len(coeffs)
    # Compute convolution length = len(up) + N - 1
    conv_len = len(up) + N - 1
    conv = [0] * conv_len
    for i in range(conv_len):
        acc = 0
        # Convolve: sum up * coeff
        for k in range(N):
            if 0 <= i - k < len(up):
                prod = up[i - k] * coeffs[k]  # Q15 * Q18 => Q33
                acc += prod
        # Now acc is Q33 (since 15+18=33 fractional bits).
        # Convert to Q15 by shifting (33-15=18 bits), with rounding.
        acc_rounded = round_ties_to_even(acc, 18)
        # Saturate to 16 bits
        acc_sat = saturate_to_int16(acc_rounded)
        conv[i] = acc_sat

    # Step 3: Decimate by 3
    # Choose offset = 0 (i.e., take indices 0,3,6,...). Adjust if needed.
    out = conv[0:conv_len:3]
    return out

# Example usage:
# x_input = [...]  # input Q15 samples
# y_fir = fir_fractional_decimator(x_input, fir_taps)

def apply_notch_filter(x_in, b, a, scale):
    """
    Apply a single SOS notch filter to input x_in.
    b: [b0, b1, b2] (Q20.18 ints), a: [a1, a2] (Q20.18 ints, a0 assumed 1),
    scale: Q20.18 int scale factor.
    Returns filtered output (list of Q15 ints).
    """
    # Initialize states (previous inputs/outputs)
    x_nm1 = 0  # x[n-1]
    x_nm2 = 0  # x[n-2]
    y_nm1 = 0  # y[n-1]
    y_nm2 = 0  # y[n-2]
    y_out = []
    for x_n in x_in:
        # Compute numerator part: b0*x[n] + b1*x[n-1] + b2*x[n-2]
        # Each product: Q15 * Q18 = Q33
        acc = b[0] * x_n
        acc += b[1] * x_nm1
        acc += b[2] * x_nm2
        # Subtract feedback: a1*y[n-1] + a2*y[n-2]
        # Note: a1,a2 are positive, we subtract their effect
        acc -= a[0] * y_nm1
        acc -= a[1] * y_nm2
        # Now apply scale (Q20.18): multiply by Q18 factor
        acc *= scale
        # Acc is now effectively Q(33+18)=Q51 fractional bits
        # Shift back to Q15: fractional bits to drop = 51-15 = 36
        acc_rounded = round_ties_to_even(acc, 36)
        acc_sat = saturate_to_int16(acc_rounded)

        # Output
        y = acc_sat
        y_out.append(y)
        # Update delays
        x_nm2 = x_nm1
        x_nm1 = x_n
        y_nm2 = y_nm1
        y_nm1 = y
    return y_out

# Example usage for each notch (assuming iir_sections list holds parsed data):
# y_notch1 = apply_notch_filter(y_fir, iir_sections[0]["b"], iir_sections[0]["a"], iir_sections[0]["scale"])


# Cascade the three notch filters:
y_notch1 = apply_notch_filter(y_fir, iir_sections[0]["b"], iir_sections[0]["a"], iir_sections[0]["scale"])
y_notch2 = apply_notch_filter(y_notch1, iir_sections[1]["b"], iir_sections[1]["a"], iir_sections[1]["scale"])
y_notch3 = apply_notch_filter(y_notch2, iir_sections[2]["b"], iir_sections[2]["a"], iir_sections[2]["scale"])

def cic_decimator(x_in):
    """
    Single-section CIC decimator (R=2, M=1). Both integrator and comb use Q15 saturation.
    x_in: list of Q15 ints.
    Returns decimated output (list of Q15 ints).
    """
    integrator = 0
    prev_int = 0
    y_out = []
    for idx, x_n in enumerate(x_in):
        # Accumulate with saturation
        integrator = saturate_to_int16(integrator + x_n)
        # Decimate by 2: output on every second sample (idx starting at 0)
        if idx % 2 == 1:
            diff = integrator - prev_int
            # Saturate diff to 16-bit
            diff_sat = saturate_to_int16(diff)
            y_out.append(diff_sat)
            prev_int = integrator
    return y_out

# Example usage:
# y_cic = cic_decimator(y_notch3)

import os

stages = {
    "fracdecim": y_fir,
    "notch1MHz": y_notch1,
    "notch2MHz": y_notch2,
    "notch2p4MHz": y_notch3,
    "cic": y_cic
}
os.makedirs("outputs", exist_ok=True)

for name, data_int in stages.items():
    # Floating-point file (divide integer by 2^15 for actual value)
    with open(f"outputs/{name}_fp.txt", "w") as f_fp:
        for val in data_int:
            f_fp.write(f"{val / 2**15:.6f}\n")
    # Integer file
    with open(f"outputs/{name}_int.txt", "w") as f_int:
        for val in data_int:
            f_int.write(f"{val}\n")
    # Binary file (16-bit two's complement)
    with open(f"outputs/{name}_bin.txt", "w") as f_bin:
        for val in data_int:
            # Python format for signed 16-bit: mask & format
            bin_str = format((val & 0xFFFF), '016b')
            f_bin.write(f"{bin_str}\n")
