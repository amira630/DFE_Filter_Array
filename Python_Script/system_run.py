"""
Python implementation of MATLAB System_run_VOL2.m
Digital Filter Engine (DFE) - Signal Processing Pipeline

This script processes signals through a configurable filter chain with bypass options:
- Fractional Decimator
- IIR 2.4MHz Notch Filter
- IIR 5MHz Notch Filter (1 stage)
- CIC Decimation Filter

Author: Mustafa EL-Sherif
"""

import numpy as np
import os
import shutil
from read_write_utils import *
from fixed_point_utils import *
from fractional_decimator import *
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

    # Floating vs Fixed Point
    fi_vs_float_var = int(config[0], 2)

    # Extract values from binary configuration
    # CIC Configuration (bits 5-9 as 5-bit value)
    cic_decf_binary = config[4:9]
    cic_decf = int(cic_decf_binary, 2)

    # Define 16 test cases with different input characteristics
    # Each test case has: frequency, amplitude, signal_shape, interference, tones, noise
    max_amplitude = 0.999969482421875  # Max amplitude for 16-bit signed fixed point

    test_cases = [
        # TC_1 to TC_16: Different combinations of parameters
        {'freq': 1e5, 'amp': 0.25         , 'shape': 'sine', 'inter': 0, 'tones': 0, 'noise': 0},  # TC_1
        {'freq': 1e5, 'amp': 0.25         , 'shape': 'sine', 'inter': 1, 'tones': 0, 'noise': 0},  # TC_2
        {'freq': 1e5, 'amp': 0.25         , 'shape': 'sine', 'inter': 1, 'tones': 1, 'noise': 0},  # TC_3
        {'freq': 1e5, 'amp': 0.25         , 'shape': 'sine', 'inter': 0, 'tones': 0, 'noise': 1},  # TC_4
        {'freq': 1e5, 'amp': 0.25         , 'shape': 'sine', 'inter': 1, 'tones': 0, 'noise': 1},  # TC_5
        {'freq': 1e5, 'amp': 0.25         , 'shape': 'sine', 'inter': 1, 'tones': 1, 'noise': 1},  # TC_6
        {'freq': 1e5, 'amp': max_amplitude, 'shape': 'sine', 'inter': 0, 'tones': 0, 'noise': 0},  # TC_7
        {'freq': 1e5, 'amp': max_amplitude, 'shape': 'sine', 'inter': 1, 'tones': 0, 'noise': 0},  # TC_8
        {'freq': 1e5, 'amp': max_amplitude, 'shape': 'sine', 'inter': 1, 'tones': 1, 'noise': 0},  # TC_9
        {'freq': 1e5, 'amp': max_amplitude, 'shape': 'sine', 'inter': 0, 'tones': 0, 'noise': 1},  # TC_10
        {'freq': 1e5, 'amp': max_amplitude, 'shape': 'sine', 'inter': 1, 'tones': 0, 'noise': 1},  # TC_11
        {'freq': 1e5, 'amp': max_amplitude, 'shape': 'sine', 'inter': 1, 'tones': 1, 'noise': 1},  # TC_12
        {'freq': 5e4, 'amp': 0.25         , 'shape': 'sine', 'inter': 1, 'tones': 0, 'noise': 1},  # TC_13
        {'freq': 2e5, 'amp': 0.25         , 'shape': 'sine', 'inter': 1, 'tones': 0, 'noise': 1},  # TC_14
        {'freq': 5e4, 'amp': max_amplitude, 'shape': 'sine', 'inter': 1, 'tones': 0, 'noise': 0},  # TC_15
        {'freq': 2e5, 'amp': max_amplitude, 'shape': 'sine', 'inter': 1, 'tones': 0, 'noise': 0},  # TC_16
    ]

    num_test_cases = len(test_cases)

    # Display configuration
    print('Binary Configuration:')
    print('Raw bits: ', end='')
    print(''.join(config))
    print('\n')

    print('Parsed Configuration:')
    print(f'CIC decf (binary {cic_decf_binary}) = {cic_decf}\n')

    # Sampling parameters
    Fs = 9e6
    N = 48000
    t = np.arange(N) / Fs

    # Interference parameters (constant for all test cases)
    f_intf_2_4 = 2.4e6
    f_intf_5 = 5e6

    A_intf_2_4 = 0.2
    A_intf_5 = 0.2

    intf1 = A_intf_2_4 * np.sin(2 * np.pi * f_intf_2_4 * t)
    intf2 = A_intf_5 * np.sin(2 * np.pi * f_intf_5 * t)
    interference = intf1 + intf2

    # Tones
    f_tone_1 = 2.8e6
    f_tone_2 = 3e6
    f_tone_3 = 3.2e6
    f_tone_4 = 4e6
    f_tone_5 = 4.5e6

    A_tones = 0.2

    tone_1 = A_tones * np.sin(2 * np.pi * f_tone_1 * t)
    tone_2 = A_tones * np.sin(2 * np.pi * f_tone_2 * t)
    tone_3 = A_tones * np.sin(2 * np.pi * f_tone_3 * t)
    tone_4 = A_tones * np.sin(2 * np.pi * f_tone_4 * t)
    tone_5 = A_tones * np.sin(2 * np.pi * f_tone_5 * t)

    tones = tone_1 + tone_2 + tone_3 + tone_4 + tone_5

    # Wide-Band Noise parameters
    # High quality (40-50 dB SNR): noise_variance = 1e-6 to 1e-5
    # Medium quality (30-40 dB SNR): noise_variance = 1e-5 to 1e-4
    # Low quality (20-30 dB SNR): noise_variance = 1e-4 to 1e-3
    noise_variance = 1e-5  # Adjust based on desired SNR

    # Generate all bypass combinations
    # Based on your description, we have 4 stages that can be bypassed:
    # 1. Fractional Decimator
    # 2. IIR 2.4 MHz
    # 3. IIR 5 MHz
    # 4. CIC

    # Create all possible bypass combinations (2^4 = 16 combinations)
    num_combinations = 16

    print(f'Generating {num_test_cases} Test Cases, each with {num_combinations} bypass scenarios...\n')

    if fi_vs_float_var == 0:
        print('Processing mode: Fixed Point\n')

        # Loop through each test case
        for tc_idx in range(num_test_cases):
            # Get current test case parameters
            tc = test_cases[tc_idx]
            f_sig = tc['freq']
            amplitude = tc['amp']
            signal_shape = tc['shape']
            add_interference = tc['inter']
            add_tones = tc['tones']
            add_noise = tc['noise']

            # Create test case directory
            tc_dir = f'TC_{tc_idx + 1}'
            os.makedirs(tc_dir, exist_ok=True)

            print('========================================')
            print(f'Processing Test Case {tc_idx + 1}/{num_test_cases}: {tc_dir}')
            print(f'  Signal parameters - Freq: {f_sig/1000:.2f} kHz, Amp: {amplitude:.3f}, Shape: {signal_shape}')
            print('========================================\n')

            # Generate clean signal based on test case parameters
            x_real_clean = generate_signal(signal_shape, amplitude, f_sig, t)

            x_real_noisy = x_real_clean.copy()

            # Add interference (same for all test cases)
            if add_interference == 1:
                print('  Adding interference signals (2.4 MHz and 5 MHz)...')
                x_real_noisy = x_real_noisy + interference

            # Add tones
            if add_tones == 1:
                print('  Adding tone signals (2.8 MHz, 3 MHz, 3.2 MHz, 4 MHz, 4.5 MHz)...')
                x_real_noisy = x_real_noisy + tones

            # Add wide-band noise (generate unique noise for each test case)
            if add_noise == 1:
                print(f'  Adding wide-band noise (variance = {noise_variance:.1e})...')
                noise = np.sqrt(noise_variance) * np.random.randn(N)  # White Gaussian noise
                x_real_noisy = x_real_noisy + noise

            x_quantized_noisy = quantize_fixed_point(x_real_noisy, word_length=16, frac_length=15)

            # Process each bypass combination for this test case
            for combo_idx in range(num_combinations):
                # Extract bypass flags for this combination
                bypass_frac_dec = (combo_idx >> 3) & 1
                bypass_iir_24 = (combo_idx >> 2) & 1
                bypass_iir_5 = (combo_idx >> 1) & 1
                bypass_cic = combo_idx & 1

                # Create directory name for this scenario inside test case folder
                scenario_dir = os.path.join(tc_dir,
                    f'scenario_frac{bypass_frac_dec}_iir24{bypass_iir_24}_iir5{bypass_iir_5}_cic{bypass_cic}')

                # Create directory if it doesn't exist
                os.makedirs(scenario_dir, exist_ok=True)

                print(f'  Processing scenario {combo_idx + 1}/{num_combinations}: scenario_frac{bypass_frac_dec}_iir24{bypass_iir_24}_iir5{bypass_iir_5}_cic{bypass_cic}')
                print(f'    Bypass flags - frac_dec:{bypass_frac_dec}, iir_24:{bypass_iir_24}, iir_5:{bypass_iir_5}, cic:{bypass_cic}')

                # Processing chain with current bypass options
                current_signal = x_quantized_noisy.copy()

                # Write Stage 0: Input signal (after quantization)
                write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'input.txt'), 16, 15)

                # Stage 1: Fractional Decimator
                if bypass_frac_dec == 0:
                    print('    Applying Fractional Decimator...')
                    current_signal = fractional_decimator(current_signal, use_fixed_point=True)

                    # Write Stage 1: After fractional decimator
                    write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'frac_decimator.txt'), 16, 15)
                else:
                    print('    Bypassing Fractional Decimator')
                    shutil.copyfile(os.path.join(scenario_dir, 'input.txt'),
                                  os.path.join(scenario_dir, 'frac_decimator.txt'))

                # Stage 2: IIR 2.4MHz Notch Filter
                if bypass_iir_24 == 0:
                    print('    Applying IIR 2.4MHz Notch Filter...')
                    current_signal = iir_24mhz_filter(current_signal, use_fixed_point=True)

                    # Write Stage 2: After IIR 2.4MHz filter
                    write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'iir_24mhz.txt'), 16, 15)
                else:
                    print('    Bypassing IIR 2.4MHz Notch Filter')
                    shutil.copyfile(os.path.join(scenario_dir, 'frac_decimator.txt'),
                                  os.path.join(scenario_dir, 'iir_24mhz.txt'))

                # Stage 3: IIR 5MHz Notch Filter (only IIR_1)
                if bypass_iir_5 == 0:
                    print('    Applying IIR 5MHz Notch Filter...')
                    current_signal = iir_5mhz_filter(current_signal, use_fixed_point=True)

                    # Write Stage 3.1: After first IIR 5MHz filter
                    write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'iir_5mhz_1.txt'), 16, 15)
                else:
                    print('    Bypassing IIR 5MHz Notch Filter')
                    shutil.copyfile(os.path.join(scenario_dir, 'iir_24mhz.txt'),
                                  os.path.join(scenario_dir, 'iir_5mhz_1.txt'))

                # Stage 4: CIC Filter
                if bypass_cic == 0:
                    print(f'    Applying CIC Filter with decimation factor {cic_decf}...')
                    current_signal = cic_decimator(current_signal, dec_factor=cic_decf, use_fixed_point=True)

                    # Write Stage 4: After CIC filter
                    write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'cic.txt'), 16, 15)
                else:
                    print('    Bypassing CIC Filter')
                    shutil.copyfile(os.path.join(scenario_dir, 'iir_5mhz_1.txt'),
                                  os.path.join(scenario_dir, 'cic.txt'))

                # Final output
                output = current_signal
                write_fixed_point_binary(output, os.path.join(scenario_dir, 'output.txt'), 16, 15)

                print('    Scenario complete!\n')

            print(f'Test Case {tc_dir} complete!\n')

    else:
        print('Processing mode: Floating Point\n')

        # Loop through each test case
        for tc_idx in range(num_test_cases):
            # Get current test case parameters
            tc = test_cases[tc_idx]
            f_sig = tc['freq']
            amplitude = tc['amp']
            signal_shape = tc['shape']
            add_interference = tc['inter']
            add_tones = tc['tones']
            add_noise = tc['noise']

            # Create test case directory
            tc_dir = f'TC_{tc_idx + 1}'
            os.makedirs(tc_dir, exist_ok=True)

            print('========================================')
            print(f'Processing Test Case {tc_idx + 1}/{num_test_cases}: {tc_dir}')
            print(f'  Signal parameters - Freq: {f_sig/1000:.2f} kHz, Amp: {amplitude:.3f}, Shape: {signal_shape}')
            print('========================================\n')

            # Generate clean signal based on test case parameters
            x_real_clean = generate_signal(signal_shape, amplitude, f_sig, t)

            x_real_noisy = x_real_clean.copy()

            # Add interference (same for all test cases)
            if add_interference == 1:
                print('  Adding interference signals (2.4 MHz and 5 MHz)...')
                x_real_noisy = x_real_noisy + interference

            # Add tones
            if add_tones == 1:
                print('  Adding tone signals (2.8 MHz, 3 MHz, 3.2 MHz, 4 MHz, 4.5 MHz)...')
                x_real_noisy = x_real_noisy + tones

            # Add wide-band noise (generate unique noise for each test case)
            if add_noise == 1:
                print(f'  Adding wide-band noise (variance = {noise_variance:.1e})...')
                noise = np.sqrt(noise_variance) * np.random.randn(N)  # White Gaussian noise
                x_real_noisy = x_real_noisy + noise

            x_quantized_noisy = quantize_fixed_point(x_real_noisy, word_length=16, frac_length=15)

            # Process each bypass combination for this test case
            for combo_idx in range(num_combinations):
                # Extract bypass flags for this combination
                bypass_frac_dec = (combo_idx >> 3) & 1
                bypass_iir_24 = (combo_idx >> 2) & 1
                bypass_iir_5 = (combo_idx >> 1) & 1
                bypass_cic = combo_idx & 1

                # Create directory name for this scenario inside test case folder
                scenario_dir = os.path.join(tc_dir,
                    f'scenario_frac{bypass_frac_dec}_iir24{bypass_iir_24}_iir5{bypass_iir_5}_cic{bypass_cic}')

                # Create directory if it doesn't exist
                os.makedirs(scenario_dir, exist_ok=True)

                print(f'  Processing scenario {combo_idx + 1}/{num_combinations}: scenario_frac{bypass_frac_dec}_iir24{bypass_iir_24}_iir5{bypass_iir_5}_cic{bypass_cic}')
                print(f'    Bypass flags - frac_dec:{bypass_frac_dec}, iir_24:{bypass_iir_24}, iir_5:{bypass_iir_5}, cic:{bypass_cic}')

                # Processing chain with current bypass options
                current_signal = x_quantized_noisy.copy()

                # Write Stage 0: Input signal (after quantization)
                write_fixed_point_binary(current_signal, os.path.join(scenario_dir, 'input.txt'), 16, 15)

                current_signal = x_real_noisy.copy()

                # Stage 1: Fractional Decimator
                if bypass_frac_dec == 0:
                    print('    Applying Fractional Decimator...')
                    current_signal = fractional_decimator(current_signal, use_fixed_point=False)

                    # Write Stage 1: After fractional decimator
                    write_floating_double(current_signal, os.path.join(scenario_dir, 'frac_decimator.txt'))
                else:
                    print('    Bypassing Fractional Decimator')
                    shutil.copyfile(os.path.join(scenario_dir, 'input.txt'),
                                  os.path.join(scenario_dir, 'frac_decimator.txt'))

                # Stage 2: IIR 2.4MHz Notch Filter
                if bypass_iir_24 == 0:
                    print('    Applying IIR 2.4MHz Notch Filter...')
                    current_signal = iir_24mhz_filter(current_signal, use_fixed_point=False)

                    # Write Stage 2: After IIR 2.4MHz filter
                    write_floating_double(current_signal, os.path.join(scenario_dir, 'iir_24mhz.txt'))
                else:
                    print('    Bypassing IIR 2.4MHz Notch Filter')
                    shutil.copyfile(os.path.join(scenario_dir, 'frac_decimator.txt'),
                                  os.path.join(scenario_dir, 'iir_24mhz.txt'))

                # Stage 3: IIR 5MHz Notch Filter (only IIR_1)
                if bypass_iir_5 == 0:
                    print('    Applying IIR 5MHz Notch Filter...')
                    current_signal = iir_5mhz_filter(current_signal, use_fixed_point=False)

                    # Write Stage 3.1: After first IIR 5MHz filter
                    write_floating_double(current_signal, os.path.join(scenario_dir, 'iir_5mhz_1.txt'))
                else:
                    print('    Bypassing IIR 5MHz Notch Filter')
                    shutil.copyfile(os.path.join(scenario_dir, 'iir_24mhz.txt'),
                                  os.path.join(scenario_dir, 'iir_5mhz_1.txt'))

                # Stage 4: CIC Filter
                if bypass_cic == 0:
                    print(f'    Applying CIC Filter with decimation factor {cic_decf}...')
                    current_signal = cic_decimator(current_signal, dec_factor=cic_decf, use_fixed_point=False)

                    # Write Stage 4: After CIC filter
                    write_floating_double(current_signal, os.path.join(scenario_dir, 'cic.txt'))
                else:
                    print('    Bypassing CIC Filter')
                    shutil.copyfile(os.path.join(scenario_dir, 'iir_5mhz_1.txt'),
                                  os.path.join(scenario_dir, 'cic.txt'))

                # Final output
                output = current_signal
                write_floating_double(output, os.path.join(scenario_dir, 'output.txt'))

                print('    Scenario complete!\n')

            print(f'Test Case {tc_dir} complete!\n')

    print('========================================')
    print(f'All {num_test_cases} Test Cases with {num_combinations} bypass scenarios each processed successfully!')
    print(f'Total scenarios: {num_test_cases * num_combinations}')
    print('========================================\n')
    print('Output Structure:')
    for tc_idx in range(num_test_cases):
        print(f'TC_{tc_idx + 1}/')
        for combo_idx in range(num_combinations):
            bypass_frac_dec = (combo_idx >> 3) & 1
            bypass_iir_24 = (combo_idx >> 2) & 1
            bypass_iir_5 = (combo_idx >> 1) & 1
            bypass_cic = combo_idx & 1

            scenario_dir = f'scenario_frac{bypass_frac_dec}_iir24{bypass_iir_24}_iir5{bypass_iir_5}_cic{bypass_cic}'

            print(f'  {scenario_dir}/')
        print()


if __name__ == "__main__":
    main()

