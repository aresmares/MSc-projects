% rotations from fixed to mobile frame
rotation = [pi/3 0 0]
translation = [0 0 6]

% Screw transformation
[R,~] = rotation_matrix(rotation);
T = translation_matrix(translation);
transformation = R*T
 
% current MOBILE coord frame location
pM = [5 7 2 1]'
% get fixed frame from transformation
pF = transformation * pM


% current FIXED fram
% pF = [1 1 1 1]'
% get MOBILE frame from transformation
% pM = inv(transformation)*pF