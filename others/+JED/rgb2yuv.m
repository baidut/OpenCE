function Z= rgb2yuv(img)

% [w h d]=size(img);
% img=double(img);
% Z=zeros(w,h,d);
% A=[0.299,0.587,0.114;-0.14713,-0.28886,0.436;0.615,-0.51499,-0.10001];
% 
% for i=1:w
%     for j=1:h
%         Z(i,j,:)=A*reshape(img(i,j,:),[3 1]);
%     end
% end

T = [0.299,0.587,0.114;-0.169,-0.331,0.5;0.5,-0.419,-0.081]';

[h w r] = size(img);

temp = double(reshape(img, h*w, r));
gray = double(ones(h*w,r)*128);
gray(:,1) = 0;
temp = temp*T+gray;
Z = reshape(temp, h, w, r);

end