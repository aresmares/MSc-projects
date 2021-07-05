I1 = [1 2 1
    1 1 1 
    1 2 1
    1 3 4
];

H = [4 2 3
];

% H = H';

% where mask fits
out = conv2(H,I1,"same");
disp(out)
% out = out';

% with padding
I2 = [0.25 1 0.8
    0.75 1 1
    0 1 0.4];
H2 = [0 0 0
    0 0 1
    0 0 0];
out2 = conv2(H2,I2,"same");


