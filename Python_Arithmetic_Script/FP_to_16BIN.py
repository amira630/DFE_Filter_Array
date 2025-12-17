def float_to_binary(f):
    # Convert floating-point number to s16.15 fixed-point with saturation and rounding
    # s16.15 range: -1.0 to 0.999969482421875 (approximately 1.0 - 2^-15)

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

    # Scale by 2^15 and apply nearest rounding
    scaled_value = f * (2 ** 15)
    rounded_result = round(scaled_value)

    # Convert to integer within 16-bit signed range
    int_value = int(rounded_result)

    # Handle 16-bit signed integer range (-32768 to 32767)
    if int_value < -32768:
        int_value = -32768
    elif int_value > 32767:
        int_value = 32767

    # Convert to 16-bit two's complement binary
    if int_value >= 0:
        # Positive number - direct binary representation
        binary_representation = format(int_value, '016b')
    else:
        # Negative number - two's complement
        # Convert absolute value to binary, invert bits, and add 1
        positive_equivalent = abs(int_value)
        inverted_bits = (1 << 16) - 1 - positive_equivalent
        twos_complement = inverted_bits + 1
        binary_representation = format(twos_complement & ((1 << 16) - 1), '016b')

    return binary_representation


def convert_coefficients(input_file, output_file):
    # Read coefficients from the input file
    with open(input_file, "r") as file:
        coefficients = [float(line.strip()) for line in file]

    # Convert coefficients to binary representation
    binary_coefficients = [float_to_binary(coeff) for coeff in coefficients]

    # Save binary coefficients to the output file
    with open(output_file, "w") as file:
        for binary_coeff in binary_coefficients:
            file.write(binary_coeff + "\n")

    print(f"Conversion complete. Converted {len(binary_coefficients)} coefficients.")
    print(f"Output saved to: {output_file}")


if __name__ == "__main__":
    # Provide the input and output file names
    input_file_name = "input_FP.txt"  # Update with your input file name
    output_file_name = "output_16BIN.txt"  # Update with your output file name

    # Call the function to convert coefficients and save to the output file
    convert_coefficients(input_file_name, output_file_name)