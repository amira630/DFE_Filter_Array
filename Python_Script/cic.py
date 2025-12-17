"""
CIC (Cascaded Integrator-Comb) Decimator Implementation

This implementation matches MATLAB's dsp.CICDecimator behavior, including:
- Fixed-point quantization with 16-bit word length and 15-bit fraction length
- Floor rounding (truncation towards negative infinity) for output quantization
  to match MATLAB's default RoundingMethod='Floor'

Note: MATLAB's dsp.CICDecimator uses Floor rounding by default when converting
from internal precision to output precision. This differs from convergent
rounding (round-to-even) which was initially implemented.
"""
from write_fixed_point_binary import *

def quantize_with_floor_rounding(data, word_length, frac_length):
    """
    Quantize with floor rounding (truncation) to match MATLAB CICDecimator behavior.
    MATLAB's dsp.CICDecimator uses Floor rounding by default.
    """
    scale = 2 ** frac_length
    max_positive = (2 ** (word_length - 1) - 1) / scale
    max_negative = -(2 ** (word_length - 1)) / scale

    # Saturate first
    data_clipped = np.clip(data, max_negative, max_positive)

    # Scale and apply floor rounding
    scaled = data_clipped * scale
    rounded_int = np.floor(scaled).astype(np.int64)

    # Apply integer saturation
    max_int = 2 ** (word_length - 1) - 1
    min_int = -(2 ** (word_length - 1))
    rounded_int = np.clip(rounded_int, min_int, max_int)

    # Convert back to floating-point
    return rounded_int / scale

def create_cic_state(decimation_factor=2, differential_delay=1, num_sections=1):
    """Initialize CIC decimator state"""
    return {
        'R': decimation_factor,
        'M': differential_delay,
        'N': num_sections,
        'integrator_state': np.zeros(num_sections),
        'comb_state': np.zeros((num_sections, differential_delay)),
        'comb_ptr': 0
    }


def process_cic_sample(x, state, use_fixed_point=False):
    """Process single input sample through integrator stages

    Args:
        x: Input sample
        state: CIC state dictionary
        use_fixed_point: If True, apply 20-bit quantization at integrator stages
    """
    int_out = x
    for i in range(state['N']):
        int_out = int_out + state['integrator_state'][i]

        # Apply section quantization (20-bit, 15-bit fraction) to match MATLAB
        if use_fixed_point:
            int_out = quantize_with_floor_rounding(int_out, word_length=20, frac_length=15)

        state['integrator_state'][i] = int_out

    return int_out


def process_cic_block(input_signal, state, use_fixed_point=False):
    """Process input block with decimation

    MATLAB's dsp.CICDecimator outputs the first sample based on initial state (zeros),
    then continues with regular decimation. This matches MATLAB's behavior where
    the first output is always zero (from initial state), followed by outputs at
    every R-th sample starting from sample index R-1.

    Args:
        input_signal: Input signal array
        state: CIC state dictionary
        use_fixed_point: If True, apply section quantization (20-bit) at integrator/comb stages
    """
    output = []

    # MATLAB outputs initial state first (all zeros) - this gives us the first zero output
    # Process first output from initial state (before any input)
    if 'first_output_done' not in state:
        # First output: comb of initial integrator state (which is zero)
        comb_out = 0.0  # Initial integrator is zero, and delay is zero, so output is zero
        state['first_output_done'] = True
        output.append(comb_out)

    for n, x in enumerate(input_signal):
        # Run integrator for every sample
        int_out = process_cic_sample(x, state, use_fixed_point)

        # Decimate and run comb
        # After first output, we output at n = R-1, 2R-1, 3R-1, ...
        # which for R=2 is n = 1, 3, 5, ...
        if (n % state['R']) == (state['R'] - 1):
            # Comb stages
            comb_out = int_out
            for i in range(state['N']):
                delay_val = state['comb_state'][i, state['comb_ptr']]
                comb_out = comb_out - delay_val

                # Apply section quantization at comb stage
                if use_fixed_point:
                    comb_out = quantize_with_floor_rounding(comb_out, word_length=20, frac_length=15)

                state['comb_state'][i, state['comb_ptr']] = int_out if i == 0 else comb_out

            output.append(comb_out)

    # Update circular buffer pointer
    state['comb_ptr'] = (state['comb_ptr'] + 1) % state['M']

    return np.array(output)

def cic_decimator(input_signal, dec_factor = 2, use_fixed_point = False):
    """CIC Decimator processing function

    Args:
        input_signal: Input signal array
        dec_factor: Decimation factor
        use_fixed_point: If True, apply fixed-point quantization
                        - Section stages: 20-bit word, 15-bit fraction
                        - Output: 16-bit word, 15-bit fraction (Floor rounding)
    """
    # Create CIC state
    state = create_cic_state(decimation_factor = dec_factor, differential_delay = 1, num_sections = 1)

    # Process input signal with fixed-point quantization at section stages
    output_signal = process_cic_block(input_signal, state, use_fixed_point)

    # Quantize output if fixed-point is used
    # MATLAB's dsp.CICDecimator uses Floor rounding by default for output
    if use_fixed_point:
        output_signal = quantize_with_floor_rounding(output_signal, word_length = 16, frac_length = 15)

    expected_length = len(input_signal) // dec_factor
    output_sig = output_signal[:expected_length]

    return output_sig
