function [Hist_I, Hist_S] = build_is_hist(im)
[hei wid ch] = size(im);
I =  padarray(im,[2,2,0], 'replicate');
hsv = uint8(rgb2hsv(I).*255);
fh = [-1 0 1;-2 0 2;-1 0 1];
fv = fh';
H = hsv(:,:,1);
S = hsv(:,:,2);
I = hsv(:,:,3);
dIh = filter2(fh,I);
dIv = filter2(fv,I);
dI = uint32(sqrt(dIh.^2+dIv.^2));
di = dI(3:hei+2,3:wid+2);
dSh = filter2(fh,S);
dSv = filter2(fv,S);
dS = uint32(sqrt(dSh.^2+dSv.^2));
ds = dS(3:hei+2,3:wid+2);
h = H(3:hei+2,3:wid+2);
s = S(3:hei+2,3:wid+2);
i = I(3:hei+2,3:wid+2);
Imean = conv2(double(I),ones(5)/25,'same');
Smean = conv2(double(S),ones(5)/25,'same');
Rho = zeros([hei+4 wid+4]);

for p = 3:hei+2
    for q = 3:wid+2
        tmpi = double(I(p-2:p+2,q-2:q+2));
        tmps = double(S(p-2:p+2,q-2:q+2));
        corre = corrcoef(tmpi(:),tmps(:));
        Rho(p,q) = corre(1,2);
    end
end

rho = abs(Rho(3:hei+2,3:wid+2));
rd = uint32(rho.*double(ds));
Hist_I = zeros(256,1);
Hist_S = zeros(256,1);

for n = 0:255
    lc = i == n;
    temp = zeros(size(di));
    temp(lc) = di(lc);
    Hist_I(n+1) = sum(temp(:));
    temp = 0;
    temp(lc) = rd(lc);
    Hist_S(n+1) = sum(temp(:));
end
