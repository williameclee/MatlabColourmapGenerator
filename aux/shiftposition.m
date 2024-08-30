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
