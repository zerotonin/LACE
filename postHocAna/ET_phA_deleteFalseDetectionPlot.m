function falseDetection = ET_phA_deleteFalseDetectionPlot(h)
% This function of the Ethotrack posthoc analysis toolbox (ET_phA_) shows
% you all animals in subplots. The algorithmn asks you to click on the wrong 
% detection.
%
% GETS:
%      nothing
%
%
% RETURNS:
%falseDetection = the ID number of the false detection
%
% SYNTAX: falseDetection = ET_phA_deleteFalseDetectionPlot(figureH,frame,frameNumber,traceResult)
%
% Author: B.Geurten 11-30-2015
% 
% Notes:
%
% see also ET_plot_animals2subplots

% wait for user input
ginput(1);
% get the active Handle
activeHandle = gca;
% find the animal ID
falseDetection = find(h == activeHandle);
%delete subplot
delete(activeHandle);