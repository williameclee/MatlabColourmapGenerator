%%  findcmap
%   finds a colourmap by name and returns the corresponding colour string
%   and position.
%
%   Syntax:
%   [colourString, colourPosition, cmapPolarity] = findcmap(name) searches for a
%   colourmap with the specified name and returns the corresponding colour
%   string and position, as well as the polarity of the colour map.
%
%   Inputs:
%   - name: The name of the colour map to search for.
%
%   Outputs:
%   - colourString: The colour string of the found colour map.
%   - colourPosition: The position of the found colour map.
%   - cmapPolarity: The polarity of the found colour map.
%
%   Example:
%       [colourString, colourPosition, cmapPolarity] = findcmap('temperature');
%
%   This is a helper function for keynotecmap.
%
%   E.-C. 'William' Lee
%   williameclee@gmail.com
%   Jun 4, 2024

function [colourString, colourPosition, cmapPolarity] = findcmap(name)
    % Read all the colour map data
    fileroot = fullfile(fileparts(mfilename('fullpath')), 'colours');
    % Read the colour index file into a table and clean the data format
    index_table = readtable(fullfile(fileroot, 'index-colourmaps.csv'), ...
        'Delimiter', ';');
    % Format the table cells
    index_table.name = string(index_table.name);
    index_table.colourString = cellfun(@strsplit, ...
        index_table.colourString, ...
        'UniformOutput', false);
    index_table.position = cellfun(@(x) str2double(strsplit(x, ',')), ...
        index_table.position, ...
        'UniformOutput', false);
    index_table.polarity = string(index_table.polarity);

    % Find the colour map by name
    cmapId = find(index_table.name == name, 1);
    % Check if the colour map was found
    if isempty(cmapId)
        error(['Unknown colour map name ''', name, '''.']);
    end

    % Return the colour map data
    colourString = index_table.colourString{cmapId};
    colourPosition = index_table.position{cmapId};
    cmapPolarity = index_table.polarity{cmapId};
end
