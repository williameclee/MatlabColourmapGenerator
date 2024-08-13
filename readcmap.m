%% READCMAP
%   finds a colourmap by name and returns the corresponding colour
%   string and position.
%
%   Syntax:
%   [colourString, colourPosition, cmapPolarity] = readcmap(name)
%       searches for a colourmap with the specified name and returns the
%       corresponding colour string and position, as well as the polarity
%       of the colour map.
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
%   [colourString, colourPosition, cmapPolarity] = ...
%       readcmap('temperature');
%
%   This is a helper function for keynotecmap.
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   May 9, 2024
%
%   Last modified by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 14, 2024

function [colourString, colourPosition, cmapPolarity] = ...
        readcmap(name, varargin)
    %% Initialisation
    p = inputParser;
    addRequired(p, 'Name', @(x) ischar(x) || isstring(x));
    addOptional(p, 'ColourScheme', 'keynote', ...
        @(x) ischar(x) || isstring(x));
    parse(p, name);
    name = p.Results.Name;
    colourScheme = p.Results.ColourScheme;

    %% Reading the colour map data
    fileroot = fullfile(fileparts(mfilename('fullpath')), 'colours');
    indexFileId = fopen(fullfile(fileroot, [colourScheme, '-cmaps.txt']), 'r');

    if indexFileId == -1
        error('readcmap:FileNotFound', ...
        'The colour map index file was not found.');
    end

    fgetl(indexFileId);
    
    % Read the metadata
    nCmap = textscan(indexFileId, '%u', 1);
    nCmap = nCmap{1};

    % Read the colourmaps
    cmapMetadata = textscan(indexFileId, '%s %s %s %s', nCmap, 'Delimiter', ';');
    cmapNames = string(cmapMetadata{1});
    cmapColours = cmapMetadata{2};
    cmapColours = cellfun(@strsplit, ...
        cmapColours, ...
        'UniformOutput', false); % format data
    cmapPosition = cmapMetadata{3};
    cmapPosition = cellfun(@(x) str2double(strsplit(x, ',')), ...
        cmapPosition, ...
        'UniformOutput', false); % format data
    cmapPolarity = string(cmapMetadata{4});

    %% Retriving the specified colour map data
    cmapId = find(cmapNames == name, 1);
    % Check if the colour map was found
    if isempty(cmapId)
        error(['Unknown colour map name ''', name, '''.']);
    end

    %% Collecting and returning the colour map data
    colourString = cmapColours{cmapId};
    colourPosition = cmapPosition{cmapId};
    cmapPolarity = cmapPolarity{cmapId};
end
