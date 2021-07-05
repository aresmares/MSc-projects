I = imread('im11.jpg');
I = im2double(I);
I = im2gray(I);

I = conv_gaus(I,3);
% I = intensity_gradients(I);

In = zeros(512,512);
In(1:size(I,1),1:size(I,2)) = I;

[~,threshold] = edge(In,"Canny");
threshold = ((threshold(2)-threshold(1))*1.5);

S = qtdecomp(In,threshold);

I = full(S(1:size(I,1),1:size(I,2)));

Im = remove_pixel(I);
% [Im,~] = reduce_noise(Im, bwboundaries(I),2);

figure(1)
imshow(I)
figure(2)
imshow(Im)



function im = remove_pixel(I)

im = zeros(size(I));
for m=2:size(I)-1
    for n=2:size(I,2)-1 
        if I(m,n) == 1
            if I(m,n-1) == 1 || ...
                 I(m-1,n) == 1 || ...
                 I(m-1,n-1) == 1 || ...
                 I(m,n+1) == 1 || ...
                 I(m+1,n) == 1 || ...
                 I(m+1,n+1) == 1 || ...
                 I(m-1,n+1) == 1 || ...
                 I(m+1,n-1) == 1
                im(m,n) = 1;
            else
                im(m,n) = 0;
            end
        end
    end
end

end



function Id = sobel_orientaitons(I)
dx = [1,0,-1,2,0,-2,1,0,-1];
dy = [1,2,1,0,0,0,-1,-2,-1];

Idx = conv2(I,dx,"same");
Idy = conv2(I,dy,"same");

Id = sqrt((Idx.^2)+(Idy.^2));
direction = atan(Idy./Idx);
end


function Ibox = conv_gaus(I,n)
box3 = ones(n,n)./(n^2);
Ibox=conv2(I,box3,'same');
end


function Ibdiff = intensity_gradients(Id)
Ibdiffv=Id(1:size(Id)-1,:)-Id(2:size(Id),:);
Ibdiffh=Id(:,1:size(Id,2)-1)-Id(:,2:size(Id,2));
Ibdiff=sqrt(Ibdiffh(1:size(Id)-1,:).^2+Ibdiffv(:,1:size(Id,2)-1).^2);
end


function [im, bounds] = reduce_noise(I, boundary,si)

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