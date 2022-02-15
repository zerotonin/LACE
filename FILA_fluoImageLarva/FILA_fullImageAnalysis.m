function anaRes =  FILA_fullImageAnalysis(image,scale,thresh)
% This function from the fluorescent image larva analysis toolbox (FILA) 
% combines the whole oolbox functions and completely analysis 1 frame.
% Basically it detects the larvae arranges it horizontally takes the 
%
% GETS:
%          image = a matlab image variable
%          scale = either a scalar <=1 which is applied to all directions 
%                  or a two-element vector where each scalar as used for
%                  another dimension.%   
%          thresh = gray value detection threshold 0->1
%
% RETURNS  
%         anaRes = a struct containing the following fields
%          image : a cropped and turned version of the orignial image
%        longLum : 6xn matrix where n is the width of the image and the rows
%                  are as follows: 1) median 2) mean 3) variance 4)
%                  standard deviation 5) upper confidence interval 6)
%                  lower CI
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
%    searchAreas : image snippet on the caudal  and rostral extremes of the
%                  animal, which was used to find the mouth and abdomen of
%                  the animal.
%
% SYNTAX: anaRes =  FILA_fullImageAnalysis(image);
%
% Author: B. Geurten 22.01.2015
%
% see also FILA_getLarvaPos,  FILA_turnImage2LarvaOrient, FILA_getLarvaPos, 
%          FILA_imcrop2boundary, FILA_scaleDownBoundary, FILA_getLongLum,
%          FILA_getMouthPos

% normalise image
image = ET_im_normImage(image);
%find larva
[boundary,~] = FILA_getLarvaPos(image, thresh);
%rotate image
[imageRot,~] = FILA_turnImage2LarvaOrient(image,boundary);
%find larva again
[boundary,~] = FILA_getLarvaPos(imageRot);
%crop image
[cropImage,cropBoundary] = FILA_imcrop2boundary(imageRot,boundary);
% get inner boundary
newBoundary = FILA_scaleDownBoundary(cropBoundary,scale);
% detect head and tail
[hctPos,pixRatio,ellipse_t,lSA,rSA] = FILA_getMouthPos(cropImage,cropBoundary);
% get longitunal luminence values
longLum = FILA_getLongLum(cropImage,newBoundary);

% setup return struct
anaRes.image= cropImage;
anaRes.outterBoundary = cropBoundary;
anaRes.centroid = mean(cropBoundary,1);
anaRes.innerBoundary = newBoundary;
anaRes.ellipseFit = ellipse_t;
anaRes.hctPos = hctPos;
anaRes.pixRatio = pixRatio;
anaRes.searchAreas =[lSA,rSA];
anaRes.longLum=longLum;
