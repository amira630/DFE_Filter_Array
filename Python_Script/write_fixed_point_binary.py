import os
from fixed_point_utils import *

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