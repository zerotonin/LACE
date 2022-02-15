function  longLum = FILA_getLongLum(image,boundary)
% This function from the fluorescent image larva analysis toolbox (FILA) 
% disects the forground from the background and than calculates the
% central value of the luminence and it's dispersion measure. Only values
% from inside the boundary are used for these calculations
%
% GETS:
%          image = a matlab image variable, turned so that the larva is
%                  horizontally, as returned by FILA_turnImage2LarvaOrient
%       boundary = a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background, as produced by
%                  FILA_getLarvaPos
%
% RETURNS  
%        longLum = 6xn matrix where n is the width of the image and the rows
%                  are as follows: 1) median 2) mean 3) variance 4)
%                  standard deviation 5) upper confidence interval 6)
%                  lower CI
%
% SYNTAX: longLum = FILA_getLongLum(image,boundary);
%
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos -> 
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos -> 
%          FILA_imcrop2boundary->FILA_scaleDownBoundary -> FILA_getLongLum
%
% Author: B. Geurten 22.01.2015
%
% see also imcrop

% create empty logical Index
logIDX = zeros(size(image,1),size(image,2));

%now set the boundary to be one
logIDX(sub2ind(size(image),boundary(:,1),boundary(:,2)) ) = 1;

%than fillup the boundary and set everything to logical true that is a one
%in the picture
logIDX = imfill(logIDX) ==1;
image = double(image);

% now use the inverse logical index to set the background to NAN
image(~logIDX) = NaN;


% get some statistical values to the longitudinal axis of the image
longLum   = [nanmedian(image,1);nanmean(image,1);...
             nanvar(image,1);nanstd(image,0,1)];
[nhi,nlo] = confintND(image,1);
longLum   = [longLum;bsxfun(@minus,[nhi;nlo],longLum(1,:))];