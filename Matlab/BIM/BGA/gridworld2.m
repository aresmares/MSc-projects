%The sum of the distance between the each coordinates of the path and
%destination is used as cost
function f = gridworld2(x)
% x(i) = 1: up; 2: right; 3: down; 4: left; otherwise: stand still

%height = 4; % height of the grid world
%width = 4;  % width of the grid world
x = round(x);
source = [1,1]; % start point
destination = [4,4]; % end point
obstacles = [2 2; 3 3]; % obstacles coordinations; each row represents x and y coordinations
len = length(x);

R_distance = 10;
R_obstacles = 100;
R_not_destination = 1000;

current_coordinates = source;
coordination_trace = source;
distance = 0;

for i = 1:len      
    if x(i) == 1 % up
            current_coordinates = current_coordinates + [0, 1];
    elseif x(i) == 2 % right
            current_coordinates = current_coordinates + [1, 0];
    elseif x(i) == 3 % down
            current_coordinates = current_coordinates + [0, -1];
    elseif x(i) == 4 % left
            current_coordinates = current_coordinates + [-1, 0];
    else
            current_coordinates = current_coordinates + [0, 0];
    end 
   
    coordination_trace = [coordination_trace; current_coordinates];
    distance = distance + norm(current_coordinates - destination);
end

% if norm(current_coordinates - destination) == 0
%     current_coordinates
%     coordination_trace
%     x
%     pause
% end


f = distance;


