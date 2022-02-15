function curvAmp = FILA_ana_curveAmp(anaMat,turnSeq)
% This function of the FILA toolbox calculates overall body length values
% from the original tracing data. You have to run acouple of different
% routines before see "Analysis Chain" at the end of the help text.
% Furthermore this routine usually runs as a subroutine of 
% FILA_ana_peristalsis. The routine calculates maximal median and minimal
% curveture value during turns and during straight paths.
%
% GETS:
%       turnSeq = a number of indices at which the larva is turning
%
%        anaMat = a mxn matrix where m is the number of analysed frames
%                 col 1:the combined and filtered mean of the long axis
%                 (elipsefit),eccentricity, spline length, length of the  
%                 inner spline (waveFinder)
%                 col 2:the filtered version of splineLength (splineLenF)
%                 col 3:the filtered version of splineInnerLen (splineInnerLF)
%                 col 4:filtered curveture value (absolute value)
%                 col 5:filtered curveture value (sign + left - right)
%                 col 6:eccentricity
%                 col 7:length of the long axis (pixels) 
%                 col 8:length of the short axis (pixels)
%
% RETURNS:
%     curveAmp = a 3x2 matrix where the three rows hold the maximal,
%                median and minimal value of the absolute curveture (col 4
%                of anaMat). The columns code for straight part segments 
%                (col 1) or curved path segments (col 2), as indicated by
%                turnSeq.
%
% SYNTAX:  curvAmp = FILA_ana_curveAmp(anaMat,turnSeq);
%
% Author: B. Geurten Nov 2015 
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis -> 
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD-> 
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ImageSpineAnalysis, FILA_ana_detectWave, 
%          FILA_ana_postAnalysis, FILA_ana_peristalsis,FILA_ana_bodyAmp,
%          FILA_ana_bodyLen, FILA_ana_perisFreq, FILA_ana_trigAve

% during straight path
straightIDX = ones(size(anaMat,1),1);
straightIDX(turnSeq) = 0;
straightIDX = straightIDX == 1;

% during turn
turnIDX = ~straightIDX;



% get body length values during all locomotion
temp = [ max(anaMat(straightIDX,4),[],1); median(anaMat(straightIDX,4),1) ; min(anaMat(straightIDX,4),[],1)];

% get body length values only during complete waves
if ~isempty(turnSeq),
    temp2 = [ max(anaMat(turnIDX,4),[],1); median(anaMat(turnIDX,4),1) ; min(anaMat(turnIDX,4),[],1)];
else
    temp2 = [];
end

% combine
curvAmp = [temp,temp2];