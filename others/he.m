function image = he(image)

nChannel = size(image,3);
switch nChannel
    case 3 % RGB
        image = cat(3, histeq(image(:,:,1)),histeq(image(:,:,2)),histeq(image(:,:,3)));
    case 1 % gray
        image = histeq(image);
    otherwise
        for c = 1:nChannel
            image(:,:,c) = histeq(image(:,:,c));
        end
end