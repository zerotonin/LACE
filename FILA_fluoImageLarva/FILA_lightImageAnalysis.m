function anaRes =  FILA_lightImageAnalysis(image,scale)
% This function from the fluorescent image larva analysis toolbox (FILA) 
% combines the whole toolbox functions and completely analysis 1 frame.
% Basically it detects the larvae arranges it horizontally takes the 
%
% GETS:
%          image = a matlab image variable
%          scale = either a scalar <=1 which is applied to all directions 
%                  or a two-element vector where each scalar as used for
%                  another dimension.%   
%
% RETURNS  
%         anaRes = a struct containing the following fields
%        longLum : 6xn matrix where n is the width of the image and the rows
%                  are as follows: 1) median 2) mean 3) variance 4)
%                  standard deviation 5) upper confidence interval 6)
%                  lower CI
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
%
% SYNTAX: anaRes =  FILA_lightImageAnalysis(image);
%
% Author: B. Geurten 22.01.2015
%
% see also FILA_getLarvaPos,  FILA_turnImage2LarvaOrient, FILA_getLarvaPos, 
%          FILA_imcrop2boundary, FILA_scaleDownBoundary, FILA_getLongLum,
%          FILA_getMouthPos

%find larva
[boundary,~] = FILA_getLarvaPos(image);
%rotate image
[imageRot,~] = FILA_turnImage2LarvaOrient(image,boundary);
%find larva again
[boundary,~] = FILA_getLarvaPos(imageRot);
%crop image
[cropImage,cropBoundary] = FILA_imcrop2boundary(imageRot,boundary);
% get inner boundary
newBoundary = FILA_scaleDownBoundary(cropBoundary,scale);
% detect head and tail
[hctPos,pixRatio,ellipse_t,~,~] = FILA_getMouthPos(cropImage,cropBoundary);
% get longitunal luminence values
longLum = FILA_getLongLum(cropImage,newBoundary);

% setup return struct
anaRes.ellipseFit = ellipse_t;
anaRes.hctPos = hctPos;
anaRes.pixRatio = pixRatio;
anaRes.longLum=longLum;
