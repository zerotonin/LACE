function anaRes = FILA_new2oldStructFormat(anaRes)
% This function of the FILA toolbox does a post hoc analysis of the spline
% data collected from FILA_ImageSpineAnalysis.
% The spline length as well as the curveture is smoothed over time using a
% 2nd degree butterworth filter with a cut off of 0.1. The curvature values
% which are basically the integral under the spine (signed or unsigned) are
% normalised by the square of the length and saved in the structure array.
%
% GETS
%         anaRes = a struct array containing the following fields
%
% outterboundary : a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background, as produced by
%                  FILA_getLarvaPos 
%  innerboundary : a scaled down version of the outterboundary to ignore
%                  autofluourescence from the body wall
%       centroid : a 2 element column vetcor holding the 2D position of the
%                  centroid or center of gravity of the boundary
%                  (mean(boundary,1))
%         hctPos : a 3x2 vector where the columns contain the x and y
%                  position respectively. First row is the head position,
%                  2nd row contains the center of the ellipse and the last
%                  row contains the tail position.
%     ellipseFit : a fit struct containing all important information about
%                  the fitted ellipse as returned by fit_ellipse
%       pixRatio : a scalar 0->1 showing the difference of both pixel
%                  counts between the two search areas if it reaches more
%                  than 0.9 the detection mechanismn needs to be
%                  supervised.
%         spline : a mx2 matrix with the central line of the polygon
%    splineCurvV : a 2 value vector holding the signed and unsigned
%                  integral of the spine
%    splineEdges : a 8x2 matrix with the coordinates of the bin edges
%    splineLength: length of the shortend spline
%     gutCenters : mx2 matrix holding the coordinates of the gut
%                  center
%     gutBoudary : mx2 matrix with coordinates of the gut boundary
%          image : a cropped and turned version of the orignial image
%                  optional!
%
% RETURNS
%         anaRes = as above with the following updates:
%                  after splineCurvV the following field was inserted
%    splineCurvF : the filtered and normalised version of splineCurveV
%                  after splineLength the following field was inserted
%     splineLenF : the filtered version of splineLength
%
%
% SYNTAX: anaRes = FILA_ana_postSpline(anaRes);
%
% Author: B. Geurten Octobre 2015
%
% see also FILA_ImageSpineAnalysis,FILA_ana_postEcc,FILA_ana_postPixRatio,
%          FILA_ana_postInnerSpline,FILA_ana_postAnalysis

% get cell array for calculation reason
temp = struct2cell(anaRes');

% get fieldnames
fNames = fieldnames(anaRes);

if sum(strcmp(fNames,'outterBoundaryRot')) ~= 0,
    idx  = [2 1 4 6 11 12 8 13 14 15 10 9];
    %new struct
    fNames2 = {'outterBoundary','outterBoundaryOrig','centroid','hctPos','ellipseFit','pixRatio'...
       ,'spline','splineCurvV','splineEdges','splineLength','gutCenter','gutCentersOrig' };
   
    anaRes = cell2struct(temp(idx,:),fNames2,1);
end