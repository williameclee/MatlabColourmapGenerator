%%  id2colour
%   Converts a character array or cell array of character arrays
%   representing colours to an (RGB) colour array.
%
%   Syntax:
%   colourArray = id2colour(colourString)
%
%   Input:
%   - colourString: A character array or a cell array of character arrays
%       representing colours.
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
%   keynotecolour
%
%   E.-C. 'William' Lee
%   williameclee@gmail.com
%   May 13, 2024

function colourArray = id2colour(colourString)
    % Siwtch between character array and cell array
    if ischar(colourString)
        colourArray = char2colour(colourString);
    elseif iscell(colourString)
        colourArray = cell2colour(colourString);
    else
        error('Input must be a character array or a cell array of character arrays.');
    end

end

%%  Converts a character array representing colours to an (RGB) colour array
function colourArray = char2colour(colourChar)
    % Split the string into individual colours
    colourString = strrep(colourChar, ' ', '');
    colourString = regexprep(colourString, '([A-Za-z])', '; $1');
    colourList = strsplit(colourString, '; ');
    colourList = colourList(~cellfun('isempty', colourList));

    % Initialise the colour array
    colourArray = zeros(length(colourList), 3);
    % Convert each colour to an colour array with keynotecolour
    for colourId = 1:length(colourList)
        [colourArray(colourId, :), errorFlag] = keynotecolour( ...
            colourList{colourId});

        switch errorFlag
            case 1
                warning(['Unknown colour name ''', ...
                             colourList{colourId}, ...
                             ''' in the input at index ', ...
                             num2str(colourId), '.']);
        end

    end

end

%%  Converts a cell array of character arrays representing colours to an RGB colour array
function colourArray = cell2colour(colourCell)
    % Initialise the colour array
    colourArray = zeros(length(colourCell), 3);
    % Convert each colour to an colour array with keynotecolour
    for colourId = 1:length(colourCell)
        [colourArray(colourId, :), errorFlag] = keynotecolour( ...
            char(colourCell{colourId}));

        switch errorFlag
            case 1
                warning(['Unknown colour name ''', ...
                             colourCell{colourId}, ...
                             ''' in the input at index ', ...
                             num2str(colourId), '.']);
        end

    end

end
