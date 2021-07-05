function [Full_M, Rot] = rotation_matrix(q)
    M1 = [1      0        0; 
          0 cos(q(1)) -sin(q(1)); 
          0 sin(q(1)) cos(q(1))];
 
    M2 = [cos(q(2))    0    sin(q(2)); 
             0       1       0; 
          -sin(q(2))   0    cos(q(2))];
      
    M3 = [cos(q(3)) -sin(q(3))    0; 
          sin(q(3)) cos(q(3))     0; 
            0          0     1];
    
    Rot = M1*M2*M3;
    Full_M = [Rot [0 0 0].'; 0 0 0 1];

end

