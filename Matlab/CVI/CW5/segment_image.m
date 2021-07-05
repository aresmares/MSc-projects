%%%%%
%
% Ares Agourides - k19044380
%
%%%%%
%
% After many attempts to create something which remotely matches the test 
% images, I have settled on the kmeans clustering method.  The quad-tree
% method seemed to come second closest while containing gaps in the
% segmentations due to soft edges with no distinct intensity gradient difference. 
% K-means clustering by colour seems to work exceptionally well in situations 
% where there are distinct features in the images, and can correctly pick up 
% differences in soft edges. It seems to struggle more when the background 
% contains noise which has similar-intensity feautures - segmentation from 
% these features in possible, however filtering them from desired section 
% seems to be difficult as the correct segment is hard to identify. 
% In an attempt to reduce this effect a 3D guassian blur of scale 5 was used 
% along with a custom noise-reduction algorithm to present only distinct, 
% continuious edges around segments.
% Trial-and-error demonstrated that there was no major difference between
% running  'imsegkmeans' 3 to 5 times. Wanting to avoid a local minimum, thus I
% decided on 4 repetitions which seemed to work well for most images.
%
%
% Main source: 
% https://uk.mathworks.com/help/images/color-based-segmentation-using-k-means-clustering.html
%
%%%%

function seg = segment_image(I)

% format and filter image
Ilab = rgb2lab(I);
Im = Ilab(:,:,2:3);
Im = im2single(Im);
Im = imgaussfilt3(Im,5);

% perform k-means segmentation with 4 repetitions
nColors = 3;
pixel_segments = imsegkmeans(Im,nColors,'NumAttempts',5);
figure(1)
imshow(pixel_segments,[])

% find edges between regions
[~,threshold] = edge(pixel_segments,"Canny");
threshold = (threshold(2)-threshold(1)).*1.5;
Iedges = edge(pixel_segments,"Canny",threshold);
figure(2)
imshow(Iedges)   

% reduce insignificant edge boundaries less than 50 pixels.
% Iedges = reduce_noise(Iedges,bwboundaries(Iedges),0);
% figure(3)
% imshow(Iedges)

% return edges between segments with noise reduced
seg = Iedges;   

end


%% Remove boundary edges which are smaller that size si
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
