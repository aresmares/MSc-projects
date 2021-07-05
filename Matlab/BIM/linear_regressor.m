% step size
h = 0.1;

% dataset
%    x1  x2  y
X = [1  -2  3;
     2   4  -1;
     3   0  5];

% initial linear params
%   w1 w2 b
z = [1 1 1]';

% iterations I
I = 5

for k=1:I
    k
    
    dz = get_dz(z,X);
 
    zp1 = z - h*dz 
    z = zp1;
end

function dz = get_dz(z,X)
    M = size(X,1);
    
    dz = [(2/M)*sum( ((X(:,1)*z(1) + X(:,2)*z(2) + z(3)) -X(:,3)).*X(:,1)) ;
         (2/M)*sum( ((X(:,1)*z(1) + X(:,2)*z(2) + z(3)) -X(:,3)).*X(:,2)) ;
         (2/M)*sum( (X(:,1)*z(1) + X(:,2)*z(2) + z(3)) -X(:,3))];
end
