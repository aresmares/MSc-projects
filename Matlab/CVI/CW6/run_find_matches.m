I1=im2double(imread('walls/img1.png'));
I2=im2double(imread('walls/img2.png'));

detector = detectHarrisFeatures(rgb2gray(I1)); 
pos1 = detector.Location;

hold on;
plot(pos1(:,1),pos1(:,2),'y+','LineWidth',2);

pos2 = find_matches(I1,pos1,I2);

