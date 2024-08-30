function [colour, errorFlag, ColourData] = getcolour(scheme, varargin)
    errorFlag = uint8(0);

    % Parse inputs
    p = inputParser;
    addRequired(p, 'ColourName', @(x) ischar(x) || isstring(x));
    addOptional(p, 'Darkness', 2, @isnumeric);
    addParameter(p, 'Format', 'normalised', @(x) ischar(x) || isstring(x));
    addParameter(p, 'ColourData', []);
    parse(p, varargin{:});
    colourName = p.Results.ColourName;
    darkness = p.Results.Darkness;
    format = p.Results.Format;
    ColourData = p.Results.ColourData;

    %% Processing the colour and darkness values
    % Convert colour abbreviation to colour name and darkness value
    if iscolourabbr(colourName)
        darkness = str2double(colourName(2:end));
        colourName = colourName(1);
    end

    %% Retrieving the colour from the colour files
    % Truncate the darkness value to the range [0, 5]
    if darkness < 0 || darkness > 5
        warning(['Darkness value must be between 0 and 5. ', ...
                 'Truncating to this range.']);
        errorFlag = uint8(2);
        darkness = min(max(darkness, 0), 5);
    end

    if isempty(ColourData)
        [ColourData.matrix, ColourData.aliases, ~, ~, ColourData.nShade] = ...
            readcolourmatrix(scheme);
        ColourData.matrix = double(ColourData.matrix);
    end

    colourId = find(cellfun(@(c) any(strcmp(colourName, c)), ColourData.aliases), 1, 'first');

    if isempty(colourId)
        errorFlag = uint8(1);
        warning(['Unknown colour name ''', colourName, '''.']);
        colour = [255, 255, 255]; % white
        return
    end

    % Retrieve the colour based on the darkness value
    colour = interpcolour(ColourData, colourId, darkness);
    % Normalise the colour based on the format
    switch lower(format)
        case {'normalised', 'normalized'}
            colour = colour / 255;
        case {'8bit', '8-bit', 'uint8', 'int'}
            colour = uint8(colour);
        otherwise
            error(['Unknown format ''', format, '''.']);
    end

end
