function  prevPosVote= ET_eva_prevPos(ellipseFits,prevDetection)
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
% prevDetection = a mx2 matrix with the previous detected fly positions in
%                 pixels for the whole image
%
% RETURNS:
%   prevPosVote = a vector containing if the algorithm found an animal at a
%                 similar position in the last frame              
%
% SYNTAX: prevPosVote= ET_eva_prevPos(ellipseFits,prevDetection); 
%
% Author: B.Geurten 11-29-2015
%
% NOTE: The linear matching alghorithmn was coded by by Yi Cao at Cranfield 
% University on 10th April 2013
% Reference:
% R. Jonker and A. Volgenant, "A shortest augmenting path algorithm for
% dense and spare linear assignment problems", Computing, Vol. 38, pp.
% 325-340, 1987.
%
% see also ET_eva_contourLength,ET_eva_ellipseSurfaceArea

%create current ellipse positions
currentDetection = cell2mat(cellfun(@(x) x(1,1:2),ellipseFits,'UniformOutput',false));
% make distance matrix with euclidean distances
distMat = Hungarian_getDistMat(prevDetection,currentDetection,'euclidean');
% now make a linear matching using the faster 
assingment = lapjv(distMat);
if length(prevDetection) < length(currentDetection),
    prevPosVote = zeros(length(ellipseFits),1); 
    prevPosVote(assingment) =1;
else
    prevPosVote = zeros(length(ellipseFits),1);
    prevPosVote(assingment) = 1;
end