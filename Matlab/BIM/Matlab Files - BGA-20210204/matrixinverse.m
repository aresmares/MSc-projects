function f = matrixinverse(x)
dim = sqrt(length(x));
x = reshape(x,dim,dim);

A = [1 2 3; 4 15 6; 7 8 19];

f = sum(sum(abs(A*x-eye(dim))));


