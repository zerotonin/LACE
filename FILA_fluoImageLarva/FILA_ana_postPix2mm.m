function anaRes = FILA_ana_postPix2mm(anaRes,pix2mm)
% This function of the FILA toolbox does a post hoc analysis of the spline
% data collected from FILA_ImageSpineAnalysis.The length parameters are 
%transformed from pixels to millimeters via the pix2mm factor.
%
% GETS
%         pix2mm = a factor to calculate milimeter values from pixels.
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
% including the fields, as returned by FILA_ana_postEcc,
% FILA_ana_postPixRatio:
% splineInnerLen : the length of the spline inside the innerboundary, this
%                  gets rid of mouth and abdominal movement noise [pix]
%splineInnerLenF : the filtered version of splineInnerLen [pix]
%    splineLength: length of the shortend spline [pix]
%     splineLenF : the filtered version of splineLength [pix]
%
% RETURNS
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
% the following fields are updated:
% splineInnerLen : the length of the spline inside the innerboundary, this
%                  gets rid of mouth and abdominal movement noise [mm]
%splineInnerLenF : the filtered version of splineInnerLen [mm]
%    splineLength: length of the shortend spline [mm]
%     splineLenF : the filtered version of splineLength [mm]
%
% SYNTAX: anaRes = FILA_ana_postPix2mm(anaRes,pix2mm);
%
% Author: B. Geurten Octobre 2015
%
% see also FILA_ImageSpineAnalysis, FILA_ana_postSpline, FILA_ana_postInnerSpline
if ~isfield(anaRes,'splineCurvF') ||  ~isfield(anaRes,'splineInnerL'),
    warning('FILA_ana_postpix2mm: not all spline analysis have been done')
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculating inner length %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    lengths = [ [anaRes(:).splineLength]' [anaRes(:).splineLenF]' [anaRes(:).splineInnerL]' [anaRes(:).splineInnerLF]' ];
    lengths = lengths.*pix2mm;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % saving back to the struct %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get cell array for calculation reason
    temp = struct2cell(anaRes);
    % get fieldnames
    fNames = fieldnames(anaRes);
    %get curvature value position
    splinePos = strfind(fNames,'splineInnerL');
    splinePos = find(~cellfun(@isempty,splinePos));
    % make one cell matrix
    temp =[temp(1:splinePos(1)-1,:); num2cell(lengths') ; temp(splinePos(1)+4:end,:)];
    % create new struct array from cell matrix
    anaRes = cell2struct(temp,fNames,1);
end