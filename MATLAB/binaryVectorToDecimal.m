function decimal = binaryVectorToDecimal(binary_vec)
    % Convert binary vector to decimal number
    % Most significant bit first
    n = length(binary_vec);
    decimal = 0;
    for i = 1:n
        decimal = decimal + binary_vec(i) * 2^(n-i);
    end
end