function traces = ivT_ananalyseMulti2DTraces(traces, filterChoice,frameRate,mmPerPix)
% This function analysis multiple 2D ivTrace trajectories. The function
% unwraps the atan2 coded yaw and filters the data with a predefined filter
% setting. Afterwards the velocities for thrust, slip and yaw are calculated.
%
% GETS:
%         traces =  is a cell array in which every cell holds a 
%                   mx5 matrix holding fly trajectories  m is the number 
%                   of frames;
%                   col(1) x-position pixels center of mass 
%                   col(2) y-position pixels center of mass
%                   col(3) yaw in radians center of mass
%                   col(4) space in pixels occupied by the larvae
%                   col(5) ratio between long and short axis of the
%                          ellipsoid 0.5 = circle 1 = line
%     fiterchoice = Filter type
%                   1 : Savitzky-Golay (3,21)
%                   2 : Savitzky-Golay (3,31)
%                   3 : Butterworth (2,0.1)
%                   4 : Butterworth (2,0.05)
%                   5 : Butterworth (3,0.1)
%                   6 : Gauss 50 frame window | 3 frame sigma
%                   default and other values evoke no filtering
%       frameRate = frameRate in Hz of the original footage
%        mmPerPix = factor to convert pixels to mm if you have a different
%                   value for each trace give as cell array in the same 
%                   orientation as traces, if yopu use pixand mm boxes make
%                   them 4x4x2 matrixes holding point information as in
%                   ivT_pix2mm with (:,:,1) holding pix values and (:,:,2)
%                   mm values
%
% RETURNS:
%         traces =  is a cell array in which every cell holds a 
%                   mx8 matrix holding fly trajectories  m is the number 
%                   of frames; all original columns are filtered
%                   individually as described by the filterChoice variable
%                   col(1) x-position mm center of mass 
%                   col(2) y-position mm center of mass
%                   col(3) yaw in radians center of mass
%                   col(4) space in pixels occupied by the larvae
%                   col(5) ratio between long and short axis of the
%                          ellipsoid 0.5 = circle 1 = line
%                   col(6) thrust in mm/s 
%                   col(7) slip in mm/s 
%                   col(8) yaw in deg/s 
%
% SYNTAX: traces = ivT_ananalyseMulti2DTraces(traces, filterChoice,frameRate,mmPerPix);
%
% ANALYSIS TRAIN:  ivT_IO_readLargeNoisySingleAreaTRA->ivT_ananalyseMulti2DTraces->
%                  ivT_artifact2D_findSpeedArtifacts
%
% Author: B.Geurten 10.6.13
%
% see also cellfun, ivT_IO_loadmultFullTra, filter2DTrace, ivT_analyseSaccades_multi2Dtraces

% goes through all cells
if iscell(mmPerPix),
    if size(mmPerPix{1},1) ~=1,
        traces = cellfun(@(x,y)...
            [filter3DTrace([ivT_pix2mm(y(:,:,1),y(:,:,2),x(:,1:2)) ivT_unwrapAtan2(x(:,3))],filterChoice)...         % filter position and orientation | transform from pix to mm | unwrap yaw
            filter2DTrace(x(:,4:5),filterChoice)],traces,mmPerPix,'UniformOutput',false); % filter size and excentricity
        
    else
        traces = cellfun(@(x,y)...
            [filter3DTrace([x(:,1:2).*y ivT_unwrapAtan2(x(:,3))],filterChoice)...         % filter position and orientation | transform from pix to mm | unwrap yaw
            filter2DTrace(x(:,4:5),filterChoice)],traces,mmPerPix,'UniformOutput',false); % filter size and excentricity
    end
else
    traces = cellfun(@(x)...
        [filter3DTrace([x(:,1:2).*mmPerPix ivT_unwrapAtan2(x(:,3))],filterChoice)...  % filter position and orientation | transform from pix to mm | unwrap yaw
        filter2DTrace(x(:,4:5),filterChoice)],traces,'UniformOutput',false);          % filter size and excentricity
    % calculate speeds from position and orientation
end



traces = cellfun(@(x) [ x [IV_2Dtrace_calcAnimalSpeed(x(:,1:3)) [diff(rad2deg(x(:,3)));NaN]].*frameRate]...
         ,traces,'UniformOutput',false);
 