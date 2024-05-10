function cmap = createcolourmap(colour, position, steps)
    cmap = zeros([steps, 3]);
    cmap(:, 1) = createColourmapChannel(colour(:, 1), position, steps); % channel: r
    cmap(:, 2) = createColourmapChannel(colour(:, 2), position, steps); % channel: g
    cmap(:, 3) = createColourmapChannel(colour(:, 3), position, steps); % channel: b
end

function cmap_channel = createColourmapChannel(colour, position, steps)
    cmap_channel = interp1(position, colour, linspace(0, 1, steps), 'linear', 'extrap');
    cmap_channel = round(cmap_channel, 3); % round to 3 decimal places
end