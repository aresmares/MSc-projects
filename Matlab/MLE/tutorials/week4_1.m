
% Module: Machine Learning for Engineers, Osvaldo Simeone, King's College London
% Chapter 4       Supervised Learning: Getting Started –Problems

%% Week 4.1 Problem 1

clear; N=10;
q=[0.3,0.3,0.4];
xoh=mnrnd(1,q,N); %generate x as one-hot vectors
x=xoh*[0,1,2]'; %convert from one-hot vector to scalar representation
t=zeros(N,1);
for n=1:N %generate t given x
    if (x(n)==0)
        t(n)=binornd(1,0.67);
    elseif (x(n)==1)
        t(n)=binornd(1,0.33);
    elseif (x(n)==2)
        t(n)=binornd(1,0.75);
    end
end

pest=zeros(3,2);
for n=1:N
    if (x(n)==0)&&(t(n)==0)
        pest(1,1)=pest(1,1)+1/N; % MATLAB starts with 1 and not 0!
    elseif (x(n)==0)&&(t(n)==1)
        pest(1,2)=pest(1,2)+1/N;
    elseif (x(n)==1)&&(t(n)==0)
        pest(2,1)=pest(2,1)+1/N;
    elseif (x(n)==1)&&(t(n)==1)
        pest(2,2)=pest(2,2)+1/N;
    elseif (x(n)==2)&&(t(n)==0)
        pest(3,1)=pest(3,1)+1/N;
    elseif (x(n)==2)&&(t(n)==1)
        pest(3,2)=pest(3,2)+1/N;
    end
end
N , pest % display

% note: the "for" loop above can be shortened into
% for n=1:N
%   pest(1+x(n),1+t(n)) = pest(1+x(n),1+t(n)) +1/N;
% end



% repeating for N=10000

N=10000;
q=[0.3,0.3,0.4];
xoh=mnrnd(1,q,N); %generate x as one-hot vectors
x=xoh*[0,1,2]'; %convert from one-hot vector to scalar representation
t=zeros(N,1);
for n=1:N %generate t given x
    if (x(n)==0)
        t(n)=binornd(1,0.67);
    elseif (x(n)==1)
        t(n)=binornd(1,0.33);
    elseif (x(n)==2)
        t(n)=binornd(1,0.75);
    end
end

pest=zeros(3,2);
for n=1:N
    if (x(n)==0)&&(t(n)==0)
        pest(1,1)=pest(1,1)+1/N;
    elseif (x(n)==0)&&(t(n)==1)
        pest(1,2)=pest(1,2)+1/N;
    elseif (x(n)==1)&&(t(n)==0)
        pest(2,1)=pest(2,1)+1/N;
    elseif (x(n)==1)&&(t(n)==1)
        pest(2,2)=pest(2,2)+1/N;
    elseif (x(n)==2)&&(t(n)==0)
        pest(3,1)=pest(3,1)+1/N;
    elseif (x(n)==2)&&(t(n)==1)
        pest(3,2)=pest(3,2)+1/N;
    end
end
N , pest % display


%% Week 4.1 Problem 2


clear; N=10
q=[0.3,0.3,0.4];
xoh=mnrnd(1,q,N); %generate x as one-hot vectors
x=xoh*[0,1,2]'; %convert from one-hot vector to scalar representation
t=zeros(N,1);
for n=1:N %generate t given x
    if (x(n)==0)
        t(n)=binornd(1,0.67);
    elseif (x(n)==1)
        t(n)=binornd(1,0.33);
    elseif (x(n)==2)
        t(n)=binornd(1,0.75);
    end
end

pest=zeros(3,2);
for n=1:N
    if (x(n)==0)&&(t(n)==0)
        pest(1,1)=pest(1,1)+1/N;
    elseif (x(n)==0)&&(t(n)==1)
        pest(1,2)=pest(1,2)+1/N;
    elseif (x(n)==1)&&(t(n)==0)
        pest(2,1)=pest(2,1)+1/N;
    elseif (x(n)==1)&&(t(n)==1)
        pest(2,2)=pest(2,2)+1/N;
    elseif (x(n)==2)&&(t(n)==0)
        pest(3,1)=pest(3,1)+1/N;
    elseif (x(n)==2)&&(t(n)==1)
        pest(3,2)=pest(3,2)+1/N;
    end
end
LD=pest(1,2)+pest(2,1)+pest(3,2)

tERM=zeros(3,1);
for i=1:3
    [M,I]=max(pest(i,:)); % M is the maximal value, I is its index (argmax)
    tERM(i)=I-1; % MATLAB is 1-based, t takes value as 0-based
end
LDERM = pest(1 , ~tERM(1)+1) + pest(2,~tERM(2)+1) + pest(3,~tERM(3)+1)
%compare with LD!
p(1,1)=0.1;p(1,2)=0.2; p(2,1)=0.2; p(2,2)=0.1; p(3,1)=0.1; p(3,2)=0.3;
LpERM = p   (1 , ~tERM(1)+1) + p   (2,~tERM(2)+1) + p   (3,~tERM(3)+1)
% compare with Lp(t^∗(.)) = 0.3!

LpERM_gap_from_LpUnconstrained = LpERM-0.3

N=10000
q=[0.3,0.3,0.4];
xoh=mnrnd(1,q,N); %one-hot vectors
x=xoh*[0,1,2]'; %convert from one-hot vector to scalar representation
pest=zeros(3,2); %initialization of the empirical estimate
for n=1:N
    if (x(n)==0)
        t(n)=binornd(1,0.67);
        pest(1,t(n)+1)=pest(1,t(n)+1)+1/N;
    elseif (x(n)==1)
        t(n)=binornd(1,0.33);
        pest(2,t(n)+1)=pest(2,t(n)+1)+1/N;
    elseif (x(n)==2)
        t(n)=binornd(1,0.75);
        pest(3,t(n)+1)=pest(3,t(n)+1)+1/N;
    end
end

for i=1:3
    [M,I]=max(pest(i,:));
    tERM(i)=I-1;
end %compare with population-optimal predictor
p(1,1)=0.1;p(1,2)=0.2; p(2,1)=0.2; p(2,2)=0.1; p(3,1)=0.1; p(3,2)=0.3;
LpERM=p(1,~tERM(1)+1)+p(2,~tERM(2)+1)+p(3,~tERM(3)+1) % compare with Lp(t^*(.)) = 0.3!

LpERM_gap_from_LpUnconstrained = LpERM-0.3


%% Week 4.1 Problems 3-4
% analytical problem, no code needed


%% Week 4.1 Problem 5

% see LSsolver.m

%% Week 4.1 Problem 6

clear;
load sineregr_data_set;

figure;
plot(x,t,'ro','MarkerSize',10,'LineWidth',2);
xlabel('$x$','Interpreter','latex');
ylabel('$t$','Interpreter','latex');

N=length(x);
for n=1:N
    X(n,:)=[1,x(n),x(n)^2,x(n)^3,x(n)^4,x(n)^5];
end

thERM=LSsolver(X,t);
xaxis=[min(x):0.01:max(x)];
L=length(xaxis);
for l=1:L
    ul=[1,xaxis(l),xaxis(l)^2,xaxis(l)^3,xaxis(l)^4,xaxis(l)^5]';
    tl(l)=thERM'*ul;
end
hold on; plot(xaxis,tl,'b','LineWidth',2)

LDERM=1/N*norm(t-X*thERM)^2;

X=zeros(N,4);
for n=1:N
    X(n,:)=[1,x(n),x(n)^2,x(n)^3];
end
thERM=LSsolver(X,t);
xaxis=[min(x):0.01:max(x)];
L=length(xaxis);
for l=1:L
    ul=[1,xaxis(l),xaxis(l)^2,xaxis(l)^3]';
    tl(l)=thERM'*ul;
end
hold on; plot(xaxis,tl,'g','LineWidth',2)

X=zeros(N,11);
for n=1:N
    X(n,:)=[1,x(n).^[1:10]];
end
thERM=LSsolver(X,t);
xaxis=[min(x):0.01:max(x)];
L=length(xaxis);
for l=1:L
    ul=[1,xaxis(l).^[1:10]]';
    tl(l)=thERM'*ul;
end
hold on; plot(xaxis,tl,'k','LineWidth',2);

legend('data','M=5','M=3','M=10');
