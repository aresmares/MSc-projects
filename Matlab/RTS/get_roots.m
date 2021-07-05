% Will return eigenvalues of function

% i.e as^2 +bs + c = u = 0
% coeffs = [a  b  c]

syms M C K F
cfs = [M C K]
lamda = roots(cfs)

% inverse is poly(lamda)