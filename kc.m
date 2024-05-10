% FILEPATH: /Users/williameclee/Documents/MATLAB/custom-colours/keynoteColour.m
%
% KEYNOTECOLOUR Returns the RGB value of a colour in Apple's Keynote colour palette based on the given colour name, darkness, and format.
% KC is a shorthanded alias for KEYNOTECOLOUR.
%
%   COLOUR = KEYNOTECOLOUR(COLOURNAME) returns the customised colour specified by COLOURNAME.
%   The default darkness value is 2, and the default format is 'normalised'.
%   The COLOURNAME can be a string like 'blue' or 'green', or an abbrevation followed by the darkness value like 'b3' or 'g1'.
%
%   COLOUR = KEYNOTECOLOUR(COLOURNAME, DARKNESS) returns the customised colour with the specified darkness value.
%   The darkness value can be a number between 0 and 4, where 0 is the lightest and 4 is the darkest. The default darkness value is 2.
%
%   COLOUR = KEYNOTECOLOUR(COLOURNAME, 'Format', FORMAT) returns the customised colour with the specified format.
%   The format can be 'normalised' to between 0 and 1 (default) or '8bit' to between 0 and 255.
%
%   Input Arguments:
%   - COLOURNAME: A character vector specifying the colour name, or an abbreviation followed by the darkness value.
%   - DARKNESS: A numeric value specifying the darkness level of the colour (default is 2).
%   - FORMAT: A character vector specifying the format of the colour (default is 'normalised').
%
%   Output Argument:
%   - COLOUR: A 1-by-3 numeric array representing the RGB values of the customised colour.
%
%   Example:
%   colour = keynotecolour('blue', 3);
%   colour = keynotecolour('b3');
%   colour = keynotecolour('b', 3, 'Format', '8bit');

function colour = kc(colourString, varargin)
	colour = keynotecolour(colourString, varargin{:});
end
