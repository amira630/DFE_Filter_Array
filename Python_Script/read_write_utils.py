import os
import numpy as np
from fixed_point_utils import *

def read_binary_config(filename):
    """
    Read binary configuration from file.
    Returns array of 0s and 1s.
    """
    try:
        with open(filename, 'r') as f:
            binary_str = f.read().strip()

        return binary_str

    except FileNotFoundError:
        print(f"Error: Cannot open configuration file: {filename}")
        raise


def load_coefficients(filepath):
    """
    Load coefficients from a text file in the current directory.

    Args:
        filepath: Path to the coefficient file (e.g., 'coeff.txt')

    Returns:
        numpy array of coefficients as floats
    """
    with open(filepath, 'r') as f:
        coeffs = [float(line.strip()) for line in f if line.strip()]

    return np.array(coeffs)

def write_fixed_point_binary(signal_data, filename, word_length = 16, fraction_length = 15):
    """
    Write fixed-point signal as binary to text file.
    Each line contains one 16-bit binary value.
    """
    os.makedirs(os.path.dirname(filename), exist_ok = True)

    with open(filename, 'w') as f:
        for sample in signal_data:
            fp_bin = quantize_fixed_point(sample, word_length, fraction_length, return_FP = False)
            f.write(f"{int_to_binary(fp_bin, word_length = word_length)}\n")

def write_floating_double(signal_data, filename):
    """
        Write floating-point (double) values to a text file, one per line.
    """
    os.makedirs(os.path.dirname(filename), exist_ok = True)

    with open(filename, 'w') as f:
        for sample in signal_data:
            f.write(f"{sample:.17g}\n")