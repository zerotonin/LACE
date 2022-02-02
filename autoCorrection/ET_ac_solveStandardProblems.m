function [corrIDX,evaluation,animalNumber,problemSolved] =...
ET_ac_solveStandardProblems(evaluation,problemCase,animalNumber,...
expectedAnimals,multiDetectionPossible)
% This function of the Ethotrack autocorrection toolbox (ET_ac_) solves the
% standard problems as described in depth in the Notes section. This is
% done through various subroutines which are listed in the see all action.
% There overall solution stratgey is also listed in the Notes section.
%
% GETS:
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
%expectedAnimals= number of animals that should be visible in the footage
% multiDetectionPossible = boolean 1 if animals can be close together
%   problemCase = the problem case number as explained above 
%
% RETURNS:
%       corrIDX = a vector of length of the animals found the corrected
%                 animals are assigned the problem case number the others
%                 are zero
%    evaluation = as above only the detection value for corrected animals
%                 is halfed
%  animalNumber = updated version of above
% problemSolved = boolean 1 if there was a solution for the problem
%
% SYNTAX: [corrIDX,evaluation,animalNumber,problemSolved] =...
%         ET_ac_solveStandardProblems(evaluation,problemCase,animalNumber,...
%         expectedAnimals,multiDetectionPossible);
%
% Author: B.Geurten 11-29-2015
% 
% Notes:
% Problem  1:Too many animals found and the amount of superflous animals is
%            identical to the number of multianimal ellipses (ellipses with
%            more than one animal assigned to it). In this case the number
%            of assigned animals in multi animal ellipses is reduced to 1
% Problem  2:Too many animals found in too many ellipses. The ellipses with
%            the worst detection value are deleted
% Problem  3:Too many animals found in too many ellipses and multi animal 
%            ellipses are found. First multi ellipses are reduced than
%            ellipses with lowest detection value are deleted
% Problem  4:Too few ellipses are found and no multi animal ellipses. The
%            discared animals (0 animals assinged) with the highest
%            detection quality are assigned one animal
% Problem  5:Too few ellipses are found and multi animal ellipses are found.
%            This is also called the chaining problem and is solved by
%            splitting the chain via refitting of multiple ellipses
% Problem  6:Situation as in Problem 5 but the chains can not be split into
%            enough animals to solve the problem. Than the discarded aimal
%            with the highest quality value is assigned an animal.
% Problem  7:The correct number of animals was found but there were multi
%            animal ellipses. This is again chaining and will be solved by
%            splitting chains. If after splitting there are too many or not
%            enough animals, again the detection quality decides who is
%            added or removed.
%
% see also ET_ac_classifyProblem, ET_ac_reduceMultiAnimalEllipses,
%          ET_ac_deleteLowQdetections, ET_ac_addDetections


% find out which standard problem needs to be adressed
switch problemCase
    case 1,
        [animalNumber,corrIDX,evaluation] = ET_ac_reduceMultiAnimalEllipses(animalNumber,evaluation,problemCase);
        problemSolved =1;
    case 2,
        [animalNumber,corrIDX,evaluation] = ET_ac_deleteLowQdetections(animalNumber,evaluation,problemCase,expectedAnimals);
        % if there were not enough candidates tell the system to find
        % another solution
        if corrIDX == -1,
            problemSolved = 0;
        else
            problemSolved =1;
        end
    case 3
        [animalNumber,corrIDX1,evaluation] = ET_ac_reduceMultiAnimalEllipses(animalNumber,evaluation,problemCase);
        [animalNumber,corrIDX2,evaluation] = ET_ac_deleteLowQdetections(animalNumber,evaluation,problemCase,expectedAnimals);
        % if there were not enough candidates tell the system to find
        % another solution
        if corrIDX1 == -1,
            problemSolved = 0;
        else
            corrIDX = bsxfun(@plus,corrIDX1,corrIDX2);
            problemSolved =1;
        end
    case 4
        [animalNumber,corrIDX,evaluation] = ET_ac_addDetections(animalNumber,evaluation,problemCase,expectedAnimals);
        % if there were not enough candidates tell the system to find
        % another solution
        if corrIDX == -1,
            problemSolved = 0;
        else
            problemSolved =1;
        end
    case 5
        error('ET_ac_solveStandardProblems: not implemented yet','This correction needs BFT split chains which is not updated')
    case 6
        error('ET_ac_solveStandardProblems: not implemented yet','This correction needs BFT split chains which is not updated')
    case 7
        error('ET_ac_solveStandardProblems: not implemented yet','This correction needs BFT split chains which is not updated')
        if expectedAnimals ~= sum(animalNumber),
            [problemCase,animalNumber] = ET_ac_classifyProblem(animalNumber,multiDetectionPossible);
            [corrIDX,evaluation,animalNumber,problemSolved] =...
                ET_ac_solveStandardProblems(evaluation,problemCase,animalNumber,...
                expectedAnimals,multiDetectionPossible);
        end
      
    otherwise
        problemSolved = 0;
        warning('This is an unkwon case')
end