function imageBin = ET_im_erode(imageBin,eroderR)
% This function of the Ethotrack image manipulation toolbox (ET_im_) 
% erodes the binary image of the animals with a disk shaped eroder tool. 
%
% GETS:
%      imageBin = a mxn uint8 image
%       eroderR = erosion radius in pixels
%
% RETURNS:
%      imageBin = eroded image
%
%
% SYNTAX: imageBin = ET_im_erode(imageBin,eroderR);
%
% Author: B.Geurten 11-27-2015
%
% NOTE: 
%
% see also

% make tool
se= strel('disk',eroderR);
% erode
imageBin =imerode(imageBin,se);