function [Y, L, U] = errorbar_gen(y)
% This gives mean, lower, and upper bound of input matrix y

Y = mean(y);
L = Y - min(y);
U = max(y) - Y;

end