function [trigAve,trigAveN] = FILA_ana_trigAve(completeWaves,anaMat,fps)
% This function of the FILA toolbox calculates overall body length values
% from the original tracing data. You have to run acouple of different
% routines before see "Analysis Chain" at the end of the help text.
% Furthermore this routine usually runs as a subroutine of 
% FILA_ana_peristalsis. The routine calculates serveral different things
% ,see return variable. Note that the peristalsis ave frequency is just the
% duration⁻¹. 
%
% GETS:
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
% completeWaves = a mx3 matrix with all complete peristatlsis movements,
%                 meaning that there was a direct change from stretch to 
%                 contraction to stretch again. Also the wave did not
%                 touch a truning sequence. The three clomuns hold the
%                 indices of the 1st stretch peak the contraction peak and
%                 the 2ns stretch peak.
%           fps = frames per second of the original footage
%
% RETURNS:
%    trigAve = 2 x fps*1.5 x 2 matrix containing the averaged data. Note 
%              that now the orientation of the data is transponded. First
%              The first row is the outter body length the second row
%              contains the inner body length.
%              The order in the third dimension is mean and ste!
%   trigAveN = 2 x fps*1.5 x 3 matrix containing the averaged data. Note 
%              that now the orientation of the data is transponded. First
%              The first row is the outter body length the second row
%              contains the inner body length.
%              The order in the third dimension is median, higher CI, lower
%              CI. Note that the values here are allready CI + median!
%
% SYNTAX:  [trigAve,trigAveN] = FILA_ana_trigAve(completeWaves,anaMat,fps);
%
% Author: B. Geurten Nov 2015 
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis -> 
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD-> 
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ImageSpineAnalysis, FILA_ana_detectWave, 
%          FILA_ana_postAnalysis, FILA_ana_peristalsis,FILA_ana_bodyAmp,
%          FILA_ana_bodyLen, FILA_ana_curveAmp, FILA_ana_perisFreq


% normal distribution triggered average with mean and ste
trigAve = triggeredAverage(anaMat(:,2:3),completeWaves(:,2),round(fps.*.75),1:size(anaMat,1),0);
% not normal distribution triggered average with median and CI
trigAveN = triggeredAverageND(anaMat(:,2:3),completeWaves(:,2),round(fps.*.75),1:size(anaMat,1),0);
