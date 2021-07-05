
function [threshold, Ig,seg]=test2(I)
%% filter and process the origional image
Ig = rgb2gray(I);

Ig = conv_gaus(Ig,3);
Ig = conv_lap(Ig);
Ig = intensity_gradients(Ig);
% Ig = sobel_orientaitons(Ig);

% Ig = laplace_pyramid(Ig,5);
figure(1)
imshow(Ig)
title("Origional image")

% Ig(2:end,2:end) = Ig(2:end,2:end) .* intensity_gradients(Ig);
Ig = conv_gaus(Ig,2);
% Ig = conv_lap(Ig);
Ipy = laplace_pyramid(Ig,5);
Ig = Ipy{1};
% Ig = conv_gaus(Ig,3);


%% find edges and make bw 
scale_f = 10;
Ig = Ig.*scale_f;
figure(2)
imshow(Ig)
title("After filtering and blurring")
[~,threshold] = edge(Ig,'Canny');
threshold = (threshold(2)-threshold(1)).*(2.*scale_f-1);
Iedges = imbinarize(Ig,1.1);

figure(3)
imshow(Iedges)
title("BW binerized")

%% reduce edges and remove noise to get segements
Iedges = bwmorph(Iedges, 'skel', inf);
Iedges = imdilate(Iedges,strel("disk",5,8));
% Iedges = imerode(Iedges,strel("disk",4,8));
figure(4)
imshow(Iedges   )
title("BW canny")
bounds = bwboundaries(Iedges);
[Inew,~] = reduce_noise(Iedges,bounds,25);

% Ier = imerode(Iedges,strel("disk",4,8));
figure(5)
imshow(Inew)
title("Ater processing edges")

%% fill in the segments
Ifill = imfill(Inew,"holes");
figure(6)
imshow(Ifill)
title("Filling in holes")

Iskel = edge2(Inew);
Iskel = imfill(Iskel,"holes");
figure(7)
imshow(Iskel)
title("outine of segments")


seg = Inew;
end


function [im, bounds] = reduce_noise(I,boundary,si)

bounds = cell(size(boundary,1),1);

for i=1:size(boundary)
    if size(boundary{i},1) > si
        bounds{i} = boundary{i};
    end
end

im = zeros(size(I));
for i=1:size(bounds)
    if size(bounds{i},1) ~= 0
        b= bounds{i};
        for n=1:size(b)
            x = b(n,1);
            y = b(n,2);
            im(x,y) = 1;
        end
    end
    
end
end

function pyr = pyramid(I, level)
pyr = I;
for p = 1:level
    pyr = conv_lap(pyr);
    pyr = conv_gaus(pyr,3);

end
end


function pyr = laplace_pyramid(I, level)
pyr = cell(1,level);
pyr{1} = im2double(I);
for p = 2:level
	pyr{p} = impyramid(pyr{p-1},'reduce');

end

for p = level-1:-1:1
	s = size(pyr{p+1})*2-1;
	pyr{p} = pyr{p}(1:s(1),1:s(2),:);
end
for p = 1:level-1
	pyr{p} = pyr{p}-impyramid(pyr{p+1},'expand');

end
end

function Ibdiff = intensity_gradients(Id)
Ibdiffv=Id(1:size(Id)-1,:)-Id(2:size(Id),:);
Ibdiffh=Id(:,1:size(Id,2)-1)-Id(:,2:size(Id,2));
Ibdiff=sqrt(Ibdiffh(1:size(Id)-1,:).^2+Ibdiffv(:,1:size(Id,2)-1).^2);
end

function Ilap = conv_lap(I)
lap = [1,-1,-1,-1,8,-1,-1,-1,-1];
Ilap=conv2(I,lap,'same');
end

function Ibox = conv_gaus(I,n)
box3 = ones(n,n)./(n^2);
Ibox=conv2(I,box3,'same');
end

function Id = sobel_orientaitons(I)
dx = [1,0,-1,2,0,-2,1,0,-1];
dy = [1,2,1,0,0,0,-1,-2,-1];

Idx = conv2(I,dx,"same");
Idy = conv2(I,dy,"same");

Id = sqrt((Idx.^2)+(Idy.^2));
direction = atan(Idy./Idx);
end
