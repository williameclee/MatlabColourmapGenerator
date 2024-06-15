%% XYZ2OKLAB
%   Converts a colour from XYZ to Oklab. The algorithm and the matrix are taken from https://bottosson.github.io/posts/oklab/
%
%   Syntax:
%   colourOklab = xyz2oklab(colourXyz)
%       returns the Oklab colour values of the XYZ colour values.
%
%   Input:
%   - colourXyz: A n x 3 or 3 x n numeric matrix representing the XYZ colour values.
%
%   Output:
%   - colourOklab: A n x 3 or 3 x n numeric matrix representing the Oklab colour values. The size of the output is the same as the input.
%
%   Example:
%   colourOklab = xyz2oklab([0.5, 0, 0]);
%
%   See also:
%   OKLAB2XYZ
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 14, 2024

function colourOklab = xyz2oklab(colourXyz)
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
    % From XYZ to lms to Oklab
    Mxyz2lms = [ ...
                    +0.8189330101, +0.0329845436, +0.0482003018; ...
                    + 0.3618667424, +0.9293118715, +0.2643662691; ...
                    - 0.1288597137, +0.0361456387, +0.6338517070 ...
                ];
    Mlms2oklab = [ ...
                      +0.2104542553, +1.9779984951, +0.0259040371; ...
                      +0.7936177850, -2.4285922050, +0.7827717662; ...
                      -0.0040720468, +0.4505937099, -0.8086757660 ...
                  ];

    colourLms = Mxyz2lms * colourXyz';
    colourOklab = Mlms2oklab * (colourLms .^ (1/3));

    %% Post-processing
    % Clip the colour values to the valid range
    colourOklab = real(colourOklab);

    % Reshape the output to the same size as the input
    if ~isTransposed
        colourOklab = colourOklab';
    end

end
