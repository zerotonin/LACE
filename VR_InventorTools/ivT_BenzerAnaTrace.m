function trace = ivT_BenzerAnaTrace(trace,pix2mm,fps,butterDeg,butterCutOff,mmBox,arenaHeight)
% This function analysis traces of the autmatic benzer climbing essay. In
% contrast to normal analysis in which fly based velocities are used, here
% global velocities are used to determine the climbing speed. Frames are
% thought to be recorded so that the Y-axis of the frame is the
% gravitational axis. As in camera coordinates the Y axis is inverted. The
% pixel values are first transered to 
%
% GETS:
%       trace = a mx3xn matrix where m is the number of frames and n is the
%               number of flies. 1:2 hold x and y position in pixels 3 the 
%               yaw angle in radiance as for example returned by 
%               ivT_IO_readMultFullIVtrace; 2nd dimension can be larger
%               entries after 3 will be ignored
%      pix2mm = can either be a number than it has to be the factor from
%               pixels to milimeters or 2x4 matrix holding the coordinates
%               of the 4 trace points of the Benzer arena. As for example
%               returned by ivT_pixBoxGUI. 
%                                      4--------3
%                                      |        |
%                                      |        |
%                                      1--------2
%         fps = a number frames per second 
%   butterDeg = degree of the Butterworth filter used to filter the 
%               trace | DEFAULT: 2
%butterCutOff = cutoff of the Butterworth filter | DEFAULT: 0.25
%       mmBox = 4x2 matrix used to get the pixel 2 mm factor value from 
%               4x2 pix2mm variable | DEFAULT: [0 0; 89 0; 89 75; 0 75]; 
% arenaHeight = height of the arena in mm | DEFAULT: 75
%
% if a default value was given as input you can not set this variable or
% leave it empty and it will be set to the default value
%
% RETURNS:
%          trace = mx6 data matrix, where m is the number of frames. The 
%                  rows are defined as:  
%                  1. filtered x-coordinate [mm]
%                  2. filtered y-coordinate [mm]
%                  3. filtered yaw [rad]
%                  4. global horizontal speed [mm/s]
%                  5. global vertical speed [mm/s]
%                  6. yaw speed [rad/s]
%
% SYNTAX: trace =
% ivT_BenzerAnaTrace(pixtrace,pix2mm,fps,butterDeg,...
%                                           butterCutOff,mmBox,arenaHeight);
%
% Author: B. Geurten 15.07.2014
%
% see also ivT_IO_readMultFullIVtrace, ivT_pixBoxGUI, norm,ivT_BenzerAnalysis

%%%%%%%%%%%%%%%%%%%
% standard values %
%%%%%%%%%%%%%%%%%%%

if ~exist('butterDeg','var')
    butterDeg = 2;
else
    if isempty(butterDeg),
        butterDeg = 2;
    end
end

if ~exist('butterCutOff','var')
    butterCutOff = 0.25;
else
    if isempty(butterCutOff),
        butterCutOff = 0.25;
    end
end

if ~exist('mmBox','var')
    mmBox = [0 0;89 0;89 75;0 75 ];
else
    if isempty(mmBox),
        mmBox = [0 0;89 0;89 75;0 75 ];
    end
end

if ~exist('arenaHeight','var')
    arenaHeight = 75 ;
else
    if isempty(arenaHeight),
        arenaHeight = 75 ;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obtain trajectory facts %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get Size
[frameNo,~,flyNo] = size(trace);

% pix 2 mm
if numel(pix2mm) ==1,
    trace=[trace(:,1,:).*pix2mm (trace(:,2,:).*(-1*pix2mm))+arenaHeight trace(:,3,:)];
else
   % mmBoxNorm= norm(bsxfun(@minus,mmBox(2,:),mmBox(4,:)))/norm(bsxfun(@minus,pix2mm(2,:),pix2mm(4,:)));
   % trace=[trace(:,1,:).*mmBoxNorm (trace(:,2,:).*(-1*mmBoxNorm))+arenaHeight trace(:,3,:)];
   trace =[ivT_pix2mm(pix2mm,mmBox,trace(:,1:2,:)) trace(:,3,:)];
   trace=ivT_Benzer_interpNaN(trace);  
end
% filter trace
[B,A] = butter(butterDeg,butterCutOff);
trace = filtfilt(B,A,trace);

% built global velocities
trace = [trace [diff(trace,1); NaN(1,3,flyNo)].*fps];
