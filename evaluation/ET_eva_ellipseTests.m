function [evaluation,animalNumber] = ET_eva_ellipseTests(ellipseFits,objectContours,prevDetection,expetedLength,expetedSize,voteWeights)
% This function of the Ethotrack detection evaluation toolbox (ET_eva_)
% evaluates the fitting done by ET_HTD_detectEllipses. Therefore it
% controls the surface area, contour length the position in relation
% previous detections of each fitted ellipse. This is combined in a
% weighted mean to be used to asess how many animals are in a detected
% ellipse. Furthermore this is further combined with a weighted ellipse
% fittig quality to produce an overall detection quality. This value can be
% later used to help the user find frames with wrong detections.
%
% GETS:
%   ellipseFits = a p cell array consisting of 10x6 matrix. Where the rows 
%                 are the fits in decreasing quality the columns hold the
%                 values: x-coordinate central point, y coordinate central
%                 point, major axis, minor axis, angle [deg] and the 
%                 fitting score.
%objectContours = a cell array containing the x and y coordinates for the
%                 boundaries of all found objects, carefull most likely 
%                 these are not only animals you are looking for
% prevDetection = a mx2 matrix with the previous detected fly positions in
%                 pixels for the whole imageound an animal at a
%                 similar position in the last frame. If left empty the
%                 result of this evaluation is set to 1.
%expectedLength = the length one animal should have if set to NaN the 
%                 median length of all contours is used
%  expectedSize = the size one animal should have if set to NaN the mean
%                 size of the ellipses is used
%   voteWeights = a four element vector holding the relative weights for
%                 the different test. (1) surface area test (2) contour 
%                 length test (3) previous position test (4) fit quality of
%                 the ellipse
%
% RETURNS:
%    evaluation = mx6 matrix where m is the number of fitted ellipses,
%                 col(1) represents how many animals hould be detected due
%                 to their surfaceArea. col (2) shows how many it would be
%                 due to their contour length. col(3) is one if this area
%                 was found in the last detection as well or an area close
%                 to it. col(4) is the weighted mean (weights are found in 
%                 voteWeights(1:3)) of columns 1:3. col(5) is the weighted
%                 fit quality as found in the 6th column of the ellipse
%                 fit. col(6) is the detection quality a product of col(5)
%                 and col(4).
%  animalNumber = a row vector with entries for every fitted ellipse. Each
%                 entry shows how many animals are inside the fitted
%                 ellipse, according to this evaluation.
%   
%
% SYNTAX: [evaluation,animalNumber] = ET_eva_ellipseTests(ellipseFits,...
%      objectContours,prevDetection,expetedLength,expetedSize,voteWeights);
%
% Author: B.Geurten 11-29-2015
%
% NOTE: The linear matching alghorithmn was coded by by Yi Cao at Cranfield 
% University on 10th April 2013. used in ET_eva_prevPos
% Reference:
% R. Jonker and A. Volgenant, "A shortest augmenting path algorithm for
% dense and spare linear assignment problems", Computing, Vol. 38, pp.
% 325-340, 1987.
%
% see also ET_eva_contourLength, ET_eva_ellipseSurfaceArea, ET_eva_prevPos, 
%          ET_HTD_detectEllipses

% get them via circumferance
contourLenVote = ET_eva_contourLength(objectContours,expetedLength);

% get them via surface size Votes
surfaceAreaVote = ET_eva_ellipseSurfaceArea(ellipseFits,expetedSize);

% get them via the last position
if isempty(prevDetection)
    prevPosVote = NaN(length(ellipseFits),1);
else
    prevPosVote= ET_eva_prevPos(ellipseFits,prevDetection); 
end

% combine vote results

voteMat = [contourLenVote surfaceAreaVote prevPosVote];


% weighted mean of the tests
if isempty(prevDetection) % if there is no previous detection ignore weights
    evaQuality = mean(voteMat(:,1:2),2);
else% otherwise go
    evaQuality = wmean(voteMat,repmat(voteWeights(1:3),length(ellipseFits),1),2);
end
% adjusted ellipse quality
fitQuality = bsxfun(@times,cellfun(@(x) x(1,6),ellipseFits),voteWeights(4));
% calculate the detection quality as aproduct of fitQuality and evaQuality
detectionQuality = bsxfun(@times,fitQuality,evaQuality);
% make return variable
evaluation = [voteMat evaQuality fitQuality detectionQuality];
animalNumber = round(evaQuality);