clc; clear all;

I = im2double(imread("training_images/train08.jpg"));
figure; imshow(I)

%% isolate blue block template
blueI = im2double(imread("blue_2by4brick.jpg"));
g = im2gray(blueI);
bw = g > 0.55;
bw = bwareaopen(bw,50);
Ib = blueI .* ~bw;
% figure; imshow(Ib)

%% get strongest 3 features from template
blueF = detectSURFFeatures(rgb2gray(Ib));
blueF = selectStrongest(blueF,8); 
blueFloc = blueF.Location;
[blueF, validBlue] = extractFeatures(rgb2gray(Ib),blueF,"FeatureSize",128);

%% isolate blue blocks from training image
[blueMask,bluebounds] = get_blue_mask(I);
Iblue = I .* blueMask;

blue = 0;
for i=1:size(bluebounds)
    %% iterate over blue blocks to match features
    region = bluebounds{i};
    region_mask = get_region_mask(Iblue,region);
    block = I .* region_mask; 
    [imask,~] = get_blue_mask(block);
    block = I .* imask;
     %% isolate features of test block
    testF = detectSURFFeatures(rgb2gray(block));
    testFloc= testF.Location;
    [testF, validTest] = extractFeatures(rgb2gray(block),testF,"FeatureSize",128);
    
    %% calculate SAD for temp features and test features
    [testPoints, bluePoints, match, matchIdx] = match_temp_to_region_SAD(testF,testFloc,blueF,blueFloc);
    match = match(2:end);
    match = match(2:end);
    

    %% increment blue count if more than one feature is matched 
    if size(match,2) > 0
%          transformation = [(testPoints(k,1)-bluePoints(k,1)) (testPoints(k,2)-bluePoints(k,2))];        
        blue = blue +1;
    end
    
end
disp(blue)


%% get red edges of template faces
redI = im2double(imread("red_2by2brick.jpg"));
g = im2gray(redI);
bw = g > 0.7;
bw = bwareaopen(bw,50);
Ir = redI .* ~bw;
bounds = bwboundaries(~bw);
[redR, redC, redZ] = size(Ir);
Ir = crop_im_boundary(Ir,bounds{1});

%% get strongest features from template
redF = detectSURFFeatures(rgb2gray(Ir));
redF = selectStrongest(redF,8); 
figure;imshow(Ir); hold on;
plot(redF);
redFloc = redF.Location;
[redF, validRed] = extractFeatures(rgb2gray(Ir),redF,"FeatureSize",128);



[redMask,redbounds] = get_red_mask(I);
Ired = I .* redMask;
redbounds = bwboundaries(redMask);
figure; imshow(Ired)
red = 0;
for i=1:size(redbounds)
    %% iterate over red blocks to match features
    region = redbounds{i};
    region_mask = get_region_mask(Ired,region);
%     block = I .* region_mask; 
%     [imask,~] = get_red_mask(block);
%     block = I .* imask;
    block = crop_im_boundary(region_mask,region);
%     block = imresize(block, [redR redC]);
    
     %% isolate features of test block
    testF = detectSURFFeatures(rgb2gray(block));
    testFloc= testF.Location;
    figure;imshow(block); hold on
    plot(testF);
    hold off;
    [testF, validTest] = extractFeatures(rgb2gray(block),testF,"FeatureSize",128);
    
    %% calculate SAD for temp features and test features
    [testPoints, redPoints, match, matchIdx] = match_temp_to_region_SAD(testF,testFloc,redF,redFloc);
    match = match(2:end);
    
%      m = matchFeatures(testF,redF,"Metric","SAD","MatchThreshold",0.4);
    %% increment red count if more than one feature is matched 
     if size(match,2) > 0
%     if size(m,1) > 1

         transformation = [(testPoints(:,1)-redPoints(:,1)) (testPoints(:,2)-redPoints(:,2))];        
         [tform,inlierIndex,status] = estimateGeometricTransform2D(testPoints,redPoints,'similarity');

         red = red +1;
    end
end
disp(red)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [testPoints, templatePoints, match, matchIdx] = match_temp_to_region_SAD(testFeatures, testFloc, templateFeatures, tempFloc)
    match = 0;
    matchIdx = zeros(0,2);
    testPoints = zeros(0,2);
    templatePoints = zeros(0,2);

    for k=1:size(testFeatures)
        ratio = 0;
        val = 0;
        for n=1:size(templateFeatures)
            myAbsDiff = abs(double(testFeatures(k,:)) - double(templateFeatures(n,:)));
            sad = sum(myAbsDiff(:));
            if val ~= 0
                ratio = val / sad;
                val = 0;
                
                if ratio < 0.4
                    match(end+1) = ratio;
                    testPoints(end+1,:) =  testFloc(k,:);
                    templatePoints(end+1,:) =  tempFloc(n,:);
                    matchIdx(end+1,1) = k;
                    matchIdx(end+1,2) = n;
                    break;
                end  
            else
                val = sad;
            end
        end
    end
end


function [mask, bounds] = get_blue_mask(I)
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);

b=find((green+red>=1.2*blue));
red(b)=0;
green(b)=0;
blue(b)=0;

D=cat(3,red,green,blue);

bw=im2bw(D,0);
[bw, bounds] = reduce_noise(bw,bwboundaries(bw),300);
mask = imfill(bw,"holes");
bounds = bounds(~cellfun('isempty',bounds));


end


function mask = get_region_mask(Im,region)
    imask = zeros(size(rgb2gray(Im)));
    imask(region(:,1),region(:,2)) = 1;
    mask = Im .* imask; 
end

function I = crop_im_boundary(Im,boundary)
    [maxX,maxY,~] = size(Im);
    pad = 12;
    
    if max(boundary(:,1))+pad > maxX || min(boundary(:,1))-pad < 1
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

function [mask, bounds] = get_red_mask(I)
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);

% nr=find((green+blue>=0.55*red) | (red> 0.3 & (green<0.3 & green>0.2) & blue<0.02));
nr=find((green+blue>=1.2*red) | (blue > 0.3) |  (green > 0.1) | red < 0.3);

red(nr)=0;
green(nr)=0;
blue(nr)=0;

D=cat(3,red,green,blue);

bw=im2bw(D,0);
[bw, bounds] = reduce_noise(bw,bwboundaries(bw),300);
mask = imfill(bw,"holes");
mask = bwareaopen(mask,50);
se = strel("disk",10,8);
mask = imdilate(mask,se);
mask = imerode(mask,se);
bounds = bounds(~cellfun('isempty',bounds));




end
