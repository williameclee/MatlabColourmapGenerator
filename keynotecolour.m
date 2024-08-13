%%  KEYNOTECOLOUR
%   Returns the RGB value of a colour in Apple's Keynote colour palette
%   based on the given colour name, darkness, and format.
%
%   Syntax:
%   colour = keynotecolour(colourname)
%       returns the colour specified by the colour name or the
%       colour-darkness abbreviation.
%   colour = keynotecolour(colourname, darkness)
%       returns the colour with the specified darkness value.
%   colour = keynotecolour(colourname, 'Format', format)
%       returns the colour with the specified format, 'normalised' or
%       '8bit'.
%       The default format is 'normalised'.
%
%   Input Arguments:
%   - colourname: A string (char) specifying the colour name, or an
%       abbreviation followed by the darkness value.
%       For example, 'blue', 'b', or 'b3'.
%   - darkness: A number specifying the darkness level of the colour.
%       The darkness value can be between 0 and 4, where 0 is the lightest
%       and 4 is the darkest.
%   - format: A string (char) specifying the format of the colour.
%
%   Output Argument:
%   - colour: A 1-by-3 numeric array representing the RGB values of the
%       colour.
%
%   Example:
%   colour = keynotecolour('blue', 3);
%   colour = keynotecolour('b3');
%   colour = keynotecolour('b', 3, 'Format', '8bit');
%
%   An alias for this function is kc.
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   May 9, 2024
%
%   Last modified by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 6, 2024

function [colour, errorFlag, ColourData] = ...
        keynotecolour(colourName, varargin)
    %% Initialisation
    errorFlag = uint8(0);
    % fileroot = [fileparts(mfilename('fullpath')), '/colours/'];
    p = inputParser;
    addRequired(p, 'ColourName', @(x) ischar(x) || isstring(x));
    addOptional(p, 'Darkness', 2, @isnumeric);
    addParameter(p, 'Format', 'normalised', @(x) ischar(x) || isstring(x));
    addParameter(p, 'ColourData', []);
    parse(p, colourName, varargin{:});
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
    % Truncate the darkness value to the range [0, 4]
    if darkness < 0 || darkness > 4
        warning(['Darkness value must be between 0 and 4. ', ...
                 'Truncating to this range.']);
        errorFlag = uint8(2);
        darkness = min(max(darkness, 0), 4);
    end

    if isempty(ColourData)
        [ColourData.matrix, ColourData.aliases, ~, ~, ColourData.nShade] = ...
            readcolourmatrix('keynote');
        ColourData.matrix = double(ColourData.matrix);
    end

    colourId = find(cellfun(@(c) any(strcmp(colourName, c)), ColourData.aliases), 1, 'first');

    if isempty(colourId)
        errorFlag = uint8(1);
        warning(['Unknown colour name ''', colourName, '''.']);
        colour = [255, 255, 255]; % white
        return;
    end

    % Retrieve the colour based on the darkness value
    colour = getcolour(ColourData, colourId, darkness);
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

%% Subfunctions
% Returning the interpolated colour based on the index value.
function colour = getcolour(ColourData, colourId, shade)
    % Determine whether interpolation is necessary
    if isinteger(shade)

        if shade == 0
            colour = ones([1, 3]) * 255; % white
        else
            colour = ColourData.matrix((colourId - 1) * ColourData.nShade + shade, :);
        end

        return;
    end

    % Interpolate between the colours
    if shade < 1 % interpolate between white and the first colour
        colour = ColourData.matrix((colourId - 1) * ColourData.nShade + 1, :) * shade + ones([1, 3]) * 255 * (1 - shade);
    else % interpolate between colours
        shadeInt = floor(shade);
        colour = interp1([shadeInt, shadeInt + 1], ...
            [ColourData.matrix((colourId - 1) * ColourData.nShade + shadeInt, :); ColourData.matrix((colourId - 1) * ColourData.nShade + shadeInt + 1, :)], ...
            shade, 'linear');
    end

end

% Determination of whether the input is numerically an integer (but not necessarily using an integer class).
function flag = isinteger(x)
    flag = isnumeric(x) && isreal(x) && isfinite(x) && x == round(x);
end

% Determination of whether the input is a colour abbreviation (e.g. 'b3')
function flag = iscolourabbr(colourString)
    flag = isnumeric(str2double(colourString(2:end))) && ...
        ~isnan(str2double(colourString(2:end)));
end
