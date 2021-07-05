
Nkeep = 2

x = [-10 8;
    -2 4; 
    5 -5; 
    0 -3]

display('EVALUATING COST')
fx = evaluate(x)';
T = table(x,fx)

display('RANK BY MIN. COST')
[x, fx] = rank_cost(x, fx);
T = table(x, fx)

display('NORMALIZE COST AND APPLY PROBABILITY')
[Cn, Pn, Sp] = normalize_cost(fx, Nkeep);
T = table(x,fx,Cn,Pn,Sp)

function fx = evaluate(x)
% COST FUNCTION 
    f  = @(x)    2*x(1)^2 - x(1)*x(2) - 5*x(2)^2

    fx = zeros(1);
    for i=1:size(x)
        fx(i) = f(x(i,:));
    end
end

function [x, fx] = rank_cost(x, fx)
    x = [x fx];
    sx = sortrows(x,size(x,2));
    x = sx(:,1:size(sx,2)-1);
    fx = sx(:,size(sx,2));
end

function [Cnorm, Pn, Sp] = normalize_cost(fx, Nkeep)
    n = fx(Nkeep+1);
    Cn = @(xi, n) xi + n;
    
    if Nkeep == 0 
        n = fx(size(fx,1));
        Cn = @(xi,n) xi -2* n;
        Nkeep = size(fx,1);
    end
    
    Cnorm = zeros(size(fx,1),1);
    for i=1:Nkeep
        Cnorm(i) = Cn(fx(i),n);
    end
    
%     Getting probability and cumulative probability of the Nkeep vars
    Pn = zeros(size(fx,1),1);
    Sp = zeros(size(fx,1),1);
    for i=1:Nkeep
        Pn(i) = Cnorm(i)/sum(Cnorm);
        Sp(i) = sum(Pn);
    end
    

end