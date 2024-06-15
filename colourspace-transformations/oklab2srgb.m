%% OKLAB2SRGB
%   Coneverts a n x 3 matrix of Oklab colour values to sRGB.
%
%   Syntax:
%   colourSrgb = oklab2srgb(colourOklab)
%       returns the sRGB colour values of the Oklab colour values.
%
%   Input:
%   - colourOklab: A n x 3 or 3 x n numeric matrix representing the Oklab colour values.
%
%   Output:
%   - colourSrgb: A n x 3 or 3 x n numeric matrix representing the sRGB colour values. The size of the output is the same as the input.
%
%   Example:
%   colourSrgb = oklab2srgb([0.5, 0, 0]);
%
%   See also:
%   SRGB2OKLAB, OKLAB2XYZ, XYZ2SRGB
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 14, 2024

function colourSrgb = oklab2srgb(colourOklab)
    %% Input Validation
    p = inputParser;
    addRequired(p, 'colourOklab', ...
        @(x) isnumeric(x) && any(size(x) == 3));
    parse(p, colourOklab);
    colourOklab = p.Results.colourOklab;

    %% Pre-processing
    % Check if the input is transposed
    isTransposed = size(colourOklab, 2) ~= 3; % if input is 3 x n

    if isTransposed
        colourOklab = colourOklab'; % reshape to n x 3
    end

    %% Colour space transformation
    % From Oklab to XYZ to sRGB
    colourXyz = oklab2xyz(colourOklab);
    colourSrgb = xyz2srgb(colourXyz);

    %% Post-processing
    % Clip the colour values to the valid range
    colourSrgb = max(0, min(1, real(colourSrgb)));

    % Reshape the output to the same size as the input
    if isTransposed
        colourSrgb = colourSrgb';
    end

end
