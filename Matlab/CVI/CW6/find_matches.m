%%%%%%%%%%%%%%%%%%%%%
% Ares Agourides - 19044380
%%%%%%%%%%%%%%%%%%%%%
% As the input pos1 contains coordinates derived from the Harris Feature
% Detector from I1, I have chosen to use the same approach to extract
% meaningful corner coordinates for I2. With the two arrays of meaninful 
% coordinates, feature vectors are extracted from each using the
% extractFeatures() method, which returns a list of 128 feature points for
% each coordinate and the meaninful points. The feature vectors for each of 
% the images are compared with eachother using the matchFeatures(), which 
% looks for similarities, and creates an nx2 matrix containing the indecies 
% for meaningful points arrays of sets of matching points.
% This matrix is iterated over to index the corresponding points found in
% pos1, into the appropriate location in a new array for image I2, pos2.
% a 0 value will be given in pos2, where there is no corresponding point in
% pos1.
% Returns an array of corresponding points to pos1 in I2.
%
% Main source:
% https://uk.mathworks.com/help/vision/ref/matchfeatures.html
%
%%%%%%%%%%%%%%%%%%%%%
function [pos2]=find_matches(I1,pos1,I2)
%% find Harris Features
I1 = rgb2gray(I1);
I2 = rgb2gray(I2);

detector = detectHarrisFeatures(I2); 
p2 = detector.Location;

%% handle different size images
padI=zeros(size(I1));
if size(I2) > size(I1)
    padI = zeros(size(I2));
    padI(size(I1)) = I1;
    I1 = padI;
elseif size(I2) < size(I1)
   padI = zeros(size(I1));
   padI(1:size(I2,1),1:size(I2,2),:) = I2; 
   I2 = padI;
end

%% Extract feature vectors and match points uniquely 
[f1,vpts1] = extractFeatures(I1,pos1);
[f2,vpts2] = extractFeatures(I2,p2);
m = matchFeatures(f1,f2,"Unique",true);

%% index vpts features from pos1 into correct position in pos2
pos2 = zeros(size(pos1));
for i=1:size(m)
    vp1 = m(i,1);
    vp2 = m(i,2);
    idx = find(pos1 == vpts1(vp1,1));
    idx = idx(1);
    pos2(idx,:) = vpts2(vp2,:);
end


figure(1)
imshow(I1);
hold on;
plot(p2(:,1),p2(:,2),'y+','LineWidth',2);

figure(2)
imshow(I2);
hold on;
plot(pos2(:,1),pos2(:,2),'y+','LineWidth',2);


m1=vpts1(m(:,1),:);
m2=vpts2(m(:,2),:);

figure(3)
showMatchedFeatures(I1,I2,m1,m2);

end
