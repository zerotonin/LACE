function trace = IV_filterInvetorTrace(trace,filterChoice)
% This function filters an inventor trace. Because the inventor trace
% orientation values are active Fick angles in radians.  We have to
% transform the m into degrees and deal with  the circular statistics by
% unwraping the angles. Aftwerwards the angles are converted to radians
% again.
%
% GETS
%           trace = ivrender readable trace mx6 with Fick angles in radians
%    filterChoice = flag to determine which filter to use (moszt often 3)
%                   1: Savitzky-Golay (3,21)
%                   2: Savitzky-Golay (3,31)
%                   3: Butterworth (2,0.1)
%                   4: Butterworth (2,0.05)
%                   5: Butterworth (3,0.1)
%                   6: Gauss 50 frame window | 3 frame sigma
%                   default and other values evoke no filtering
% RETRUNS
%           trace = filtered trajectory
%
% SYNTAX: trace = IV_filterInvetorTrace(trace,filterChoice);
%
% Author: B.Geurten 20.05.2011
%
% see also IV_ivTrace2IVrenderTrj, filter3DTrace, unwrap_yaw

% transform to degrees and unwrap
angles = rad2deg(trace(:,4:6));
angles = [unwrap_yaw((angles(:,1))) unwrap_yaw((angles(:,2))) unwrap_yaw((angles(:,3)))];

% filter orientations
angles = filter3DTrace(angles,filterChoice);
%transform back to radians
angles = deg2rad(angles);

%filter coordinates
coords = filter3DTrace(trace(:,1:3),filterChoice);

%return variable
trace = [coords angles];

