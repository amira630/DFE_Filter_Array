function writeFloatingDouble(signal, filename)
    % Write floating-point (double) values to a text file, one per line.
    % Keeps full double precision with %.17g formatting.

    fid = fopen(filename, 'w');
    if fid == -1
        error('Cannot open file %s for writing', filename);
    end

    % Convert to double if needed
    signal = double(signal);

    % Write each sample with full precision (round-trip safe)
    for i = 1:length(signal)
        fprintf(fid, '%.17g\n', signal(i));
    end

    fclose(fid);
end
