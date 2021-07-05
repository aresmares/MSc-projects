function [H, eigenvalues, L] = get_hessian(g_function, sym_th)
% GET_HESSIAN get hessian and eigenvalues for a symbolic function g
% with varialbes th
%      sym_th =
%                   th = [sym("th1") sym("th2")];
%      g_function = 
%                   g= 2*th(1)^2 + 2*th(2)^2 -3*th(1)*th(2) + 3;


H = hessian(g_function,sym_th);
eigenvalues = diag(H);
L = max(eigenvalues);

end

