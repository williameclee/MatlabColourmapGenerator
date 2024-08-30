% Determination of whether the input is numerically an integer (but not necessarily using an integer class).
function flag = isintegerv(x)
    flag = isnumeric(x) && isreal(x) && isfinite(x) && x == round(x);
end