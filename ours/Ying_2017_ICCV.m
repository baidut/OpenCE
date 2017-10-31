function J = Ying_2017_ICCV(I, model) 

% @InProceedings{Ying_2017_ICCV,
% author = {Ying, Zhenqiang and Li, Ge and Ren, Yurui and Wang, Ronggang and Wang, Wenmin},
% title = {A New Low-Light Image Enhancement Algorithm Using Camera Response Model},
% booktitle = {The IEEE International Conference on Computer Vision (ICCV)},
% month = {Oct},
% year = {2017}
% }
%
% Please feel free to contact me (yingzhenqiang-at-gmail-dot-com) if you
% have any questions or concerns.

if ~isfloat(I), I = im2double(I); end

%% Param Settings
alpha = 1;
eps = 0.001;
range = 5;
ratioMax = 7;

%% Camear Model
% we use beta-gamma model as default
if ~exist('model', 'var'), model = 'beta-gamma'; end

switch lower(model)
    case 'preferred' 
        param = {4.3536    1.2854    0.1447};
        [a, b, c] = deal(param{:});
        g = @(I,k)(I.*(k.^(a.*c)) )./ (( (I).^(1./c) .*(k.^a - 1)   + 1).^c);
        
    case 'beta-gamma'
    	param = {-0.3293    1.1258};
    	[a, b] = deal(param{:});
        f = @(x)exp((1-x.^a).*b);
        g = @(I,k)I.^(k.^a).*f(k);
        
    case 'affine'
         param = {-0.1797    1.2076    0.3988};
         [alpha, beta, gamma] = deal(param{:});
         g = @(I,k)I.*(k.^gamma) + alpha.*(1-k.^gamma);
         
    case 'beta'
         c = 0.4800;
         g = @(I,k)I.*( k.^c );
         
    otherwise 
        error('unkown model: %s', model);
end

%% Exposure Ratio Map

% Initial Exposure Ratio Map
t0 = max(I, [], 3);
[M,N] = size(t0);

% Exposure Ratio Map Refinement
t0 = imresize(t0,0.5);
dt0_v = [diff(t0,1,1);t0(1,:)-t0(end,:)];
dt0_h = [diff(t0,1,2)';t0(:,1)'-t0(:,end)']';
gauker_h = filter2(ones(1,range),dt0_h);
gauker_v = filter2(ones(range,1),dt0_v);
W_h = 1./(abs(gauker_h).*abs(dt0_h)+eps);
W_v = 1./(abs(gauker_v).*abs(dt0_v)+eps);
T = solveLinearEquation(t0,W_h,W_v,alpha./2);
T = imresize(T,[M,N]);

T = repmat(T, [1 1 3]);
kRatio = min(1./T,ratioMax);

%% Enhancement
J = g(I, kRatio);
J = max(0, min(1, J));

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
        [ tout, flag ] = pcg( A, tin( : ), 0.1, 50, L, L' );
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