N=100;
x1=binornd(1,0.5,N,1); %this generates samples x1 from the marginal p(x1)=Bern(0.5)
x2=zeros(N,1);
for n=1:N
if (x1(n)==0)
x2(n)=binornd(1,0.1); %this generates sample x2 from the conditional p(x2|x1=0)=Bern(0.1)
else
x2(n)=binornd(1,0.8); %this generates sample x2 from the conditional p(x2|x1=0)=Bern(0.8)
end
end
pest=zeros(4,1);
for n=1:N
if ((x1(n)==0)&&(x2(n)==0))
pest(1)=pest(1)+1/N;
elseif ((x1(n)==1)&&(x2(n)==0))
pest(2)=pest(2)+1/N;
elseif ((x1(n)==0)&&(x2(n)==1))
pest(3)=pest(3)+1/N;
elseif ((x1(n)==1)&&(x2(n)==1))
pest(4)=pest(4)+1/N;
end
end
pest