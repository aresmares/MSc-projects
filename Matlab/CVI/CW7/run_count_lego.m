val = [3,1;4,1;4,2;2,1;3,0;1,3;1,0;3,2;1,0;2,0;2,3;1,0];

test1 = zeros(size(val));
test2 = zeros(size(val));

imagefiles = dir('training_images/*.jpg');   

for i=1:length(imagefiles)
   currentfilename = strcat('training_images/',imagefiles(i).name);
   I = imread(currentfilename);
   [a,b] = count_lego(im2double(I));
   test1(i,1) = a;
   test1(i,2) = b;
   
   [a,b] = count_lego2(im2double(I));
   test2(i,1) = a;
   test2(i,2) = b;
end

abs1 = sum(abs(val -test1),'all');
abs2 = sum(abs(val -test2),'all');
% I = imread("training_images/.");

[a,b] = count_lego(im2double(I));
% [a,b] = transform(im2double(I));