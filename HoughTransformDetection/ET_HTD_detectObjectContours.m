function objectContours = ET_HTD_detectObjectContours(imageBin)
% This function of the Ethotrack image hough transform detection toolbox 
% (ET_HTD_) builds a minimal sized image for every found object to
% afterwards be fitted with an ellipse.
%
% GETS:
%      imageBin = a mxn binary matrix
%
% RETURNS:
%objectContours = a cell array containing the x and y coordinates for the
%                 boundaries of all found objects, carefull most likely 
%                 these are not only animals you are looking for
%
% SYNTAX: objectContours = ET_HTD_detectObjectContours(imageBin);
%
% Author: B.Geurten 11-27-2015
%
% NOTE: 
%
% see also bwboundaries


objectContours = bwboundaries(imageBin,'noholes');