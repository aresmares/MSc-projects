function pdf(data,g_title)

[mu, sd] = normfit(data);

x = [min(data)-1:0.1:max(data)+1];
y = normpdf(x,mu,sd);

figure;
hold on;
title(g_title)
xlabel("Outcome")
ylabel("Probability")

histogram(data,'Normalization','probability')
plot(x,y)

legend("Histogram",sprintf("Normal distribution (\\mu=%0.2f \\sigma=%0.2f)",round(mu,2),round(sd,2)))
hold off;
end