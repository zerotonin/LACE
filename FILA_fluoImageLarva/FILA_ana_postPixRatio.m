function anaRes = FILA_ana_postPixRatio(anaRes)
% This function of the FILA toolbox does a post hoc analysis of the spline
% data collected from FILA_ImageSpineAnalysis.
% The spline length as well as the pix ratio are filtered. In case of
% spline length we check first if it was allready filtered. The pix ratio
% interestingly is a good indicator of the on and offset of the perestaltic
% wave. The visibility of the mouthhooks changes the pix ratiovalue and
% thereby changes periodically in phase with the peristalsis. Hence this is
% very good measure for frequency!
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
%                  after pixRatio the following field was inserted
%      pixRatioF : the filtered version of pixRatio
%
%
% SYNTAX: anaRes = FILA_ana_postPixRatio(anaRes);
%
% Author: B. Geurten Octobre 2015
%
% see also FILA_ImageSpineAnalysis,FILA_ana_postEcc,
%          FILA_ana_postSpline, FILA_ana_postInnerSpline,
%          FILA_ana_postAnalysis


%check if this analysis was allready done
if isfield(anaRes,'pixRatioF'),
    warning('FILA_ana_postPixRatio: has already been analysed with this routine, will close now')
else
    % get cell array for calculation reason
    temp = struct2cell(anaRes');
    
    % create filter kernel
    [B,A] = butter(2,0.1);
    
    % convert cell to matrix and filter with kernel
    pixRF = filtfilt(B,A,[anaRes.pixRatio]');
    
    
    % convert matrixs to cell again
    pixRF = num2cell(pixRF);
    % get fieldnames
    fNames = fieldnames(anaRes);
    
    %get curvature value position
    pixPos = strfind(fNames,'pixRatio');
    pixPos = find(~cellfun(@isempty,pixPos));
    % make one cell matrix
    temp =[temp(1:pixPos,:); pixRF'; temp(pixPos+1:end,:)];
    %update fieldnames
    fNames = [fNames(1:pixPos); {'pixRatioF'}; fNames(pixPos+1:end)];
    
    
    % create new struct array from cell matrix
    anaRes = cell2struct(temp,fNames,1);
    
end

