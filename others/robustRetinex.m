%clear;


%img = double(imread('9.bmp'));
function res = robustRetinex(img)

if ~isfloat(img)
	img = im2doule(img)
end

img = img*255;

para.epsilon_stop_L = 1e-3;
para.epsilon_stop_R = 1e-3;
para.epsilon = 10/255;
para.u = 1;
para.ro = 1.5;
para.lambda = 5;
para.beta = 0.01;
para.omega = 0.01;
para.delta = 10;

gamma = 2.2;

[R, L, N] = RobustRetinex.lowlight_enhancement(img, para);

res = R.*L.^(1/gamma);

%figure,imshow(res)



















