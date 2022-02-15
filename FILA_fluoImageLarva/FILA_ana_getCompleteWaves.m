function [completeWaves,incompleteC,misformedC,insideROD] =FILA_ana_getCompleteWaves(cLocs,sLocs,turnSeq)
% This function of the FILA toolbox searches for complete peristalsis
% movements. Peristalsis movements can be 'misformed', by two contraction
% phases that are not properly interspersed by a relaxtion phase or a
% recorded during turning or at the end/beginning of the data.
%
% GETS:
%          cLocs = indices of compression peaks
%          sLocs = indices of stretch peaks
%        turnSeq = a number of indices at which the larva is turning as
%                  returned by FILA_ana_getROD
%
% RETURNS:
%  completeWaves = a mx3 matrix with all complete peristatlsis movements,
%                  meaning that there was a direct change from stretch to 
%                  contraction to stretch again. Also the wave did not
%                  touch a truning sequence. The three clomuns hold the
%                  indices of the 1st stretch peak the contraction peak and
%                  the 2ns stretch peak.
%    incompleteC = all contractions that were incomplete due to the
%                  beginnig or end of the data
%     misformedC = all contraction periods that are not interspersed by a
%                  relaxation phase
%      insideROD = all contraction periods that are during a turnin
%                  movement
%
% SYNTAX: [completeWaves,incompleteC,misformedC,insideROD] = ...
%                           FILA_ana_getCompleteWaves(cLocs,sLocs,turnSeq);
%
% Author: B. Geurten Nov 2015 
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis -> 
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD-> 
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ImageSpineAnalysis, FILA_ana_detectWave, 
%          FILA_ana_postAnalysis

% 'preAllocation' of result variables
incompleteC = [];
misformedC = [];
insideROD = [];
completeWaves = [];

for i =1:length(cLocs),
    
    % check if there is a relaxation peak before the contraction
    smallerSLoc = find(sLocs < cLocs(i),1,'last');
    if ~isempty(smallerSLoc),
        %check if there is another contraction peak before there is a
        %relaxtion peak
        candidateC = find(cLocs > sLocs(smallerSLoc),1,'first');
        if  cLocs(candidateC) == cLocs(i),
            %check if there is a relaxation peak after the contraction
            largerSLoc = find(sLocs > cLocs(i),1,'first');
            if ~isempty(largerSLoc),
                %check if there is another contraction peak before there is a
                %relaxtion peak
                candidateC = find(cLocs <  sLocs(largerSLoc),1,'last');
                if cLocs(candidateC) == cLocs(i),
                    %if we are here we estblished that we have found a wave
                    
                    %Now we need to check if this wave falls into a region
                    %of disinterest (ROD)
                    if sum(ismember(sLocs(smallerSLoc:largerSLoc),turnSeq)) == 0,
                        %passed all tests, this is a complete wave
                        completeWaves = [completeWaves; sLocs(smallerSLoc) cLocs(i) sLocs(largerSLoc)];
                    else
                        %broken because it is inside a ROD
                        insideROD = [insideROD; cLocs(i)];
                    end
                else
                    %brocken because another contraction comes after the contraction
                    misformedC = [incompleteC;cLocs(i)];
                end
            else
                % broken because there was no relaxtion after contraction
                incompleteC = [incompleteC;cLocs(i)];
            end
        else
            %brocken because another contraction comes before the contraction
            misformedC = [incompleteC;cLocs(i)];
        end
    else
        % broken because there was no relaxtion before contraction
        incompleteC = [incompleteC;cLocs(i)];
    end
end
