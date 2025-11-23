function config_bits = readBinaryConfig(filename)
    % Read binary configuration from file
    % File contains continuous stream of 0s and 1s (no spaces, no newlines)
    
    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open configuration file: %s', filename);
    end
    
    % Read the entire file as a string
    binary_str = fscanf(fid, '%s');
    fclose(fid);
    
    % Convert string to array of numbers (0s and 1s)
    config_bits = arrayfun(@(c) str2double(c), binary_str);
    
    % Verify we have enough bits (at least 12 for all parameters)
    if length(config_bits) < 12
        warning('Config file has only %d bits, expected at least 12. Padding with zeros.', length(config_bits));
        config_bits = [config_bits, zeros(1, 15 - length(config_bits))];
    end
end