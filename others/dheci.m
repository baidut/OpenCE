function d = dheci(im,alpha,hist_i,hist_s)

if ~exist('alpha','var'),alpha = 0.5;end
if ~exist('hist_i','var') || ~exist('hist_s','var'),[hist_i, hist_s] = build_is_hist(im);end

hsv = rgb2hsv(im);
hist_c = alpha*hist_s+(1-alpha)*hist_i;
hist_sum = sum(hist_c);
hist_cum = cumsum(hist_c);
h = hsv(:,:,1);
s = hsv(:,:,2);
i = uint8(hsv(:,:,3).*255);
c = hist_cum./hist_sum;
s_r = uint8(c.*255);
i_s = zeros(size(i));
for n = 0:255
    lc = i == n;
    i_s(lc) = double(s_r(n+1))/255;
end
hsi_o = cat(3,h,s,i_s);
d = uint8(hsv2rgb(hsi_o).*255);

