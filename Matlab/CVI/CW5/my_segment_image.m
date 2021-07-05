function [seg]=my_segment_image(I)
figure(1)
imshow(I)
title("Origional image")

%% filter and process the origional image
Ig = rgb2gray(I);
Ig = conv_gaus(Ig,3);
Ig = intensity_gradients(Ig);

%% find edges and make bw
scale_f = 4;
Ig = Ig.*scale_f;
figure(2)
imshow(Ig)
title("After filtering and blurring")
%%
[~,threshold] = edge(Ig,'Canny');
threshold = (threshold(2)-threshold(1))*(scale_f);
Iedges = imbinarize(Ig,threshold);
figure(4)
imshow(Iedges)
title("BW edges dil+er")

%% reduce edges and remove noise to get segements
% Iedges = bwmorph(Iedges, 'skel', inf);
bounds = bwboundaries(Iedges);
[Inew,~] = reduce_noise(Iedges,bounds,25);
Inew = imdilate(Inew,strel("disk",3,8));

figure(5)
imshow(Inew)
title("Ater processing edges")



seg = Inew;
end


function [im, bounds] = reduce_noise(I,boundary,si)

bounds = cell(size(boundary,1),1);
im = zeros(size(I));

for i=1:size(boundary)
    if size(boundary{i},1) > si
        bounds{i} = boundary{i};
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

