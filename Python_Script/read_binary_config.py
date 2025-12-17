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
