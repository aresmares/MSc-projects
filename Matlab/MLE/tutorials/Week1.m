
% Module: Machine Learning for Engineers, Osvaldo Simeone, King's College London
% Chapter 2. Basic Background - Problems

%% Week 1 Problem 1
figure;
pbern=0.2;
stem([0,1],[1-pbern,pbern],'LineWidth',2)
xlabel('$x$','Interpreter','latex')
ylabel('$p(x)$','Interpreter','latex')
help binornd
binornd(1,pbern)
N=10;
x=binornd(1,pbern,N,1);
pest=mean(x)
N=1000;
x=binornd(1,pbern,N,1);
pest=mean(x)

%% Week 1 Problem 2

q=[0.2,0.1,0.3,0.4];
stem([0,1,2,3],q,'LineWidth',2)
xlabel('$x$','Interpreter','latex')
ylabel('$p(x)$','Interpreter','latex')
%%%
help mnrnd
mnrnd(1,q) %one-hot representation
N=10;
xoh=mnrnd(1,q,N);
pest=mean(xoh)
%%%
N=1000;
xoh=mnrnd(1,q,N);
pest=mean(xoh)

%% Week 1 Problem 3

dx=0.01;
xaxis=[-9:dx:3];
help normpdf
plot(xaxis,normpdf(xaxis,-3,2),'LineWidth',2); %note that we need to specify the standard deviation and not the variance
xlabel('$x$','Interpreter','latex')
ylabel('$p(x)$','Interpreter','latex')
%%%
normrnd(-3,2)
N=10;
x=normrnd(-3,2,N,1);
pest=mean(((-3<=x).*(x<=3)))
N=1000;
x=normrnd(-3,2,N,1);
pest=mean(((-3<=x).*(x<=3)))

%% Week 1 Problem 4
% analytical problem, no code needed

%% Week 1 Problem 5

q=[0.2,0.1,0.3,0.4];
N=10000;
xoh=mnrnd(1,q,N);
x=xoh*[0,1,2,3]'; %convert from one-hot vector to scalar representation
expest=mean(x.^2+3*exp(x))

%% Week 1 Problem 6
% analytical problem, no code needed

%% Week 1 Problem 7
N=10000;
x=normrnd(-3,2,N,1);
expest=mean(x+3*x.^2)

%% Week 1 Problem 8
paxis=[0:0.01:1];
plot(paxis,paxis.*(1-paxis),'LineWidth',2)
xlabel('$p$','Interpreter','latex')
ylabel('Var$(p)$','Interpreter','latex')

%% Week 1 Problem 9
% analytical problem, no code needed

%% Week 1 Problem 10
% analytical problem, no code needed

%% Week 1 Problem 11
x=[2;1]; %or x=[2,1]';
y=[-1;3];
%represent as points on the plane
plot(x(1),x(2),'x','LineWidth',2,'MarkerSize',10); hold on
plot(y(1),y(2),'o','LineWidth',2,'MarkerSize',10)
ylim([0,3])
%represent as arrows
drawArrow = @(a,b) quiver( a(1),a(2),b(1)-a(1),b(2)-a(2),0);
a = [0 0];
drawArrow(a,x);
hold on
drawArrow(a,y);

%% Week 1 Problem 11 - cont'
x=[2;1]; y=[-1;3];
x'*y %inner product
norm(x) %l2 norm (not squared)
norm(y) %l2 norm (not squared)
x'*y/(norm(x)*norm(y)) %angle
%%%
drawArrow = @(a,b) quiver( a(1),a(2),b(1)-a(1),b(2)-a(2),0);
a = [0 0];
drawArrow(a,x);
hold on
drawArrow(a,y);
z=[-1;2];
drawArrow(a,z);
ynorm=y/norm(y);
drawArrow(a,ynorm);
zp=0.6*x;
zm=-0.6*x;
drawArrow(a,zp);
drawArrow(a,zm);

%% Week 1 Problem 12

A=[1,-1;-1,2]; B=[2,3,-1;-1,2,3];
A*B
B'*A' %can be equivalently computed as (A*B)'
diag([1,2])*B %note that we have diag(A)=[1,2]
[U,L]=eig(A);
L %all eigenvalues are positive, so A is positive definite
U*L*U' %this equals A
%%%
help mesh
x1axis=[-2:0.01:2];
x2axis=[-2:0.01:2];
[X1,X2] = meshgrid(x1axis,x2axis);
mesh(X1,X2,A(1,1)*X1.^2+A(2,2)*X2.^2+2*A(1,2)*X1.*X2)

[U,L]=eig(B*B');
L %they are all positive and hence B*B' is positive definite
rank(B*B') %the matrix is 2x2 and the rank is 2 so it is invertible
inv(B*B')
[U,L]=eig(B'*B);
L %one of the eigenvalues is zero and the others are positive, and hence B'*B is positive semi-definite
rank(B'*B) %the matrix is 3x3 and the rank is 2 so it is not invertible – try using inv(B'*B)!