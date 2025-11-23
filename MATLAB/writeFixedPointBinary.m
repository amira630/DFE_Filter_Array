function writeFixedPointBinary(signal, filename, word_length, fraction_length)
    % Write fixed-point signal as binary s16.15 to text file
    % Each line contains one 16-bit binary value
    
    fid = fopen(filename, 'w');
    if fid == -1
        error('Cannot open file %s for writing', filename);
    end
    
    % Convert to fixed-point if not already
    if ~isfi(signal)
        signal_fi = fi(signal, 1, word_length, fraction_length);
    else
        signal_fi = signal;
    end
    
    % Write each sample as binary string
    for i = 1:length(signal_fi)
        % Get binary representation
        bin_str = bin(signal_fi(i));
        
        % Ensure it's exactly 16 bits (pad with zeros if needed)
        if length(bin_str) < word_length
            bin_str = [repmat('0', 1, word_length - length(bin_str)), bin_str];
        elseif length(bin_str) > word_length
            bin_str = bin_str(end-word_length+1:end);
        end
        
        fprintf(fid, '%s\n', bin_str);
    end
    
    fclose(fid);
end