function [dg] = get_gradient(g_function, sym_inputs)
%GET_GRADIENT Getting gradient of curve wrt inputs
% with varialbes
%      sym_inputs =
%                   sym_inputs = [sym("th1") sym("th2")];
%      g_function = 
%                   g= 2*th(1)^2 + 2*th(2)^2 -3*th(1)*th(2) + 3;

dg=sym(zeros(size(sym_inputs,2),1));
for i=1:size(sym_inputs,2)
    dg(i) = diff(g_function,sym_inputs(i));
end

end

