function [dimpleCenter,dimpleBoundary]= FILA_getDimples(bodyWallImage,cutoff)
% This function from the fluorescent image larva analysis toolbox (FILA)
% detects the black spots, called dimples that appear if the animal fully
% streches. It does so by a cmbination of image erosions and openings as
% well as binarisations.
%
% GETS:
%     bodyWallImage = the cropped larva image, with all pixel outside the body
%                  wall ring set to NaN as returned by FILA_ana_getBodywallRing
%            cutoff = threshold concerning the number of pixel found in the
%                     boundary of a dimple (20 is a good value)
%
% RETURNS:
%     dimpleCenters = mx2 matrix holding the coordinates of the cdimle
%                     centers
%     dimpleBoudary = cell array holding mx2 matrices with coordinates of
%                     the boundary of a dimple
%
% SYNTAX: [dimpleCenter,dimpleBoundary]= FILA_getDimples(bodyWallImagem,cutoff)
%
%
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos ->
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos ->
%          FILA_imcrop2boundary->FILA_ana_getBodywallRing->FILA_getDimples
%
% Author: B. Geurten 20.07.2015
%
% see also strel, imerode, imopen,  FILA_ana_getBodywallRing

%inverting the pixture to detect the blackdimples
iPic = imcomplement(bodyWallImage);
iPic(isnan(iPic)) = 0;
iPic = iPic./max(max(iPic));

% now create a Bblack and white image
BW = im2bw(iPic,0.8);

% erode the black white picture
se = strel('disk',2);
balls = imerode(BW,se);

%and open it up
se = strel('disk',2);
balls = imopen(balls,se);

%now determine the boundaries of dimples
dimpleBoundary = bwboundaries(balls,'noholes');

%get their size and omitt everyything below 20 pixels
bsize = cellfun(@length,dimpleBoundary);
dimpleBoundary = dimpleBoundary(bsize>cutoff);

%calculate dimple centers
dimpleCenter = cell2mat(cellfun(@(x) mean(x,1),dimpleBoundary,'UniformOutput',false));