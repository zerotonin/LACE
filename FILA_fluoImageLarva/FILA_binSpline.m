function binEdges=FILA_binSpline(spline,innerBoundary)
% This function from the fluorescent image larva analysis toolbox (FILA)
% bins the spline into 7abdominal bins. This is done by taking only the
% spline from the innerBoundatry as retured by FILA_ana_getBodywallRing.
%
% GETS:
%         spline = a mx2 matrix with the central line of the polygon
%  innerboundary = a mx2 matrix with the m 2D positions of the boundary,
%                  between the body wall ring and the central part of the
%                  larva, cropped to the new cropImage
%
% RETURNS:
%       binEdges = a 8x2 matrix with the coordinates of the bin edges
%
% SYNTAX: binEdges=FILA_binSpline(spline,innerBoundary)
%
%
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos ->
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos ->
%          FILA_imcrop2boundary->FILA_ana_getBodywallRing->FILA_ana_getSpine
%          ->FILA_binSpline
%
% Author: B. Geurten 20.07.2015
%
% see also  FILA_ana_getSpine, FILA_ana_getBodywallRing, interp1

cropSpline = spline(spline(:,2)<max(innerBoundary(:,2)) & spline(:,2)>min(innerBoundary(:,2)),:);

if all(diff(cropSpline(:,1))>0) || all(diff(cropSpline(:,1))<0)
    % this is a bad hack but the larval is now horizontally turned so the y
    % axis is the monoton one while x is differing
    xi = linspace(min(cropSpline(:,1)),max(cropSpline(:,1)),8);
    yi = interp1(cropSpline(:,1), cropSpline(:,2),xi,'pchip');
    
    binEdges = [xi',yi'];
elseif all(diff(cropSpline(:,2))>0) || all(diff(cropSpline(:,2))<0)
    
    % this is a bad hack but the larval is now horizontally turned so the y
    % axis is the monoton one while x is differing
    xi = linspace(min(cropSpline(:,2)),max(cropSpline(:,2)),8);
    yi = interp1(cropSpline(:,2), cropSpline(:,1),xi,'pchip');
    
    binEdges = [yi',xi'];
else
    warning('binEdges cannot find monotic vector, used cropSpline')
    binEdges = cropSpline;
end
