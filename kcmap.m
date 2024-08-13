%% KCMAP
%   Generate a custom colourmap based on a given name and parameters.
% 	This is an alias for keynotecmap.
%
%   Syntax:
%   cmap = kcmap('demo') 
%       runs a demonstration of the function.
%   cmap = kcmap(name)
%       returns the colourmap based on the given name.
%   cmap = kcmap(name, levels)
%       returns the colourmap with the specified number of levels.
%       The default number of levels is 16.
%   cmap = kcmap(name, 'Centre', centre)
%       returns the colourmap with its centre at the specified position.
%       The default centre position is 0.5.
%   cmap = kcmap(name, 'Centre', centre, 'CentreMode', centreMode)
%       returns the colourmap with the specified centre mode, 'equal'
%       or 'full'.
%   cmap = kcmap(name, 'Direction', direction)
%       returns the colourmap with the specified direction, 'normal' or
%       'reverse'.
%       The default direction is 'normal'.
%   cmap = kcmap(name, 'Method', method)
%       returns the colourmap with the specified interpolation method,
%       'exact' or 'smooth'.
%       The default method is 'exact'.
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
%   - direction: The direction of the colourmap, 'normal' or 'reverse'.
%   - method: A character vector specifying the interpolation method,
%      'exact' or 'smooth'.
%      'exact' ensures that the specified colours are in the colourmap,
%      while 'smooth' interpolates between the colours.
%
%   Output Argument:
%   - cmap: The generated colourmap.
%
%   Example:
%   cmap = kcmap('temperature', 32, 'Centre', 0.3, 'CentreMode', 'full');
%
%   See also:
%   KEYNOTECOLOUR (KC), INTERPCMAP
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   May 9, 2024
%
%   Last modified by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 6, 2024

function cmap = kcmap(name, varargin)
    cmap = keynotecmap(name, varargin{:});
end
