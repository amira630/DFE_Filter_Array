import numpy as np

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

def wrap_integer(int_value, word_length=16):
    """
    Wrap integer value to fit within specified word length using modulo arithmetic.

    Args:
        int_value: Input integer value or array
        word_length: Total bits (e.g., 16 for s16.15)

    Returns:
        Wrapped integer value or array
    """
    num_values = 2 ** word_length
    min_int = -(2 ** (word_length - 1))

    wrapped_int = ((int_value - min_int) % num_values) + min_int
    return wrapped_int


def int_to_binary(int_value, word_length=16):
    """Convert integer to binary string with configurable bit width"""
    mask = (1 << word_length) - 1
    return f'{int_value & mask:0{word_length}b}'

def quantize_with_convergent_rounding(data, word_length, frac_length, scale_fac = 1):
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

    rounded_int = rounded_int / scale_fac
    # Apply integer saturation
    max_int = 2 ** (word_length - 1) - 1
    min_int = -(2 ** (word_length - 1))
    rounded_int = np.clip(rounded_int, min_int, max_int)

    # Convert back to floating-point
    return rounded_int / scale


def quantize_with_floor_rounding_wrap(data, word_length, frac_length, use_saturation = False):
    """
    Quantize with floor rounding and wrapping (instead of saturation).
    This matches MATLAB's CIC output behavior when OverflowAction='Wrap'.

    Fixed to prevent spurious zeros during zero-crossings by ensuring that
    non-zero input values that are smaller than LSB remain non-zero.

    Args:
        data: Input floating-point array or scalar
        word_length: Total bits (e.g., 16 for s16.15)
        frac_length: Fractional bits (e.g., 15 for s16.15)

    Returns:
        Quantized data with wrapping applied
    """
    data = np.asarray(data)
    scale = 2 ** frac_length

    # Define minimum representable non-zero value (LSB)
    min_lsb = 1.0 / scale

    # Scale to integer
    scaled = data * scale

    # Apply floor rounding
    rounded_int = np.floor(scaled).astype(np.int64)

    # Fix spurious zeros: if input was non-zero but floor rounded to zero
    # (i.e., value is between 0 and min_lsb for positive, or between -min_lsb and 0 for negative)
    # preserve the sign by using ±1 (minimum representable integer)
    mask_spurious_zero = (rounded_int == 0) & (np.abs(data) >= min_lsb / 2)
    rounded_int = np.where(mask_spurious_zero,
                           np.where(data > 0, 1, -1),  # Use ±1 based on sign
                           rounded_int)

    if use_saturation:
        # Apply integer saturation
        max_int = 2 ** (word_length - 1) - 1
        min_int = -(2 ** (word_length - 1))
        res_int = np.clip(rounded_int, min_int, max_int)
    else :
        res_int = wrap_integer(rounded_int, word_length = word_length)

    # Convert back to floating-point
    return res_int / scale

def quantize_fixed_point(data, word_length = 16, frac_length = 15, return_FP = True):
    """
    Quantize floating-point data to fixed-point representation.

    Args:
        data: Input floating-point array or scalar
        word_length: Total bits (e.g., 16 for s16.15)
        frac_length: Fractional bits (e.g., 15 for s16.15)

    Returns:
        Quantized floating-point array (representing fixed-point values)
        :param data:
        :param word_length:
        :param frac_length:
        :param return_FP:
    """
    # Convert to numpy array if not already
    data = np.asarray(data)

    scale = 2 ** frac_length
    max_positive = (2 ** (word_length - 1) - 1) / scale
    max_negative = -(2 ** (word_length - 1)) / scale

    # Apply saturation (vectorized)
    clipped_data = np.clip(data, max_negative, max_positive)

    # Warn if any values were clipped
    if np.any(data > max_positive):
        print(f"Warning: {np.sum(data > max_positive)} values clipped to max positive: {max_positive}")
    if np.any(data < max_negative):
        print(f"Warning: {np.sum(data < max_negative)} values clipped to max negative: {max_negative}")

    # Scale and round
    scaled = clipped_data * scale
    rounded_result = np.round(scaled)

    # Define integer bounds
    max_int = 2 ** (word_length - 1) - 1
    min_int = -(2 ** (word_length - 1))

    # Convert to integer and apply bounds
    quantized_int = rounded_result.astype(np.int32)
    quantized_int = np.clip(quantized_int, min_int, max_int)

    if return_FP:
        quant_out = quantized_int / scale
    else:
        quant_out = quantized_int


    # Convert back to floating-point representation
    return quant_out
