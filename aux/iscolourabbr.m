% Determination of whether the input is a colour abbreviation (e.g. 'b3')
function flag = iscolourabbr(colourString)
    flag = isnumeric(str2double(colourString(2:end))) && ...
        ~isnan(str2double(colourString(2:end)));
end