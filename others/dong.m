function d = Dong( im ,w )
    if max(im(:)) > 1
        im = im2double(im);
    end
    isize = size(im);
    im =  padarray(im,[2*5,2*5,0],'replicate');
    if (~exist('w','var') || w<=0)
        w = 0.8;
    end
    
    R = 1 - im;
%     [Rd,~] = dehaze(R,w);
    Ir = R(:,:,1);
    Ig = R(:,:,2);
    Ib = R(:,:,3);

    Ir1 = Ir(:);
    Ig1 = Ig(:);
    Ib1 = Ib(:);
    Il = (Ir1+Ig1+Ib1)./3;
    n = length(Il);
    N = floor(n*0.002);

    Ir_d = ordfilt2(Ir,1,ones(7,7));
    Ig_d = ordfilt2(Ig,1,ones(7,7));
    Ib_d = ordfilt2(Ib,1,ones(7,7));
    darkc = min(min(Ir_d(:),Ig_d(:)),Ib_d(:));
    [~, i] = sort(darkc,1,'descend');
    temp = Il(i(1:N));
    [~,j] = sort(temp,1,'descend');
    Ar = Ir1(i(j(1)));
    Ag = Ig1(i(j(1)));
    Ab = Ib1(i(j(1)));
% exp(log())
    t = max(1-w.*min(min(Ir_d./Ar,Ig_d./Ag),Ib_d./Ab),10^(-7));
    lc = t<0.5;
    t(lc) = 2 * t(lc).^2;

    Sr = (Ir - Ar)./t +Ar;
    Sg = (Ig - Ag)./t +Ag;
    Sb = (Ib - Ab)./t +Ab;

    Rd = cat(3,Sr,Sg,Sb);
    d = 1-Rd(11:isize(1)+10,11:isize(2)+10,:);
end

