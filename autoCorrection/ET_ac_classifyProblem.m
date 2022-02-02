function [problemCase,animalNumber] = ET_ac_classifyProblem(animalNumber,expectedAnimals,multiDetectionPossible)
% This function of the Ethotrack autocorrection toolbox (ET_ac_) is the
% key to most false detection corrections. It tries to assess the severity
% of the problem and solves it by simple reassignments.
% There are serveral cases it tries to solve:
%
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
% If there are no multiAnimals possible as for example if you only have one
% animal in the footage or if you have seperated tracks as in Benzertests
% or thermoreception setups. The cases 5 - 7 become case 4 by definition as
% we cannot split animalchains into more animals.
% 
% GETS:
%  animalNumber = a row vector with entries for every fitted ellipse. Each
%                 entry shows how many animals are inside the fitted
%                 ellipse, according to this evaluation.
%expectedAnimals= number of animals that should be visible in the footage
% multiDetectionPossible = boolean 1 if animals can be close together
%
% RETURNS:
%   problemCase = the problem case number as explained above 
%  animalNumber = a row vector with entries for every fitted ellipse. Each
%                 entry shows how many animals are inside the fitted
%                 ellipse, according to this evaluation.
%
% SYNTAX: [problemCase,animalNumber] = ET_ac_classifyProblem(animalNumber,...
%                                                  multiDetectionPossible);
%
% Author: B.Geurten 11-29-2015
% 
% see also

% how many animals were detected
detectedAnimals = sum(animalNumber);
% how many animals are too big
multiAnimals = sum(animalNumber(animalNumber>1)-1);

% determine which case is the problem
% too many animals found
if  detectedAnimals > expectedAnimals,
    %number of multiAnimals is identical to number of superfulous.
    if  detectedAnimals-expectedAnimals == multiAnimals,
        problemCase = 1;
    % there are no multiAnimals
    elseif multiAnimals == 0,
        problemCase = 2;
    % there are multiAnimals but their number is not identical to the
    % number of superfluous animals
    else
        problemCase = 3;
    end
    
%not enough animals found
elseif detectedAnimals < expectedAnimals,
    % no multi detections
    if multiAnimals == 0,
        problemCase = 4;
    % identical numbers of multi detections and missing animals
    elseif  expectedAnimals-detectedAnimals == multiAnimals,
        problemCase = 5;
    % multi detections and missing animals
    else
        problemCase = 6;
    end
    % correct number of animals with multi detections
else
    problemCase = 7;
end

% if multi detections are impossible this is just a problem 4
if multiDetectionPossible ~=1 && (problemCase == 7 || problemCase == 5 || problemCase == 6),
    animalNumber(animalNumber>1) =1;
    problemCase =4;
end

