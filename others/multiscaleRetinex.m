function OUT = multiscaleRetinex(I, method, varargin)

if nargin == 0
%     I = imload; %imread(imgetfile); %imread('office_1.jpg');
%     J = multiscaleRetinex(I, 'MSRCR');
%     ezFig I J
%     return;

    I = imload; %imread(imgetfile); %('office_1.jpg');
    method = Popupmenu({'MSRCR','MSR','SSR'});
    J = ImCtrl(@multiscaleRetinex, I, method);
    ezFig I J
end

if nargin == 1
   method = 'MSRCR';
end

I = im2double(I).*255+1; % +1 to avoid Inf
SSR = @SSRlog; % @SSR; %

% TODO: gray or RGB

switch (method)
    case {'SSR' 'single scale retinex'}, f = SSR;
    case {'MSR' 'multi scale retinex'}, f = @MSR;
    case 'MSRCR', f = @MSRCR;
    %case 'MSRCP', f = @MSRCP;
    otherwise
        return;
        %f = str2func(method);
end

OUT = f(I, varargin{:});

end

function OUT = SSR(I, varargin)
T = imgaussfilt(I, varargin{:});
OUT = I./(T); % avoid NaN
end

function OUT = SSRlog(I, varargin)
T = imgaussfilt(I, varargin{:});
OUT = log(I) - log(T+1) + 0.5;
end

function OUT = MSR(I, varargin)
if numel(varargin) == 0
    varargin = {25 100 240};
end
OUT = 0; N = numel(varargin);
for n = 1:N
    OUT = OUT + (1/N)* multiscaleRetinex(I,'SSR',varargin{n});
end
end

function OUT = MSRCR(I, lowScale, medScale, highScale, leftChop, rightChop)
if ~exist('lowScale', 'var'), lowScale = 15; end
if ~exist('MedScale', 'var'), medScale = 80; end
if ~exist('HighScale', 'var'), highScale = 250; end
if ~exist('s1', 'var'), leftChop = 1; end
if ~exist('s2', 'var'), rightChop = 1; end

MSR = multiscaleRetinex(I, 'MSR', lowScale, medScale, highScale);

for c = 1:3
    CR = (log(125*I(:,:,c))-log(I(:,:,1)+I(:,:,2)+I(:,:,3)));
    OUT(:,:,c) = colorBalance(mat2gray(CR.*MSR(:,:,c)), 'simplest', leftChop, rightChop);
end
%OUT = max(0, min(1, OUT));
end
