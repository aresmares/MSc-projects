vi_m_1 = [11 14 8 10 7 6 10 15 9 9 11 14 14 9 12];
vi_s_1 = [18 16 16 19 18 19 16 15 17 18 19 18 19 17 16];
vi_m_07 = [14 7 13 15 10 12 11 11 13 10 10 11 8 10 12];
vi_s_07 = [16 12 10 12 19 21 15 16 14 14 11 15 19 14 17];

pi_m_1 = [11 14 8 10 7 6 10 15 9 9 11 14 14 9 12];
pi_s_1 = [16 15 19 17 11 19 14 14 15 17 17 19 20 17 16];
pi_m_07 = [8 12 10 10 12 9 8 11 10 7 11 10 11 15 6];
pi_s_07 = [13 12 17 16 12 12 20 14 11 16 13 16 15 15 12];

data_small = [vi_s_07; vi_s_1; pi_s_07; pi_s_1];
data_medium = [vi_m_07; vi_m_1; pi_m_07; pi_m_1];
data_small = data_small.';
data_medium = data_medium.';

% x1 = [11 14 8 10 7 6 10 15 9 9 11 14 14 9 12];
% x2 = [18 16 16 19 18 19 16 15 17 18 19 18 19 17 16];
% % boxplot(vi_m_07)
% boxplot([vi_m_07,vi_s_07],'Labels',{'vi_m_07','vi_s_07'})

figure;
boxplot(data_small,"Labels",{'vi g=0.7', 'vi g=1', 'pi g=0.7', 'pi g=1'})
title('Box Plots for smallGrid map outcomes')
ylabel('Outcome (/25)')


figure;
boxplot(data_medium,"Labels",{'vi g=0.7', 'vi g=1', 'pi g=0.7', 'pi g=1'})
title('Box Plots for mediumClassic map outcomes')
ylabel('Outcome (/25)')

