function maskIDX = ET_im_calcMaskCoord(bgMin,anchors)
% This function of the Ethotrack image manipulation toolbox (ET_im_)
% offers the user to create a ROI which can be used for later calculation.
% NOTE! If you use a minimal background (black animal / white background)
% or maximal background (if vice versa) you can see the animals complete
% trajectory and create an optimal ROI.
%
% GETS:
%          bgMin = image 
%            axH = axis handle
%
% RETURNS:
%        anchors = a mx2 matrix (x,y coordinates) of the ROI
%
% SYNTAX: anchors = ET_im_getROI(bgMin,axH);
%
% Author: B.Geurten 15-01-2016
%
% see also sub2ind, unique, ET_im_getROI


% get a matrix of frame size filled with zeros
mask = zeros(size(bgMin));

% make the anchor list round robin
anchorsRR = [anchors;anchors(1,:)];
%number of anchors
anchorNum = size(anchorsRR,1);
% the interpolation factor is equal to the longest possible line in the
% image,m as images are squares it is the hypotenuse
interpF=sqrt(size(bgMin,1)^2 + size(bgMin,2)^2);

% the new interpolated values. We interpolate a hypotenusis length between
% each coordinate pair
xi = linspace(1,anchorNum,anchorNum*interpF);
% the old x values
x  =1:anchorNum;

% now interpolate both coordinates with a linear kernel  and round the
% values as pixel positions can only be integer
borderlines =round([interp1(x,anchorsRR(:,1),xi,'linear')' ...
                interp1(x,anchorsRR(:,2),xi,'linear')' ]);
% now we make a single value coordinate with sub2ind and unique eliminates 
% duplicates
linearInd = unique(sub2ind(size(bgMin), borderlines(:,2), borderlines(:,1)));

% we use the single value coordinates to differtiate between ROI and
% background
mask(linearInd) = 1;

% we fill the ROI
mask = imfill(mask);

% and get the single vector coordinates for the background
maskIDX = find(mask == 0);