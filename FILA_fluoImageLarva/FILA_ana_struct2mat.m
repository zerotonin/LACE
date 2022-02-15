function anaMat = FILA_ana_struct2mat(anaRes)
% This function of the FILA toolbox does a post hoc analysis of the spline
% data collected from FILA_ImageSpineAnalysis. This function 
%
%
% GETS
%anaRes = a struct array containing the following fields
%
%     waveFinder : the combined and filtered mean of the long axis
%                  (elipsefit),eccentricity, spline length, length of the
%                  inner spline
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
%   eccentricity : 3 value vector, with the entries: eccentricity,length of
%                  the long axis (pixels) and length of the short axis
%                  (pixels)
%       pixRatio : a scalar 0->1 showing the difference of both pixel
%                  counts between the two search areas if it reaches more
%                  than 0.9 the detection mechanismn needs to be
%                  supervised.
%      pixRatioF : the filtered version of pixRatio
%         spline : a mx2 matrix with the central line of the polygon
%     splineLenF : the filtered version of splineLength
%    splineCurvV : a 2 value vector holding the signed and unsigned
%                  integral of the spine
%    splineCurvF : the filtered and normalised version of splineCurveV
%                  after splineLength the following field was inserted
%    splineEdges : a 8x2 matrix with the coordinates of the bin edges
% splineInnerLen : the length of the spline inside the innerboundary, this
%                  gets rid of mouth and abdominal movement noise
%splineInnerLenF : the filtered version of splineInnerLen
%    splineLength: length of the shortend spline
%     gutCenters : mx2 matrix holding the coordinates of the gut
%                  center
%     gutBoudary : mx2 matrix with coordinates of the gut boundary
%          image : a cropped and turned version of the orignial image
%                  optional!
%
%
% RETURNS
%
%   anaMat = a mxn matrix where m is the number of analysed frames
%            col 1:the combined and filtered mean of the long axis
%            (elipsefit),eccentricity, spline length, length of the inner 
%            spline (waveFinder)
%            col 2:the filtered version of splineLength (splineLenF)
%            col 3:the filtered version of splineInnerLen (splineInnerLF)
%            col 4:filtered curveture value (absolute value)
%            col 5:filtered curveture value (sign + left - right)
%            col 6:eccentricity
%            col 7:length of the long axis (pixels) 
%            col 8:length of the short axis (pixels)
%
%
% SYNTAX: data = FILA_ana_struct2mat(anaRes);
%
% Author: B. Geurten Octobre 2015
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis -> 
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD-> 
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ana_postAnalysis


if isfield(anaRes,'pixRatioF') && isfield(anaRes,'eccentricity')...
        && isfield(anaRes,'splineCurvF') && isfield(anaRes,'splineInnerLF'),
    
    anaMat = [[anaRes.waveFinder]' [anaRes.splineLenF]' [anaRes.splineInnerLF]'...
        reshape([anaRes.splineCurvF],2,length(anaRes))'...
        reshape([anaRes.eccentricity],3,length(anaRes))'];
else
    anaMat = [];
end
