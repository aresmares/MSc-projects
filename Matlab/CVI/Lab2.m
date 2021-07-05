
offsets=[0:30];
for offset=offsets
   simb(offset+1)=corr2(Ib(1:end-offset,:),Ib(1+offset:end,:));
   simc(offset+1)=corr2(Ic(1:end-offset,:),Ic(1+offset:end,:));
   simdog(offset+1)=corr2(Ibdog(1:end-offset,:),Ibdog(1+offset:end,:));
   simdogc(offset+1)=corr2(Icdog(1:end-offset,:),Icdog(1+offset:end,:));

end
figure(7), clf,
plot(offsets,simb);
hold on;
plot(offsets,simc);
plot(offsets,simdog);
plot(offsets,simdogc);

legend({'elephant','woods','ibdog'});
xlabel('shift'); ylabel('correlation coefficient')