% A point in 3D space has coordinates [10,10,500] mm relative to the camera 
% reference frame. If the image principal point is at coordinates [244,180] pixels
% and the magnification factors in the x and y directions are 925 and 740,
% then determine the location of the point in the image
%

x = 50;
y = 50;
z = 500;

ox=400;
oy=300;

%alpha
mag_factor_x=-1333.3;
%beta
mag_factor_y=-1000;


Coords3d=[x; y; z; 1];
origin=[ox,oy];
mag=[mag_factor_x,mag_factor_y];

out=translate_3d_points(origin,Coords3d,mag);


function ref = translate_3d_points(origin,coords3d,trans)
    
    mag_factor = [trans(1) 0 origin(1);
              0 trans(2) origin(2); 
              0 0 1];
    ref = (1/coords3d(3)) * mag_factor * [1 0 0 0; 0 1 0 0; 0 0 1 0] *coords3d;
    ref = round(ref);
end
