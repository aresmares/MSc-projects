%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ares Agourides - k19044830
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I attempted to implement a geometric region based matching method to count 
% match and count legos.
% Templates: Using the two template images given, the red_template.m and blue_template.m
% functions create a template structure containing various information
% to do with the template blocks - include features, isolated block
% faces and region rations.
%
% Training: For the training images, the first step is to isolate all red
% colours and blue colours into separate matricies. Next the code iterates
% over the boundaries of these matricies, isolating edges and block faces,
% then calculates the area and length of edges. An array of region rations
% is constructed from this data.
%
% Matching: the region rations of the test and template are compared using
% the absolute square of each individual value - the value is to be
% minimized. If the value falls below a threshold, then a match is found.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main source: https://uk.mathworks.com/help/images/ref/regionprops.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [numA, numB] = count_lego1(I)
%%
rI = im2double(imread("red_2by2brick.jpg"));
blueI = im2double(imread("blue_2by4brick.jpg"));
red_temp = red_template(rI);
blue_temp = blue_template(blueI);

% figure; imshow(I)
[redMask,redbounds] = get_red_mask(I,0.5);
Ir = I .* redMask;

red = 0;
for i=1:size(redbounds)
    % isolate only the specific block in region
    region = redbounds{i};
    block_segment = crop_im_boundary(I,region);
    [segment_mask,~] = get_red_mask(block_segment,1);
    segment_mask = imclose(segment_mask,strel('disk',10));
    block = block_segment .* segment_mask;
    
    % get edges for block in region
    BW = edge(im2gray(block),"canny");
    e = BW;

    [BW, ~] = isolate_edge_bounds(BW,150);
    BW = imdilate(BW,strel("disk",3,4));
    BW = imerode(BW,strel("disk",5,4));
    BW = bwmorph(BW,"skel");
    % if region is not a valid block break loop.
    in = find(BW>0);
    if size(in,1) < 5 
        continue;
    end

    % Get a variable containing each isolated regions image
    b = bwboundaries(BW);
    images = cell(0);
    for k=1:size(b,1)
        tb = zeros(size(block,1),size(block,2));
        boun = b{k};
        for n=1:size(boun,1)
            x = boun(n,1);
            y = boun(n,2);
            tb(x,y) = 1;
        end
        images{end+1} = tb;
    end
    
    % get edge ratios from red_template
    red_ratios = red_temp.Region_Ratios;
    
    % compute ratio of edge lengths to area for test image
    test_ratios = zeros(0,1);
    for k=1:size(images,2)
       ends = bwmorph(images{k},"skel");
        s = sum(ends,"all");
        a = bwarea(ends);
        ed = a/s; 
        test_ratios(end+1) = ed;
    end
    
    % match edge rations with template and test image
    valid = zeros(0,0);
    for k=1:size(red_ratios,2)
        for n=1:size(test_ratios,2)
            dist = sqrt(abs(test_ratios(1,n)^2 - red_ratios(1,k)^2));
            if dist < 0.08
                valid(end+1) = dist;
                continue;
            end
        end
    end
    
    % increment red if a valid match is found
    if size(valid,2) >= 1
        red = red+1;
%         figure;
%         subplot(2,2,1), imshow(BW)
%         subplot(2,2,2), imshow(e)
%         subplot(2,2,3), imshow(block)
%         subplot(2,2,4), imhist(block)    
% 
%     else
%         figure;
%         subplot(2,2,1), imshow(BW)
%         subplot(2,2,2), imshow(e)
%         subplot(2,2,3), imshow(block)
    end
%     disp(red)

end


[blueMask,bluebounds] = get_blue_mask(I);
Ib = I .* blueMask;

blue = 0;
for i=1:size(bluebounds)
    % isolate only the specific block in region
    region = bluebounds{i};
    block_segment = crop_im_boundary(I,region);
    [segment_mask,~] = get_blue_mask(block_segment);
    block = block_segment .* segment_mask;
    
    % get edges for block in region
    BW = edge(im2gray(block),"canny");
    e = BW;
%     BW = reduce_noise(BW,bwboundaries(BW),50);
     BW = bwareaopen(BW,60);
    BW = imclose(BW,strel('disk',5));
%     BW = bwareaopen(BW,50);

    BW = bwskel(BW);

    % if region is not a valid block break loop.
    in = find(BW>0);
    if size(in,1) < 5 
        continue;
    end

    % Get a variable containing each isolated regions image
    b = bwboundaries(BW);
    images = cell(0);
    for k=1:size(b,1)
        tb = zeros(size(block,1),size(block,2));
        boun = b{k};
        for n=1:size(boun,1)
            x = boun(n,1);
            y = boun(n,2);
            tb(x,y) = 1;
        end
        images{end+1} = tb;
    end
    
    % get edge ratios from red_template
    blue_ratios = blue_temp.Region_Ratios;
    
    % compute ratio of edge lengths to area for test image
    test_ratios = zeros(0,1);
    for k=1:size(images,2)
       ends = bwmorph(images{k},"skel");
        s = sum(ends,"all");
        a = bwarea(ends);
        ed = a/s; 
        test_ratios(end+1) = ed;
    end
    
    % match edge rations with template and test image
    valid = zeros(0,0);
    for k=1:size(blue_ratios,2)
        for n=1:size(test_ratios,2)
            dist = sqrt(abs(test_ratios(1,n)^2 - blue_ratios(1,k)^2));
            if dist < 0.1
                valid(end+1) = dist;
                continue;
            end
        end
    end
    
    % increment red if a valid match is found
    if size(valid,2) >= 0.75
        blue = blue+1;
    
%         figure;
%         subplot(2,2,1), imshow(BW)
%         subplot(2,2,2), imshow(e)
%         subplot(2,2,3), imshow(block)    
%         subplot(2,2,4), imhist(block)
%     else
%         figure;
%         subplot(2,2,1), imshow(BW)
%         subplot(2,2,2), imshow(e)
%         subplot(2,2,3), imshow(block)  
    end
%     disp(blue)

end

disp(blue)
disp(red)

numA=blue;
numB=red;

end

%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function b = get_region_props(images)
    b = cell(size(images,2));
    for i=1:size(images,2)
        tmp=regionprops('struct',images{i},'Circularity','Area','Perimeter');
        b{i} = tmp;
    end
end


function [BW, bounds] = isolate_edge_bounds(BW, pix)
%     figure;imshow(BW)
    BW = bwareaopen(BW,pix);
    se = strel("disk",2,8);
    BW = imdilate(BW,se);
    BW = imerode(BW,se);
    bounds = bwboundaries(BW);
end


function [mask, bounds] = get_red_mask(I, thresh)
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);

nr=find((green+blue>=thresh*red) | (blue > 0.3) |  (green > 0.1));
% nr=find((green+blue>=thresh*red) | (green>20 & blue<15));
red(nr)=0;
green(nr)=0;
blue(nr)=0;

D=cat(3,red,green,blue);

bw=im2bw(D,0);
[bw, bounds] = reduce_noise(bw,bwboundaries(bw),300);
mask = imfill(bw,"holes");
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

function [mask, bounds] = get_blue_mask(I)
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);

b=find((green+red>=1.5*blue));
red(b)=0;
green(b)=0;
blue(b)=0;

D=cat(3,red,green,blue);

bw=im2bw(D,0);
[bw, bounds] = reduce_noise(bw,bwboundaries(bw),300);
mask = imfill(bw,"holes");
bounds = bounds(~cellfun('isempty',bounds));
mask = imdilate(mask,strel("disk",2,8));
mask = imerode(mask,strel("disk",2,8));


end

function I = crop_im_boundary(Im,boundary)
    [maxX,maxY,~] = size(Im);
    pad = 5;
    
    if max(boundary(:,1))+pad > maxX || min(boundary(:,1)) -pad < 1
        m1 = max(boundary(:,1));    n1 = min(boundary(:,1));
    else
        m1 = max(boundary(:,1))+pad;    n1 = min(boundary(:,1))-pad;
    end
    
    if max(boundary(:,2))+pad > maxY || min(boundary(:,2))-pad < 1
        m2 = max(boundary(:,2));    n2 = min(boundary(:,2));
    else
        m2 = max(boundary(:,2))+pad;    n2 = min(boundary(:,2))-pad;

    end

    ima = imcrop(Im, [n2 n1 m2 m1]);
    I = ima(1:(m1-n1),1:(m2-n2),:);
end
