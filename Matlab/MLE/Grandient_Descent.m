% GD

% setup model (equation) to perform GD on.
syms th1 th2;
th = [th1 th2];     % inputs

g= 6*th(1)^2 - 24*th(1) + 9*th(2)^2 + 27*th(2) + 5*th(1)*th(2) + 8; % g_function

dg = get_gradient(g,th);
[H,~,L] = get_hessian(g,th);


gamma = 0.1; % gamma (learning-rate) =< 1/L
th0 = [-6 8];
I = 20;


vg = zeros(0,1); % value of g function
ng = zeros(0,1); % scaled gradient of g
for i=1:I
    vg(i) = double(subs(g,th,th0(i,:)));
    dg = double(subs(dg,th,th0(i,:)));
    th0(i+1,:) = (th0(i,:)' - gamma * dg)';
    ng(i)=gamma/2*norm(dg)^2; %scaled gradient norm

end


plot([1:I],vg,'k','LineWidth',2);
hold on; plot([1:I],ng,'r--','LineWidth',2);
hold on; plot([1:I+1],th0,'g--','LineWidth',2);

xlabel('iterations','Interpreter','latex','FontSize',12)
legend('$g(\theta)$',...
    '$ \gamma /2 \cdot || \nablag(\theta) ||^{2} $',...
    'Interpreter','latex','FontSize',14)



