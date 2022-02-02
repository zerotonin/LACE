function [animalNumber,corrIDX,evaluation] = ET_ac_deleteLowQdetections(animalNumber,evaluation,problemCase,expectedAnimals)
% This function of the Ethotrack autocorrection toolbox (ET_ac_) corrects
% standard Problem 2 (see below). By deleting the animals with the lowest
% quality value.
% Problem  2:Too many animals found in too many ellipses. The ellipses with
%            the worst detection value are deleted
%
% GETS:
%  animalNumber = a row vector with entries for every fitted ellipse. Each
%                 entry shows how many animals are inside the fitted
%                 ellipse, according to this evaluation.
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
%   problemCase = the problem case number as explained above 
%expectedAnimals= number of animals that should be visible in the footage
%
% RETURNS:
%  animalNumber = as above but now corrected
%       corrIDX = a vector of length of the animals found the corrected
%                 animals are assigned the problem case number the others
%                 are zero. If corrIDX == -1 the correction did not work.
%    evaluation = as above only the detection value for corrected animals
%                 is halfed
%
% SYNTAX: [animalNumber,corrIDX,evaluation] = ET_ac_deleteLowQdetections(animalNumber,...
%                                                  evaluation,problemCase);
%
% Author: B.Geurten 11-30-2015
% 
% Notes:
%
% see also ET_ac_updateMetaData4Corrected, ET_ac_solveStandardProblems


% logical index of the animals to correct
detectionQuality = evaluation(:,6);
detectionQuality(animalNumber == 0) = Inf;%set the detection quality for those areas which are without an animal to the infinity
dQSorted = sort(detectionQuality); % sort it
number2del = sum(animalNumber)-expectedAnimals; % calculate how many animals need to be deleted
a2corrIDX= detectionQuality <= dQSorted(number2del); % get the indices of all animals with an equal or smaller quality
% check if you found enough
if sum(a2corrIDX) ~= number2del
    corrIDX = -1;
else
    % reduce the lowest quality areas to zero
    animalNumber(a2corrIDX)=0;
    % update meta data
    [corrIDX,evaluation] =  ET_ac_updateMetaData4Corrected(evaluation,a2corrIDX,problemCase);
end
