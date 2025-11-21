import math


def float_to_binary_s8_7(f):
    """
    Convert floating-point number to s8.7 fixed-point with saturation and rounding.
    s8.7 range: -1.0 to 127/128 (0.9921875)
    Output: 8-bit two's-complement binary string (e.g. '10000000' .. '01111111')
    """
    # Define the fixed-point range for s8.7
    MAX_POSITIVE = 127 / 128.0  # 0.9921875
    MAX_NEGATIVE = -1.0

    # Apply saturation
    if f > MAX_POSITIVE:
        f = MAX_POSITIVE
        print(f"Warning: Clipped to max positive value: {MAX_POSITIVE}")
    elif f < MAX_NEGATIVE:
        f = MAX_NEGATIVE
        print(f"Warning: Clipped to max negative value: {MAX_NEGATIVE}")

    # Scale by 2^7 and apply nearest rounding
    scaled_value = f * (2 ** 7)
    rounded_result = round(scaled_value)

    # Convert to integer within 8-bit signed range (-128 to 127)
    int_value = int(rounded_result)

    # Handle 8-bit signed integer range (-128 to 127)
    if int_value < -128:
        int_value = -128
    elif int_value > 127:
        int_value = 127

    # Convert to 8-bit two's complement binary using mask
    binary_representation = format(int_value & 0xFF, '08b')

    return binary_representation


def convert_coefficients(input_file, output_file):
    # Read coefficients from the input file (one float per line)
    with open(input_file, "r") as file:
        coefficients = [float(line.strip()) for line in file if line.strip() != ""]

    # Convert coefficients to binary representation (s8.7)
    binary_coefficients = [float_to_binary_s8_7(coeff) for coeff in coefficients]

    # Save binary coefficients to the output file
    with open(output_file, "w") as file:
        for binary_coeff in binary_coefficients:
            file.write(binary_coeff + "\n")

    print(f"Conversion complete. Converted {len(binary_coefficients)} coefficients.")
    print(f"Output saved to: {output_file}")


if __name__ == "__main__":
    # Provide the input and output file names
    input_file_name = "input_float.txt"   # Update with your input file name
    output_file_name = "input_binary.txt" # Update with your output file name

    # Call the function to convert coefficients and save to the output file
    convert_coefficients(input_file_name, output_file_name)
