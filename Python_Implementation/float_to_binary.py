import math

def float_to_binary_and_hex(f):
    """
    Convert floating-point number to s16.15 fixed-point binary and hexadecimal strings
    with saturation and rounding.
    Range: -1.0 to 0.999969482421875
    """

    # Define the fixed-point range
    MAX_POSITIVE = 32767 / 32768.0  # 0.999969482421875
    MAX_NEGATIVE = -1.0

    # Apply saturation
    if f > MAX_POSITIVE:
        f = MAX_POSITIVE
        print(f"Warning: Clipped to max positive value: {MAX_POSITIVE}")
    elif f < MAX_NEGATIVE:
        f = MAX_NEGATIVE
        print(f"Warning: Clipped to max negative value: {MAX_NEGATIVE}")

    # Scale by 2^15 and round
    scaled_value = f * (2 ** 15)
    rounded_result = round(scaled_value)
    int_value = int(rounded_result)

    # Clamp to signed 16-bit range
    if int_value < -32768:
        int_value = -32768
    elif int_value > 32767:
        int_value = 32767

    # Convert to 16-bit two's complement binary
    if int_value >= 0:
        binary_representation = format(int_value, '016b')
    else:
        binary_representation = format((1 << 16) + int_value, '016b')

    # Convert to hexadecimal (4-digit uppercase)
    hex_representation = format((int(binary_representation, 2)), '04X')
    hex_representation = hex_representation

    return binary_representation, hex_representation


def convert_coefficients(input_file, output_file):
    """
    Read floating-point coefficients, convert to s16.15 binary + hex, and write to file.
    """
    # Read coefficients
    with open(input_file, "r") as file:
        coefficients = [float(line.strip()) for line in file]

    results = [float_to_binary_and_hex(coeff) for coeff in coefficients]

    # Write to output file
    with open(output_file, "w") as file:
        for binary_val, hex_val in results:
            file.write(f"{hex_val}\n")

    print(f"Conversion complete. Converted {len(results)} coefficients.")
    print(f"Output saved to: {output_file}")


if __name__ == "__main__":
    input_file_name = r"e:\Digital Track\SI-Clash Hackathon\DFE_Filter_Array\Python_Implementation\input_float.txt"
    output_file_name = r"e:\Digital Track\SI-Clash Hackathon\DFE_Filter_Array\Python_Implementation\inputs_IIR.txt"

    convert_coefficients(input_file_name, output_file_name)
