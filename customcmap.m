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

function cmap = customcmap(name, varargin)
    %% Checking for demo
    if strcmp(name, 'demo')
        cmap = rundemo;
        return
    end

    cmap = getcmap('custom', name, varargin{:});
end

%% Subfunctions
function cmap = rundemo
    %% Generating the colourmap
    level = 16;
    cmap = customcmap('temperature anomaly', level);

    %% Plotting the colourmap
    % Generate the data to plot
    peak = peaks(100);
    peak(peak < 0) = peak(peak < 0) / abs(min(peak(:)));
    peak(peak > 0) = peak(peak > 0) / max(peak(:));
    peak = peak * level;

    % Plot the data
    figure(999)
    clf
    contourf(peak, level, 'LineStyle', 'none')
    colormap(cmap)
    cbar = colorbar;
    clim([-level, level])
    cbar.Ticks = linspace(-level, level, level + 1);
end