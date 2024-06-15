%% XYZ2SRGB
%    Converts a n x 3 matrix of XYZ colour values to sRGB. The algorithm and the matrix are taken from https://www.image-engineering.de/library/technotes/958-how-to-convert-between-srgb-and-ciexyz
%
%    Syntax:
%    colourSrgb = xyz2srgb(colourXyz)
%        returns the sRGB colour values of the XYZ colour values.
%
%    Input:
%    - colourXyz: A n x 3 or 3 x n numeric matrix representing the XYZ colour values.
%
%    Output:
%    - colourSrgb: A n x 3 or 3 x n numeric matrix representing the sRGB colour values. The size of the output is the same as the input.
%
%    Example:
%    colourSrgb = xyz2srgb([0.5, 0, 0]);
%
%    See also:
%    SRGB2XYZ, XYZ2OKLAB, OKLAB2XYZ
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 14, 2024

function colourSrgb = xyz2srgb(colourXyz)
    %% Input Validation
    p = inputParser;
    addRequired(p, 'colourXyz', ...
        @(x) isnumeric(x) && any(size(x) == 3));
    parse(p, colourXyz);
    colourXyz = p.Results.colourXyz;

    %% Pre-processing
    % Check if the input is transposed
    isTransposed = size(colourXyz, 2) ~= 3;

    if isTransposed
        colourXyz = colourXyz';
    end

    %% Colour space transformation
    % From XYZ to sRGB
    M = [ ...
             +3.2404542, -1.5371385, -0.4985314; ...
             -0.9692660, +1.8760108, +0.0415560; ...
             +0.0556434, -0.2040259, +1.0572252 ...
         ];

    colourSrgb = M * colourXyz';

    isLinear = colourSrgb <= 0.0031308;
    colourSrgb(isLinear) = colourSrgb(isLinear) * 12.92;
    colourSrgb(~isLinear) = 1.055 * colourSrgb(~isLinear) .^ (1/2.4) - 0.055;

    %% Post-processing
    % Clip the colour values to the valid range
    colourSrgb = max(0, min(1, real(colourSrgb)));

    % Reshape the output to the same size as the input
    if ~isTransposed
        colourSrgb = colourSrgb';
    end

end
