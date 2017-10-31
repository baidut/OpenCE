function fused = Ying_2017_CAIP(I, mu, k, a, b) % camera a, b
%%
% @inproceedings{ying2017new,
%   title={A New Image Contrast Enhancement Algorithm Using Exposure Fusion Framework},
%   author={Ying, Zhenqiang and Li, Ge and Ren, Yurui and Wang, Ronggang and Wang, Wenmin},
%   booktitle={International Conference on Computer Analysis of Images and Patterns},
%   pages={36--46},
%   year={2017},
%   organization={Springer}
% }
%
% Please feel free to contact me (yingzhenqiang-at-gmail-dot-com) if you
% have any questions or concerns.

if  ~exist( 'mu', 'var' )
    mu = 0.5;
end

if ~exist( 'a', 'var' )
    a = -0.3293;
end

if ~exist( 'b', 'var' )
    b = 1.1258;
end

if ~isfloat(I)
    I = im2double( I );
end

lambda = 0.5;
sigma = 5;

%% t: scene illumination map
t_b = max( I, [], 3 ); % also work for single-channel image
t_our =  imresize( tsmooth( imresize( t_b, 0.5 ), lambda, sigma ), size( t_b ) );

%% k: exposure ratio
if  ~exist( 'k', 'var' ) || isempty(k)
    isBad = t_our < 0.5;
    J = maxEntropyEnhance(I, isBad);
else
    J = applyK(I, k, a, b); %k
    J = min(J, 1); % fix overflow
end

%% W: Weight Matrix 
t = repmat(t_our, [1 1 size(I,3)]);
W = t.^mu;

I2 = I.*W;
J2 = J.*(1-W);

fused = I2 + J2;

    function J = maxEntropyEnhance(I, isBad)
        Y = rgb2gm(real(max(imresize(I, [50 50]), 0))); % max - avoid complex number 
        
        if exist('isBad', 'var')
            isBad = (imresize(isBad, [50 50]));
            Y = Y(isBad);
        end
        
        if isempty(Y)
           J = I; % no enhancement k = 1
           return;
        end
        
        opt_k = fminbnd(@(k) ( -entropy(applyK(Y, k)) ),1, 7);
        J = applyK(I, opt_k, a, b) - 0.01;
        
    end
end

function I = rgb2gm(I)
if size(I,3) == 3
    I = im2double(max(0,I)); % negative double --> complex double
    I = ( I(:,:,1).*I(:,:,2).*I(:,:,3) ).^(1/3);
end
end

function J = applyK(I, k, a, b)

if ~exist( 'a', 'var' )
    a = -0.3293;
end

if ~exist( 'b', 'var' )
    b = 1.1258;
end

f = @(x)exp((1-x.^a)*b);
beta = f(k);
gamma = k.^a;
J = I.^gamma.*beta;
end

function S = tsmooth( I, lambda, sigma, sharpness)
if ( ~exist( 'lambda', 'var' ) )
    lambda = 0.01;
end
if ( ~exist( 'sigma', 'var' ) )
    sigma = 3.0;
end
if ( ~exist( 'sharpness', 'var' ) )
    sharpness = 0.001;
end
I = im2double( I );
x = I;
[ wx, wy ] = computeTextureWeights( x, sigma, sharpness);
S = solveLinearEquation( I, wx, wy, lambda );
end

function [ W_h, W_v ] = computeTextureWeights( fin, sigma, sharpness)

dt0_v = [diff(fin,1,1);fin(1,:)-fin(end,:)];
dt0_h = [diff(fin,1,2)';fin(:,1)'-fin(:,end)']';

gauker_h = filter2(ones(1,sigma),dt0_h);
gauker_v = filter2(ones(sigma,1),dt0_v);
W_h = 1./(abs(gauker_h).*abs(dt0_h)+sharpness);
W_v = 1./(abs(gauker_v).*abs(dt0_v)+sharpness);

end

function OUT = solveLinearEquation( IN, wx, wy, lambda )
[ r, c, ch ] = size( IN );
k = r * c;
dx =  -lambda * wx( : );
dy =  -lambda * wy( : );
tempx = [wx(:,end),wx(:,1:end-1)];
tempy = [wy(end,:);wy(1:end-1,:)];
dxa = -lambda *tempx(:);
dya = -lambda *tempy(:);
tempx = [wx(:,end),zeros(r,c-1)];
tempy = [wy(end,:);zeros(r-1,c)];
dxd1 = -lambda * tempx(:);
dyd1 = -lambda * tempy(:);
wx(:,end) = 0;
wy(end,:) = 0;
dxd2 = -lambda * wx(:);
dyd2 = -lambda * wy(:);

Ax = spdiags( [dxd1,dxd2], [-k+r,-r], k, k );
Ay = spdiags( [dyd1,dyd2], [-r+1,-1], k, k );

D = 1 - ( dx + dy + dxa + dya);
A = (Ax+Ay) + (Ax+Ay)' + spdiags( D, 0, k, k );

if exist( 'ichol', 'builtin' )
    L = ichol( A, struct( 'michol', 'on' ) );
    OUT = IN;
    for ii = 1:ch
        tin = IN( :, :, ii );
        [ tout, ~ ] = pcg( A, tin( : ), 0.1, 50, L, L' );
        OUT( :, :, ii ) = reshape( tout, r, c );
    end
else
    OUT = IN;
    for ii = 1:ch
        tin = IN( :, :, ii );
        tout = A\tin( : );
        OUT( :, :, ii ) = reshape( tout, r, c );
    end
end
end

