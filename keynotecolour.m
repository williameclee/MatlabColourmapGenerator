%%  keynotecolour
%   Returns the RGB value of a colour in Apple's Keynote colour palette
%   based on the given colour name, darkness, and format.
%
%   Syntax:
%   colour = keynotecolour(colourname) returns the colour specified by the
%       colour name or the colour-darkness abbreviation.
%   colour = keynotecolour(colourname, darkness) returns the colour with
%       the specified darkness value.
%   colour = keynotecolour(colourname, 'Format', format) returns the colour
%       with the specified format, 'normalised' or '8bit'.
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
%   E.-C. 'William' Lee
%   williameclee@gmail.com
%   May 13, 2024

function [colour, errorFlag] = keynotecolour(colourName, varargin)
    %% Initialisation
    errorFlag = uint8(0);
    fileroot = [fileparts(mfilename('fullpath')), '/colours/'];
    p = inputParser;
    addRequired(p, 'ColourName', @ischar);
    addOptional(p, 'Darkness', 2, @isnumeric);
    addParameter(p, 'Format', 'normalised', @ischar);
    parse(p, colourName, varargin{:});
    colourName = p.Results.ColourName;
    darkness = p.Results.Darkness;
    format = p.Results.Format;

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

    % Generate the colour-to-file dictionary
    fileDict = findfile(fileroot);
    % Read the colour list from the corresponding file
    if isKey(fileDict, colourName)
        colourList = readmatrix(strjoin([fileroot, fileDict(colourName)], ''));
    else
        error(['Unknown colour name ''', colourName, '''.']);
    end

    % Retrieve the colour based on the darkness value
    colour = getColour(colourList, darkness);
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

%% Reading the colour index file and generating the colour-to-file dictionary.
function fileDict = findfile(fileroot)
    % Read the colour index file into a table and clean the data format
    colour_index_table = readtable([fileroot, 'index-colours.csv'], ...
        'Delimiter', ';');
    colour_index_table.aliases = cellfun(@(x) (strsplit(x, ', ')), ...
        colour_index_table.aliases, ...
        'UniformOutput', false);
    % Generate the colour-to-file dictionary
    aliases = [colour_index_table.aliases{:}].';
    file = cellfun(@(x, y) repmat({x}, length(y), 1), ...
        colour_index_table.file, colour_index_table.aliases, ...
        'UniformOutput', false);
    file = vertcat(file{:});
    fileDict = dictionary(string(aliases), string(file));
end

%% Returning the interpolated colour based on the index value.
function colour = getColour(colourList, index)
    % Determine whether interpolation is necessary
    if isinteger(index)

        if index == 0
            colour = [255, 255, 255]; % white
        else
            colour = colourList(index, :);
        end

        return;
    end

    % Interpolate between the colours
    if index < 1 % interpolate between white and the first colour
        colour = colourList(1, :) * index + [255, 255, 255] * (1 - index);
    else % interpolate between colours
        indexInt = floor(index);
        colour = interp1([indexInt, indexInt + 1], ...
            [colourList(indexInt, :); colourList(indexInt + 1, :)], ...
            index, 'linear');
    end

end

%% Determination of whether the input is numerically an integer (but not necessarily using an integer class).
function flag = isinteger(x)
    flag = isnumeric(x) && isreal(x) && isfinite(x) && x == round(x);
end

%% Determination of whether the input is a colour abbreviation (e.g. 'b3')
function flag = iscolourabbr(colourString)
    flag = isnumeric(str2double(colourString(2:end))) && ...
        ~isnan(str2double(colourString(2:end)));
end
