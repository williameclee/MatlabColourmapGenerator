%%  findcmap
%   finds a colourmap by name and returns the corresponding colour string
%   and position.
%
%   Syntax:
%   [colourString, colourPosition] = findcmap(name) searches for a
%   colourmap with the specified name and returns the corresponding colour
%   string and position.
%
%   Inputs:
%   - name: The name of the colour map to search for.
%
%   Outputs:
%   - colourString: The colour string of the found colour map.
%   - colourPosition: The position of the found colour map.
%
%   Example:
%       [colourString, colourPosition] = findcmap('temperature');
%
%   This is a helper function for keynotecmap.
%
%   E.-C. 'William' Lee
%   williameclee@gmail.com
%   May 13, 2024

function [colourString, colourPosition] = findcmap(name)
    % Read all the colour map data
    fileroot = [fileparts(mfilename('fullpath')), '/colours/'];
    [colourDict, positionDict] = readcolourmap(fileroot);

    if ~isKey(colourDict, lower(name))
        error(['Unknown colour map name ''', name, '''.']);
    end

    % Look up the colourmap name
    colourString = colourDict(name);
    colourPosition = positionDict(name);
    % Clean the data format
    colourString = colourString{:};
    colourPosition = colourPosition{:};
end

%% Read the colour map data from the index file
function [colourDict, positionDict] = readcolourmap(fileroot)
    % Read the colour index file into a table and clean the data format
    index_table = readtable([fileroot, 'index-colourmaps.csv'], ...
        'Delimiter', ';');
    index_table.name = string(index_table.name);
    index_table.colourString = cellfun(@strsplit, ...
        index_table.colourString, ...
        'UniformOutput', false);
    index_table.position = cellfun(@(x) str2double(strsplit(x, ',')), ...
        index_table.position, ...
        'UniformOutput', false);

    % Convert the table to a dictionary
    colourDict = dictionary(index_table.name, ...
        index_table.colourString);
    positionDict = dictionary(index_table.name, ...
        index_table.position);

end
