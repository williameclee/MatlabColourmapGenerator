%% SRGB2OKLAB
%   Coneverts a n x 3 matrix of sRGB colour values to Oklab.
%
%   Syntax:
%   colourOklab = srgb2oklab(colourSrgb)
%       returns the Oklab colour values of the sRGB colour values.
%
%   Input:
%   - colourSrgb: A n x 3 or 3 x n numeric matrix representing the sRGB colour values.
%
%   Output:
%   - colourOklab: A n x 3 or 3 x n numeric matrix representing the Oklab colour values. The size of the output is the same as the input.
%
%   Example:
%   colourOklab = srgb2oklab([0.5, 0, 0]);
%
%   See also:
%   OKLAB2SRGB, SRGB2XYZ, XYZ2OKLAB
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 14, 2024

function colourOklab = srgb2oklab(colourSrgb)
    %% Input Validation
    p = inputParser;
    addRequired(p, 'colourSrgb', ...
        @(x) isnumeric(x) && any(size(x) == 3));
    parse(p, colourSrgb);
    colourSrgb = p.Results.colourSrgb;

    %% Pre-processing
    % Check if the input is transposed
    isTransposed = size(colourSrgb, 2) ~= 3; % if input is 3 x n

    if isTransposed
        colourSrgb = colourSrgb'; % reshape to n x 3
    end

    %% Colour space transformation
    % From sRGB to XYZ to Oklab
    colourXyz = srgb2xyz(colourSrgb);
    colourOklab = xyz2oklab(colourXyz);

    %% Post-processing
    % Clip the colour values to the valid range
    colourOklab = real(colourOklab);

    % Reshape the output to the same size as the input
    if isTransposed
        colourOklab = colourOklab';
    end

end
