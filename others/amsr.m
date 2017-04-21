function d = amsr(im,sigma1,sigma2,sigma3)

if ~exist('sigma1','var'),sigma1 = 15;end
if ~exist('sigma2','var'),sigma2 = 80;end
if ~exist('sigma3','var'),sigma3 = 250;end

im = im2double(im); % double --> im2double
gausKernel1 = fspecial('gaussian',[sigma1 sigma1],5);
gausKernel2 = fspecial('gaussian',[sigma2 sigma2],20);
gausKernel3 = fspecial('gaussian',[sigma3 sigma3],50);
Y = 0.299.*im(:,:,1)+0.587.*im(:,:,2)+0.114.*im(:,:,3);

blur_im1 = (imfilter(Y,gausKernel1,'replicate'));
blur_im2 = (imfilter(Y,gausKernel2,'replicate'));
blur_im3 = (imfilter(Y,gausKernel3,'replicate'));

Y_ssr1 = log(Y) - log(blur_im1);
Y_ssr2 = log(Y) - log(blur_im2);
Y_ssr3 = log(Y) - log(blur_im3);

sr = sort(Y_ssr1(:));
p1 = sr(uint32(0.01*size(im,1)*size(im,2)));
p99 = sr(uint32(0.99*size(im,1)*size(im,2)));
lc1 = Y_ssr1 >= p1 & Y_ssr1 <= p99;
lc2 = Y_ssr1 < p1;
lc3 = Y_ssr1 > p99;
Y_ssr1(lc1) = 255 * (Y_ssr1(lc1)-p1)./(p99-p1);
Y_ssr1(lc2) = 0;
Y_ssr1(lc3) = 255;

sr = sort(Y_ssr2(:));
p1 = sr(uint32(0.01*size(im,1)*size(im,2)));
p99 = sr(uint32(0.99*size(im,1)*size(im,2)));
lc1 = Y_ssr2 >= p1 & Y_ssr2 <= p99;
lc2 = Y_ssr2 < p1;
lc3 = Y_ssr2 > p99;
Y_ssr2(lc1) = 255 * (Y_ssr2(lc1)-p1)./(p99-p1);
Y_ssr2(lc2) = 0;
Y_ssr2(lc3) = 255;

sr = sort(Y_ssr3(:));
p1 = sr(uint32(0.01*size(im,1)*size(im,2)));
p99 = sr(uint32(0.99*size(im,1)*size(im,2)));
lc1 = Y_ssr3 >= p1 & Y_ssr3 <= p99;
lc2 = Y_ssr3 < p1;
lc3 = Y_ssr3 > p99;
Y_ssr3(lc1) = 255 * (Y_ssr3(lc1)-p1)./(p99-p1);
Y_ssr3(lc2) = 0;
Y_ssr3(lc3) = 255;

% Y = 0.299.*im(:,:,1)+0.587.*im(:,:,2)+0.114.*im(:,:,3);
% Y_ssr1 = 0.299.*R_ssr1(:,:,1)+0.587.*R_ssr1(:,:,2)+0.114.*R_ssr1(:,:,3);
% Y_ssr2 = 0.299.*R_ssr2(:,:,1)+0.587.*R_ssr2(:,:,2)+0.114.*R_ssr2(:,:,3);
% Y_ssr3 = 0.299.*R_ssr3(:,:,1)+0.587.*R_ssr3(:,:,2)+0.114.*R_ssr3(:,:,3);
sigma = 32;
mu0 = 32;
mu1 = 96;
mu2 = 160;
mu3 = 224;
P0 = exp(-(Y-mu0).^2./(2*sigma^2));
P1 = exp(-(Y-mu1).^2./(2*sigma^2));
P2 = exp(-(Y-mu2).^2./(2*sigma^2));
P3 = max(P0,exp(-(Y-mu3).^2./(2*sigma^2)));
psum = P0+P1+P2+P3;
omega0 = P0./psum;
omega1 = P1./psum;
omega2 = P2./psum;
omega3 = P3./psum;
Y_amsr = omega0.*Y + omega1.*Y_ssr1 + omega2.*Y_ssr2 + omega3.*Y_ssr3;
ratio = Y_amsr./Y;

% modified: uint8 --> im2uint8
hsv = rgb2hsv(im2uint8(im));
v = hsv(:,:,3);%.*255;
v = 0.5.*(ratio.*(v+Y)+v-Y);
hsv(:,:,3) = v./255;
%d = uint8(hsv2rgb(hsv).*255);
d = double(hsv2rgb(hsv)); % modified
d = min(max(d,0),1); % add

% r = 0.5.*(ratio.*(im(:,:,1)+Y)+im(:,:,1)-Y);
% g = 0.5.*(ratio.*(im(:,:,2)+Y)+im(:,:,2)-Y);
% b = 0.5.*(ratio.*(im(:,:,3)+Y)+im(:,:,3)-Y);
% d = cat(3,r,g,b)./255;
end