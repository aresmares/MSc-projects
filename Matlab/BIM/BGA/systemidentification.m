function f = systemidentification(sysA)

load systemidentification.mat;
para = [1.5438      4.9817     0.50062];
dim = sqrt(length(sysA));
sysA = reshape(sysA,dim,dim);

c = para(1);
k = para(2);
m = para(3);
A = [0 1; -k/m -c/m];
f = sum(sum(((sysA - A)*y').^2));
