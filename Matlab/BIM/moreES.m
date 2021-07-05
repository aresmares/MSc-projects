clc;clear all;

f       = @(x)      x(1).^2 .*sin(x(:,2)) + 2.*(x(:,1)-x(:,2))-x(:,2).^2 .*cos(x(:,1));
get_N   = @(x)     [1:size(x,2)].^2;

%%% (mu + lamda)-ES

%  init
mu = 3;
lamda = 2;
order = [1 3; % size (lamda, j)
         2 3];
x = [3 8
     10 -10
     5 -5];
 
s = [1 2
    3 4
    5 6];


for t=1:6
   
    display("")
    display("PARENTS")
    % evaluate cost 
    fx = f(x);
    T =table(x , s, fx);   
    disp(T)
    
    display("")
    display("OFFSPRING FROM RECOMBINATION")
    [x_offspring, s_offspring] = recombination(x,s,order);
    T =table(x_offspring, s_offspring);   
    disp(T)
    
    display("")
    display("OFFSPRING AFTER MUTATION")
    [xp_offspring, sp_offspring] = mutate(x_offspring, s_offspring, get_N(x));
    fxp = f(xp_offspring);
    T =table(xp_offspring, sp_offspring, fxp);   
    disp(T)

end

function [x_offspring, s_offspring]= recombination(x, s, order)
    x_offspring = zeros(0,2);
    s_offspring = zeros(0,2);

    for i=1:size(order,1)
       x_offspring(end+1,:) = 0.5 * sum(x(order(i,:),:));
       s_offspring(end+1,:) = 0.5 * sum(s(order(i,:),:));
    end
end

function [xp, sp] = mutate(x, s, N)
    xp = x + s.*N;
    sp = 0.9 * s;
    
end