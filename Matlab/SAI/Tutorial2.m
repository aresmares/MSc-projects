Data21 = normrnd(1,0.2,[1,21]);
Data51 = normrnd(1,0.2,[1,51]);
[Y21,S21] = mean_std(Data21,21);
[Y51,S51] = mean_std(Data51,51);

function [Y,S] = mean_std(Data,n)
    Y(1) = Data(1);
    S(1) = 0;
    
    for i=2:n
        Y(i)= 1/(i+1) * (i*Y(i-1)+Data(i));
        S(i)= 1/i*(S(i-1)*(i-1)+(Data(i)-Y(i))^2);
    end
     
    figure
    subplot(2,1,1)
    plot(Y,'o-')
    subplot(2,1,2)
    plot(sqrt(S),'o-')   
end

