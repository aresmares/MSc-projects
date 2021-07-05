clc;clear;


% global partical swarm optimisation (GPSO)
% x = current position
% y = best position

c1 = 3; %cognitive component
c2 = 3; %social component
r1 = 0.3;
r2 = 0.7;

% Interia weight
% w=1;

f               = @(x)      (5*x(1) + 4*x(2) + x(3))^2;
% to make gbest, lbest, put neighberhood best as yb  below instead of global best
get_w           =@(x,yb)    sum(abs(x-yb));
update_v        = @(w,x,v,y,yb)  w*v + r1*c1*(y-x)+c2*r2*(yb-x);
update_x        = @(x,v)       x+v;



x = [13,16,11
   3,1,17
   7,2,12
   10,19,20]; 

v = [0.6,2,0.7
    0.2,1.5,1.3
    1,1.2,0.8
    0.5,1.6,0.3];

y=[8,14,17
    1,3,16
    5,4,18
    2,7,10];

% for lbest
% N=[1
%     1
%     1
%     6
%     6];

% for gpso
yb = get_y_best(y,f);

X1 = zeros(size(x));
V1 = zeros(size(x));

Y1 = zeros(size(x));
Fx1 = zeros(size(x,1),1);
Fy = zeros(size(x,1),1);
Fy1 = zeros(size(x,1),1);


for i=1:size(x,1)
    xi = x(i,:);
    vi = v(i,:);
    yi = y(i,:);
    
%     for lpso
%     Ni = N(i,:);
%      yb = get_y_best(Ni,f);
    
    fx = f(xi);
    
    fy = f(yi);
    Fy(i) = fy;
    
    w = get_w(xi,yb);
    vi1 = update_v(w,xi,vi,yi,yb);
    xi1 = update_x(xi,vi1);
    fx1 = f(xi1);
    V1(i,:) = vi1;
    X1(i,:) = xi1;
    Fx1(i,:) = fx1;

    
    yi1 = yi;
    if fx1 < f(yi)
        yi1 = xi1;
    end
    Y1(i,:) = yi1;
    Fy1(i,:) = f(yi1);
    

end
T = table(x,v,y,Fy,V1,X1,Fx1,Y1,Fy1)


function yb = get_y_best(y,f)
    yb = y(1,:);
    fi = f(y(1,:));
    for i=2:size(y,1)
        if f(y(i,:)) < fi
            fi = f(y(i,:));
            yb = y(i,:);
        end
    end   
end
