function [f] = fs(x)
N = size(x,2);

f = 10*N + sum( x.^2 - 10.*cos(2.*pi.*x) );

end

