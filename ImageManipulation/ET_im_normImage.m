function imageN = ET_im_normImage(image)
% This function of the Ethotrack image manipulation toolbox (ET_im_) 
% normalises an image so that it's lowest value = 0 and its largest value
% is 1
%
% GETS:
%         image = a mxn uint8 image
%
% RETURNS:
%           diff = a mxn double matrix with values 0->1 
%
%
% SYNTAX: imageN = ET_im_normImage(image);
%
% Author: B.Geurten 09-25-2015
%
% NOTE: NOT TESTED FOR BACKLIGHT!
%
% see also

%uint8 2 double
imageN = double(image);

% get extremes
imageMin = min(min(imageN));
imageMax = max(max(imageN));

% normalise
imageN =(imageN-imageMin)./(imageMax-imageMin);