"""
IIR Notch Filter - Python Implementation
Direct equivalent to MATLAB's iirnotch + dfilt.df2tsos

MATLAB Reference: IIR_1.m, IIR_2.m, IIR_2_4.m
- Uses Second-Order Sections (SOS) format
- Fixed-point: Q20.18 coeffs -> Q36.33 product -> Q38.33 accum -> Q16.15 output
- Convergent rounding and saturation

Author: Copilot
Date: December 15, 2025
"""

import numpy as np
from scipy import signal
from coeff_utils import load_coefficients


def convergent_round(x):
    """
    Convergent rounding (round-to-even) to match MATLAB's 'Convergent' rounding mode.
    Also known as banker's rounding or round-half-to-even.
    """
    rounded = np.round(x)
    # For values exactly at 0.5, round to nearest even
    halfway = np.abs(x - np.floor(x) - 0.5) < 1e-10
    is_odd = np.asarray((rounded % 2) != 0, dtype=bool)
    rounded = np.where(halfway & is_odd, rounded - np.sign(x), rounded)
    return rounded


def quantize_with_convergent_rounding(data, word_length, frac_length):
    """
    Quantize with convergent rounding and saturation to match MATLAB behavior.
    """
    scale = 2 ** frac_length
    max_positive = (2 ** (word_length - 1) - 1) / scale
    max_negative = -(2 ** (word_length - 1)) / scale

    # Saturate first
    data_clipped = np.clip(data, max_negative, max_positive)

    # Scale and apply convergent rounding
    scaled = data_clipped * scale
    rounded_int = convergent_round(scaled).astype(np.int64)

    # Apply integer saturation
    max_int = 2 ** (word_length - 1) - 1
    min_int = -(2 ** (word_length - 1))
    rounded_int = np.clip(rounded_int, min_int, max_int)

    # Convert back to floating-point
    return rounded_int / scale


def load_iir_coefficients(notch_freq):
    """
    Load IIR coefficients from file based on notch frequency.

    Args:
        notch_freq: Notch frequency in Hz (1000000, 2400000, or 5000000)

    Returns:
        sos: Second-order sections array [b0, b1, b2, a0, a1, a2]
    """
    # Map notch frequency to coefficient file
    freq_to_file = {
        2400000: 'iir_24_coeff.txt',      # 2.4 MHz notch
        1000000: 'iir_5_1_coeff.txt',     # 5 MHz stage 1 (1 MHz notch)
        2000000: 'iir_5_2_coeff.txt',     # 5 MHz stage 2 (2 MHz notch)
    }

    if notch_freq not in freq_to_file:
        raise ValueError(
            f"Unsupported notch frequency: {notch_freq} Hz. "
            f"Supported frequencies: {list(freq_to_file.keys())}"
        )

    coeff_file = freq_to_file[notch_freq]

    try:
        coeffs = load_coefficients(coeff_file)
    except FileNotFoundError:
        raise FileNotFoundError(
            f"Coefficient file '{coeff_file}' not found for notch frequency {notch_freq} Hz."
        )

    # Coefficients are stored as [b0, b1, b2, a0, a1, a2]
    # Convert to SOS format expected by scipy: [[b0, b1, b2, 1, a1, a2]]
    if len(coeffs) != 6:
        raise ValueError(f"Expected 6 coefficients, got {len(coeffs)}")

    b0, b1, b2, a0, a1, a2 = coeffs

    # Normalize by a0 (should be 1.0, but ensure it)
    b0 /= a0
    b1 /= a0
    b2 /= a0
    a1 /= a0
    a2 /= a0

    # SOS format: [b0, b1, b2, 1.0, a1, a2]
    sos = np.array([[b0, b1, b2, 1.0, a1, a2]])

    return sos


def sosfilt_fixed_point(sos, x):
    """
    Apply second-order sections filter with fixed-point arithmetic.

    This implements Direct Form II Transposed with convergent rounding
    at each multiply-accumulate step to match MATLAB's dfilt.df2tsos exactly.

    Args:
        sos: Second-order sections [b0, b1, b2, 1.0, a1, a2] (Q20.18)
        x: Input signal (Q16.15)

    Returns:
        y: Filtered output (Q16.15)
    """
    # Extract coefficients (already quantized to Q20.18)
    b0, b1, b2, _, a1, a2 = sos[0]

    # Initialize states (Q38.33 format)
    # MATLAB: StateWordLength=38, StateFracLength=33
    s1 = 0.0
    s2 = 0.0

    # Output array
    y = np.zeros(len(x))

    # Process each sample
    for n in range(len(x)):
        # Input (Q16.15)
        xn = x[n]

        # Direct Form II Transposed structure:
        # y[n] = b0*x[n] + s1
        # s1 = b1*x[n] - a1*y[n] + s2
        # s2 = b2*x[n] - a2*y[n]

        # Compute output: y[n] = b0*x[n] + s1
        # Product: Q16.15 * Q20.18 = Q36.33
        yn_prod = xn * b0  # Q36.33
        yn = yn_prod + s1   # Q38.33 (s1 is Q38.33)

        # Quantize output to Q16.15 with convergent rounding
        yn_q16 = quantize_with_convergent_rounding(np.array([yn]), word_length=16, frac_length=15)[0]
        y[n] = yn_q16

        # Update state s1: b1*x[n] - a1*y[n] + s2
        # Products are Q36.33
        prod_b1 = xn * b1
        prod_a1 = yn_q16 * a1

        # Accumulator: Q38.33
        s1_new = prod_b1 - prod_a1 + s2

        # Quantize state to Q38.33 with convergent rounding
        s1 = quantize_with_convergent_rounding(np.array([s1_new]), word_length=38, frac_length=33)[0]

        # Update state s2: b2*x[n] - a2*y[n]
        # Products are Q36.33
        prod_b2 = xn * b2
        prod_a2 = yn_q16 * a2

        # Accumulator: Q38.33
        s2_new = prod_b2 - prod_a2

        # Quantize state to Q38.33 with convergent rounding
        s2 = quantize_with_convergent_rounding(np.array([s2_new]), word_length=38, frac_length=33)[0]

    return y


def iir_notch_filter(input_sig, notch_freq, use_fixed_point=False):
    """
    Apply IIR notch filter to input signal.

    Matches MATLAB's iirnotch + dfilt.df2tsos behavior with fixed-point arithmetic.

    Args:
        input_sig: Input signal array (Q16.15 if use_fixed_point=True)
        notch_freq: Notch frequency in Hz (1000000, 2400000, or 5000000)
        use_fixed_point: If True, applies fixed-point quantization matching MATLAB

    Returns:
        output_sig: Filtered output signal (Q16.15 if use_fixed_point=True)

    Example:
        # 2.4 MHz notch filter with fixed-point
        output = iir_notch_filter(input_sig, notch_freq=2400000, use_fixed_point=True)

        # 5 MHz notch filter stage 1
        output = iir_notch_filter(input_sig, notch_freq=1000000, use_fixed_point=True)
    """
    # Load IIR coefficients in SOS format
    sos = load_iir_coefficients(notch_freq)

    if use_fixed_point:
        # MATLAB fixed-point configuration:
        # Coefficients: Q20.18 (numerictype([],20,18))
        # Quantize coefficients
        sos_quantized = quantize_with_convergent_rounding(sos, word_length=20, frac_length=18)

        # Input is already Q16.15 from system_run.py
        # Ensure input is properly quantized
        input_quantized = quantize_with_convergent_rounding(input_sig, word_length=16, frac_length=15)

        # Apply custom SOS filter with convergent rounding at each step
        # This matches MATLAB's dfilt.df2tsos exactly
        output_sig = sosfilt_fixed_point(sos_quantized, input_quantized)

    else:
        # Floating-point mode - use scipy's sosfilt directly
        output_sig = signal.sosfilt(sos, input_sig)

    return output_sig


# Convenience functions for specific notch frequencies
def iir_24mhz_filter(input_sig, use_fixed_point=False):
    """Apply 2.4 MHz notch filter"""
    return iir_notch_filter(input_sig, notch_freq=2400000, use_fixed_point=use_fixed_point)


def iir_5mhz_filter_stage_1(input_sig, use_fixed_point = False):
    """ Apply 5 MHz notch filter """
    return iir_notch_filter(input_sig, notch_freq=1000000, use_fixed_point=use_fixed_point)

def iir_5mhz_filter_stage_2(input_sig, use_fixed_point = False):
    """ Apply 5 MHz notch filter """
    return iir_notch_filter(input_sig, notch_freq=2000000, use_fixed_point=use_fixed_point)

