I = [15,15,15];

I2 =[10,15,5];

% t = I2(2:4,1:3);

abs_diff = abs(I - I2);

sad = sum(abs_diff(:));

disp(sad)