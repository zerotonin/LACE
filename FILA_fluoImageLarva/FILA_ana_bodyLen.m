function bodyLen = FILA_ana_bodyLen(anaMat,turnSeq,completeWaves)
% This function of the FILA toolbox calculates overall body length values
% from the original tracing data. You have to run acouple of different
% routines before see "Analysis Chain" at the end of the help text.
% Furthermore this routine usually runs as a subroutine of 
% FILA_ana_peristalsis. The routine calculates maximal median and minimal
% bodylength values of the inner and outter body length, during all
% locomotion and only during complete peristalsis waves.
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
% completeWaves = a mx3 matrix with all complete peristatlsis movements,
%                 meaning that there was a direct change from stretch to 
%                 contraction to stretch again. Also the wave did not
%                 touch a truning sequence. The three clomuns hold the
%                 indices of the 1st stretch peak the contraction peak and
%                 the 2ns stretch peak.
% RETURNS:
%      bodyLen = a 3x2x2 matrix where the three rows hold the maximal,
%                median and minimal value of the bodylangth, the columns
%                code for the complete body length (col 1) and the inner
%                bodylength (col 2). In the third dimension we show during
%                all locomotion (layer 1) and only during complete waves 
%                (layer 2).
%
% SYNTAX: bodyLen = FILA_ana_bodyLen(anaMat,turnSeq,completeWaves);
%
% Author: B. Geurten Nov 2015 
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis -> 
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD-> 
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ImageSpineAnalysis, FILA_ana_detectWave, 
%          FILA_ana_postAnalysis, FILA_ana_peristalsis,FILA_ana_bodyAmp,
%          FILA_ana_curveAmp, FILA_ana_perisFreq,FILA_ana_trigAve

% make logical indexing for during locomotion
duringLocIDX = ones(size(anaMat,1),1);
duringLocIDX(turnSeq) = 0;
duringLocIDX = duringLocIDX == 1;

% make logical indexing for during complete waves
duringWavIDX =indice2signal(completeWaves(:,1),completeWaves(:,2),ones(size(completeWaves,1),1),size(anaMat,1))' == 1;

% get body length values during all locomotion
temp = [ max(anaMat(duringLocIDX,2:3),[],1); median(anaMat(duringLocIDX,2:3),1) ; min(anaMat(duringLocIDX,2:3),[],1)];
% get body length values only during complete waves
temp2 = [ max(anaMat(duringWavIDX,2:3),[],1); median(anaMat(duringWavIDX,2:3),1) ; min(anaMat(duringWavIDX,2:3),[],1)];
% combine
bodyLen = cat(3,temp,temp2);