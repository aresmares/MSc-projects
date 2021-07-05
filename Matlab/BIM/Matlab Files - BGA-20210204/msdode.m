function dy = msdode(t,y,options,para)
dy = zeros(2,1);
y=[y(1); y(2)];
c = para(1);
k = para(2);
m = para(3);
A = [0 1; -k/m -c/m];
dy = A*y;