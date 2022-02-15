function newBoundary = FILA_scaleDownBoundary(boundary,scale)
% This function from the fluorescent image larva analysis toolbox (FILA)
% reduces the boundary of the larva thereby it is possible to exclude
% certain parts of the animal as for example the body wall that produces a
% lot of autofluorescense.
%
% GETS:
%       boundary = a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background, as produced by
%                  FILA_getLarvaPos
%          scale = either a scalar <=1 which is applied to all directions 
%                  or a two-element vector where each scalar as used for
%                  another dimension.
%
% RETURNS
%    newBoundary = a smaller version of the orignal boundary
%
% SYNTAX: newBoundary = FILA_scaleDownBoundary(boundary,scale);
%
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos -> 
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos -> 
%          FILA_imcrop2boundary->FILA_scaleDownBoundary -> FILA_getLongLum
%
% Author: B. Geurten 22.01.2015
%
% see also imrot, FILA_getLarvaPos,bsxfun

% check if scale factor is below 1
if sum(scale >1) ~=0,
    error('FILA_scaleDownBoundary:if scale factor is grater than 1.0 boundaries will be bigger and sparse')
end

% if two scale factors are given apply them seperaty for  each dimension
if length(scale) == 2,
    %get vector from centroid to boundary and scale down
    newBoundary = bsxfun(@minus,boundary,mean(boundary));
    newBoundary = [newBoundary(:,1).*scale(1) newBoundary(:,2).*scale(2)];
    %now add centroid position to smaller vector
    newBoundary = bsxfun(@plus,newBoundary,mean(boundary));
elseif length(scale) ==1
    %get vector from centroid to boundary and scale down
    newBoundary = bsxfun(@minus,boundary,mean(boundary)).*scale;
    %now add centroid position to smaller vector
    newBoundary = bsxfun(@plus,newBoundary,mean(boundary));
else
    warning('FILA_scaleDownBoundary:more than two scale factors found, only took first!')
    %get vector from centroid to boundary and scale down
    newBoundary = bsxfun(@minus,boundary,mean(boundary)).*scale(1);
    %now add centroid position to smaller vector
    newBoundary = bsxfun(@plus,newBoundary,mean(boundary));
end
% round positions as they are pixels and cannot be floats!
newBoundary = round(newBoundary);