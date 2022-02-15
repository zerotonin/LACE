function [boundary,centroid,thresh] = FILA_getLarvaPos(image,thresh)
% This function from the fluorescent image larva analysis toolbox (FILA) detects
% the bright larva in front of the black background of a given image. It
% returns the boundary of the found regions and its centroid.
%
% GETS:
%          image = a matlab image variable
%         thresh = gray value detection threshold 0->1
%
% RETURNS
%       boundary = a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background.
%       centroid = a 2 element column vetcor holding the 2D position of the
%                  centroid or center of gravity of the boundary
%                  (mean(boundary,1))
%
% SYNTAX: [boundary,centroid] = FILA_getLarvaPos(image,thresh)
%
%
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos -> 
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos -> 
%          FILA_imcrop2boundary->FILA_scaleDownBoundary -> FILA_getLongLum
%
% Author: B. Geurten 22.01.2015
%
% see also graythresh, im2bw, bwtraceboundary

%check gray level
if ~exist('thresh','var'),
    thresh = -1;
end
if thresh < 0, 
[thresh,~] = graythresh(image);
end

%transform to black white image
BW = im2bw(image,thresh);
% get boundary
% now delete outter larval cutticula
seD = strel('diamond',2);
BW = imdilate(BW,seD);
BW = imfill(BW,'holes');
BW = imerode(BW,seD);
BW = imerode(BW,seD);
%BW =imclearborder(BW);
% objet detection
boundary = bwboundaries(BW,'noholes');

bsize = cellfun(@length,boundary);
boundary = boundary{bsize==max(bsize)};
% calculate centroid
centroid = mean(boundary,1);