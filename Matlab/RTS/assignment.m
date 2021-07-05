clear all; close all; clc;
% Please do not change the template code before this line.

% Please complete the following with your details
firstname ='Ares';
surname   ='Agourides';
number    ='k19044830'; % this should be your 'k' number, e.g., 'k1234567'

% Please complete Question 1 here.
L  = [20]; % Inductance
c  = [0.1]; % Capacitance
R  = [4]; % Resistance 
Ac = [0 1; -1/(L*c) -R/L]; % Continu ous time A matrix
Bc = [0; 1/L]; % Continuous time B matrix

% Please complete Question 2 here.
dt = [0.002]; % Sampling rate.
T  = [20]; % Simulation duration.
A  = [eye(2) + (Ac*dt)]; % Discrete time A matrix.
B  = [Bc*dt]; % Discrete time B matrix.
u  = [1]; % Control input.
x  = [0; 0]; % Initial state.
S  = T/dt;  % Number of simulation steps.
X  = zeros(2,S); % Matrix for storing data
for s = 1:S
    x = A*x + B*u;
    X(:,s) = x;
end

% Please complete Question 3 here.
C = [1 0]; % Observer ('C') matrix
H = [C; C*A]; % Observability matrix 
              % det(H)!=0, meaning the system is observable.
z = [round(eig(A),4)]; % Vector containing poles in order of increasing size.

% Uncomment the lines below to view the continuous and discrete models 
% - should overlap almost exactly if they are equivilent 
% cont = ss(Ac,Bc,C,0);
% disc = ss(A,B,C,0,dt);
% step(cont,T)
% hold on; step(disc,T)

% Please do not change the template code after this lne.
save(['rlc_',number,'_',firstname,'_',surname]);