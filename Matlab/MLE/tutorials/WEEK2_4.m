x1=-3*sqrt(2):0.1:3*sqrt(2);
x2=x1;
[X1,X2] = meshgrid(x1,x2);
X = [X1(:) X2(:)]; %X1(:) makes a vector out of matrix X1
mu=[0,0];
Sigma=[2 -1.9;-1.9 2];
y = mvnpdf(X,mu,Sigma);
y = reshape(y,length(x2),length(x1));
mesh(x1,x2,y,"FaceAlpha",0.5);
xlabel("$x 1$","Interpreter","latex","FontSize",14);
ylabel("$x 2$","Interpreter","latex","FontSize",14)
zlabel("$p(x 1,x 2)$","Interpreter","latex","FontSize",14);
title("$\mu 1=\mu 2=0$, $\sigma 1ˆ2=\sigma 2ˆ2=2$ and $\sigma {12}=-1.9$","Interpreter","latex","FontSize",14)