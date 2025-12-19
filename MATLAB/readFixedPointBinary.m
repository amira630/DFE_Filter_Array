function data = readFixedPointBinary(filename, word_length, fraction_length, is_signed)
    % Read fixed-point binary data from file
    % Each line contains one binary word (16 bits for s16.15 format)
    %
    % Inputs:
    %   filename        - Path to the binary data file
    %   word_length     - Total number of bits (e.g., 16)
    %   fraction_length - Number of fractional bits (e.g., 15)
    %   is_signed       - 1 for signed, 0 for unsigned
    %
    % Output:
    %   data - MATLAB fi object array

    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open file: %s', filename);
    end

    % Read all lines
    lines = {};
    line = fgetl(fid);
    while ischar(line)
        if ~isempty(line)
            lines{end+1} = line;
        end
        line = fgetl(fid);
    end
    fclose(fid);

    % Convert binary strings to decimal values
    num_samples = length(lines);
    data_raw = zeros(num_samples, 1);

    for i = 1:num_samples
        binary_str = strtrim(lines{i});

        % Convert binary string to decimal
        if is_signed && binary_str(1) == '1'
            % Two's complement negative number
            % Invert bits
            inverted = '';
            for j = 1:length(binary_str)
                if binary_str(j) == '0'
                    inverted = [inverted '1'];
                else
                    inverted = [inverted '0'];
                end
            end
            % Convert to decimal and add 1, then negate
            data_raw(i) = -(bin2dec(inverted) + 1);
        else
            % Positive number or unsigned
            data_raw(i) = bin2dec(binary_str);
        end
    end

    % Convert to fixed-point with proper scaling
    % For s16.15, divide by 2^15 to get the fractional value
    data_double = data_raw / (2^fraction_length);

    % Create fi object
    data = fi(data_double, is_signed, word_length, fraction_length);
end

