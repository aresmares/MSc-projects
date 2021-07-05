function f = pointdistance(x)
load pos;
[r,c] = size(pos);
d = 0;
for i=1:r
    d = d + sqrt( (x(1)-pos(i,1))^2 + (x(2)-pos(i,2))^2);
end

f = d;
