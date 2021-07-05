
% population
pop = [1 1 0 1 0 1 1
      0 0 1 0 1 0 0
      0 1 1 1 1 1 0
      1 0 1 0 1 0 1];
  
% xlo = 7;
% xhi = 10;
% no_vars = 2;
% % d = 0; 
% m = 4;

get_bits(10,-5,2)

% decode_binary([1 1], xhi,xlo,m)
% encode_binary(8.8, xhi,xlo,m)

% x_values = get_var_values(pop,no_vars,xhi,xlo,m);
% cost = calculate_cost(x_values);
% 
% T = table(pop, x_values, cost)

% decodes binary x values into decimal values for population
function vars = get_var_values(x,no_vars, xhi, xlo, m)   
    vars = zeros(size(x,2),no_vars);
    for k=1:size(x,1)
        xi = x(k,:);
        b = [];
        for i=1:no_vars:size(xi,2)
           b(end+1) = decode_binary(xi(i:i+no_vars-1),xhi,xlo,m) ;
        end
        vars(k,:) = b;
    end
end

% takes decoded x values as input and calculates cose
function fx = calculate_cost(x_values)
    f = @(x) x(1)^2 + x(2)^2; % CHANGE AS NEEDED
    
    fx = zeros(size(x_values,2),1);
    for i=1:size(x_values,1)
        fx(i) = f(x_values(i,:));
    end    
end

% get d = get_decimal_places(xhi,xlo,m)
function dp = get_decimal_places(xhi, xlo, m)
    step = (xhi-xlo)/(2^m -1);
    dp = -log10(step);
    dp = floor(dp);
end

% get m = get_bits(xhi,xlo,d)
function bits = get_bits(xhi, xlo, d)
    step = ((xhi-xlo)/10^(-d)) +1;
    bits = abs(log2(step));
    bits = ceil(bits);
end

% takes binary, decodes it to decimal within BGA params
function value = decode_binary(x_bin, xhi, xlo, m)
    step = (xhi-xlo)/(2^(m)-1);
    value = xlo + b2d(x_bin)*step;
end

% takes decimal, encodes it to binary within BGA params
function binary = encode_binary(x, xhi, xlo, m)
    step = (xhi-xlo)/(2^(m)-1);
    binary = d2b((x - xlo)/(step));
    binary = ceil(binary);
end