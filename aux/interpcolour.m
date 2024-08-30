% Returning the interpolated colour based on the index value.
function colour = interpcolour(CData, colourId, shade)
    % Determine whether interpolation is necessary
    if isintegerv(shade)

        if shade == 0
            colour = [1, 1, 1] * 255; % white
        elseif shade == 5
            colour = [0, 0, 0]; % black
        else
            colour = CData.matrix((colourId - 1) * CData.nShade + shade, :);
        end

        return
    end

    % Interpolate between the colours
    if shade < 1 % interpolate between white and the first colour
        colour = CData.matrix((colourId - 1) * CData.nShade + 1, :) * shade ...
            + ones([1, 3]) * 255 * (1 - shade);
    else % interpolate between colours
        shadeInt = floor(shade);
        colour = interp1([shadeInt, shadeInt + 1], ...
            [CData.matrix((colourId - 1) * CData.nShade + shadeInt, :); ...
             CData.matrix((colourId - 1) * CData.nShade + shadeInt + 1, :)], ...
            shade, 'linear');
    end

end
