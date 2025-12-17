import numpy as np

def int_to_binary(int_value, word_length=16):
    """Convert integer to binary string with configurable bit width"""
    mask = (1 << word_length) - 1
    return f'{int_value & mask:0{word_length}b}'

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
