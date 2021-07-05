% plot(xtr(1:40,1),xtr(1:40,2),'ro','MarkerSize',10,'LineWidth',2); %labelled as 0
% hold on;
% plot(xtr(41:80,1),xtr(41:80,2),'bx','MarkerSize',10,'LineWidth',2); %labelled as 1
% I=100; %number of iterations
% gamma=0.1; %learning rate
% th=[-1,-1]'; %initialization
% plot(-2:0.01:2.5,1/th(2)*(-[-2:0.01:2.5]*th(1)))
% waitforbuttonpress
% for i=1:I
% ind=mnrnd(1,1/80*ones(80,1),1)*[1:80]'; %generate one random index
% plot(xtr(ind,1),xtr(ind,2),'yo','MarkerSize',4,'LineWidth',2);
% th=th-gamma*(1/(1+exp(-th'*xtr(ind,:)'))-ttr(ind))*xtr(ind,:)';
% plot(-2:0.01:2.5,1/th(2)*(-[-2:0.01:2.5]*th(1)))
% ylim([-2.5,1.5])
% waitforbuttonpress
% end
% plot(-2:0.01:2.5,1/th(2)*(-[-2:0.01:2.5]*th(1)),'LineWidth',2)
% xlabel('$x 1$','Interpreter','latex','FontSize',12)
% ylabel('$x 2$','Interpreter','latex','FontSize',12)
% 

% plot(xtr(1:40,1),xtr(1:40,2),'ro','MarkerSize',10,'LineWidth',2); %labelled as 0
hold on;
% plot(xtr(41:80,1),xtr(41:80,2),'bx','MarkerSize',10,'LineWidth',2); %labelled as 1
I=100; %number of iterations
S=20; %mini-batch size
gamma=0.1; %learning rate
th=[-1,-1]'; %initialization
% plot(-2:0.01:2.5,1/th(2)*(-[-2:0.01:2.5]*th(1)))

for i=1:I
    ind=mnrnd(1,1/80*ones(80,1),S)*[1:80]'; %generate S random indices
    g=zeros(2,1);
        for s=1:S
            g=g-1/S*(1/(1+exp(-th'*xtr(ind(s),:)'))-ttr(ind(s)))*xtr(ind(s),:)';
        end
    th=th+gamma*g;
%     plot(-2:0.01:2.5,1/th(2)*(-[-2:0.01:2.5]*th(1)))
%     ylim([-2.5,1.5])
    trainloss(i,:) = 1/80 * sum( abs(-[ttr .* log(xtr*th) + (1-ttr).*log(1-xtr*th)]));
    valloss(i,:) = 1/40 * sum( abs(-[tval .* log(xval*th) + (1-tval).*log(1-xval*th)]));
end
% plot(-2:0.01:2.5,1/th(2)*(-[-2:0.01:2.5]*th(1)),'LineWidth',2)
% xlabel('$x 1$','Interpreter','latex','FontSize',12)

hold on; plot(trainloss,'g', 'LineWidth',2);
hold on; plot(valloss,'r', 'LineWidth',2);% ylabel('$x 2$','Interpreter','latex','FontSize',12)