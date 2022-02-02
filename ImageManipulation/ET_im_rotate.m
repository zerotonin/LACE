function image = ET_im_rotate(image,angle)
% This function of the Ethotrack image manipulation toolbox (ET_im_) 
% rotates the image for a certain angle and crops it to its original size
% images are corrected with bilinear interpolation.
%
% GETS:
%         image = a mxn matrix
%         angle = turning angle in degree
%
% RETURNS:
%         image = a mxn  image 
%
%
% SYNTAX: image = ET_im_rotate(image,angle);
%
% Author: B.Geurten 11-27-2015
%
% NOTE: 
%
% see also

image = imrotate(image,angle,'bilinear','crop');