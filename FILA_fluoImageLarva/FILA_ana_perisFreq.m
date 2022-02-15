function perisFreq = FILA_ana_perisFreq(turnSeq,completeWaves,misformedC,anaMat,fps)
% This function of the FILA toolbox calculates overall body length values
% from the original tracing data. You have to run acouple of different
% routines before see "Analysis Chain" at the end of the help text.
% Furthermore this routine usually runs as a subroutine of 
% FILA_ana_peristalsis. The routine calculates serveral different things
% ,see return variable. Note that the peristalsis ave frequency is just the
% duration⁻¹. 
%
% GETS:
%       turnSeq = a number of indices at which the larva is turning%
% completeWaves = a mx3 matrix with all complete peristatlsis movements,
%                 meaning that there was a direct change from stretch to 
%                 contraction to stretch again. Also the wave did not
%                 touch a truning sequence. The three clomuns hold the
%                 indices of the 1st stretch peak the contraction peak and
%                 the 2ns stretch peak.
%    misformedC = all contraction periods that are not interspersed by a
%                 relaxation phase
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
%           fps = frames per second of the original footage
%
% RETURNS:
%     perisFreq = 1) the median duration of a peristalsis wave 2) the
%                 median freuqency of a peristalsis wave 4) the number of
%                 misformed peristalsis waves per second 5) the number of
%                 turns per second
%
% SYNTAX: perisFreq = ...
%          FILA_ana_perisFreq(turnSeq,completeWaves,misformedC,anaMat,fps);
%
% Author: B. Geurten Nov 2015 
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis -> 
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD-> 
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ImageSpineAnalysis, FILA_ana_detectWave, 
%          FILA_ana_postAnalysis, FILA_ana_peristalsis,FILA_ana_bodyAmp,
%          FILA_ana_bodyLen, FILA_ana_curveAmp, FILA_ana_trigAve


% get complete duration of the movie in seconds
durationInS = size(anaMat,1)/fps;

%wave duration
waveDur = median(bsxfun(@minus,completeWaves(:,3),completeWaves(:,1))./fps);
wavePeriode = waveDur^-1;

% turnSequence
numberOfTurns = length(getSeqStartsEnds(turnSeq,1));

% collect all data
perisFreq = [waveDur wavePeriode length(misformedC)/durationInS numberOfTurns/durationInS];