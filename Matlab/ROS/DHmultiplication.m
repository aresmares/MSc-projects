% link= [ theta,    d,      alpha, a ] 
syms q1 q2 q3 q4 q5 a1 a2 a3 a4 d1 d2 d3 d4 d5


%%%%%%%%%%%% 6DoF Fanuc %%%%%%%%%%%%%%
% q = [q1 q2 q3 q4 q5 q6]
% a = [0  0  0  0  0  0]
% d = [d1 d2 d3 0  0  0]
% links = [q(1)   d(1)     0      0
%          0      d(2)    -pi/2   0
%          0      d(3)     0      0
%          q(4)   0       -pi/2   0
%          q(5)   0       pi/2    0
%          q(6)   0       pi/2    0];
syms a5
q = [q1 q2 q3 q4 q5]
a = [a1  a2  a3  a4  a5]
d = [d1 d2 d3 0  d5 ]
links = [q(1)   d(1) pi/2      0
         q(2)   0     0         a(2)
         q(3)   0    -pi/2      a(3)
         q(4)   0    pi/2       0
         q(5)   d(5) -pi/2    a(5)];


%%%%%%%%%%%%% 5DoF Rhino %%%%%%%%%%%%
%  q = [0 -pi/2 pi/2 0 -pi/2]
%  a = [0 a2 a3 a4 0]
%  d = [d1 0 0 0 d5]
% links = [q(1)     d(1)   -pi/2   0
%          q(2)     0       0      a(2)
%          q(3)     0       0      a(3)   
%          q(4)     0      -pi/2   a(4)
%          q(5)     d(5)    0      0    ];  
      
 
%%%%%%%%%%% 4DoF SCARA %%%%%%%%%%%%%
% q = [0 0 100 pi/2]
% a = [a1 a2 0 0]
% d = [d1 0 0 d4]
% links = [q(1)     d(1)   pi     a(1)
%          q(2)     0      0      a(2)
%          0        q(3)   0      0   
%          q(4)     d(4)   0      0  ];  


%%%%%%%%%%% 3DoF PLANAR %%%%%%%%%%%
% q = [q1 q2 q3]
% a = [-pi/2  0 -pi/2]
% syms L1 L2
% links = [q(1)     0        pi/2     L1
%          q(2)     0         0        L2
%          q(3)     0      pi/2       0   ];

     
% % % % % % TEST 5DOF
%  q = [q1 q2 q3 q4 q5]
%  a = [0 a2 0 a4 0]
%  d = [d1 0 d3 0 d5]
% links = [q(1)     d(1)   -pi/2   0
%          q(2)     0       -pi/2   a(2)
%          0        q(3)    pi/2      0 
%          q(4)     0      -pi/2   a(4)
%          q(5)     d(5)    0      0    ];  
%      
     
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %      
m = eye(4);
n = cell(size(links,1));
h = cell(size(links,1));
for i=1:size(links,1)
    display('link no: ');
    i
    h{i} = homogeneous_matrix(links(i,:));
    m = m * homogeneous_matrix(links(i,:))
    n{i} = m;
end

% major_axis = h{1}*h{2}*h(3)
% minor_axis = h{4}*h{5}....
m = simplify(m)