function [I, R, L] = jed(img)

if ~isfloat(img)
	img = im2doule(img)
end

img = img*255;

para.alpha = 0.001;
para.beta = 0.007;
para.omega = 0.016;
para.lambda = 6;

scale = 1;     
[I, R, L] = JED.JED(img, para);  
% imwrite(I, ['./results/' num2str(i) '_JED.bmp']); 
