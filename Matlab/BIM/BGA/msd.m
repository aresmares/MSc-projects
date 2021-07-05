function f = msd(para)

initx = [1 0];
period = 5;
options=odeset('RelTol', 1e-3);
[t,y]=ode23('msdode',[0 period],[initx],options,para);

f = trapz(t,y(:,1).^2);