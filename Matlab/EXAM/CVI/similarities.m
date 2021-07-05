
I1 = [15.03 16 9.31];

I2 = [5.01 2 7.98
];

% I2 = [2,3,0,1];
% I2 = [3,4,1,3];
% I2 = [1,2,4,2];
% I2 = [0,1,3,0];

out = euclid(I1,I2)




I = [1 1 1
1 0 1
1 1 1];

T1 = [1 1 1
1 1 0
1 1 1];

T3 = [1 1 1
1 1 0
1 1 1];

T2 = [1 1 1
1 0 0
1 1 1];

out1 = cross_corr(T2,I);
out2 = norm_cross_corr(T2,I);
% out = euclid(T,I(1:3,2:4));
out3 = sad(T2,I);
disp(out)

function C= cross_corr(T,I)
s = T.*I;
C = sum(s(:));
end

function C= norm_cross_corr(T,I)
Ts = sqrt(sum(T.^2,"all"));
Is = sqrt(sum(I.^2,"all"));
ITs = Ts .* Is;
C = cross_corr(T,I)./ITs;
end

function C=euclid(T,I)
    d = I - T;
    C = sum(sqrt( d.^2 ),"all");
end

function C = ssd(T,I)
    d = I - T;
    C = sum( d.^2 ,"all");
end

function C = sad(T,I)
abs_diff = abs(I - T);

C = sum(abs_diff(:));
end
