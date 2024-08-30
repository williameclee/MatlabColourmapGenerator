%% ID2COLOUR
%   Converts a character array or cell array of character arrays
%   representing colours to an (RGB) colour array.
%
%   Syntax:
%   colourArray = id2colour(colourString)
%
%   Input:
%   - colourString: A character array or a cell array of character
%       arrays representing colours.
%
%   Output:
%   - colourArray: An RGB colour array, where each row represents a colour
%       in the input.
%
%   Example:
%   colourArray = id2colour('b4y3');
%   colourArray = id2colour({'b4', 'y3'});
%   They will return the same 2-by-3 colour array.
%
%   See also:
%   KEYNOTECOLOUR (KC)
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   May 9, 2024
%
%   Last modified by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 14, 2024

function colourArray = id2colour(colourString, varargin)
    p = inputParser;
    addOptional(p, 'ColourScheme', 'keynote', ...
        @(x) ischar(x) || isstring(x));
    parse(p, varargin{:});
    cscheme = p.Results.ColourScheme;

    switch cscheme
        case 'keynote'
            cfun = 'keynotecolour';
        case 'custom'
            cfun = 'customcolour';
        otherwise
            error('Unknown colour scheme ''%s''.', cscheme);
    end

    % Siwtch between character array and cell array
    if ischar(colourString)
        colourArray = char2colour(colourString, cfun);
    elseif iscell(colourString)
        colourArray = cell2colour(colourString, cfun);
    else
        error('Input must be a character array or a cell array of character arrays.');
    end

end

%% Subfunctions
% Converts a character array representing colours to an (RGB) colour array
function colourArray = char2colour(colourChar, cfun)
    % Split the string into individual colours
    colourString = strrep(colourChar, ' ', '');
    colourString = regexprep(colourString, '([A-Za-z])', '; $1');
    colourList = strsplit(colourString, '; ');
    colourList = colourList(~cellfun('isempty', colourList));

    % Initialise the colour array
    colourArray = zeros(length(colourList), 3);
    ColourData = [];

    % Convert each colour to an colour array with keynotecolour
    for colourId = 1:length(colourList)
        [colourArray(colourId, :), errorFlag, ColourData] = ...
            feval(cfun, colourList{colourId}, 'ColourData', ColourData);

        switch errorFlag
            case 1
                warning(['Unknown colour name ''', ...
                             colourList{colourId}, ...
                             ''' in the input at index ', ...
                             num2str(colourId), '.']);
        end

    end

end

% Converts character arrays to an RGB colour array
function colourArray = cell2colour(colourCell, cfun)
    % Initialise the colour array
    colourArray = zeros(length(colourCell), 3);
    ColourData = [];
    % Convert each colour to an colour array with keynotecolour
    for colourId = 1:length(colourCell)
        [colourArray(colourId, :), errorFlag, ColourData] = ...
            feval(cfun, char(colourCell{colourId}), ...
            'ColourData', ColourData);

        switch errorFlag
            case 1
                warning(['Unknown colour name ''', ...
                             colourCell{colourId}, ...
                             ''' in the input at index ', ...
                             num2str(colourId), '.']);
        end

    end

end
