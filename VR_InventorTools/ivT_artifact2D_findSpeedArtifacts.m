function [thrustE,slipE,yawE] = ivT_artifact2D_findSpeedArtifacts(trace,threshold)
% This function checks for artifaxcts in the analysed 2D traces of insects.
% The routine expects speeds to be in the dimensions of mm*s-1 and deg*s-1.
% Then it looks for frames in which the animal exceeds this velocity. It
% returns the indices and values.
%
% GETS:
%          traces = is a mx8 matrix with m frames and the following cols:
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
%       threshold = a 3 value vector holding the thresholds for thrust slip
%                   and yaw in this sucession. As we detect the speeds as
%                   absolute values you do not have to care about negative 
%                   values
%
% RETURNS:
%         thrustE = a mx2 matrix, where m is the number of detected thrust
%                   artifacts, col(1) holds the frame number col(2) the
%                   speed value
%           slipE = a mx2 matrix, where m is the number of detected slip
%                   artifacts, col(1) holds the frame number col(2) the
%                   speed value
%            yawE = a mx2 matrix, where m is the number of detected yaw
%                   artifacts, col(1) holds the frame number col(2) the
%                   speed value
% SYNTAX: [thrustE,slipE,yawE] = ivT_artifact2D_findSpeedArtifacts(trace,threshold);
% 
%
% ANALYSIS TRAIN:  ivT_IO_readLargeNoisySingleAreaTRA->ivT_ananalyseMulti2DTraces->
%                  ivT_artifact2D_findSpeedArtifacts
% 
% Author: B. Geurten 21.05.15
%
% see also ivT_IO_readLargeNoisySingleAreaTRA,ivT_ananalyseMulti2DTraces

thrust = trace(:,6);
slip   = trace(:,7);
yaw    = trace(:,8);

logThrust = abs(thrust) > threshold(1);
logSlip   = abs(slip) > threshold(2);
logYaw    = abs(yaw) > threshold(3);

thrustE = [find(logThrust) thrust(logThrust)];
slipE   = [find(logSlip) slip(logSlip)];
yawE    = [find(logYaw) yaw(logYaw)];
