function [bodyWallImage,innerBoundary] = FILA_ana_getBodywallRing(cropImage,outterBoundary)
% This function from the fluorescent image larva analysis toolbox (FILA)
% crops the image to the larval body wall so that one can track the dark
% spots in close to the bodywall. This is done by using to 
%
% GETS:
%      cropImage = the cropped larva image as returned by FILA_imcrop2boundary 
% outterboundary = a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background.
%
% RETURNS:
%     bodyWallImage = the cropped larva image, with all pixel outside the body
%                  wall ring set to NaN
%  innerboundary = a mx2 matrix with the m 2D positions of the boundary,
%                  between the body wall ring and the central part of the
%                  larva, cropped to the new cropImage
%
% SYNTAX: [bodyWallImage,innerBoundary] = ...
%               FILA_ana_getBodywallRing(cropImage,outterBoundary);
%
%
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos ->
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos ->
%          FILA_imcrop2boundary->FILA_ana_getBodywallRing
%
% Author: B. Geurten 20.07.2015
%
% see also bwtraceboundary, sub2ind, voronoi, FILA_getLarvaPos


% make new inner Boundary
innerBoundary = FILA_scaleDownBoundary(outterBoundary,[0.5 0.85]);

% create empty logical Index for outterBoundary
logIDX = zeros(size(cropImage,1),size(cropImage,2));

%now set the boundary to be one
logIDX(sub2ind(size(cropImage),outterBoundary(:,1),outterBoundary(:,2)) ) = 1;

%than fillup the boundary and set everything to logical true that is a one
%in the picture
logIDX_oB = imfill(logIDX) ==1;

% create empty logical Index for innerBoundary
logIDX = zeros(size(cropImage,1),size(cropImage,2));

%now set the boundary to be one
logIDX(sub2ind(size(cropImage),innerBoundary(:,1),innerBoundary(:,2)) ) = 1;

%than fillup the boundary and set everything to logical true that is a one
%in the picture
logIDX_iB = imfill(logIDX) ==1;

%delete inner boundary
logIDX_oB(logIDX_iB) = 0;

% now use the inverse logical index to set the background to NAN
bodyWallImage = cropImage;
bodyWallImage(~logIDX_oB) = NaN;


