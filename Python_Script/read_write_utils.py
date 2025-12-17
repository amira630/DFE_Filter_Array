import numpy as np


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
