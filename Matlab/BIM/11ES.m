clc;clear all;
f       = @(x)      x(1)^2 + x(2)^2 + x(3)^2 ;
x_p     = @(x,s,N) (x' + s'.*N')';
sp     = @(s)      0.8*s;
get_N   = @(t)     [0.5/t 1.5/t];

%%% (1+1)-ES


%init
x = [-1 2 -3];
s = [0.1 0.6 0.9];
N = [0.2 0.4 0.7]

% if offspring < parent, outcome = 1
outcome = 1;

for t=1:6
   
   % get new param value
%    N = get_N(t);

  % evaluate cost 
   fx = f(x);
   
   % get sigma'
%    sp = s_p(s,outcome);
    spr = sp(s);

   % get x' and its cost
   xp = x_p(x, s, N);
   fxp = f(xp);
   
   T =table(t, x, fx, s, spr, N, xp, fxp);   
   disp(T)
    
   % compare cost of x and x', replace if x' is less (1+1)-ES
   if fxp < fx 
       outcome = 1
       x = xp;
       s = sp;
   else 
       outcome = 0
   end
end


function s = s_p(s, bool)
    
    if bool == 0
        s = (1/exp(1/3)^(1/4))*s';
    else
        s = exp(1/3)*s';
    end
    s = s';
end
