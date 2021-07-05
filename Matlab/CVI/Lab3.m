Ia=imread('rooster.jpg');
Ib=imread('elephant.png');
Ic=imread('boxes.pgm');

Ia = im2gray(Ia);
Ib = im2gray(Ib);
Ic = im2gray(Ic);

Ia = im2double(Ia);
Ib = im2double(Ib);
Ic = im2double(Ic);

box25 = ones(25,25)./(25^2);
box5 = ones(5,5)./(5^2);

Iabox5=conv2(Ia,box5,'same');
Iabox25=conv2(Ia,box25,'same');

Ibbox5=conv2(Ib,box5,'same');
Ibbox25=conv2(Ib,box25,'same');

Icbox5=conv2(Ic,box5,'same');
Icbox25=conv2(Ic,box25,'same');

figure(1), clf
subplot(2,2,1), imagesc(Iabox5), colorbar, title('rooster with 5x5 mask');
subplot(2,2,2), imagesc(Iabox25), colorbar, title('rooster with 25x25 mask');
subplot(2,2,3), imagesc(Icbox5), colorbar, title('boxes with 5x5 mask');
subplot(2,2,4), imagesc(Icbox25), colorbar, title('boxes with 25x25 mask');

