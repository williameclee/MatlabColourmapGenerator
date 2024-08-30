%% INTERPCMAP
%   Creates a colourmap from an array of colours
%
%   Syntax:
%   cmap = interpcmap(colourarray)
%       returns a colourmap by interpolating between the colours in the
%       colour array.
%   cmap = interpcmap(colourarray, levels)
%       returns a colourmap with the specified number of levels.
%       The default number of levels is 256.
%   cmap = interpcmap(colourarray, 'Position', position)
%       returns a colourmap with colours in the colour array at the
%       specified positions.
%       The default positions are equally spaced between 0 and 1.
%   cmap = interpcmap(colourarray, 'ColourSpace', space)
%       returns a colourmap with the specified interpolation space,
%       'oklab' or 'rgb'.
%       The default interpolation space is 'oklab'.
%   cmap = interpcmap(colourarray, 'Direction', direction)
%       returns a colourmap with the specified direction, 'normal' or
%       'reverse'.
%       The default direction is 'normal'.
%   cmap = interpcmap(colourarray, 'Method', method)
%       returns a colourmap with the specified interpolation method,
%       'exact' or 'smooth'.
%       The default method is 'exact'.
%   cmap = interpcmap(colourarray, levels, position, method)
%       returns a custom colourmap by interpolating between the colours in
%       the colour array, with the specified number of levels,
%       positions, and interpolation method.
%
%   Input Arguments:
%   - colourarray: A matrix specifying the colour channels.
%   - levels: The number of levels in the colourmap.
%   - position: A numeric vector specifying the relative position of each
%       colour in the colourmap.
%       The length of position should be the same as the number of rows in
%       the colour array.
%       The values should be in the range [0, 1], unless extrapolating.
%   - direction: The direction of the colourmap, 'normal' or 'reverse'.
%   - method: A character vector specifying the interpolation method,
%       'exact' or 'smooth'.
%       'exact' ensures that the specified colours are in the
%       colourmap, while 'smooth' interpolates between the colours.
%   - dipolecentre: The position of the centre of the dipole in the
%       colour. When the dipole centre falls at the boundary of two
%       colours, the colour at the centre is duplicated. This parameter
%       is only relevant when the method is 'exact' and the colourmap is
%       dipolar.
%
%   Output Argument:
%   - cmap: A levels x n numeric matrix representing the custom
%       colourmap, where n is the number of colour channels.
%
%   Example:
%   colour_array = [1 0 0; 0 1 0; 0 0 1]; % Red, Green, Blue
%   position = [0 0.5 1]; % Colours at positions 0, 0.5, 1
%   levels = 256; % Number of levels in the colourmap
%   cmap = interpcmap(colour_array, levels, position);
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   May 9, 2024
%
%   Last modified by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 12, 2024

function cmap = interpcmap(colourArray, varargin)
    %% Initialisation
    p = inputParser;
    addRequired(p, 'ColourArray', @ismatrix);
    addOptional(p, 'Levels', 256, @isscalar);
    addOptional(p, 'Position', [], @ismatrix);
    addParameter(p, 'ColourSpace', 'oklab', ...
        @(x) ischar(validatestring(lower(x), ...
        {'oklab', 'rgb', 'srgb'})));
    addParameter(p, 'Direction', 'normal', ...
        @(x) ischar(validatestring(x, {'normal', 'reverse'})));
    addParameter(p, 'Method', 'exact', ...
        @(x) ischar(validatestring(x, {'exact', 'smooth'})));
    addParameter(p, 'DipoleCentre', nan, ...
        @(x) (isnumeric(x) && x >= 0 && x <= 1) || isnan(x));
    parse(p, colourArray, varargin{:});
    colourArray = p.Results.ColourArray;
    levels = p.Results.Levels;
    position = p.Results.Position;
    colourSpace = lower(p.Results.ColourSpace);
    direction = p.Results.Direction;
    interpMethod = p.Results.Method;
    centre = p.Results.DipoleCentre;

    if isempty(position)
        position = linspace(0, 1, size(colourArray, 1));
    end

    %% Interpolation
    if strcmpi(colourSpace, 'oklab')
        colourArray = srgb2oklab(colourArray);
    end

    switch interpMethod
        case 'smooth'
            cmap = intpcmapsmooth(colourArray, position, levels);
        case 'exact'
            cmap = intpcmapexact(colourArray, position, levels, centre);
        otherwise
            cmap = intpcmapexact(colourArray, position, levels, centre);
            warning(['Unknown interpolation method ''', interpMethod, ...
                     ''', using ''exact''.']);
    end

    if strcmpi(colourSpace, 'oklab')
        cmap = oklab2srgb(cmap);
    end

    % Reverse the colourmap if necessary
    if strcmpi(direction, 'reverse')
        cmap = flipud(cmap);
    end

end

%% Subfunctions
% The 'smooth' interpolation method smoothly interpolates between the colours
function cmap = intpcmapsmooth(colourArray, position, levels)
    cmap = interp1(position, colourArray, linspace(0, 1, levels), ...
    'linear'); % interpolate colours
end

% The 'exact' interpolation method ensures that the specified colours are in the colourmap
function cmap = intpcmapexact(colourArray, position, levels, centre)
    cmap = zeros([levels, size(colourArray, 2)]); % initialise colourmap
    % Find the closest index of each colour in the colourmap
    stepsize = 1 / levels;
    level = round(position / stepsize) + 1;

    if level(end) == levels + 1
        level(end) = levels;
    end

    if ~isnan(centre)
        [~, centreId] = min(abs(position(:) - centre));

        if abs((level(centreId) - 1) * stepsize - centre) <= 1e-3
            colourArray = [colourArray(1:centreId, :); ...
                               colourArray(centreId, :); ...
                               colourArray(centreId + 1:end, :)];
            level = [level(1:centreId - 1), ...
                         level(centreId) - 1, ...
                         level(centreId:end)];
        elseif abs((level(centreId)) * stepsize - centre) <= 1e-3
            colourArray = [colourArray(1:centreId - 1, :); ...
                               colourArray(centreId, :); ...
                               colourArray(centreId:end, :)];
            level = [level(1:centreId), ...
                         level(centreId) + 1, ...
                         level(centreId + 1:end)];
        else
            level(centreId) = floor(centre / stepsize) + 1;
        end

    end

    % Interpolate piecewise between the colours
    for iColour = 1:length(level) - 1
        level_min = max(level(iColour), 1); % lower index of interpolation
        level_max = min(level(iColour + 1), levels); % upper index

        % Determine whether interpolation is necessary
        if level_min == level_max ...
                && level(iColour) >= 1 && level(iColour) <= levels
            % When two colours are at the same index, average the colours
            % This situation should preferably be prevented by raising
            % levels or changing the position
            cmap(level(iColour), :) ...
                = (colourArray(iColour, :) + colourArray(iColour + 1, :)) / 2;
            continue
        end

        % Interpolate between the colours
        cmap(level_min:level_max, :) = interp1( ...
            [level(iColour), level(iColour + 1)], ...
            [(colourArray(iColour, :)); colourArray(iColour + 1, :)], ...
            level_min:level_max);
        % Note that the original positions can be outside the range [0, 1]
    end

end
