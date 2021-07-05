R1 = 0.1;
Theta = 0:0.001:1;
E1 = (R1./(R1+Theta-Theta.^2))-1;

R2 = 1;
E2 = (R2./(R2+Theta-Theta.^2))-1;

R3 = 10;
E3 = (R3./(R3+Theta-Theta.^2))-1;

plot(Theta,E1)

hold on
plot(Theta,E2)
plot(Theta,E3)