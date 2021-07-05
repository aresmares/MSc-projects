global d a alfa theta
d = [877, 0, 120, 200];
a = [425,375, 0, 0];
alfa = [pi,0, 0,0];
theta = [pi/4, -pi/3, 0, pi/2];

T1 = trans_(1)
T2 = trans_(2)
T3 = trans_(3)
T4 = trans_(4)

T_tot = T1*T2*T3*T4

    
function T = trans_(k)
    global d a alfa theta
    T = [cos(theta(k)), -cos(alfa(k))*sin(theta(k)), sin(alfa(k))*sin(theta(k)), a(k)*cos(theta(k)); ...
       sin(theta(k)), cos(alfa(k))*cos(theta(k)), - sin(alfa(k))*cos(theta(k)), a(k)*sin(theta(k));...
       0, sin(alfa(k)), cos(alfa(k)), d(k); ...
       0,0,0,1];
end 