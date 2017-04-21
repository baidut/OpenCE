function d = bpdhe(im)

im = im2uint8(im);

hsv = rgb2hsv(im);
h = hsv(:,:,1);
s = hsv(:,:,2);
i = uint8(hsv(:,:,3).*255);
% i = uint8(20+rand(512).*(200));
ma = double(max(i(:)));
mi = double(min(i(:)));
bins = (ma-mi)+1;
hist_i = hist(double(i(:)),bins);
gausFilter = fspecial('gaussian',[1 9],1.0762);
blur_hist = (imfilter(hist_i,gausFilter,'replicate'));
derivFilter = [-1 1];
deriv_hist = imfilter(blur_hist,derivFilter,'replicate');
sign_hist = sign(deriv_hist);
meanFilter = [1/3 1/3 1/3];
smooth_sign_hist = sign(imfilter(sign_hist,meanFilter,'replicate'));
cmpFilter = [1 1 1  -1 -1 -1 -1 -1];
index = zeros([1,3]);
index(1) = 0;
p = 2;
for n = 1:bins-7
    C = smooth_sign_hist(n:n+7) == cmpFilter;
    if sum(C) ==8
        index(p) = n+3;
        p = p+1;
    end 
end
index(p) = bins;
factor = zeros([length(index)-1,1]);
span = factor;
M = factor;
range = factor;
start = factor;
endd = factor;
sub_hist = cell([length(index)-1,1]);
for m = 1:length(index)-1;
    sub_hist{m} = hist_i(index(m)+1:index(m+1));
    M(m) = sum(sub_hist{m});
    low = mi + index(m);
    high = mi + index(m+1)-1; 
    span(m) = high-low+1;
    factor(m) = span(m)*log10(M(m));
end
factor_sum = sum(factor);
for m = 1:length(index)-1;
    range(m) = round((256-mi)*factor(m)/factor_sum);
end
start(1) = mi;
endd(1) = mi+range(1)-1;
for m = 2:length(index)-1;
    start(m) = start(m-1)+range(m-1);
    endd(m) = endd(m-1)+range(m);
end
y = cell([length(index)-1,1]);
s_r = zeros([1,mi]);
for m = 1:length(index)-1;
    hist_cum = cumsum(sub_hist{m});
    c = hist_cum./M(m);
    y{m} = round(start(m)+(endd(m)-start(m)).*c);
    s_r = [s_r,y{m}];
end
i_s = zeros(size(i));
for n = mi:ma
    lc = i == n;
    i_s(lc) = double(s_r(n+1))/255;
end
% hist_is = hist(double(i_s(:)),bins);
hsi_o = cat(3,h,s,i_s);
d = uint8(hsv2rgb(hsi_o).*255);
