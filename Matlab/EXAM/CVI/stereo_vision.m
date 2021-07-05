% For colinar cameras
%
% Z = fB / (xl-xr)
%
% Z = distance
% f = focal length
% B = baseline (distance from cameras)
% (xl-xr) = disparity



function Z = getDistance(f,B,xl,xr)
    Z = f * B / (xl - xr);
end

function f = getF(Z,B,xl,xr)
    f = (Z * (xl - xr)) / B;
end

function B = getB(Z,f,disp)
    B = (Z * (xl - xr)) / f;
end

function disp = getDisp(Z,f,B)
    disp = (f*B) / Z;
end