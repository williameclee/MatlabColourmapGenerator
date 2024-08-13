%% KEYNOTECMAP
% Generate a custom colourmap based on a given name and parameters.
%
% Syntax
%   cmap = keynotecmap('demo')
%   cmap = keynotecmap(name)
%   cmap = keynotecmap(name, levels)
%       The default number of levels is 16.
%   cmap = keynotecmap(name, 'Centre', centre)
%   cmap = keynotecmap(name, ...
%           'Centre', centre, 'CentreMode', centreMode)
%       The default centre mode is 'equal'.
%   cmap = keynotecmap(name, 'Direction', direction)
%       returns the colourmap with the specified direction, 'normal' or
%       'reverse'.
%       The default direction is 'normal'.
%   cmap = keynotecmap(name, 'Method', method)
%       returns the colourmap with the specified interpolation method,
%       'exact' or 'smooth'.
%       The default method is 'exact'.
%
% Input arguments
%   name - The name of the colourmap
%   levels - The number of levels in the colourmap
%       The default number of levels is 16.
%   centre - The centre position of the colourmap
%   centremode - The mode for shifting the colour position
%       - 'equal': Both sides from the centre are scaled equally. Parts of
%           the colourmap may be truncated.
%       - 'full': The two sides are scaled independently, showing the full
%           range of colours.
%       The default mode is 'equal'.
%   direction - The direction of the colourmap
%       The default direction is 'normal'.
%   method - The interpolation method
%      'exact' ensures that the specified colours are in the colourmap,
%      while 'smooth' interpolates between the colours.
%
% Output arguments
%   - cmap: The generated colourmap.
%
% Example
%   >>  cmap = keynotecmap('temperature', 32, ...
%       'Centre', 0.3, 'CentreMode', 'full');
%
% See also
%   KEYNOTECOLOUR (KC), INTERPCMAP
%
% Last modified by
%   2024/08/13, williameclee@arizona.edu (@williameclee)
%   2024/06/06, williameclee@arizona.edu (@williameclee)

function cmap = keynotecmap(name, varargin)
    %% Initialisation
    % p = inputParser;
    % addRequired(p, 'Name', @(x) ischar(x) || isstring(x));
    % addOptional(p, 'Levels', 16, ...
    %     @(x) isnumeric(x) && x > 0);
    % addParameter(p, 'ColourSpace', 'oklab', ...
    %     @(x) ischar(validatestring(lower(x), {'oklab', 'rgb'})));
    % addParameter(p, 'Centre', 0.5, ...
    %     @(x) (isnumeric(x) && x >= 0 && x <= 1) ...
    %     || isempty(x) || isnan(x));
    % addParameter(p, 'CentreMode', 'equal', ...
    %     @(x) ischar(validatestring(x, {'equal', 'full'})));
    % addParameter(p, 'Direction', 'normal', ...
    %     @(x) ischar(validatestring(x, {'normal', 'reverse'})));
    % addParameter(p, 'Method', 'exact', ...
    %     @(x) ischar(validatestring(x, {'exact', 'smooth'})));
    % addParameter(p, 'SymmetricCentre', 'on', ...
    %     @(x) ischar(validatestring(x, {'on', 'off'})));
    % parse(p, name, varargin{:});
    % name = p.Results.Name;
    % levels = round(p.Results.Levels);
    % colourSpace = p.Results.ColourSpace;
    % centre = p.Results.Centre;
    % centreMode = p.Results.CentreMode;
    % direction = p.Results.Direction;
    % interpMethod = p.Results.Method;
    % isSymmetricCentre = p.Results.SymmetricCentre;
    %
    % if isempty(centre)
    %     centre = nan;
    % end

    % % Check for inverted or reversed colourmap
    % if contains(name, 'inverted')
    %     direction = 'reverse';
    %     name = strtrim(strrep(name, 'inverted', ''));
    % elseif contains(name, 'reverse')
    %     direction = 'reverse';
    %     name = strtrim(strrep(name, 'reverse', ''));
    % end

    [name, levels, colourSpace, centre, centreMode, ...
         direction, interpMethod, isSymmetricCentre] = parseinputs(name, varargin{:});

    %% Checking for demo
    if strcmp(name, 'demo')
        cmap = rundemo;
        return;
    end

    %% Main function
    % Retreive colourmap information
    [colourString, colourPosition, cmapPolarity] = readcmap(name);
    dipoleCentre = nan;

    if strcmp(cmapPolarity, 'dipole') && strcmp(interpMethod, 'exact') && ...
            strcmp(isSymmetricCentre, 'on')
        dipoleCentre = centre;
    elseif strcmp(cmapPolarity, 'dipole') && strcmp(interpMethod, 'smooth') && ...
            strcmp(isSymmetricCentre, 'on')
        warning('The ''SymmetricCentre'' parameter is not applicable.');
    end

    % Convert colour string to RGB array
    colourArray = id2colour(colourString);
    % Shift the colour position
    if strcmp(direction, 'reverse')
        centre = 1 - centre;
        dipoleCentre = 1 - dipoleCentre;
    end

    colourPosition = shiftposition(colourPosition, centre, centreMode);
    % Interpolate the colourmap
    cmap = interpcmap(colourArray, levels, colourPosition, ...
        'ColourSpace', colourSpace, 'Method', interpMethod, ...
        'Direction', direction, 'DipoleCentre', dipoleCentre);

end

%% Subfunctions
function cmap = rundemo
    %% Generating the colourmap
    level = 16;
    cmap = keynotecmap('temperature anomaly', level);

    %% Plotting the colourmap
    % Generate the data to plot
    peak = peaks(100);
    peak(peak < 0) = peak(peak < 0) / abs(min(peak(:)));
    peak(peak > 0) = peak(peak > 0) / max(peak(:));
    peak = peak * level;

    % Plot the data
    figure
    clf
    contourf(peak, level, 'LineStyle', 'none')
    colormap(cmap)
    cbar = colorbar;
    clim([-level, level])
    cbar.Ticks = linspace(-level, level, level + 1);
end

function varargout = parseinputs(varargin)
    p = inputParser;
    addRequired(p, 'Name', @(x) ischar(x) || isstring(x));
    addOptional(p, 'Levels', 16, ...
        @(x) isnumeric(x));
    addParameter(p, 'ColourSpace', 'oklab', ...
        @(x) ischar(validatestring(lower(x), {'oklab', 'rgb'})));
    addParameter(p, 'Centre', 0.5, ...
        @(x) (isnumeric(x) && x >= 0 && x <= 1) ...
        || isempty(x) || isnan(x));
    addParameter(p, 'CentreMode', 'equal', ...
        @(x) ischar(validatestring(x, {'equal', 'full'})));
    addParameter(p, 'Direction', 'normal', ...
        @(x) ischar(validatestring(x, {'normal', 'reverse'})));
    addParameter(p, 'Method', 'exact', ...
        @(x) ischar(validatestring(x, {'exact', 'smooth'})));
    addParameter(p, 'SymmetricCentre', 'on', ...
        @(x) ischar(validatestring(x, {'on', 'off'})));
    parse(p, varargin{:});
    name = p.Results.Name;

    if isscalar(p.Results.Levels)
        levels = round(p.Results.Levels);
        centre = p.Results.Centre;
    else
        levels = length(p.Results.Levels) - 1;

        cLim = [min(p.Results.Levels), max(p.Results.Levels)];

        if cLim(2) > 0 && cLim(1) < 0
            centre = (0 - cLim(1)) / (cLim(2) - cLim(1));
        else
            centre = 0.5;
        end

    end

    colourSpace = p.Results.ColourSpace;
    centreMode = p.Results.CentreMode;
    direction = p.Results.Direction;
    interpMethod = p.Results.Method;
    isSymmetricCentre = p.Results.SymmetricCentre;

    if isempty(centre)
        centre = nan;
    end

    % Check for inverted or reversed colourmap
    if contains(name, 'inverted')
        direction = 'reverse';
        name = strtrim(strrep(name, 'inverted', ''));
    elseif contains(name, 'reverse')
        direction = 'reverse';
        name = strtrim(strrep(name, 'reverse', ''));
    end

    varargout = ...
        {name, levels, colourSpace, centre, centreMode, ...
         direction, interpMethod, isSymmetricCentre};
end

% Shift and normalise the colour position
function positionShift = shiftposition(position, centre, centreMode)
    % If the centre is 0.5, no need to shift
    if isnan(centre)
        positionShift = normalize(position, 'range');
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
