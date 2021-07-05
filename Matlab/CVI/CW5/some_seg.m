function [seg]=segment_image(I)

Ig = rgb2gray(I);
Ig = conv_gaus(Ig,3);
Ig = intensity_gradients(Ig);

% Ig = conv_gaus(Ig,4);
Ig = Ig .* 1.5;
Line 9 


[~,threshold] = edge(Ig,'Canny');
threshold = (threshold(2)-threshold(1))*1.5;
% Ig = Ig>threshold;
% Ig = non_max_supp(Ig);

Iedges = imbinarize(Ig,threshold);
Ier = imdilate(Iedges, strel("disk",3,8));

Iskel = bwmorph(Iedges, 'skel', inf);
bounds = bwboundaries(Iskel);
[Inew,~] = reduce_noise(Iskel,bounds,20);

figure(1)
imshow(~Ig)

figure(2)
imshow(I)

figure(3)
imshow(Iedges)

figure(4)
imshow(Iskel)

figure(5)
imshow(Inew)

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


function Ibdiff = intensity_gradients(Id)
Ibdiffv=Id(1:size(Id)-1,:)-Id(2:size(Id),:);
Ibdiffh=Id(:,1:size(Id,2)-1)-Id(:,2:size(Id,2));
Ibdiff=sqrt(Ibdiffh(1:size(Id)-1,:).^2+Ibdiffv(:,1:size(Id,2)-1).^2);
end


function Ibox = conv_gaus(I,n)
box3 = ones(n,n)./(n^2);
Ibox=conv2(I,box3,'same');
end 

function Im = non_max_supp(I)
Im = zeros(size(I));

for m=1:size(I)
    for n=1:size(I,2)-1
        if I(m,n+1) > I(m,n)
           Im(m,n) = 0;
        else 
            Im(m,n) = 1;
        end
    end
end
end

