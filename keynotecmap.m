%%  keynotecmap
%   Generate a custom colourmap based on a given name and parameters.
%
%   Syntax:
%   cmap = keynotecmap(name) returns the colourmap based on the given name.
%   cmap = keynotecmap(name, levels) returns the colourmap with the 
%       specified number of levels.
%       The default number of levels is 16.
%   cmap = keynotecmap(name, 'Centre', centre) returns the colourmap with 
%       its centre at the specified position.
%       The default centre position is 0.5.
%   cmap = keynotecmap(name, ...
%           'Centre', centre, 'CentreMode', centreMode) 
%       returns the colourmap with the specified centre mode, 'equal' or 
%       'full'.
%
%   Input Arguments:
%   - name: The name of the colourmap.
%   - levels: The number of levels in the colourmap.
%   - centre: The centre position of the colourmap.
%   - centremode: The mode for shifting the colour position.
%       - 'equal': Both sides from the centre are scaled equally. Parts of 
%           the colourmap may be truncated.
%       - 'full': The two sides are scaled independently, showing the full 
%           range of colours.
%
%   Output Argument:
%   - cmap: The generated colourmap.
%
%   Example:
%   cmap = keynotecmap('temperature', 32, ...
%           'Centre', 0.3, 'CentreMode', 'full');
%
%   E.-C. 'William' Lee
%   williameclee@gmail.com
%   May 13, 2024

function cmap = keynotecmap(name, varargin)
    %% Initialisation
    p = inputParser;
    addRequired(p, 'Name', @ischar);
    addOptional(p, 'Levels', 16, ...
        @(x) isnumeric(x) && x > 0);
    addParameter(p, 'Centre', 0.5, ...
        @(x) isnumeric(x) && x >= 0 && x <= 1);
    addParameter(p, 'CentreMode', 'equal', ...
        @(x) ischar(validatestring(x, {'equal', 'full'})));
    parse(p, name, varargin{:});
    name = p.Results.Name;
    levels = round(p.Results.Levels);
    centre = p.Results.Centre;
    centreMode = p.Results.CentreMode;

    %% Main
    % Retreive colourmap information from colours/index-colourmaps.csv
    [colourString, colourPosition] = findcmap(name);
    % Convert colour string to RGB array
    colourArray = id2colour(colourString);
    % Shift the colour position
    colourPosition = shiftposition(colourPosition, centre, centreMode);
    % Interpolate the colourmap
    cmap = interpcmap(colourArray, levels, colourPosition);
end

%% Shift and normalise the colour position
function positionShift = shiftposition(position, centre, centreMode)
    % If the centre is 0.5, no need to shift
    if centre == 0.5
        positionShift = noramlize(position, 'range');
        return;
    end

    % Shift the position
    switch lower(centreMode)
        case 'equal'
            position = normalize(position, 'range') * 2 - 1;
            positionShift = position * max(centre, 1 - centre) + centre;

        case 'full'
            position = normalize(position, 'range');
            positionShift = position;
            positionShift(position >= 0.5) = centre ...
                + (position(position >= 0.5) - 0.5) * 2 * (1 - centre);
            positionShift(position < 0.5) = centre ...
                - (0.5 - position(position < 0.5)) * 2 * centre;
    end

end
