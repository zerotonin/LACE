function anaRes = FILA_ana_postAnalysis(anaRes,pix2mm)
% This function of the FILA toolbox does a post hoc analysis of the spline
% data collected from FILA_ImageSpineAnalysis.
%
% STEP 1: 
% The spline length as well as the curveture is smoothed over time using a
% 2nd degree butterworth filter with a cut off of 0.1. The curvature values
% which are basically the integral under the spine (signed or unsigned) are
% normalised by the square of the length and saved in the structure array.
%
% STEP 2:
% The spline length as well as the pix ratio are filtered. In case of
% spline length we check first if it was allready filtered. The pix ratio
% interestingly is a good indicator of the on and offset of the perestaltic
% wave. The visibility of the mouthhooks changes the pix ratiovalue and
% thereby changes periodically in phase with the peristalsis. Hence this is
% very good measure for frequency!
%
% STEP 3:
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
% STEP4:
% The large spline values calculated by ana_postSpline often are noisy
% because of the abdominal end of the larva, and the voronoi calculation.
% Also mouthhook movements make it more noisy. We use the splineEdges to
% calculate spline length inside the innerboundary there by ignoring those
% noise sources. The result is filtered with a 2nd degree butterworth 
% filter with a cut off of 0.1. 
%
% STEP 5: The length parameters are transformed from pixels to millimeters
% via the pix2mm factor.
%
% STEP 6: The mean of the filtered versions of the ellipse long axis, the
% outter and inner spline length, as well as the eccentricity, is filtered
% with a 2nd degree Butterworth filter (cutOff = 0.05); This measure can be
% used to garther the on& off set of a perestaltic wave
%
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
% RETURNS
%         anaRes = a struct array containing the following fields
%
%     waveFinder : the combined and filtered mean of the long axis
%                  (elipsefit),eccentricity, spline length, length of the
%                  inner spline [aU]
% outterboundary : a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background, as produced by
%                  FILA_getLarvaPos  [pix]
%  innerboundary : a scaled down version of the outterboundary to ignore
%                  autofluourescence from the body wall [pix]
%       centroid : a 2 element column vetcor holding the 2D position of the
%                  centroid or center of gravity of the boundary [pix]
%                  (mean(boundary,1))
%         hctPos : a 3x2 vector where the columns contain the x and y
%                  position respectively. First row is the head position,
%                  2nd row contains the center of the ellipse and the last
%                  row contains the tail position. [pix]
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
%    splineCurvV : a 2 value vector holding the signed and unsigned
%                  integral of the spine [pix]
%    splineCurvF : the filtered and normalised version of splineCurveV
%                  after splineLength the following field was inserted
%    splineEdges : a 8x2 matrix with the coordinates of the bin edges [pix]
% splineInnerLen : the length of the spline inside the innerboundary, this
%                  gets rid of mouth and abdominal movement noise [mm]
%splineInnerLenF : the filtered version of splineInnerLen [mm]
%    splineLength: length of the shortend spline [mm]
%     splineLenF : the filtered version of splineLength [mm]
%     gutCenters : mx2 matrix holding the coordinates of the gut
%                  center [pix]
%     gutBoudary : mx2 matrix with coordinates of the gut boundary [pix]
%          image : a cropped and turned version of the orignial image
%                  optional!
%
%
% SYNTAX: anaRes = FILA_ana_postAnalysis(anaRes);
%
% Author: B. Geurten Octobre 2015
%
% see also FILA_ImageSpineAnalysis,FILA_ana_postEcc,FILA_ana_postPixRatio,
%          FILA_ana_postSpline, FILA_ana_postInnerSpline, FILA_ana_peristalsis


% do post hoc analysis


%filter spline and curveture values
anaRes = FILA_ana_postSpline(anaRes);
% calculate and filter eccentricity and long axis and ellipse fit
anaRes = FILA_ana_postEcc(anaRes);
% filter the head2mouth pixel ratio
anaRes = FILA_ana_postPixRatio(anaRes);
% filter and calculate inner spline length
anaRes = FILA_ana_postInnerSpline(anaRes);
% pixels to millimeters
anaRes = FILA_ana_postPix2mm(anaRes,pix2mm);

%check if this analysis was allready done
if isfield(anaRes,'waveFinder'),
    warning('FILA_ana_postAnalysis: has already been analysed with this routine, will close now')
else
    
    %calculate wavefinder
    data = NaN(length(anaRes),4);
    temp = reshape([anaRes.eccentricity],3,length(anaRes))';
    data(:,1) = temp(:,1);
    data(:,2) = temp(:,2);
    data(:,3) = reshape([anaRes.splineLenF],1,length(anaRes))';
    data(:,4) = reshape([anaRes.splineInnerLF],1,length(anaRes))';
    
    %normalise wavefinder
    dMin = min(data);
    data = bsxfun(@minus,data,dMin);
    dMax = max(data);
    data = bsxfun(@rdivide,data,dMax);
    
    % make median
    waveFinder = median(data,2);
    
    % create filter kernel
    [B,A] = butter(2,0.05);
    
    % convert cell to matrix and filter with kernel
    waveFinder = filtfilt(B,A,waveFinder);
    
    % write data back to struct
    
    % get cell array for calculation reason
    temp = struct2cell(anaRes);
    % get fieldnames
    fNames = fieldnames(anaRes);
    %get curvature value position
    % make one cell matrix
    temp =[num2cell(waveFinder') ; temp];
    %update fieldnames
    fNames = [{'waveFinder'}; fNames];
    % create new struct array from cell matrix
    anaRes = cell2struct(temp,fNames,1);
end

