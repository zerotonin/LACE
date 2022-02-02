function frame = ET_SR_loadImage(fPos)
frame =imread(fPos);


switch size(frame,3) 
    case 3,
        frame = double(imadjust(rgb2gray(frame)));
    case 1,
         % seems to be allrady gray scale
          frame = double(imadjust(frame));
    otherwise,
        error('ET_SR_loadImage: This image format is not yet implemented')
end

h = fspecial('gaussian',5,5);
frame = imfilter(frame,h);
frame = ET_im_normImage(frame);