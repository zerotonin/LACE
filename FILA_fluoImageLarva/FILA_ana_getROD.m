function turnSeq = FILA_ana_getROD(anaMat,turnThresh)
% This function of the FILA toolbox does a post hoc analysis of the spline
% data collected from FILA_ImageSpineAnalysis. This function calculates the
% frame indices in which the animal is turning. This is devidnd as
% curveture values that are above mean + standard deviation of the
% curveture.
%
%
% GETS%
%   anaMat = a mxn matrix where m is the number of analysed frames, as
%            returned by FILA_ana_struct2mat
%            col 1:the combined and filtered mean of the long axis
%            (elipsefit),eccentricity, spline length, length of the inner 
%            spline (waveFinder)
%            col 2:the filtered version of splineLength (splineLenF)
%            col 3:the filtered version of splineInnerLen (splineInnerLF)
%            col 4:filtered curveture value (absolute value)
%            col 5:filtered curveture value (sign + left - right)
%            col 6:eccentricity
%            col 7:length of the long axis (pixels) 
%            col 8:length of the short axis (pixels)
%
% RETURNS
%
%  turnSeq = a number of indices at which the larva is turning
%
% SYNTAX: turnSeq = FILA_ana_getROD(anaMat);
%
% Author: B. Geurten November 2015
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis -> 
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD-> 
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ana_postAnalysis,FILA_ana_struct2mat

if exist('turnThresh','var'),
    if ~isempty(turnThresh),
        turnSeq =find(anaMat(:,4)>= turnThresh);
    else
        turnThresh = mean(anaMat(:,4)) +std(anaMat(:,4));
        turnSeq =find(anaMat(:,4)>= turnThresh);
    end
else
    turnThresh = mean(anaMat(:,4)) +std(anaMat(:,4));
    turnSeq =find(anaMat(:,4)>= turnThresh);
end