function contourLenVote = ET_eva_contourLength(objectContours,expetedLength)
% This function of the Ethotrack detection evaluation toolbox (ET_eva_)
% tries to determine if the fitted ellipses would have the correct contour
% length to be animals. It returns a vector with the number of animals the
% contour length would be equivalent of.
%
% GETS:
%  objectContours = a cell array containing the x and y coordinates for the
%                   boundaries of all found objects, carefull most likely 
%                   these are not only animals you are looking for
%  expectedLength = the length one animal should have if set to NaN the 
%                    median length of all contours is used
%
% RETURNS:
%  contourLenVote = a vector containing the number of animals this test
%                   would expect in this ellipse fit
%
% SYNTAX:contourLenVote = ET_eva_contourLength(objectContours,expetedLength)  
%
% Author: B.Geurten 11-29-2015
%
% NOTE: 
%
% see also ET_eva_ellipseSurfaceArea,ET_eva_prevPos


% The contourlength is given by the number of points in the contour
contourLen = cellfun(@(x) size(x,1),objectContours);

% check if a surface was pre defined or if we have to calculate it
if isnan(expetedLength)
    temp = contourLen(contourLen ~= 0);
    % the median surface area is used for normalisation
    medCL = median(temp);
    contourLenVote = round(contourLen./medCL);
else
    contourLenVote = round(contourLen./expetedLength);
end
    