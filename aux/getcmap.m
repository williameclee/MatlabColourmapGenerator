function cmap = getcmap(cscheme, varargin)
    %% Initialisation
    [name, levels, colourSpace, centre, centreMode, ...
         direction, interpMethod, isSymmetricCentre] = parseinputs(varargin{:});

    %% Main function
    % Retreive colourmap information
    [colourString, colourPosition, cmapPolarity] = ...
        readcmap(name, cscheme);
    dipoleCentre = nan;

    if strcmp(cmapPolarity, 'dipole') && strcmp(interpMethod, 'exact') && ...
            strcmp(isSymmetricCentre, 'on')
        dipoleCentre = centre;
    elseif strcmp(cmapPolarity, 'dipole') && strcmp(interpMethod, 'smooth') && ...
            strcmp(isSymmetricCentre, 'on')
        warning('The ''SymmetricCentre'' parameter is not applicable.');
    end

    % Convert colour string to RGB array
    colourArray = id2colour(colourString, cscheme);
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
