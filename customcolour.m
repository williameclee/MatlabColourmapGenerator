%%  CUSTOMCOLOUR
%   Returns the RGB value of a colour in Apple's Keynote colour palette
%   based on the given colour name, darkness, and format.
%
%   Syntax:
%   colour = keynotecolour(colourname)
%       returns the colour specified by the colour name or the
%       colour-darkness abbreviation.
%   colour = keynotecolour(colourname, darkness)
%       returns the colour with the specified darkness value.
%   colour = keynotecolour(colourname, 'Format', format)
%       returns the colour with the specified format, 'normalised' or
%       '8bit'.
%       The default format is 'normalised'.
%
%   Input Arguments:
%   - colourname: A string (char) specifying the colour name, or an
%       abbreviation followed by the darkness value.
%       For example, 'blue', 'b', or 'b3'.
%   - darkness: A number specifying the darkness level of the colour.
%       The darkness value can be between 0 and 4, where 0 is the lightest
%       and 4 is the darkest.
%   - format: A string (char) specifying the format of the colour.
%
%   Output Argument:
%   - colour: A 1-by-3 numeric array representing the RGB values of the
%       colour.
%
%   Example:
%   colour = keynotecolour('blue', 3);
%   colour = keynotecolour('b3');
%   colour = keynotecolour('b', 3, 'Format', '8bit');
%
%   An alias for this function is kc.
%
%   Authored by:
%   E.-C. Lee (williameclee@gmail.com)
%   May 9, 2024
%
%   Last modified by:
%   E.-C. Lee (williameclee@gmail.com)
%   Jun 6, 2024

function [colour, errorFlag, ColourData] = ...
        customcolour(colourName, varargin)
    % addpath(fullfile(fileparts(mfilename('fullpath')), 'aux'));
    [colour, errorFlag, ColourData] = ...
        getcolour('custom', colourName, varargin{:});
end
