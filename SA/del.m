function x = del(y)
    a = size(y,1);
    b = size(y,2);
    ab = a*b;
    
    if ab == a || ab == b
        y(length(y)) = [];
        x = y;
    else
        error('The input arg should be a vector')
    end
end