load('test.mat');
xtr = Dx;
ttr = Dt;

plot(xtr(1:n0),'ro','MarkerSize',10,'LineWidth',2); %labelled as 0
hold on;
plot(xtr(n0:N),'bx','MarkerSize',10,'LineWidth',2); %labelled as 1

I=100; %number of iterations
S=20; %mini-batch size
gamma=0.1; %learning rate
th=[-1,-1]'; %initialization


plot(-2:0.01:2.5,1/th(2)*(-[-2:0.01:2.5]*th(1)))
for i=1:I
    ind=mnrnd(1,1/80*ones(80,1),S)*[1:80]'; %generate S random indices
    g=zeros(2,1);
        for s=1:S
            g=g-1/S*(1/(1+exp(-th'*xtr(ind(s),:)'))-ttr(ind(s)))*xtr(ind(s),:)';
        end
    th=th+gamma*g;
    plot(-2:0.01:2.5,1/th(2)*(-[-2:0.01:2.5]*th(1)))
    ylim([-2.5,1.5])
end
plot(-2:0.01:2.5,1/th(2)*(-[-2:0.01:2.5]*th(1)),'LineWidth',2)
xlabel('$x 1$','Interpreter','latex','FontSize',12)
ylabel('$x 2$','Interpreter','latex','FontSize',12)