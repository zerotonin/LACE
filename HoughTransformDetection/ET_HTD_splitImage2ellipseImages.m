function [splitterMax,splitterMin,splitterImagesC] = ET_HTD_splitImage2ellipseImages(imageBin,objectC)
% This function of the Ethotrack image hough transform detection toolbox 
% (ET_HTD_) builds a minimal sized image for every found object to
% afterwards be fitted with an ellipse. 
% GETS:
%      imageBin = a mxn binary matrix
%       objectC = the contour values as retruned by
%                 ET_HTD_detectObjectContours
%
% RETURNS:
%   splitterMax = the maximal coordinates for each fly candidate saved as a
%                 cell matrix. A fly candidate is  a object contour.
%   splitterMin = the minimal coordinates for each fly candidate saved as a
%                 cell matrix. A fly candidate is  a object contour.
%splitterImageC = a n cell matrix where n is the number of fly candidates
%                 containing a binary matrix with the fly candidate contour
%                 inside for further HTD analysis
%
%
% SYNTAX: [splitterMax,splitterMin,splitterImagesC] = ...
%                           ET_HTD_splitImage2ellipseImages(imageBin,flyC);
%
% Author: B.Geurten 11-27-2015
%
% NOTE: 
%
% see also ET_HTD_splitCoords2ImageCoords


% make empty picture of the footage size
splitterImage = zeros(size(imageBin));
% take candidate fly object circumfences and  make them into a 2 column
% coordinate matrix
splitterMat = cell2mat(objectC);
% now convert row col indices into a single number indice
indSplitters = sub2ind(size(imageBin),splitterMat(:,1),splitterMat(:,2));
% you end up with a picture that only includes the boundries of the
% original fly candidate objects
splitterImage(indSplitters) =1;

% Than we split said image into smaller images only as large as the size of
% each fly candidate onbject

% get the maximal coordinates of the fly candidate object
splitterMax = cellfun(@(x) max(x),objectC,'UniformOutput',false);
% get the minimal coordinates of the fly candidate object
splitterMin = cellfun(@(x) min(x),objectC,'UniformOutput',false);
% make smaller image and save it in a cell array
splitterImagesC=cellfun(@(x,y) splitterImage(x(1):y(1),x(2):y(2)),splitterMin,splitterMax,'UniformOutput',false);
