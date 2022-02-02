function [animalNumber,corrIDX,evaluation] = ET_ac_reduceMultiAnimalEllipses(animalNumber,evaluation,problemCase)
% This function of the Ethotrack autocorrection toolbox (ET_ac_) corrects
% standard Problem 1 (see below). By reducing multianimal areas to 1 per
% area.
% Problem  1:Too many animals found and the amount of superflous animals is
%            identical to the number of multianimal ellipses (ellipses with
%            more than one animal assigned to it). In this case the number
%            of assigned animals in multi animal ellipses is reduced to 1
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
%
% RETURNS:
%  animalNumber = as above but now corrected
%       corrIDX = a vector of length of the animals found the corrected
%                 animals are assigned the problem case number the others
%                 are zero
%    evaluation = as above only the detection value for corrected animals
%                 is halfed
%
% SYNTAX: 
%
% Author: B.Geurten 11-30-2015
% 
% Notes:
%
% see also ET_ac_updateMetaData4Corrected, ET_ac_solveStandardProblems

% logical index of the animals to correct
a2corrIDX = animalNumber >1;
% reduce all multianimal areas to 1
animalNumber(a2corrIDX)=1;
% update meta data
[corrIDX,evaluation] =  ET_ac_updateMetaData4Corrected(evaluation,a2corrIDX,problemCase);