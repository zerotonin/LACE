function  resStr = FILA_ana_peristalsis(anaMat,completeWaves,turnSeq,fps,misformedC)
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
%       turnSeq = a number of indices at which the larva is turning
%           fps = frames per second of the original footage
%    misformedC = all contraction periods that are not interspersed by a
%                 relaxation phase
%
% RETURNS:
%       resStr = structure holding the following fields
%      bodyLen : a 3x2x2 matrix where the three rows hold the maximal,
%                median and minimal value of the bodylangth, the columns
%                code for the complete body length (col 1) and the inner
%                bodylength (col 2). In the third dimension we show during
%                all locomotion (layer 1) and only during complete waves 
%                (layer 2).
%      bodyAmp : a mx2 matrix where ma is the number of complete waves and
%                the columns code for the complete body length (col 1) 
%                and the inner bodylength (col 2). 
% bodyAmpValue : a 3x2 matrix where the three rows hold the maximal,
%                median and minimal value of the body length amplitude, 
%                the columns code for the complete body length (col 1) 
%                and the inner bodylength (col 2). 
%     curveAmp : a 3x2 matrix where the three rows hold the maximal,
%                median and minimal value of the absolute curveture (col 4
%                of anaMat). The columns code for straight part segments 
%                (col 1) or curved path segments (col 2), as indicated by
%                turnSeq.
%      waveDur : the median duration of a peristalsis wave
%     waveFreq : the median freuqency of a peristalsis wave
%    misWavNum : the number of misformed peristalsis waves per secondthe number of
%      turnNum : the number of turns per second
%      trigAve : 2 x fps*1.5 x 2 matrix containing the averaged data. Note 
%                that now the orientation of the data is transponded. First
%                The first row is the outter body length the second row
%                contains the inner body length.
%                The order in the third dimension is mean and ste!
%     trigAveN : 2 x fps*1.5 x 3 matrix containing the averaged data. Note 
%                that now the orientation of the data is transponded. First
%                The first row is the outter body length the second row
%                contains the inner body length.
%                The order in the third dimension is median, higher CI, lower
%                CI. Note that the values here are allready CI + median!
%completeWaves : a mx3 matrix with all complete peristatlsis movements,
%                meaning that there was a direct change from stretch to 
%                contraction to stretch again. Also the wave did not
%                touch a truning sequence. The three clomuns hold the
%                indices of the 1st stretch peak the contraction peak and
%                the 2ns stretch peak.
%   misformedC : all contraction periods that are not interspersed by a
%                relaxation phase
%      turnSeq : a number of indices at which the larva is turning
%          fps : frames per second of the original footage
%
% SYNTAX: resMat=FILA_ana_peristalsis(anaMat,completeWaves,turnSeq,fps,misformedC);
%
% Author: B. Geurten Nov 2015 
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis -> 
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD-> 
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ImageSpineAnalysis, FILA_ana_detectWave, 
%          FILA_ana_postAnalysis, FILA_ana_peristalsis,FILA_ana_bodyAmp,
%          FILA_ana_bodyLen, FILA_ana_curveAmp, FILA_ana_perisFreq, 
%          FILA_ana_trigAve



if isempty(completeWaves),
    bodyAmps = NaN(1,2);
    bodyLen = NaN(3,2,2);
    bodyAmpValue = NaN(3,2);
    curvAmp = bodyAmpValue;
    perisFreq = NaN(1,2,3);
    trigAve = NaN(10,2,3);
    trigAveN = trigAve;
else
    % get body amplitudes
    [bodyAmps, bodyAmpValue] = FILA_ana_bodyAmp(anaMat,completeWaves);
    % get body lengths
    bodyLen = FILA_ana_bodyLen(anaMat,turnSeq,completeWaves);
    % get curveture data
    curvAmp = FILA_ana_curveAmp(anaMat,turnSeq);
    % get peristalsis frequency
    perisFreq = FILA_ana_perisFreq(turnSeq,completeWaves,misformedC,anaMat,fps);
    % get triggered averages
    [trigAve,trigAveN] = FILA_ana_trigAve(completeWaves,anaMat,fps);
end
% save to resulting structure
resStr.bodyLen = bodyLen;
resStr.bodyAmps = bodyAmps ;
resStr.bodyAmpValue = bodyAmpValue;
resStr.curvAmp = curvAmp;
resStr.waveDur = perisFreq(1);
resStr.waveFreq = perisFreq(2);
resStr.misWavNum = perisFreq(3);
resStr.turnNum = perisFreq(4);
resStr.trigAve = trigAve;
resStr.trigAveN = trigAveN;
resStr.completeWaves = completeWaves;
resStr.misformedC = misformedC;
resStr.turnSeq = turnSeq;
resStr.fps = fps;