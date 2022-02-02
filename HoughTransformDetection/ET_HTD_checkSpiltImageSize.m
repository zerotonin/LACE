function objectContours = ET_HTD_checkSpiltImageSize(objectContours)
% This function of the Ethotrack image hough transform detection toolbox 
% (ET_HTD_) checks if the objects found by ET_HTD_detectObjectContours span
% only pixel in any dimension, such areas cannot be traced via Hough
% Transforms as ellipse fitting is impossible and are thusly removed.
% GETS:
%objectContours = a cell array containing the x and y coordinates for the
%                 detected objects,
%
% RETURNS:
%objectContours = a cell array containing the x and y coordinates for the
%                 detected objects, without objects that only span one
%                 pixel in any dimension
%
% SYNTAX: objectContours = ET_HTD_checkSpiltImageSize(objectContours);
%
% Author: 12-2-15 B. Geurten
%
% see also ET_HTD_detectObjectContours

% minimal contour coordinates
minContour = cell2mat(cellfun(@(x) min(x,[],1),objectContours,'UniformOutput',false));
% maximum contour coordinates
maxContour = cell2mat(cellfun(@(x) max(x,[],1),objectContours,'UniformOutput',false));
% calculate maximum distance between coordinates
contourDimension = bsxfun(@minus,maxContour,minContour);
% take the smallest distance of all dimensions
contourDimension = min(contourDimension,[],2);
% discard lines
objectContours(contourDimension < 1) = [];