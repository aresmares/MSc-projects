function [Jl] = jacobians(ArmMatrixCells, inputs)
%JACOBIAN Summary of this function goes here
%   Detailed explanation goes here

n = ArmMatrixCells;
Sn = size(n,1);
Jl = sym(zeros(6,Sn));

for i=1:Sn
    approach = simplify(n{i}(1:3,3));    
    position = simplify(n{i}(1:3,4));
    
%   type=0 is prismatic, =1 is revolut
    type = get_input_type(inputs(i));
    approach = type * approach;    

    position = jacobian(position, inputs);
    position = position(:,i);

    Jl(:,i) = [position; approach] 
    
end

end


function t = get_input_type(input)
    t = 0;
    ti = arrayfun(@char, input, 'uniform', 0);
    if ti{1}(1) =="q"
        t = 1;
    end
end



