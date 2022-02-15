function anaRes = FILA_ana_postInnerSpline(anaRes)
% This function of the FILA toolbox does a post hoc analysis of the spline
% data collected from FILA_ImageSpineAnalysis.
% The large spline values calculated by ana_postSpline often are noisy
% because of the abdominal end of the larva, and the voronoi calculation.
% Also mouthhook movements make it more noisy. We use the splineEdges to
% calculate spline length inside the innerboundary there by ignoring those
% noise sources. The result is filtered with a 2nd degree butterworth 
%filter with a cut off of 0.1. 
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
%                  after splineEdges the following field was inserted
% splineInnerLen : the length of the spline inside the innerboundary, this
%                  gets rid of mouth and abdominal movement noise
%splineInnerLenF : the filtered version of splineInnerLen
%
%
% SYNTAX: anaRes = FILA_ana_postInnerSpline(anaRes);
%
% Author: B. Geurten Octobre 2015
%
% see also FILA_ImageSpineAnalysis,FILA_ana_postEcc,FILA_ana_postPixRatio,
%          FILA_ana_postSpline, FILA_ana_postAnalysis

if isfield(anaRes,'splineInnerL'),
    warning('FILA_ana_postInnerSpline: has already been analysed with this routine, will close now')
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculating inner length %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    innerLen = [anaRes(:).splineEdges]';
    innerLen = innerLen(1:2:end,[1 end]);
    innerLen = bsxfun(@minus,innerLen(:,2),innerLen(:,1));
    
    %%%%%%%%%%%%%%%%%
    % filter length %
    %%%%%%%%%%%%%%%%%
    
    % create filter kernel
    [B,A] = butter(2,0.1);
    % convert cell to matrix and filter with kernel
    innerLenF = filtfilt(B,A,innerLen');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % saving back to the struct %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get cell array for calculation reason
    temp = struct2cell(anaRes);
    % get fieldnames
    fNames = fieldnames(anaRes);
    %get curvature value position
    edgePos = strfind(fNames,'splineEdges');
    edgePos = find(~cellfun(@isempty,edgePos));
    % make one cell matrix
    temp =[temp(1:edgePos,:);num2cell(innerLen') ; num2cell(innerLenF); temp(edgePos+1:end,:)];
    %update fieldnames
    fNames = [fNames(1:edgePos); {'splineInnerL'; 'splineInnerLF'}; fNames(edgePos+1:end)];
    % create new struct array from cell matrix
    anaRes = cell2struct(temp,fNames,1);
end