function pv = pvalue(data)

[x_bar, sigma] = normfit(data);
n=length(data);

pvg = zeros(n);
for i=1:n
    mu = data(i);
    zo=(x_bar-mu)/(sigma/sqrt(n));
    pv=2*(1-normcdf(abs(zo),0,1));
    pvg(i)=pv;

end
mp = mean(pvg);
disp(mp)

if (mp<0.05)
    disp("significant difference, rejects Ho")
else
    disp("Not significant difference, failed to reject Ho")
end

end
