vi_m_1 = [11 14 8 10 7 6 10 15 9 9 11 14 14 9 12];
vi_s_1 = [18 16 16 19 18 19 16 15 17 18 19 18 19 17 16];
vi_m_07 = [14 7 13 15 10 12 11 11 13 10 10 11 8 10 12];
vi_s_07 = [16 12 10 12 19 21 15 16 14 14 11 15 19 14 17];

pi_m_1 = [11 14 8 10 7 6 10 15 9 9 11 14 14 9 12];
pi_s_1 = [16 15 19 17 11 19 14 14 15 17 17 19 20 17 16];
pi_m_07 = [8 12 10 10 12 9 8 11 10 7 11 10 11 15 6];
pi_s_07 = [13 12 17 16 12 12 20 14 11 16 13 16 15 15 12];

x = 1:15;

hold on
scatter(x,vi_s_1,'X')
line(x,vi_s_1,'Color','red','LineStyle','--')

scatter(x,vi_m_1,'X')
line(x,vi_m_1,'Color','green','LineStyle','--')

scatter(x,vi_s_07,'X')
line(x,vi_s_07,'Color','blue','LineStyle','--')

scatter(x,vi_m_07,'X')
line(x,vi_m_07,'Color','cyan','LineStyle','--')

scatter(x,pi_s_07,'X')
line(x,pi_s_07,'Color','magenta','LineStyle','--')

scatter(x,pi_m_07,'X')
line(x,pi_m_07,'Color','yellow','LineStyle','--')

scatter(x,pi_s_1,'X')
line(x,pi_s_1,'Color','black','LineStyle','--')

scatter(x,pi_m_1,'X')
line(x,pi_m_1)
% plot(s,'-o')