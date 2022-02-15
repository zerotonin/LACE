function anaRes = FILA_ana_postEcc(anaRes)
% This function of the FILA toolbox does a post hoc analysis of the spline
% data collected from FILA_ImageSpineAnalysis.
% The ellipseFit derives the long and short axis of the ellipse fitted to
% te animals circumfence. From these two values one can calculate the
% eccentricity of an ellipse, via:
%
%           sqrt(a²-b²)
%       E = ------------
%                a
% The long and short axis are filtered with a 2nd degree butterworth filter
% using a cutoff of 0.1,m before eccentricity calculations take place.
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
%                  after ellipseFit the following field was inserted
%   eccentricity : 3 value vector, with the entries: eccentricity,length of
%                  the long axis (pixels) and length of the short axis
%                  (pixels)
%
%
% SYNTAX: anaRes = FILA_ana_postEcc(anaRes);
%
% Author: B. Geurten Octobre 2015
%
% see also FILA_ImageSpineAnalysis, FILA_ana_postPixRatio,
%          FILA_ana_postSpline, FILA_ana_postInnerSpline,
%          FILA_ana_postAnalysis

%check if this analysis was allready done
if isfield(anaRes,'eccentricity'),
    warning('FILA_ana_postECC: has already been analysed with this routine, will close now')
else
    % get cell array for calculation reason
    temp = struct2cell(anaRes');
    
    % create filter kernel
    [B,A] = butter(2,0.1);
    
    % calculate eccentricity
    ellipseFit = [anaRes.ellipseFit];
    longA  = filtfilt(B,A,[ellipseFit.long_axis]);
    shortA = filtfilt(B,A,[ellipseFit.short_axis]);
    ecc = bsxfun(@rdivide,sqrt(bsxfun(@minus,longA.^2,shortA.^2)),longA);
    
    
    
    % convert matrixs to cell again
    eccentricity = mat2cell([ecc' longA' shortA'],ones(length(anaRes),1),3);
    % get fieldnames
    fNames = fieldnames(anaRes);
    
    %get curvature value position
    elpPos = strfind(fNames,'ellipseFit');
    elpPos = find(~cellfun(@isempty,elpPos));
    % make one cell matrix
    temp =[temp(1:elpPos,:); eccentricity'; temp(elpPos+1:end,:)];
    %update fieldnames
    fNames = [fNames(1:elpPos); {'eccentricity'}; fNames(elpPos+1:end)];
    
    
    % create new struct array from cell matrix
    anaRes = cell2struct(temp,fNames,1);
    
end