function [bodyAmps, bodyAmpValue] = FILA_ana_bodyAmp(anaMat,completeWaves)
% This function of the FILA toolbox calculates overall body length values
% from the original tracing data. You have to run acouple of different
% routines before see "Analysis Chain" at the end of the help text.
% Furthermore this routine usually runs as a subroutine of
% FILA_ana_peristalsis. The routine calculates maximal median and minimal
% bodylength values of the inner and outter body length, during all
% locomotion and only during complete peristalsis waves.
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
%
% completeWaves = a mx3 matrix with all complete peristatlsis movements,
%                 meaning that there was a direct change from stretch to
%                 contraction to stretch again. Also the wave did not
%                 touch a truning sequence. The three clomuns hold the
%                 indices of the 1st stretch peak the contraction peak and
%                 the 2ns stretch peak.
% RETURNS:
%      bodyAmp = a mx2 matrix where ma is the number of complete waves and
%                the columns code for the complete body length (col 1) 
%                and the inner bodylength (col 2). 
% bodyAmpValue = a 3x2 matrix where the three rows hold the maximal,
%                median and minimal value of the body length amplitude, 
%                the columns code for the complete body length (col 1) 
%                and the inner bodylength (col 2). 
%
% SYNTAX: [bodyAmps, bodyAmpValue] = FILA_ana_bodyAmp(anaMat,completeWaves)
%
% Author: B. Geurten Nov 2015
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis ->
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD->
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ImageSpineAnalysis, FILA_ana_detectWave,
%          FILA_ana_postAnalysis, FILA_ana_peristalsis,FILA_ana_bodyLen,
%          FILA_ana_curveAmp, FILA_ana_perisFreq, FILA_ana_trigAve

% get all compression states
compresLen = cat(3,anaMat(completeWaves(:,2),2),anaMat(completeWaves(:,2),3));

% get all compression states
stretchLen = cat(3,mean([anaMat(completeWaves(:,1),2) anaMat(completeWaves(:,3),2)],2),...
    mean([anaMat(completeWaves(:,1),3) anaMat(completeWaves(:,3),3)],2));

%calculate amplitudess
bodyAmps = bsxfun(@minus,stretchLen,compresLen);
bodyAmps=  reshape(bodyAmps,size(bodyAmps,1),size(bodyAmps,3));

% calculate meadian min and max amplitude
bodyAmpValue = [ max(bodyAmps,[],1); median(bodyAmps,1); min(bodyAmps,[],1)];