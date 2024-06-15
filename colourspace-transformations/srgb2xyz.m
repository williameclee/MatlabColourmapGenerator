%% SRGB2XYZ
%   Coneverts a n x 3 matrix of sRGB colour values to XYZ. The algorithm and the matrix are taken from https://www.image-engineering.de/library/technotes/958-how-to-convert-between-srgb-and-ciexyz
%
%   Syntax:
%   colourXyz = srgb2xyz(colourSrgb)
%       returns the XYZ colour values of the sRGB colour values.
%
%   Input:
%   - colourSrgb: A n x 3 or 3 x n numeric matrix representing the sRGB colour values.
%
%   Output:
%   - colourXyz: A n x 3 or 3 x n numeric matrix representing the XYZ colour values. The size of the output is the same as the input.
%
%   Example:
%   colourXyz = srgb2xyz([0.5, 0, 0]);
%
%   See also:
%   XYZ2SRGB, SRGB2OKLAB, OKLAB2XYZ
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 14, 2024

function colourXyz = srgb2xyz(colourSrgb)
    %% Input Validation
    p = inputParser;
    addRequired(p, 'colourSrgb', ...
        @(x) isnumeric(x) && any(size(x) == 3));
    parse(p, colourSrgb);
    colourSrgb = p.Results.colourSrgb;

    %% Pre-processing
    % Check if the input is transposed
    isTransposed = size(colourSrgb, 2) ~= 3;

    if isTransposed
        colourSrgb = colourSrgb';
    end

    %% Colour space transformation
    % Convert sRGB to linear RGB
    isLinear = colourSrgb <= 0.04045;
    colourSrgb(isLinear) = colourSrgb(isLinear) / 12.92;
    colourSrgb(~isLinear) = ((colourSrgb(~isLinear) + 0.055) / 1.055) .^ 2.4;

    M = [ ...
             +0.4124564, +0.3575761, +0.1804375; ...
             +0.2126729, +0.7151522, +0.0721750; ...
             +0.0193339, +0.1191920, +0.9503041 ...
         ];

    colourXyz = M * colourSrgb';

    %% Post-processing
    % Clip the colour values to the valid range
    colourXyz = real(colourXyz);

    % Reshape the output to the same size as the input
    if ~isTransposed
        colourXyz = colourXyz';
    end

end
