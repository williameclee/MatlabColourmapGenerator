%% RAEDCOLOURMATRIX
% 	Reads the colour matrix from the specified colour scheme file.
%
%   Syntax:
%   [colourMatrix, colourAliases, colourNames, nColour, nShade] = ...
%       readcolourmatrix(colourScheme)
%   Input:
%   - colourScheme: A string representing the name of the colour scheme.
%
%   Output:
%   - colourMatrix: A nColour * nShade x 3 numeric matrix representing the 
%       RGB colour values.
%   - colourAliases: A nColour x 1 cell array representing the aliases of 
%       the colours.
%   - colourNames: A nColour x 1 cell array representing the names of the 
%       colours.
%   - nColour: A scalar representing the number of colours in the colour 
%       scheme.
%   - nShade: A scalar representing the number of shades per colour in the 
%       colour scheme.
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   May 9, 2024

function [colourMatrix, colourAliases, colourNames, nColour, nShade] = ...
        readcolourmatrix(colourScheme)
    %% Opening the index file
    indexFileId = fopen(['colours/', colourScheme, '-colours.txt'], 'r');

    if indexFileId == -1
        error('readcolourmatrix:FileNotFound', ...
        'The colour scheme file was not found.');
    end

    % Read the header line
    fgetl(indexFileId);

    %% Pre-processing and preallocation
    % Read the metadata
    metadata = textscan(indexFileId, '%u %u', 1, 'Delimiter', ';');
    nColour = metadata{1};
    nShade = metadata{2};

    % Preallocation
    colourNames = cell([nColour, 1]);
    colourAliases = cell([nColour, 1]);
    colourMatrix = zeros([nColour * nShade, 3], 'uint8');

	%% Reading the colour matrix
    % Read the colours
    for colourId = 1:nColour
        % Read the colour name
        colourMetadata = textscan(indexFileId, '%s %s', 1, ...
            'Delimiter', ';');
        colourNames{colourId} = colourMetadata{1};
        colourAliases{colourId} = strsplit(colourMetadata{2}{1}, ', ');
        % Read the colour shades
        colourRGB = textscan(indexFileId, '%u8 %u8 %u8', nShade, ...
            'Delimiter', ',');
        colourMatrix((colourId - 1) * nShade + 1:colourId * nShade, :) = ...
            [colourRGB{1}, colourRGB{2}, colourRGB{3}];

    end

end
