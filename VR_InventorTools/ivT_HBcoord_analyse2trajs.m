function [head,thorax] = ivT_HBcoord_analyse2trajs(hfile,tfile,indices,frameRate,filterChoice)
% This function is part of the head-body-coordination - sub-toolbox. This
% toolbox was written to analyse 3D manual thorax and head
% trajectories. The basic idea is that the head and thorax where traced in
% the  same movie and now we can calculate the differeneces in orientation.
%
% 
% 
% GETS:
%         hfile = absolute file position of the 3D-mask trajectory for the
%                 head
%         tfile = absolute file position of the 3D-mask trajectory for the
%                 thorax
%       indices = frame indices of the interessting part of the trajectory
%                 (ivTrace frames!)
%     frameRate = frame rate with which the original movie was calculated
%  filterChoice = number that sets the filter type used to filter the
%                 trajectories:
%                 1 = Savitzky-Golay (3,21)
%                 2 = Savitzky-Golay (3,31)
%                 3 = Butterworth (2,0,1)
%                 4 = Butterworth (2,0.05)
%                 5 = Butterworth (3,0.1)
%                 6 = Gauss 50 frame window | 3 frame sigma
%                 default and other values evoke no filtering
%
% RETURNS:
%         head = mx13 matrix containing the filtered and cut version of the
%                original trajectory where m is the number of frames as set
%                by indices. Otherwise m is the cut-set between the frames
%                of both trajectories. The columns contain the following
%                information
%                1) frame indices 2) x-position [pix] 3) y-position [pix]
%                4) z-position [pix] 5) yaw [deg] 6) pitch [deg]
%                7) roll [deg] 8) thrust [pix/s] 9) slip [pix/s]
%                10) lift [pix/s] 11) yaw-velocity [deg/s]
%                12) pitch-velocity [deg/s] 13) roll-velocity [deg/s]
%       thorax = mx13 with thorax data; specifications as above
%
% SYNTAX: [head,thorax] = ivT_HBcoord_analyse2trajs(hfile,tfile,indices,...
%                         frameRate,filterChoice)
%
% Author: B.Geurten
%
% see also ivT_IO_3DmanTrace, ivT_HBcoord_makeSameLength, rad2deg,
%          calcFickAnglesFromRotAxis, ivT_unwrapAtan2, filter3DTrace,

% loading data
head   = ivT_IO_3DmanTrace(hfile);
thorax = ivT_IO_3DmanTrace(tfile);

% make same length
[head,thorax] = ivT_HBcoord_makeSameLength(head,thorax,indices);


% get fick angles
head(:,5:7) = calcFickAnglesFromRotAxis(head(:,5:7));
thorax(:,5:7) = calcFickAnglesFromRotAxis(thorax(:,5:7));

% unwrap yaw jumps
head(:,5) = ivT_unwrapAtan2(head(:,5));

% unwrap yaw jumps
thorax(:,5) = ivT_unwrapAtan2(thorax(:,5));

% calculate degree values
head(:,5:7) = rad2deg(head(:,5:7));
thorax(:,5:7) = rad2deg(thorax(:,5:7));

% filter data
head   = [head(:,1) filter3DTrace(head(:,2:4),filterChoice) filter3DTrace(head(:,5:7),filterChoice)];
thorax = [thorax(:,1) filter3DTrace(thorax(:,2:4),filterChoice) filter3DTrace(thorax(:,5:7),filterChoice)];

% calculate speeds
head   =  [head    [diff(head(:,2:7),1)  ;NaN(1,6)].*frameRate];
thorax =  [thorax  [diff(thorax(:,2:7),1);NaN(1,6)].*frameRate];


