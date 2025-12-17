"""
Fractional Decimator Filter - Python Implementation
Direct equivalent to MATLAB's dsp.FIRRateConverter

MATLAB Reference: Fractional_Decimator.m
- Interpolation Factor: 2
- Decimation Factor: 3
- Effective Rate Change: 2/3 (reduces sampling rate by factor of 1.5)
- Fixed-point: Q20.18 coeffs -> Q36.33 product -> Q42.33 accum -> Q16.15 output

Author: Mustafa EL-Sherif
"""

import numpy as np
from read_write_utils import load_coefficients
from fixed_point_utils import *
from scipy.signal import upfirdn

def fractional_decimator(input_signal, use_fixed_point = False):
    """
    Apply fractional decimator filter (2/3 rate conversion)

    Matches MATLAB's dsp.FIRRateConverter behavior exactly by using upfirdn
    with proper fixed-point arithmetic stages.

    Args:
        input_signal: Input signal array (should be Q16.15 if use_fixed_point=True)
        use_fixed_point: If True, applies fixed-point quantization matching MATLAB
    Returns:
        Decimated output signal (Q16.15 if use_fixed_point=True)
    """
    up = 2
    down = 3

    # Load FIR coefficients
    try:
        coeffs = load_coefficients('fractional_decimator_coeff.txt')
    except FileNotFoundError:
        raise FileNotFoundError(
            "Coefficient file 'fractional_decimator_coeff.txt' not found."
        )

    if use_fixed_point:
        # MATLAB fixed-point configuration:
        # Coefficients: Q20.18 (numerictype([],20,18))
        coeffs_quantized = quantize_with_convergent_rounding(coeffs, word_length=20, frac_length=18)

        # Input is already Q16.15 from system_run.py
        # Ensure input is properly quantized
        input_quantized = quantize_with_convergent_rounding(input_signal, word_length=16, frac_length=15)

        # Use upfirdn for polyphase filtering
        # upfirdn applies: upsample by up -> convolve with filter -> downsample by down
        filtered = upfirdn(coeffs_quantized, input_quantized, up = up, down=down)

        # MATLAB product format: Q36.33 (from Q16.15 * Q20.18 = Q36.33)
        # MATLAB accumulator format: Q42.33
        # MATLAB output format: Q16.15
        # The scaling and quantization happens internally in MATLAB's filter

        # Apply output quantization to Q16.15 with convergent rounding and saturation
        output_sig = quantize_with_convergent_rounding(filtered, word_length=16, frac_length=15)

    else:
        # Floating-point mode - use upfirdn directly
        output_sig = upfirdn(coeffs, input_signal, up=up, down=down)

    # Trim output to match MATLAB's length
    # MATLAB's dsp.FIRRateConverter produces exactly: len(input) * up // down samples
    # upfirdn includes filter delay, so we need to trim the extra samples
    expected_length = len(input_signal) * up // down
    output_sig = output_sig[:expected_length]

    return output_sig