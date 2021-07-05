            % link input in form = [ theta, d, alpha, a ]

function m = homogeneous_matrix(link)
th = link(1);
d = link(2);
al = link(3);
a = link(4);

m = [   cos(th)     -cos(al)*sin(th)    sin(al)*sin(th)    a*cos(th)
        sin(th)     cos(al)*cos(th)     -sin(al)*cos(th)   a*sin(th)
        0           sin(al)             cos(al)            d
        0           0                   0                  1    ];
end