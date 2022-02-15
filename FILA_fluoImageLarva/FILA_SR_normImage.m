function imageN = FILA_SR_normImage(image)
% This function of the BFT (BackLightFlyTracer) toolbox normalises images
% so that they go from a minimum value to their maximum value 0->1
%
% GETS
%       image = any matlab matrix
%
% RETURNS
%      imageN = matrix of the same dimension bu spread so that the minimum 
%               value of image is now zero and the maximum value is one 
%
% SYNTAX: imageN = FILA_SR_normImage(image);
%
% Author: B. Geurten August 2015
%
% see also BFT_SR_normImage

imageN = double(image);
imageMin = min(min(min(imageN)));
imageMax = max(max(max(imageN)));
imageN =(imageN-imageMin)./(imageMax-imageMin);