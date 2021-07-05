%%Coursework of Ares Agourides k19044830 Feb 2021%%
% rename this file to k12345678.m for submission, using your k number
%%%%%%%%%%%%%
%% initialization

clear; close all; clc; format longg;

load 'USPS_dataset9296.mat' X t; % loads 9296 handwritten 16x16 images X dim(X)=[9296x256] and the lables t in [0:9] dim(t)=[9298x1]
[Ntot,D] =      size(X);         % Ntot = number of total dataset samples. D =256=input dimension

% Anonymous functions as inlines
show_vec_as_image16x16 =    @(row_vec)      imshow(-(reshape(row_vec,16,16)).');    % shows the image of a row vector with 256 elements. For matching purposes, a negation and rotation are needed.
sigmoid =                   @(x)            1./(1+exp(-x));                         % overwrites the existing sigmoid, in order to avoid the toolbox
LSsolver =                  @(Xmat,tvec)    ( Xmat.' * Xmat ) \ Xmat.' * tvec;      % Least Square solver

PLOT_DATASET =  1;      % For visualization. Familiarise yourself by running with 1. When submiting the file, set back to 0
if PLOT_DATASET
    figure(8); sgtitle('First 24 samples and labels from USPS data set');
    for n=1:4*6
        subplot(4,6,n);
        show_vec_as_image16x16(X(n,:));
        title(['t_{',num2str(n),'}=',num2str(t(n)),'   x_{',num2str(n),'}=']);
    end
end




% code here initialization code that manipulations the data sets




% values to find from loaded dataset
to_find = [0 1];
n0 = 0; n1 = 0;

% Training set      Validation set
Dt = zeros(0,1);    Vt = zeros(0,1);    
Dx = zeros(0,256);  Vx = zeros(0,256);
% find values from value in the dataset and store them sequentially
for k=1:size(to_find,2)
    i = find(t == to_find(k));
    xk = X(i,:);
    tk = t(i,:);
    
    % get number 70% for training, 30% for validation
    n = size(i,1);
    n_training = round((n * 0.7),0);
    
    if to_find(k) == 0
        n0 = n0 + n_training;
    else
        n1 = n1+ n_training;
    end
    % update training features
    Dx = cat(1, Dx, xk(1:n_training,:)); 
    Dt = cat(1, Dt, tk(1:n_training,:)); 
    
    % update validation features
    Vx = cat(1, Vx, xk(n_training:end,:)); 
    Vt = cat(1, Vt, tk(n_training:end,:)); 
end

% update training and validation count
N = size(Dt,1); Nv = size(Vt,1);

% code for plot here
figure(1); hold on; title('Section 1: ERM regression, quadratic loss');
xlabel('$x$','Interpreter','latex');
ylabel('$t$','Interpreter','latex');


% dim(theta)=257:
th = 257;

% feature vector for theta ERM problem training set and validation set
uxv = [ones(1,size(Vx,1)); Vx.'].';
ux =  [ones(1,size(Dx,1)); Dx.'].';
thERM=LSsolver(ux,Dt);

% supporting code here that help to calculate and displaying without a ";" the two variables
traininglossLS_257=1/N*norm(Dt-ux*thERM)^2      % Training   loss when dim(theta)=257.
validationlossLS_257 = 1/Nv*norm(Vt-uxv*thERM)^2 % Validation loss when dim(theta)=257.


% dim(theta)=10:
th = 10;

% feature vector for theta ERM problem training set and validation set
uxv10 = [ones(1,size(Vx,1));  Vx(:,1:9).'].';
ux10 = [ones(1,size(Dx,1)); Dx(:,1:9).'].';
thERM10=LSsolver(ux10,Dt);

traininglossLS_10=1/N*norm(Dt-ux10*thERM10)^2
validationlossLS_10 = 1/Nv*norm(Vt-uxv10*thERM10)^2

% code for plot here (using the "hold on", it will overlay)
hold on; plot(ux10*thERM10,'r');
hold on; plot(ux*thERM,'g');
hold on; plot(Dt,'k--','LineWidth',2);
legend('th=10','th=257','Dt');

% complete the insight:
display('The predictions with the longer and shorter feature vectors are different because longer feature vectors give more information to make a more accurate prediction, hence th=257 has a smaller loss than th=10.')



%%Section 2
% supporting code here
figure(2); hold on; title('Section 2: Logistic Regression');


ux =  [ones(1,size(Dx,1)); Dx']';
uxv = [ones(1,size(Vx,1)); Vx']';
uxn = size(ux,2);

S = 50;   % mini-batch size
I = 50;  % iterations
gamma = 0.2;      % gamma
th = [-0.1*ones(257,1)]; % init theta

trloss = zeros(I,1);
valloss = zeros(I,1);

for i=1:I 
    % logistic regression with S mini-batch
    ind=mnrnd(1,1/N*ones(N,1),S)*[1:N].'; %generate S random index for training gamma
    g=zeros(uxn,1);
    for s=1:S
        xn = ux(ind(s),:)';
        tn = Dt(ind(s));
        g=g-1/S*sum( sigmoid(th'*xn)-tn ) * xn;
    end
    th=th+gamma*g;
  
    % training log-loss
    log_loss=zeros(1,N);
    for n=1:N
        log_loss(n) = -log(sigmoid((2*Dt(n,1)-1)*(th'*ux(n,:)')));
    end
    trloss(i)=sum(log_loss)/N; %training detection-error loss

    % validation loss
    log_loss=zeros(1,Nv);
    for n=1:Nv
        log_loss(n) = -log(sigmoid((2*Vt(n,1)-1)*(th'*uxv(n,:)')));
    end
    valloss(i)=sum(log_loss)/Nv; %validation detection-error loss
end

% code for plot here
xlabel('$iteration$','Interpreter','latex');
ylabel('$log\-loss$','Interpreter','latex');
hold on; plot(trloss,'g', 'LineWidth',2);
hold on; plot(valloss,'r', 'LineWidth',2);
legend('training loss','validation loss');


% complete the insight:
display(['I have chosen S=50 to optimize the gradient over with gamma=0.2 because a mini-batch of this size will reduce the amount of noise in the loss function, while also providing more points to optimize over.', newline, ....
    'Anything above is negligable when the training set is so small and did not seem to have a big effect on my training convergence value of approx 0.010. A mini-batch of size 1 would result in SGD being performed whereas we now optimize the', newline, ....
    'gradient over a mini-batch. The learninig rate was chosen in this way as it ensures the step in grandient descent will not skip over any local minimums, while also not producing to small increments to never reach a minimum. This learning rate, therefore produces the smallest loss values for both training and validation after fine tuning the parametersvalues.']);


%%Section 3
meanDx=mean(Dx,1);
xtrm=Dx-ones(N,1)*meanDx;
covarienceXtr = xtrm.'*xtrm;
[W D]=eigs(1/N*covarienceXtr,3);
w1=W(:,1); w2=W(:,2); w3=W(:,3);

% some code here, and replace the three <???> in the plots:
figure(3); sgtitle('Section 3: PCA most significant Eigen vectors');
scalef = 10;
subplot(2,2,1); show_vec_as_image16x16(w1*scalef); title('Most significant');
subplot(2,2,2); show_vec_as_image16x16(w2*scalef); title('Second significant');
subplot(2,2,3); show_vec_as_image16x16(w3*scalef); title('Third significant');

figure(4); sgtitle('Section 3: Estimating using PCA, M = number of significant components');
z(1)=w1'*xtrm(1,:)'; z(2)=w2'*xtrm(1,:)'; z(3)=w3'*xtrm(1,:)';
% some code here, and replace the three <???> in the plots:
subplot(2,2,1); show_vec_as_image16x16(xtrm(1,:));   title('First training set image');
subplot(2,2,2); show_vec_as_image16x16(z(1)*w1);   title('Reconstracting using M=1 most significant components');
subplot(2,2,3); show_vec_as_image16x16(z(1)*w1 + z(2)*w2);   title('Reconstracting using M=2');
subplot(2,2,4); show_vec_as_image16x16(z(1)*w1 + z(2)*w2 + z(3)*w3);   title('Reconstracting using M=3');

figure(5); hold on; title('Significant PCA components over all training set');
% code for plot3 here
xtr0 = xtrm(1:n0,:); xtr1 = xtrm(n0:N,:);
z0(1,:)=w1'*xtr0'; z0(2,:)=w2'*xtr0'; z0(3,:)=w3'*xtr0';
z1(1,:)=w1'*xtr1'; z1(2,:)=w2'*xtr1'; z1(3,:)=w3'*xtr1';
hold on; plot3(z0(1,:),z0(2,:),z0(3,:),'o','MarkerSize',8);
hold on; plot3(z1(1,:),z1(2,:),z1(3,:),'x','MarkerSize',8);
xlabel('$z_1$','Interpreter','latex','FontSize',16);
ylabel('$z_2$','Interpreter','latex','FontSize',16);
zlabel('$z_3$','Interpreter','latex','FontSize',16);
legend('Contributions for 0 images','Contributions for 1 images');
view(30,30);

%%Section 4

% supporting code here
zn(1,:) = w1'*Dx(1:end,:)'; zn(2,:)=w2'*Dx(1:end,:)';
ux = [ones(1,size(Dx,1)); zn(1,:); zn(2,:)]';
trloss = zeros(I,1);
th = [-1*ones(3,1)]; % init theta




for i=1:I 
    ind=mnrnd(1,1/N*ones(N,1),S)*[1:N].'; %generate S random index for training gamma
    g=zeros(3,1);
    for s=1:S
        xn = ux(ind(s),:)';
        tn = Dt(ind(s));
        g=g-1/S*sum( sigmoid(th'*xn)-tn ) * xn;
    end
    th=th+gamma*g;
  
    % training log-loss
    log_loss=zeros(1,N);
    for n=1:N
        log_loss(n) = -log(sigmoid( (2*Dt(n,1)-1)*(th'*ux(n,:)')) );
    end
    trloss(i)=sum(log_loss)/N; %training detection-error loss

end

figure(6); hold on; title('Section 4: Logistic Regression');
% code for plot here
xlabel('$iteration$','Interpreter','latex');
ylabel('$log loss$','Interpreter','latex');
legend('training loss');
hold on; plot(trloss,'g', 'LineWidth',2);

% complete the insight:
display(['Comparing with the solution in Section 2, I conclude that the PCA components produce a slightly',newline,....
    'higher training log loss than a basic mini-batch logistic regression, and also a gradual incline leading to a slower convergence. The decreased dimensionality seems',newline,....
    ' represnt the data less well, leading to a loss in data, making it slightly harder (indicated by the loss) to identify specific features. PCA component vectors also appear to work extremely well when used to recreate data as seen in the previous section.']);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A list of functions you may want to familiarise yourself with. Check the help for full details.

% + - * / ^ 						% basic operators
% : 								% array indexing
% * 								% matrix mult
% .* .^ ./							% element-wise operators
% x.' (or x' when x is surely real)	% transpose
% [A;B] [A,B] 						% array concatenation
% A(row,:) 							% array slicing
% round()
% exp()
% log()
% svd()
% max()
% sqrt()
% sum()
% ones()
% zeros()
% length()
% randn()
% randperm()
% figure()
% plot()
% plot3()
% title()
% legend()
% xlabel(),ylabel(),zlabel()
% hold on;
% grid minor;