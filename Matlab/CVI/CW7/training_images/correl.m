I = im2double(imread("training_images/train03.jpg"));

rotI = im2double(imread("red_2by2brick.jpg"));
[rm, ~] = get_red_mask(rotI,1.2);
Ir = rotI .* rm;
[rows, colm, ~]=size(Ir);


[redMask,redbounds] = get_red_mask(I,0.55);
redIm = I .* redMask;

red = 0;
for i=1:size(redbounds)
    region = redbounds{i};
    block_segment = crop_im_boundary(I,region);
%     [segment_mask,~] = get_red_mask(block_segment,0.5);
%     block = block_segment .* segment_mask;

    itest=imresize(rgb2gray(block_segment),[rows colm]);

    correlation = normxcorr2(itest(:,:,1),Ir(:,:,1));
%     correlation = normxcorr2(itest,rgb2gray(Ir));

    [ypeak,xpeak] = find(correlation==max(correlation(:)));
    v = correlation(ypeak,xpeak);
    m = mean(correlation,"all");
   
    
    if v > 0.6
        red = red +1;
        disp("YES")
        disp(v)
        disp(m)
        figure; imshow(block_segment);

    else
        disp("NO")
        disp(v)
        disp(m)
    end

    disp(red)

end


function Ibdiff = intensity_gradients(Id)
Ibdiffv=Id(1:size(Id)-1,:)-Id(2:size(Id),:);
Ibdiffh=Id(:,1:size(Id,2)-1)-Id(:,2:size(Id,2));
Ibdiff=sqrt(Ibdiffh(1:size(Id)-1,:).^2+Ibdiffv(:,1:size(Id,2)-1).^2);
end


function [BW, bounds] = isolate_edge_bounds(BW, pix)
    figure;imshow(BW)
    BW = bwareaopen(BW,pix);
    se = strel("disk",2,8);
    BW = imdilate(BW,se);
    BW = imerode(BW,se);
    bounds = bwboundaries(BW);
end

function [regions, images] = get_region_details_from_bounds(BW, bounds)
    regions = zeros(size(bounds,1),2);
    images = cell(10,1);
    for k=1:size(bounds)
        t = crop_im_boundary(BW,bounds{k});
%         figure;imshow(t)
        measurements = regionprops("table",t, 'Perimeter', 'Area');
        im = regionprops(t, 'Image');
        images{k}=im.Image;
        measurements= measurements{:,:};
        regions(k,:) = measurements(1,1:2);
    end
end

function mask = get_region_mask(Im,region)
    imask = zeros(size(rgb2gray(Im)));
    imask(region(:,1),region(:,2)) = 1;
    mask = Im .* imask; 
end

function [mask, bounds] = get_red_mask(I,thresh)
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);

nr=find((green+blue>=thresh*red) | (red> 0.3 & (green<0.3 & green>0.2) & blue<0.02));
red(nr)=0;
green(nr)=0;
blue(nr)=0;

D=cat(3,red,green,blue);

bw=im2bw(D,0);
[bw, bounds] = reduce_noise(bw,bwboundaries(bw),300);
mask = imfill(bw,"holes");
mask = bwareaopen(mask,50);
bounds = bounds(~cellfun('isempty',bounds));


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

function I = crop_im_boundary(Im,boundary)
    m1 = max(boundary(:,1));    n1 = min(boundary(:,1));
    m2 = max(boundary(:,2));    n2 = min(boundary(:,2));
    
    ima = imcrop(Im, [n2 n1 m2 m1]);
    I = ima(1:(m1-n1),1:(m2-n2),:);
end


