function [OUT] = colorBalance(I, algorithm, varargin)
% whitebalance

if nargin == 0
    I = imload; %('toysnoflash.png');
    tic, J = colorBalance(I, 'grayworld'); toc;
    tic, J2 = colorBalance(I, 'simplest'); toc;
    
    %25 100 240
    ezFig I J J2
    return;
end

[m,n,k]=size(I);
if ~isfloat(I), I = im2double(I); end

switch (algorithm)
    case {'gain_offset'}
        

    case {'grayworld'}
        Rmean      = sum(sum(I(:,:,1)))/(m*n);
        Gmean      = sum(sum(I(:,:,2)))/(m*n);
        Bmean      = sum(sum(I(:,:,3)))/(m*n);
        Avg        = mean([Rmean Gmean Bmean]);
        Kr         = Avg/Rmean;
        Kg         = Avg/Gmean;
        Kb         = Avg/Bmean;
        OUT(:,:,1) = Kr*double(I(:,:,1));
        OUT(:,:,2) = Kg*double(I(:,:,2));
        OUT(:,:,3) = Kb*double(I(:,:,3));
        
    case {'grayworld_spedup'}
        % forces the average image color to be gray
        % REF:
        % http://www.mathworks.com/matlabcentral/fileexchange/41089-color-balance-demo-with-gpu-computing/content/GPUDemoCode/whitebalance.m
        %
        % Find the average values for each channel
        pageSize = size(I,1) * size(I,2);
        avg_rgb = mean( reshape(I, [pageSize,3]) );
        
        % Find the average gray value and compute the scaling array
        avg_all = mean(avg_rgb);
        scaleArray = max(avg_all, 0.5)./avg_rgb;
        scaleArray = reshape(scaleArray,1,1,3);
        
        % Adjust the image to the new gray value
        OUT = bsxfun(@times,I,scaleArray);
    case {'underwater'}
        OUT = color_correction(I);
    case {'grayworld_gpu'}
        pageSize = size(I,1) * size(I,2);
        avg_rgb = mean( reshape(I, [pageSize,3]) );
        
        % Find the average gray value and compute the scaling array
        avg_all = mean(avg_rgb);
        scaleArray = max(avg_all, 0.5)./avg_rgb;
        scaleArray = reshape(scaleArray,1,1,3);
        
        % Adjust the image to the new gray value
        I = gpuArray(I);
        OUT = bsxfun(@times,I,scaleArray);

    case {'grayworld_cuda'}
        % Find the average values for each channel
        pageSize = size(imageData,1) * size(imageData,2);
        avg_rgb = mean( reshape(imageData, [pageSize,3]) );
        
        % Find the average gray value and compute the scaling factor
        avg_all = mean(avg_rgb);
        factor = max(avg_all, 0.5)./avg_rgb;
        factor = reshape(factor,1,1,3);
        
        % Load the kernel and set up threads
        kernel = parallel.gpu.CUDAKernel('whitebalanceKernel.ptxw64','whitebalanceKernel.cu' );
        [nRows, nCols,~] = size(imageData);
        blockSize = 256;
        kernel.ThreadBlockSize = [blockSize, 1, 3];
        kernel.GridSize = [ceil(nRows/blockSize), nCols];
        
        % Copy image data to the GPU and allocate and initialize return data
        imageDataGPU = gpuArray(imageData);
        OUT = gpuArray.zeros( size(imageData), 'uint8');
        
        % Adjust the image to the new gray value
        OUT = feval( kernel, OUT, imageDataGPU, factor, nRows, nCols );

    case 'gaussian'
        if ~isempty(varargin)
            b = varargin{1};
        else
            b = 2.3;
        end
        OUT = zeros(size(I));
        for c = 1:k
            channel_mean=mean2(I(:,:,c));
            channel_var=std2(I(:,:,c));
            channel_max=channel_mean+b*channel_var;
            channel_min=channel_mean-b*channel_var;
            OUT(:,:,c)=(I(:,:,c)-channel_min)./(channel_max-channel_min);
        end
    case 'simplest', OUT = simplest(I, varargin{:});
    otherwise
        OUT=I; disp('Unknown alogrithm, please check name.');
        algorithm
end

end

function OUT = simplest(I, s1, s2)
% Multiscale Retinex [IPOL]
% In all the outputs we applied a simplest color balance with 1% pixel clipping
% on either side of the dynamical range.

if ~exist('s1', 'var'), s1 = 1.5; end
if ~exist('s2', 'var'), s2 = 1.5; end

Tol = [s1/100, 1-s2/100];
for c = 1:size(I,3)
    Low_High = stretchlim(I(:,:,c),Tol);
    OUT(:,:,c) = imadjust(I(:,:,c),Low_High,[]);
end
end

function s_cr = color_correction(s)
b=2.3; %文章中指定的参数值2.3
s_cr=zeros(size(s));
for i=1:3
    channel_mean=mean2(s(:,:,i));%求矩阵所有元素的均值
    channel_var=std2(s(:,:,i));%求矩阵所有元素的均方误差
    channel_max=channel_mean+b*channel_var;
    channel_min=channel_mean-b*channel_var;
    s_cr(:,:,i)=(s(:,:,i)-channel_min)./(channel_max-channel_min);%归一化
end
end