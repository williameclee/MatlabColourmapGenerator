% FILEPATH: /Users/williameclee/Documents/MATLAB/custom-colours/keynoteColour.m
%
% KEYNOTECOLOUR Returns the RGB value of a colour in Apple's Keynote colour palette based on the given colour name, darkness, and format.
%
%   COLOUR = KEYNOTECOLOUR(COLOURNAME) returns the customised colour specified by COLOURNAME.
%   The default darkness value is 2, and the default format is 'normalised'.
%   The COLOURNAME can be a string like 'blue' or 'green', or an abbrevation followed by the darkness value like 'b3' or 'g1'.
%
%   COLOUR = KEYNOTECOLOUR(COLOURNAME, DARKNESS) returns the customised colour with the specified darkness value.
%   The darkness value can be a number between 0 and 4, where 0 is the lightest and 4 is the darkest. The default darkness value is 2.
%
%   COLOUR = KEYNOTECOLOUR(COLOURNAME, 'Format', FORMAT) returns the customised colour with the specified format.
%   The format can be 'normalised' to between 0 and 1 (default) or '8bit' to between 0 and 255.
%
%   Input Arguments:
%   - COLOURNAME: A character vector specifying the colour name, or an abbreviation followed by the darkness value.
%   - DARKNESS: A numeric value specifying the darkness level of the colour (default is 2).
%   - FORMAT: A character vector specifying the format of the colour (default is 'normalised').
%
%   Output Argument:
%   - COLOUR: A 1-by-3 numeric array representing the RGB values of the customised colour.
%
%   Example:
%   colour = keynotecolour('blue', 3);
%   colour = keynotecolour('b3');
%   colour = keynotecolour('b', 3, 'Format', '8bit');
%
% E.-C. 'William' Lee
% williameclee@gmail.com
% May 9, 2024

function colour = keynotecolour(colourName, varargin)
    p = inputParser;
    addRequired(p, 'colourName', @ischar);
    addOptional(p, 'Darkness', 2, @isnumeric);
    addParameter(p, 'Format', 'normalised', @ischar);
    parse(p, colourName, varargin{:});
    colourName = p.Results.colourName;
    darkness = p.Results.Darkness;
    format = p.Results.Format;

    fileroot = [fileparts(mfilename('fullpath')), '/colours/'];

    if isnumeric(str2double(colourName(2:end))) && ~isnan(str2double(colourName(2:end)))
        darkness = str2double(colourName(2:end));
        colourName = colourName(1);
    end

    colourFile = dictionary(["grey", "gray", "black", "k", "white", "w", "blue", "b", "green", "g", "cyan", "c", "yellow", "y", "red", "r", "purple", "pink", "p"], ...
        ["grey.csv", "grey.csv", "grey.csv", "grey.csv", "grey.csv", "grey.csv", "blue.csv", "blue.csv", "green.csv", "green.csv", "cyan.csv", "cyan.csv", "yellow.csv", "yellow.csv", "red.csv", "red.csv", "purple.csv", "purple.csv", "purple.csv"] ...
    );

    if isKey(colourFile, colourName)
        colourList = readmatrix(strjoin([fileroot, colourFile(colourName)], ''));
    else
        warning(['Unknown colour name ''', colourName, ''', returning black.']);
        colour = [0, 0, 0];
        return;
    end

    if darkness < 0 || darkness > 4
        warning('Darkness value must be between 0 and 4. Truncating to this range.');
        darkness = min(max(darkness, 0), 4);
    end

    colour = getColour(colourList, darkness);

    switch lower(format)
        case {'normalised', 'normalized'}
            colour = colour / 255;
        case {'8bit', '8-bit', 'uint8', 'int'}
            colour = uint8(colour);
        otherwise
            warning(['Unknown format ''', format, ''', returning normalised.']);
            colour = colour / 255;
    end

end

function colour = getColour(colourList, index)
    % Returns the interpolated colour based on the index value.
    if isInteger(index)

        if index == 0
            colour = [255, 255, 255];
        else
            colour = colourList(index, :);
        end

    else

        if index < 1
            colour = colourList(1, :) * index + [255, 255, 255] * (1 - index);
        else
            indexInt = floor(index);
            colour = interp1([indexInt, indexInt + 1], [colourList(indexInt, :); colourList(indexInt + 1, :)], ...
                index, 'linear', 'extrap');
        end

    end

end

function flag = isInteger(x)
    % Returns true if the input is numerically an integer (but not necessarily using an integer class).
    flag = isnumeric(x) && isreal(x) && isfinite(x) && x == round(x);
end
