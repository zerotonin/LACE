function [cropImage,cropBoundary] = FILA_imcrop2boundary(image,boundary,thresh)
% This function from the fluorescent image larva analysis toolbox (FILA)
% crops the image to the extremes of a given boundary set.
%
% GETS:
%          image = a matlab image variable
%       boundary = a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background, as produced by
%                  FILA_getLarvaPos
%         thresh = gray value detection threshold 0->1
%
% RETURNS
%     cropImage = image cropped
%  cropBoundary = boundary fitted to the cropped image
%
% SYNTAX: [cropImage,cropBoundary] = FILA_imcrop2boundary(image,boundary):
% Author: B. Geurten 22.01.2015
%
% see also imcrop

% get min x, min y position, width and height of the cropped square
cropBox = round([min(boundary(:,2)),min(boundary(:,1)),...
    max(boundary(:,2))-min(boundary(:,2)),...
    max(boundary(:,1))-min(boundary(:,1))]);
% crop image
cropImage = imcrop(image,cropBox);
cropImage = ET_im_normImage(cropImage);
[cropBoundary,~] = FILA_getLarvaPos(cropImage,thresh);

% [r,c] = size(cropImage);
% % if in the rotation step before see FILA_turnImage2LarvaOrient was turned
% % verticaly than we now have to turn it again about 90degrees
% if r>c
%     cropImage =imrotate(cropImage,90);
%     [cropBoundary,~] = FILA_getLarvaPos(cropImage,thresh);
%     
% else
%     cropBoundary = bsxfun(@minus,boundary,min(boundary))+1;
% end
