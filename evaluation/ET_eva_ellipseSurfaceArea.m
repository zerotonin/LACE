function surfaceAreaVote = ET_eva_ellipseSurfaceArea(ellipseFits,expetedSize)
% This function of the Ethotrack detection evaluation toolbox (ET_eva_)
% tries to determine if the fitted ellipses would have the approprete size
% for the animals. It returns a vector with the number of animals the
% ellipse surface area would be equivalent of
%
% GETS:
%  ellipseFits =  a p cell array consisting of 10x6 matrix. Where the rows 
%                 are the fits in decreasing quality the columns hold the
%                 values: x-coordinate central point, y coordinate central
%                 point, major axis, minor axis, angle [deg] and the 
%                 fitting score
%  expectedSize = the size one animal should have if set to NaN the mean
%                 size of the ellipses is used
%
% RETURNS:
% surfaceAreaVote = a vector containing the number of animals this test
%                   would expect in this ellipse fit
%
% SYNTAX:  surfaceAreaVote = ET_eva_ellipseSurfaceArea(ellipseFits,expetedSize)
%
% Author: B.Geurten 11-29-2015
%
% NOTE:
%
% see also ET_eva_contourLength,ET_eva_prevPos


% The surface area of an ellipse is defined as pi * major axis * minor axis
surfaceArea = cellfun(@(x) x(1,3)*x(1,4)*pi,ellipseFits);

% check if a surface was pre defined or if we have to calculate it
if isnan(expetedSize)
    % if you have to calculate it ignore the 0 surfaces as they are definitely
    % no animals
    temp = surfaceArea(surfaceArea ~= 0);
    % the median surface area is used for normalisation
    if isempty(temp),
        surfaceAreaVote = zeros(length(ellipseFits),1);
    else
        medSA = mean(temp);
        
        surfaceAreaVote = round(surfaceArea./medSA);
    end
else
    surfaceAreaVote = round(surfaceArea./expetedSize);
end
    