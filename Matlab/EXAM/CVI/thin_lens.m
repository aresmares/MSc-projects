%
% 1/f = 1/u + 1/v
%
% f = focal length
% u	=	object distance
% v	=	image distance
% 

v = getV(35,3000); %% in mm

function f = getF(u,v)
    f = 1/u + 1/v;
    f=1/f;
end

function u = getU(f,v)
    u  = 1/f - 1/v;
    u = 1/u;
end

function v = getV(f,u)
    v  = 1/f - 1/u;
    v = 1/v;
end