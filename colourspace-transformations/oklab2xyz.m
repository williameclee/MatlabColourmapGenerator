%% OKLAB2XYZ
%   Coneverts a n x 3 matrix of Oklab colour values to XYZ. The algorithm 
%   and the matrix are taken from https://bottosson.github.io/posts/oklab/
%
%   Syntax:
%   colourXyz = oklab2xyz(colourOklab)
%       returns the XYZ colour values of the Oklab colour values.
%
%   Input:
%   - colourOklab: A n x 3 or 3 x n numeric matrix representing the Oklab 
%       colour values.
%
%   Output:
%   - colourXyz: A n x 3 or 3 x n numeric matrix representing the XYZ 
%       colour values. The size of the output is the same as the input.
%
%   Example:
%   colourXyz = oklab2xyz([0.5, 0, 0]);
%
%   See also:
%   XYZ2OKLAB
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 14, 2024

function colourXyz = oklab2xyz(colourOklab)
    %% Input Validation
    p = inputParser;
    addRequired(p, 'colourOklab', ...
        @(x) isnumeric(x) && any(size(x) == 3));
    parse(p, colourOklab);
    colourOklab = p.Results.colourOklab;

    %% Pre-processing
    % Check if the input is transposed
    needsTranspose = size(colourOklab, 2) == 3 && size(colourOklab, 1) ~= 3;

    if needsTranspose
        colourOklab = colourOklab';
    end

    %% Colour space transformation
    % From Oklab to lms to XYZ
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

    colourLms = Mlms2oklab \ colourOklab;
    colourXyz = Mxyz2lms \ (colourLms .^ 3);

    %% Post-processing
    % Clip the colour values to the valid range
    colourXyz = real(colourXyz);

    % Reshape the output to the same size as the input
    if needsTranspose
        colourXyz = colourXyz';
    end

end
