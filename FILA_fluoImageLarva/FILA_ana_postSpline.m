function anaRes = FILA_ana_postSpline(anaRes)
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

%check if this analysis was allready done
if isfield(anaRes,'splineCurvF'),
    warning('FILA_ana_postSpline: has already been analysed with this routine, will close now')
else
    
    
    anaRes = FILA_new2oldStructFormat(anaRes);
    % get cell array for calculation reason
    temp = struct2cell(anaRes);
    % create filter kernel
    [B,A] = butter(2,0.1);
    %better spline length
    splineLen = cellfun(@(x) norm(diff(x)),temp(7,:));
    % convert cell to matrix and filter with kernel
    curvF = filtfilt(B,A,cell2mat(temp(8,:)'));
    % if body length was allready filtered just use the values otherwise filter
    splineLenF = filtfilt(B,A,splineLen');
  
    % normalise the curvature value
    curvF = bsxfun(@rdivide,curvF,splineLenF.^2);
    
    % convert matrixs to cell again
    curvF = mat2cell(curvF,ones(size(temp,2),1),2);
    splineLenF = num2cell(splineLenF);
    splineLen = num2cell(splineLen);
    
    % get fieldnames
    fNames = fieldnames(anaRes);
    
    % check if body length must be updated as well!
    if  isfield(anaRes,'splineLenF'),
        %get curvature value position
        curvPos = strfind(fNames,'splineCurvV');
        curvPos = find(~cellfun(@isempty,curvPos));
        % make one cell matrix
        temp =[temp(1:curvPos,:); curvF'; temp(curvPos+1:end,:)];
        %update fieldnames
        fNames = [fNames(1:curvPos); {'splineCurvF'}; fNames(curvPos+1:end)];
    else
        %get curvature value position        
        curvPos = strfind(fNames,'splineCurvV');
        curvPos = find(~cellfun(@isempty,curvPos));
        %get spline length position            
        lenPos = strfind(fNames,'splineLength');
        lenPos = find(~cellfun(@isempty,lenPos));
        % make one cell matrix
        temp =[temp(1:curvPos,:); curvF'; temp(curvPos+1:lenPos-1,:);splineLen; splineLenF'; temp(lenPos+1:end,:)];
        %update fieldnames
        fNames = [fNames(1:8); {'splineCurvF'}; fNames(9:10); {'splineLenF'}; fNames(11:end)];
    end
    % create new struct array from cell matrix
    anaRes = cell2struct(temp,fNames,1);
    
end

