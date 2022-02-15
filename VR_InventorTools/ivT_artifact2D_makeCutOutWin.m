function [startNstop,winIDX] = ivT_artifact2D_makeCutOutWin(thrustE,slipE,yawE,traLen,halfWin)
% This function checks for artifaxcts in the analysed 2D traces of insects.
% The routine expects speeds to be in the dimensions of mm*s-1 and deg*s-1.
% Then it looks for frames in which the animal exceeds this velocity. It
% returns the indices and values.
%
% GETS:
%         thrustE = a mx2 matrix, where m is the number of detected thrust
%                   artifacts, col(1) holds the frame number col(2) the
%                   speed value
%           slipE = a mx2 matrix, where m is the number of detected slip
%                   artifacts, col(1) holds the frame number col(2) the
%                   speed value
%            yawE = a mx2 matrix, where m is the number of detected yaw
%                   artifacts, col(1) holds the frame number col(2) the
%          traLen = length of the trajectory
%         halfWin = half the window size you want to cut away arround the
%                   artifacts
%
% RETURNS:
%      startNstop = mx2 matrix col(1) starts and column 2 stops of the cut 
%                   out window
%          winIDX = alogical vector as long as the trajectory in which 1
%                   marks a frame that should be ommited due to artifacts
%
% SYNTAX:[startNstop,winIDX] =
% ivT_artifact2D_makeCutOutWin(thrustE,slipE,yawE,traLen,halfWin);
%
% Author: B. Geurten 21.05.15
%
% see also ivT_artifact2D_findSpeedArtifacts

% create a logical index with all artifact occurences
logIDX = zeros(traLen,1);
logIDX(thrustE(:,1)) =1;
logIDX(slipE(:,1)) =1;
logIDX(yawE(:,1)) =1;

% get indices of  artifcts
artiFrames =find(logIDX);

%create cut out index
winIDX = zeros(traLen,1);
% go through all artifacts and a the half window
for i = 1:length(artiFrames),
    
    start = artiFrames(i)-halfWin;
    %check if the window is larger than the trajectory
    if start <1,
        start =1;
    end
    
    stop = artiFrames(i)+halfWin;
    %check if the window is larger than the trajectory
    if stop > traLen,
        stop =traLen;
    end
    winIDX(start:stop) = 1;
    
end

% check if first incident is at the beginning
if winIDX(1) == 1,
    starts = [1; find(diff(winIDX) ==1)+1];
else
    starts =  find(diff(winIDX) ==1)+1;
end

% check if last incident is at the end
if winIDX(end) == 1,
    stops = [ find(diff(winIDX) ==-1); length(logIDX)];
else
    stops = find(diff(winIDX) ==-1);
end
% create return variable
startNstop = [starts stops];
%make logIDX
winIDX = winIDX ==1;