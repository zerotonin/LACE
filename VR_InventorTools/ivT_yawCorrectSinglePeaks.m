function yaw = ivT_yawCorrectSinglePeaks(yaw)
% Sometimes when the User incorrectly uses AutoCorrectDirs in ivTools. The 
% yaw then flips by pi. If your data is prone to such mistakes this 
% function can correct. By employing the find peaks function this function 
% is able to find single value peaks that are at least pi/2 away from their
% directly adjacent values and has a minimal peak height of pi/3.
% Those values are corrected by the value before the peak.
%
% GETS:
%        yaw = a vector containing yaw values.
% 
% RETURNS:
%    new_yaw = a vector containing yaw values without exact zeros.
%
% SYNTAX: new_yaw = ivT_yawCorrectSinglePeaks(yaw);
%
% Author: B. Geurten
%
% see also ivT_analyse3DwalkingTraces, ivT_unwrapAtan2

% find positive single peaks
[~,locsR] = findpeaks(yaw,'Threshold',pi/2,'MinPeakHeight',pi/3);
%find negative single peaks
[~,locsL] = findpeaks(yaw.*-1,'Threshold',pi/2,'MinPeakHeight',pi/3);


%get all peaks in one matrix and sort it so the peaks can be corrected
loc = [locsL;locsR];
loc = sort(loc);

% This function can not go to loc =1 or loc=length(yaw) because such peaks
% would not be complete. Such peaks would only have one flank and are
% ignored by findpeaks
for i =1:length(loc),
    yaw(loc(i))=  yaw(loc(i)-1);
end
