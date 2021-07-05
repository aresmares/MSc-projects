
g = 0.5; %gamma
b = 0.8; %beta

%        Ui equation for DE/rand-to-best/nv/z
u =     @(xb,x1,x2,x3) g*xb + (1-g)*x1 + b*(x2-x3);
f  =     @(x)   x(1)^2 + x(2)^2;

vars = 2;

x = [1 -9    
    -4 5    
    2 8     
    -7 -2];   

ux = [x(3,:) x(2,:) x(4,:)
      x(4,:) x(3,:) x(1,:)
      x(1,:) x(2,:) x(4,:)
      x(2,:) x(3,:) x(1,:)
];
   
J = [1 2
    1 2
    1 0
    2 0];

xb = get_xbest(x,f);

Fx = zeros(size(x,1),1);
Fxp = zeros(size(x,1),1);
U = zeros(size(x));
Xp = zeros(size(x));

for i=1:size(x,1)
    xi = x(i,:);
    Fx(i) = f(xi);

    uxi = ux(i,:);
    x1 = uxi(:,1:vars);
    x2 = uxi(:,vars+1:2*vars);
    x3 = uxi(:,2*vars+1:3*vars);
    
    ui = u(xb,x1,x2,x3);
    U(i,:) = ui;

    ji = find(J(i,:) ~= 0);
    j = J(i,ji);
   
    xp = xi;
    xp(:,j) = ui(:,j);
    Xp(i,:) = xp;
    Fxp(i) = f(xp);

end

T = table(x,Fx,U,Xp,Fxp)



function yb = get_xbest(y,f)
    yb = y(1,:);
    fi = f(y(1,:));
    for i=2:size(y,1)
        if f(y(i,:)) < fi
            fi = f(y(i,:));
            yb = y(i,:);
        end
    end   
end

