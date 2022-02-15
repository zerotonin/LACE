function anaRes =  FILA_ImageSpineAnalysis(image,saveImage,thresh)
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

%figure(1),clf;imagesc(image);colormap(gray);hold on ; plot(outterBoundary(:,2),outterBoundary(:,1),'g--')
%rotate image
[imageRot,~] = FILA_turnImage2LarvaOrient(image,outterBoundary);

%find larva again
[outterBoundary,~,~] = FILA_getLarvaPos(imageRot,thresh);
%figure(2),clf;imagesc(imageRot);colormap(gray);hold on ; plot(outterBoundary(:,2),outterBoundary(:,1),'g--')

%crop image
[cropImage,outterBoundary] = FILA_imcrop2boundary(imageRot,outterBoundary,thresh/2);
outterBoundary =filter2DTrace(outterBoundary,4);
%figure(2),clf;imagesc(cropImage);colormap(gray);hold on ; plot(outterBoundary(:,2),outterBoundary(:,1),'g--')


% detect head and tail
[hctPos,pixRatio,ellipse_t,~,~] = FILA_getMouthPos(cropImage,outterBoundary);
% get spline
spline = FILA_ana_getSpine(outterBoundary);
figure(2),clf;imagesc(cropImage);colormap(gray);hold on ; plot(outterBoundary(:,2),outterBoundary(:,1),'g--');plot(spline(:,2),spline(:,1),'b--');
axis equal
axis tight
drawnow
curvetureV = FILA_ana_curvIntegral(spline);
% get inner boundary
innerBoundary = FILA_scaleDownBoundary(outterBoundary,[0.5 0.85]);
% bin spline
binEdges = FILA_binSpline(spline,innerBoundary);
%get gut position
[gutCenter,gutBoundary] = FILA_ana_getGutPosition(cropImage,innerBoundary);

% setup return struct
anaRes.outterBoundary = outterBoundary;
anaRes.innerBoundary = innerBoundary;
anaRes.centroid = mean(outterBoundary,1);
anaRes.hctPos = hctPos;
anaRes.ellipseFit = ellipse_t;
anaRes.pixRatio = pixRatio;
anaRes.spline = spline;
anaRes.splineCurvV = curvetureV;
anaRes.splineEdges = binEdges;
anaRes.splineLength = norm(diff(binEdges));
anaRes.gutCenter = gutCenter;
anaRes.gutBoundary = gutBoundary;

if saveImage,
    anaRes.image= cropImage;
end