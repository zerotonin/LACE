function diffImage = ET_im_diffImage(image,bg,modus)
% This function of the Ethotrack image manipulation toolbox (ET_im_) 
% calculates the difference between a frame and a background. So that the
% animals will be in the difference image
%
% GETS:
%         image = a mxn uint8 image
%            bg = a mxn uint8 background image (as derived from the ET_bg
%                 toolbox)
%         modus = string flag variable. 'absolute': difference of both
%                 images (brighter and darker); 'image-bg': everything
%                 brighter in the image is kept; 'bg-image': everything
%                 darker than in the image is kept
%
% RETURNS:
%           diff = a mxn uint8 image 
%
%
% SYNTAX: diffImage = ET_im_diffImage(image,bg,modus);
%
% Author: B.Geurten 09-25-2015
%
% NOTE:
%
% see also

image = double(image);
switch modus
    case 'absolute'
        diffImage = abs(bsxfun(@minus,image,bg));
    case 'image-bg'
        diffImage = bsxfun(@minus,image,bg);
    case 'bg-image'
        diffImage = bsxfun(@minus,bg,image);
    otherwise
        error(['BFT_diffImage_calc:Line 1: the modus for the image difference was badly defined as: ' modus])
end