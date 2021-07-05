I = imread("im1.jpg");

Id = im2double(I);

% test = my_segment_image(Id);
% test = seg_color(Id);Line 6 test = seg_color(Id);

test = segment_image(Id);
% test = segm(Id);
% [thresh, Ig, test] = test2(Id);


se = strel('disk',5,8);
Ifill = imclose(test, se);

% figure;
% imshow(Ifill)