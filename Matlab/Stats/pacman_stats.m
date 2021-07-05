
vi_m_1 = [11 14 8 10 7 6 10 15 9 9 11 14 14 9 12];
vi_s_1 = [18 16 16 19 18 19 16 15 17 18 19 18 19 17 16];
vi_m_07 = [14 7 13 15 10 12 11 11 13 10 10 11 8 10 12];
vi_s_07 = [16 12 10 12 19 21 15 16 14 14 11 15 19 14 17];

pi_m_1 = [11 14 8 10 7 6 10 15 9 9 11 14 14 9 12];
pi_s_1 = [16 15 19 17 11 19 14 14 15 17 17 19 20 17 16];
pi_m_07 = [8 12 10 10 12 9 8 11 10 7 11 10 11 15 6];
pi_s_07 = [13 12 17 16 12 12 20 14 11 16 13 16 15 15 12];


data = [vi_m_1,vi_s_1,vi_m_07,vi_s_07,pi_m_1,pi_s_1,pi_m_07,pi_s_07];

for i=1:size(data)
    r = data(i);
    [m, s] = normfit(r);

end

% pdf(vi_m_1,"Probability distribution graph for value iteration in 25 run mediumClassic \gamma = 1 (n=15)");
% pdf(vi_s_1,"Probability distribution graph for value iteration in 25 run smallGrid \gamma = 1 (n=15)");
% pdf(vi_m_07,"Probability distribution graph for value iteration in 25 run mediumClassic \gamma = 0.7 (n=15)");
% pdf(vi_s_07,"Probability distribution graph for value iteration in 25 run smallGrid \gamma = 0.7 (n=15)");
% 
% pdf(pi_m_1,"Probability distribution graph for policy iteration in 25 run mediumClassic \gamma = 1 (n=15)");
% pdf(pi_s_1,"Probability distribution graph for policy iteration in 25 run smallGrid \gamma = 1 (n=15)");
% pdf(pi_m_07,"Probability distribution graph for policy iteration in 25 run mediumClassic \gamma = 0.7 (n=15)");
% pdf(pi_s_07,"Probability distribution graph for policy iteration in 25 run smallGrid \gamma = 0.7 (n=15)");

% disp("vi_m_1")
% pvalue(vi_m_1);
% disp("vi_s_1")
% pvalue(vi_s_1);
% disp("vi_m_07")
% pvalue(vi_m_07);
% disp("vi_s_07")
% pvalue(vi_s_07);
% 
% disp("pi_m_1")
% pvalue(pi_m_1);
% disp("pi_s_1")
% pvalue(pi_s_1);
% disp("pi_m_07")
% pvalue(pi_m_07);
% disp("pi_s_07")
% pvalue(pi_s_07);