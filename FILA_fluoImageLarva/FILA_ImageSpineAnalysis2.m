function anaRes =  FILA_ImageSpineAnalysis2(image,saveImage,thresh)
% This function from the fluorescent image larva analysis toolbox (FILA) 
% combines the whole oolbox functions and completely analysis 1 frame.
% Basically it detects the larvae arranges it horizontally takes the 
%
% GETS:
%          image = a matlab image variable
%      saveImage = boolean if one the cropped image will be saved in the
%                  returning struct
%         thresh = gray value detection threshold 0->1
%
% RETURNS  
%         anaRes = a struct containing the following fields
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
%          image : a cropped and turned version of the orignial image, if
%                  saveImage was set to 1
%
% SYNTAX: anaRes =  FILA_fullImageAnalysis(image);
%
% Author: B. Geurten 22.01.2015
%
% see also FILA_getLarvaPos,  FILA_turnImage2LarvaOrient, FILA_getMouthPos
%          FILA_imcrop2boundary, FILA_scaleDownBoundary, FILA_getLongLum,
%          FILA_ana_getSpine, FILA_binSpline,FILA_ana_getGutPosition, 
%          FILA_SR_normImage, FILA_ana_curvIntegral

%normalise image
image = ET_im_normImage(image);

%find larva
[outterBoundary,~,thresh] = FILA_getLarvaPos(image,thresh);

%crop image
[cropImage,outterBoundary] = FILA_imcrop2boundary(image,outterBoundary,thresh);

% detect head and tail
[hctPos,pixRatio,ellipse_t] = FILA_getMouthPos(cropImage,outterBoundary);

% get spline
spline = FILA_ana_getSpine2(outterBoundary,hctPos);


%get gut position
gutCenter = FILA_ana_getGutPosition(cropImage,outterBoundary,hctPos,spline);
%get gut position


%rotate coordinates
angle = ellipse_t.phi; % shorthand
% get rotation matrix
rotMat = getFickmatrix(angle*-1,0,0,'a');
% rotate boundary and spline
splineRot = FILA_SR_rotCoords(spline,rotMat);

%test if rotate to vertical axis
testVal = abs(sum(diff(splineRot)));
if testVal(2) > testVal(1),
    if sign(angle) == -1
        rotMat = getFickmatrix(angle*-1-pi/2,0,0,'a');
    else
        rotMat = getFickmatrix(angle*-1+pi/2,0,0,'a');
    end
    splineRot = FILA_SR_rotCoords(spline,rotMat);
end

    

outterBoundaryRot = FILA_SR_rotCoords(outterBoundary,rotMat);

% bin spline
binEdges = FILA_binSpline(splineRot,outterBoundaryRot);


% get curvuture
curvetureV = FILA_ana_curvIntegral(splineRot);

% setup return struct
anaRes.outterBoundary = outterBoundary;
anaRes.outterBoundaryRot = outterBoundaryRot;
anaRes.centroid = mean(outterBoundary,1);
anaRes.centroidRot = mean(anaRes.outterBoundaryRot,1);
anaRes.hctPos = hctPos;
anaRes.hctPosRot = FILA_SR_rotCoords(hctPos,rotMat);
anaRes.spline = spline;
anaRes.splineRot = splineRot;
if ~isempty(gutCenter)
    anaRes.gutCenter = gutCenter;
    anaRes.gutCenterRot = FILA_SR_rotCoords(gutCenter,rotMat);
else
    anaRes.gutCenter = NaN(1,2);
    anaRes.gutCenterRot = NaN(1,2);
end
    
% anaRes.gutBoundary = gutBoundary;
% anaRes.gutBoundaryRot = FILA_SR_rotCoords(gutBoundary,rotMat);

anaRes.ellipseFit = ellipse_t;
anaRes.pixRatio = pixRatio;
anaRes.splineCurvV = curvetureV;
anaRes.splineEdges = binEdges;
anaRes.splineLength = norm(diff(binEdges));

if saveImage,
    anaRes.image= cropImage;
end