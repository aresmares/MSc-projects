I = im2double(imread("training_images/train02.jpg"));
% w = watershe(rgb2gray(I));


rI = im2double(imread("red_2by2brick.jpg"));
blueI = im2double(imread("blue_2by4brick.jpg"));
red_temp = red_template(rI);
blue_temp = blue_template(blueI);

figure; imshow(I)
[redMask,redbounds] = get_red_mask(I,0.5);
Ir = I .* redMask;
Ir = im2gray(Ir);
% rwsh = watershe(Ir);

for i=1:size(redbounds)
    % isolate only the specific block in region
    region = redbounds{i};
    block_segment = crop_im_boundary(I,region);
    [segment_mask,~] = get_red_mask(block_segment,1);
    block = block_segment .* segment_mask;
    w = watershe(rgb2gray(block));
end

[blueMask,bluebounds] = get_blue_mask(I);
Ib = I .* blueMask;
Ib = im2gray(Ib);
bwsh = watershe(Ib);

for i=1:size(bluebounds)
    % isolate only the specific block in region
    region = bluebounds{i};
    block_segment = crop_im_boundary(I,region);
    [segment_mask,~] = get_red_mask(block_segment,1);
    block = block_segment .* segment_mask;
    w = watershe(rgb2gray(block));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Lrgb= watershe(Ir)
gmag = imgradient(Ir);
L = watershed(gmag);
Lrgb = label2rgb(L);
se = strel('disk',20);
Io = imopen(Ir,se);
imshow(Io)
Ie = imerode(Ir,se);
Iobr = imreconstruct(Ie,Ir);
imshow(Iobr)
Ioc = imclose(Io,se);
imshow(Ioc)
Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
imshow(Iobrcbr)
fgm = imregionalmax(Iobrcbr);
I2 = labeloverlay(Ir,fgm);
se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);
fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(Ir,fgm4);
imshow(I3)
bw = imbinarize(Iobrcbr);
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
imshow(bgm)
gmag2 = imimposemin(gmag, bgm | fgm4);
L = watershed(gmag2);
labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(Ir,labels);
imshow(I4)
Lrgb = label2rgb(L,'jet','w','shuffle');
imshow(Lrgb)
figure
imshow(Ir)
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.1;
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