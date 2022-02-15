function [trigAve,peris] = ivT_analysePersistalticMovement(traces,threshold,winSize,set2zero,modus)
% This function analysis the excentricity of the traced animal. This is
% usually used to examione the peristaltic movemnt of larvae. We employ the
% get_saccades function to find the peaks of excentricity in the trace
%
% GETS:
%         traces =  as returned by ivT_ananalyseMulti2DTraces 
%                   traces is a cell array in which every cell holds a 
%                   mx8 matrix holding fly trajectories  m is the number 
%                   of frames; all original columns are filtered
%                   individually as described by the filterChoice variable
%                   col(1) x-position pixels center of mass 
%                   col(2) y-position pixels center of mass
%                   col(3) yaw in radians center of mass
%                   col(4) space in pixels occupied by the larvae
%                   col(5) ratio between long and short axis of the
%                          ellipsoid 0.5 = circle 1 = line
%                   col(6) thrust in mm/s 
%                   col(7) slip in mm/s 
%                   col(8) yaw in deg/s 
%         winSize = half window size for averageing. If e.g. the winSize is 
%                   set to 50 then a 101 window will be used. This window is 50 
%                   is 50 samples long in each direction
%        set2zero = this flag variable is used to determine wether the first
%                   value of every trigger occurence should be set to zero and
%                   the following values will be treated relative to zero.
%                   Meaning that you substract the first value of each occurence
%                   occurence from the whole occurence.
%           modus = this flag can be either 'median' or 'mean'. The triggered
%                   averages are calculatead correspondingly as median + CI
%                   or mean + STE
% 
% RETURNS
%           peris = A cell array of the length of traces. Every cell holds
%                   a mxn matrix where m is the number of found peristaltic
%                   movements and n are the following rows: start, peak
%                   ,end,direction duration and amplitude of the saccade.
%                   After this the start and end of the intersaccdic
%                   intervals are given.
%         trigAve = a nxwin*2+1x3 matrix containing (if modus = 'median')
%                   or a nxwin*2+1x2 (modus = 'mean')the averaged data. Note 
%                   that now the orientation of the data is transponded. The
%                   order in the third dimension is median, higher CI, lower
%                   CI. Note that the values here are allready CI + median!: 
%
% SYNTAX: [trigAve,peris] = ivT_analysePersistalticMovement...
%                               (traces,threshold,winSize,set2zero,modus) ;
%
% Author: B.Geurten 10.6.13
%
% see also cellfun, ivT_IO_loadmultFullTra, ivT_ananalyseMulti2DTraces,
%          get_saccades, triggeredAverageND, triggeredAverage


% get peristaltic peaks
peris = cellfun(@(x) get_saccades(x(:,5),threshold),traces,'UniformOutput',false);
% make triggered averages
switch modus
    case 'median'
    trigAve =cellfun(@(x,y) triggeredAverageND(x(:,5),y(:,2),winSize,1:size(x,1),set2zero),traces,peris,'UniformOutput',false);
    case 'mean'
    trigAve =cellfun(@(x,y) triggeredAverage(x(:,5),y(:,2),winSize,1:size(x,1),set2zero),traces,peris,'UniformOutput',false);
    otherwise
        error(['ivT_analysePersistalticMovement: modus variable was wrongly defined as "' modus '" use "median" or "mean" instead.'])
end
 % get mean of triggered averages 
trigAve = mean(cell2mat(trigAve),1);



