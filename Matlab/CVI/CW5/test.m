a =imread('im3.jpg');
a = im2double(a);
Ig = rgb2gray(a);

figure(1)

imshow(Ig)

Ig = conv_gaus(Ig,3);
Ig = intensity_gradients(Ig);

% Ig = Ig.*2;

% [~,threshold] = edge(Ig,'canny');
% threshold = (threshold(2)-threshold(1)).*4.5;
% BW = edge(Ig,'canny',threshold);

mask = zeros(size(Ig));
mask(50:end-50,50:end-50) = 1;
bw = activecontour(Ig,mask,1000);


figure(2)
imshow(Ig)

% figure(3)
% imshow(BW)

figure(4)
imshow(bw)

function Ibox = conv_gaus(I,n)
box3 = ones(n,n)./(n^2);
Ibox=conv2(I,box3,'same');
end

function Ibdiff = intensity_gradients(Id)
Ibdiffv=Id(1:size(Id)-1,:)-Id(2:size(Id),:);
Ibdiffh=Id(:,1:size(Id,2)-1)-Id(:,2:size(Id,2));
Ibdiff=sqrt(Ibdiffh(1:size(Id)-1,:).^2+Ibdiffv(:,1:size(Id,2)-1).^2);
end


