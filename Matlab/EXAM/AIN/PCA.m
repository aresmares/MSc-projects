X = [4 2 3; 6 1 3; 4 2 5; 7 8 3];
Xm = mean(X) .* ones(size(X,1),1);
B = X - Xm;
C = B' * B;

W = eig(C);

Y = cell(size(X,1),1);
for i=1:size(X,1)
    Y{i} = W' .* X(i,:); 
end
