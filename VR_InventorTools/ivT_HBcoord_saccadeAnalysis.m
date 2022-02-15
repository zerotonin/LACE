function [saccs, averageL,averageR,averageAbs] = ivT_HBcoord_saccadeAnalysis(trajectories,threshold,frameWin,triggerSource,triggerVel,ampLim)
% This function calculates the average angle velocities during a yaw
% saccade. The function calculates a triggered average to the head or
% thorax saccade as well as amplitude duration and direction of saccades. 
% Furthermore the place of the saccade peak is also returned in pixels
%
% GETS: 
%       trajectories = a m x 2 cell array containing head and thorax 3D 
%                      traces. M reopresents the number of. the first 
%                      column holds the head trace the 2nd column holds the
%                      thorax trace. The trace has the columns indice,
%                      x-position, yposition,z-position,yaw, pitch, roll, 
%                      thrust, slip, lift, yaw-vel, pitch-vel, roll-vel.
%          threshold = threshold for the saccade peak.
%           frameWin = window half size for the triggered average (frames)
%      triggerSource = this str can be set to 'head','thorax' or 
%                      'vice-versa', depending on this setting the source
%                      for the triggered average is either the head or
%                      thorax trajectory or in case of vice-versa the
%                      thorax is triggered on head saccades and vice versa.
%         triggerVel = this str determines which vel is analysed for
%                      saccade: 'yaw', 'slip' and 'roll'
%         ampLim     = amplitude limits a mx2 vector holding the lower and
%                      upper limit that the saccade has to have in degree
%                      if set to e.g. 5 and 35 saccades that have lower
%                      amplitude than 5 degrees are ommitted as are
%                      saccades that have larger amplitudes than 35
%
% RETURNS:
%           
%              saccs = a mxn matrix where m is the number of found saccades
%                      and n are the following rows: start, peak
%                      ,end,direction duration and amplitude of the saccade.
%                      After this the 3D position of the saccade is given
%                      in,x,y,z,
%           averageL = 12xmx3 matrix, where m is the number of frames of
%                      the averaging window (2*frameWin+1). Rows hold
%                      the different median values of the 12 trajectory
%                      dimensions (without indice), see trajectory. Firt
%                      layer of the 3rd dimension holds the median, 2nd
%                      layer is the higher end of the confidence intervall
%                      the 3rd layer is the lower confidence intervall.
%                      averageL holds all left saccades
%           averageR = averageR is similar to averageL and holds all right
%                      saccades
%         averageAbs = averageAbs is similar to averageL but holds all
%                      saccades. Tocalculate this the absolute values of
%                      all velocities are used.
%
% SYNTAX: [saccs, averageL,averageR,averageAbs] = ... 
%           ivT_HBcoord_saccadeAnalysis(trajectories,threshold,frameWin, ...
%                                       triggerSource,triggerVel, amplLim)
%
% Author: B. Geurten 30.5.2013
%
% see also get_saccades_moviewise, triggeredAverage

% make one long matrix containing mx7 samples the columns are frame
% numbers, head yaw-vel, head pitch-vel, head roll-vel, thorax yaw-vel,
% thorax pitch-vel, thorax roll-vel,
t = cell2mat(trajectories);
data =  t(:,[1 11:13 24:26]);
angles = t(:,[5:7 18:20]);
coords = t(:,[2:4 15:17]);
anglePos = t(:,[5:7 18:20]);
% delete NaNs!
delMe = find(isnan(data(:,end)));
anglePos(delMe,:) = [];
data(delMe,:) = [];
coords(delMe,:) = [];
angles(delMe,:) = [];
clear delMe t;

% to use different velocities to trigger the saccade analysis we change the
% order of the data 
switch triggerVel,
    case 'yaw',
        % nothing to do
        angles = angles(:,[1 4]);
    case 'pitch',
        data = data (:,[1 3 2 4 6 5 7]);
        angles = angles(:,[2 5]);
    case 'roll',
        data = data (:,[1 4 3 2 7 6 5]);
        angles = angles(:,[3 6]);
    otherwise
         error(['The trigger-velocity was false defined as ' triggerSource ' choose from "yaw", "pitch" or "roll"!'] )

end

% treat overlapping saccades
overlapFlag = 'del_overlap';

% find the saccades after trigger source
switch triggerSource,
    case 'thorax'
        [saccs, ~ ]  = get_saccades_moviewise(data(:,5:7),threshold,data(:,1),overlapFlag);
        saccs = SR_filterSaccades(saccs,ampLim,angles(:,2));
        saccPeakCoord = coords(saccs(:,2),4:6);
    case 'head',
        [saccs, ~ ]  = get_saccades_moviewise(data(:,2:4),threshold,data(:,1),overlapFlag);
        saccs = SR_filterSaccades(saccs,ampLim,angles(:,1));
        saccPeakCoord = coords(saccs(:,2),1:3);
    case 'vice-versa'
       % head saccades
        [saccsH, ~ ]  = get_saccades_moviewise(data(:,2:4),threshold,data(:,1),overlapFlag);
        saccsH = SR_filterSaccades(saccsH,ampLim,angles(:,1));
        saccPeakCoordH = coords(saccsH(:,2),1:3);
        % thorax saccades
        [saccsT, ~ ]  = get_saccades_moviewise(data(:,5:7),threshold,data(:,1),overlapFlag);
        saccsT = SR_filterSaccades(saccsT,ampLim,angles(:,2));
        saccPeakCoordT = coords(saccsT(:,2),4:6);
        
        % saving the coordinates of occurences to the return variable
        saccsH = [saccsH saccPeakCoordH];
        saccsT = [saccsT saccPeakCoordT];
        
        % get left and right saccades
        saccLeftH = saccsH(saccsH(:,4) ==1,:);
        saccRightH = saccsH(saccsH(:,4) ==-1,:);
        saccLeftT = saccsT(saccsT(:,4) ==1,:);
        saccRightT = saccsT(saccsT(:,4) ==-1,:);       
        
        % make triggered averages
        [averageRT, averageLT, averageAbsT] =SR_trigAverage(data,saccRightT,saccLeftT,saccsT,anglePos,frameWin);  
        [averageRH, averageLH, averageAbsH] =SR_trigAverage(data,saccRightH,saccLeftH,saccsH,anglePos,frameWin);
        averageR = [averageRT(1:3,:,:);averageRH(4:6,:,:);averageRT(7:9,:,:);averageRH(10:12,:,:) ];
        averageL = [averageLT(1:3,:,:);averageLH(4:6,:,:);averageLT(7:9,:,:);averageLH(10:12,:,:)];       
        averageAbs = [averageAbsT(1:3,:,:);averageAbsH(4:6,:,:);averageAbsT(7:9,:,:);averageAbsH(10:12,:,:)];
        
        %all saccs
        saccs = [saccsH; NaN(1,9); saccsT];
        


    otherwise
        error(['The trigger-source was false defined as ' triggerSource ' choose from "head", "thorax" or "vice-versa"!'] )
end



% get the averages if you not allready have done it in vice versa;
if ~strcmp(triggerSource,'vice-versa')
    % saving the coordinates of occurences to the return variable
    saccs = [saccs saccPeakCoord];
    
    % get left and right saccades
    saccLeft = saccs(saccs(:,4) ==1,:);
    saccRight = saccs(saccs(:,4) ==-1,:);
    
    % make triggered averages
    [averageR, averageL, averageAbs] =SR_trigAverage(data,saccRight,saccLeft,saccs,anglePos,frameWin);
    
    
    
end

% now we have to do the switcheroo again
switch triggerVel,
    case 'yaw',
        % nothing to do
    case 'pitch',
        rows = [2 1 3 5 4 6 8 7 9 11 10 12]';
        
        averageAbs = averageAbs(rows,:,:);
        averageR = averageR(rows,:,:);
        averageL = averageL(rows,:,:);
    case 'roll',
        rows = [3 2 1 6 5 4 9 8 7 12 11 10 ]';
        
        averageAbs = averageAbs(rows,:,:);
        averageR = averageR(rows,:,:);
        averageL = averageL(rows,:,:);
end

end


function [averageR, averageL, averageAbs] =SR_trigAverage(data,saccRight,saccLeft,saccs,anglePos,frameWin)

    set2zero=round(frameWin*0.1);
    set2zero2 = round(frameWin*0.1);

    averageR = triggeredAverage(data(:,2:7),saccRight(:,2),frameWin,data(:,1),set2zero);
    averageL = triggeredAverage(data(:,2:7),saccLeft(:,2),frameWin,data(:,1),set2zero);
    averageAbs  = triggeredAverage(abs(data(:,2:7)) ,saccs(:,2),frameWin,data(:,1),set2zero);

    anglesR = triggeredAverage(anglePos,saccRight(:,2),frameWin,data(:,1),set2zero2);
    anglesL = triggeredAverage(anglePos,saccLeft(:,2),frameWin,data(:,1),set2zero2);
    anglesAbs  = triggeredAverage(abs(anglePos) ,saccs(:,2),frameWin,data(:,1),set2zero2);
   
    
    averageR = [averageR; anglesR];
    averageL = [averageL; anglesL];
    averageAbs  = [averageAbs; anglesAbs];
end


function saccs = SR_filterSaccades(saccs,ampLim,angle)
amps = abs(angle(saccs(:,3)) -angle(saccs(:,1)));
rows = amps > ampLim(2) | amps < ampLim(1); 
saccs(rows,:)= []; 

end
