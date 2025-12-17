import os

def write_floating_double(signal_data, filename):
    """
        Write floating-point (double) values to a text file, one per line.
    """

    os.makedirs(os.path.dirname(filename), exist_ok = True)

    with open(filename, 'w') as f:
        for sample in signal_data:
            f.write(f"{sample:.17g}\n")