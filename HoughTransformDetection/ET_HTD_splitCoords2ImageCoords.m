function ellipseFits = ET_HTD_splitCoords2ImageCoords(ellipseFits,splitterMin)
% This function of the Ethotrack image hough transform detection toolbox 
% (ET_HTD_) builds a minimal sized image for every found object to
% afterwards be fitted with an ellipse. 
% GETS:
%  ellipseFits =  a p cell array consisting of 10x6 matrix. Where the rows 
%                 are the fits in decreasing quality the columns hold the
%                 values: x-coordinate central point, y coordinate central
%                 point, major axis, minor axis, angle [deg] and the 
%                 fitting score. Note coordinates are in the coordiantes of
%                 the split image
%   splitterMin = the minimal coordinates for each fly candidate saved as a
%                 cell matrix. A fly candidate is  a object contour.
%
% RETURNS:
%  ellipseFits =  a p cell array consisting of 10x6 matrix. Where the rows 
%                 are the fits in decreasing quality the columns hold the
%                 values: x-coordinate central point, y coordinate central
%                 point, major axis, minor axis, angle [deg] and the 
%                 fitting score. Now the coordinates are back in image
%                 coordinates.
%
%
% SYNTAX: ellipseFits = ET_HTD_splitCoords2ImageCoords(ellipseFits,splitterMin); 
%
% Author: B.Geurten 11-29-2015
%
% NOTE: 
%
% see also ET_HTD_detectEllipses

ellipseFits =cellfun(@(x,y) [x(:,1)+y(2)-1 x(:,2)+y(1)-1 x(:,3:end)],...
                            ellipseFits,splitterMin,'UniformOutput',false);