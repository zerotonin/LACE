function [imageRot,ellipse_t] = FILA_turnImage2LarvaOrient(image,boundary)
% This function from the fluorescent image larva analysis toolbox
% (FILA) turns the image so that the larva's body long axis is orientated 
% horizontaly. This is done by fitting an ellipse to the larva boundary at
% rotating about the fits phi angle (which is the angle between major axis 
% of the ellipse and the x axis).
%
% GETS:
%          image = a matlab image variable
%      ellipse_t = a fit struct containing all important information about
%                  the fitted ellipse as returned by fit_ellipse
% RETURNS
%       imageRot = a rotated version of the original image, keep in mind
%                  that through the image rotation it's sizes may change
%      varargout = if set the ellipsefit cen be returned as well.
%
% SYNTAX:[imageRot,ellipse_t] = FILA_turnImage2LarvaOrient(image,boundary);
%
% 
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos -> 
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos -> 
%          FILA_imcrop2boundary->FILA_scaleDownBoundary -> FILA_getLongLum
%
% Author: B. Geurten 22.01.2015
%
% see also imrot, FILA_getLarvaPos,fit_ellipse

%fit ellipse to boundary
ellipse_t = fit_ellipse(boundary(:,1),boundary(:,2));

if ~isstruct(ellipse_t),
    disp('things going down');
end
% rotate image
[imageRot] =imrotate(image,rad2deg(ellipse_t.phi));