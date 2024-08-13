%% OPTIMALCLIM
function [cLim, cStep, cLevels] = optimalclim(data, varargin)
    p = inputParser;
    addRequired(p, 'data', @isnumeric);
    addOptional(p, 'steps', 8, @isnumeric);
    addOptional(p, 'stepChoices', ...
        [1e-4, 2e-4, 5e-4, 1e-3, 2e-3, 5e-3, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1:5, 10:10:50, 100:100:500, 1000:1000:5000], ...
        @isnumeric);
    addOptional(p, 'Percentile', 1, @isnumeric);
    parse(p, data, varargin{:});

    data = p.Results.data;
    steps = p.Results.steps;
    stepChoices = p.Results.stepChoices;
    percentile = p.Results.Percentile;

    dataMax = prctile(data(:), 100 - percentile);
    dataMin = prctile(data(:), percentile);
    dataRange = dataMax - dataMin;

    cStep = stepChoices(find(stepChoices * steps < dataRange, 1, 'last'));
    if isempty(cStep)
        cStep = stepChoices(1);
    end

    cLim = [floor(dataMin / cStep) * cStep, ...
                ceil(dataMax / cStep) * cStep];

    cLevels = cLim(1):cStep:cLim(2);
end
