"""
Python implementation of MATLAB System_run.m
Digital Filter Engine (DFE) - Signal Processing Pipeline

This script processes signals through a configurable filter chain with bypass options:
- Fractional Decimator
- IIR 2.4MHz Notch Filter
- IIR 5MHz Notch Filter (2 stages)
- CIC Decimation Filter

Author: Converted from MATLAB
Date: December 14, 2025
"""

import numpy as np
import os
import shutil
from scipy import signal
from fixed_point_utils import quantize_fixed_point
from read_binary_config import read_binary_config
from write_fixed_point_binary import write_fixed_point_binary
from write_floating_double import write_floating_double
from fractional_decimator import fractional_decimator
from iir_notch_filter import *
from cic import *

def generate_signal(signal_shape, amplitude, frequency, time_array):
    """Generate clean signal based on selected shape"""
    if signal_shape == 'sine':
        return amplitude * np.sin(2 * np.pi * frequency * time_array)
    elif signal_shape == 'square':
        return amplitude * signal.square(2 * np.pi * frequency * time_array)
    elif signal_shape == 'triangular':
        return amplitude * signal.sawtooth(2 * np.pi * frequency * time_array, 0.5)
    else:
        raise ValueError(f"Unknown signal shape: {signal_shape}")


def main():
    """Main function to run the DFE signal processing pipeline"""

    print("="*80)
    print("Digital Filter Engine (DFE) - Signal Processing Pipeline")
    print("="*80)
    print()

    # Read binary configuration from file
    config_file = 'cfg.txt'
    config = read_binary_config(config_file)

    # Extract configuration parameters
    use_fp = int(config[0], 2)  # 0 = Fixed Point, 1 = Floating Point
    f = int(config[1], 2)  # Frequency randomization flag
    a = int(config[2], 2)  # Amplitude randomization flag
    s = int(config[3], 2)  # Shape randomization flag

    print("Configuration Values:")
    print(f"  use_fp: {use_fp} ({'Fixed Point' if use_fp == 0 else 'Floating Point'})")
    print(f"  f (frequency randomization): {f}")
    print(f"  a (amplitude randomization): {a}")
    print(f"  s (shape randomization): {s}")
    print()

    # Add this to confirm:
    if use_fp == 0:
        print(f"  → Using Fixed Point processing")
        write_func = write_fixed_point_binary
    else:
        print(f"  → Using Floating Point processing")
        write_func = write_floating_double
    print()

    # CIC Configuration (bits 4-8 as 5-bit value)
    cic_decf_binary = config[4:9]
    cic_decf = int(cic_decf_binary, 2)

    # Default parameters
    default_freq = 1e5  # 100 kHz
    default_amp = 0.25  # Default amplitude
    default_shape = 'sine'  # Default shape

    # Parameter ranges for randomization
    freq_range = [50e3, 200e3]  # 50 kHz to 200 kHz
    amp_range = [0.1, 1.0]  # 0.1 to 1.0
    shape_options = ['square', 'triangular']

    # Determine final parameters based on flags
    if f == 1:
        f_sig = freq_range[0] + (freq_range[1] - freq_range[0]) * np.random.rand()
    else:
        f_sig = default_freq

    if a == 1:
        amplitude = amp_range[0] + (amp_range[1] - amp_range[0]) * np.random.rand()
    else:
        amplitude = default_amp

    if s == 1:
        shape_idx = np.random.randint(0, len(shape_options))
        signal_shape = shape_options[shape_idx]
    else:
        signal_shape = default_shape

    # Map signal shape to 2-bit binary code
    shape_code_map = {
        'sine': '00',
        'square': '01',
        'triangular': '10'
    }
    shape_code = shape_code_map.get(signal_shape, '00')

    # Write shape code to text file
    shape_filename = 'signal_shape_code.txt'
    with open(shape_filename, 'w') as f:
        f.write(shape_code)

    print(f"Shape code written to: {shape_filename}")
    print(f"Signal shape: {signal_shape} -> 2-bit code: {shape_code}\n")

    # Display configuration
    print("Binary Configuration:")
    print(f"Raw bits: {''.join(map(str, config))}\n")

    print("Parsed Configuration:")
    print(f"Signal flags - f:{f}, a:{a}, s:{s}")
    print(f"CIC decf (binary {''.join(map(str, cic_decf_binary))}) = {cic_decf}\n")
    print(f"Generated signal - Freq: {f_sig/1000:.2f} kHz, Amp: {amplitude:.3f}, Shape: {signal_shape}\n")

    # Signal parameters
    fs = 9e6  # Sampling frequency (9 MHz)
    n = 48000  # Number of samples

    # Generate time array
    t = np.arange(n) / fs

    # Generate clean signal
    x_real_clean = generate_signal(signal_shape, amplitude, f_sig, t)

    # Add interference
    f_intf_2_4 = 2.4e6  # 2.4 MHz interference
    f_intf_5 = 5e6      # 5 MHz interference
    A_intf_2_4 = 0.2
    A_intf_5 = 0.2

    intf1 = A_intf_2_4 * np.sin(2 * np.pi * f_intf_2_4 * t)
    intf2 = A_intf_5 * np.sin(2 * np.pi * f_intf_5 * t)
    interference = intf1 + intf2
    x_real_noisy = x_real_clean + interference

    # Quantize signal (for fixed-point processing)
    x_quantized_noisy = quantize_fixed_point(x_real_noisy, word_length = 16, frac_length = 15)

    # Generate all bypass combinations (2^4 = 16 combinations)
    # Bits: [frac_dec, iir_24, iir_5, cic]
    num_combinations = 16

    processing_mode = "Fixed Point" if use_fp == 0 else "Floating Point"
    print(f"Generating {num_combinations} bypass {processing_mode} scenarios...\n")

    # Process each bypass combination
    for combo_idx in range(num_combinations):
        # Extract bypass flags for this combination
        bypass_frac_dec = (combo_idx >> 3) & 1
        bypass_iir_24 = (combo_idx >> 2) & 1
        bypass_iir_5 = (combo_idx >> 1) & 1
        bypass_cic = combo_idx & 1

        # Create directory name for this scenario
        scenario_dir = f"scenario_frac{bypass_frac_dec}_iir24{bypass_iir_24}_iir5{bypass_iir_5}_cic{bypass_cic}"

        # Create directory if it doesn't exist
        os.makedirs(scenario_dir, exist_ok = True)

        print(f"Processing scenario {combo_idx + 1}/{num_combinations}: {scenario_dir}")
        print(f"  Bypass flags - frac_dec:{bypass_frac_dec}, iir_24:{bypass_iir_24}, iir_5:{bypass_iir_5}, cic:{bypass_cic}")

        # Select initial signal based on processing mode
        if use_fp == 0:
            write_func = write_fixed_point_binary
        else:
            write_func = write_floating_double

        # Write Stage 0: Input signal
        # Always write input as fixed-point binary for consistency with MATLAB
        current_signal = x_quantized_noisy.copy()
        write_fixed_point_binary(current_signal,
                                os.path.join(scenario_dir, 'input.txt'), 16, 15)

        # Stage 1: Fractional Decimator
        if bypass_frac_dec == 0:
            print("  Applying Fractional Decimator...")
            # fi_vs_float_var: 0=Fixed Point, 1=Floating Point
            # use_fixed_point: True=Fixed Point, False=Floating Point
            # So we need to invert: use_fixed_point = (fi_vs_float_var == 0)
            use_fixed_point = (use_fp == 0)
            current_signal = fractional_decimator(current_signal, use_fixed_point = use_fixed_point)
            if use_fp == 0:
                write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'frac_decimator.txt'), 16, 15)
            else:
                write_floating_double(current_signal, os.path.join(scenario_dir, 'frac_decimator.txt'))

        else:
            print("  Bypassing Fractional Decimator")
            shutil.copyfile(os.path.join(scenario_dir, 'input.txt'),
                          os.path.join(scenario_dir, 'frac_decimator.txt'))

        # Stage 2: IIR 2.4MHz Notch Filter
        if bypass_iir_24 == 0:
            print("  Applying IIR 2.4MHz Notch Filter...")
            use_fixed_point = (use_fp == 0)
            current_signal = iir_24mhz_filter(current_signal, use_fixed_point = use_fixed_point)
            if use_fp == 0:
                write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'iir_24mhz.txt'), 16, 15)
            else:
                write_floating_double(current_signal, os.path.join(scenario_dir, 'iir_24mhz.txt'))
        else:
            print("  Bypassing IIR 2.4MHz Notch Filter")
            shutil.copyfile(os.path.join(scenario_dir, 'frac_decimator.txt'),
                          os.path.join(scenario_dir, 'iir_24mhz.txt'))

        # Stage 3: IIR 5MHz Notch Filter (2 stages)
        if bypass_iir_5 == 0:
            print("  Applying IIR 5MHz Notch Filter...")
            use_fixed_point = (use_fp == 0)
            current_signal_ph1 = iir_5mhz_filter_stage_1(current_signal, use_fixed_point = use_fixed_point)
            if use_fp == 0:
                write_fixed_point_binary(current_signal_ph1, os.path.join(scenario_dir, 'iir_5mhz_1.txt'), 16, 15)
            else:
                write_floating_double(current_signal_ph1, os.path.join(scenario_dir, 'iir_5mhz_1.txt'))

            current_signal = iir_5mhz_filter_stage_2(current_signal_ph1, use_fixed_point=use_fixed_point)
            if use_fp == 0:
                write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'iir_5mhz_2.txt'), 16, 15)
            else:
                write_floating_double(current_signal, os.path.join(scenario_dir, 'iir_5mhz_2.txt'))
        else:
            print("  Bypassing IIR 5MHz Notch Filter")
            shutil.copyfile(os.path.join(scenario_dir, 'iir_24mhz.txt'),
                          os.path.join(scenario_dir, 'iir_5mhz_1.txt'))
            shutil.copyfile(os.path.join(scenario_dir, 'iir_24mhz.txt'),
                          os.path.join(scenario_dir, 'iir_5mhz_2.txt'))

        # Stage 4: CIC Filter
        if bypass_cic == 0:
            print(f"  Applying CIC Filter with decimation factor {cic_decf}...")
            use_fixed_point = (use_fp == 0)
            current_signal = cic_decimator(current_signal, dec_factor=cic_decf, use_fixed_point=use_fixed_point)
            if use_fp == 0:
                write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'cic.txt'), 16, 15)
            else:
                write_floating_double(current_signal, os.path.join(scenario_dir, 'cic.txt'))
        else:
            print("  Bypassing CIC Filter")
            shutil.copyfile(os.path.join(scenario_dir, 'iir_5mhz_2.txt'),
                          os.path.join(scenario_dir, 'cic.txt'))

        # Final output
        output = current_signal
        write_func(output, os.path.join(scenario_dir, 'output.txt'))

        print(f"  Scenario {scenario_dir} complete!\n")

    print(f"All {num_combinations} scenarios processed successfully!")
    print("="*80)


if __name__ == "__main__":
    main()

