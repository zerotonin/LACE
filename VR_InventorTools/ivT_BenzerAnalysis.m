function data =ivT_BenzerAnalysis(trace,fps,varargin)
% This function analysis traces of the autmatic benzer climbing essay,
% resulting from ivT_BenzerAnaTrace. The algorithm calculates six  
% functional parameters:
% 1. did the animal reach the upper 10 mm 2, did the animal cross the
% midline 3. the duration to reach the peak in s 4. median climbing speed
% 5. overall activity and 6. distance walked in mm. The climbing speed is
% only calculated from ascends.
%
% GETS:
%       trace = mx6 data matrix, where m is the number of frames. The 
%               rows are defined as:  
%                  1. filtered x-coordinate [mm]
%                  2. filtered y-coordinate [mm]
%                  3. filtered yaw [rad]
%                  4. global horizontal speed [mm/s]
%                  5. global vertical speed [mm/s]
%                  6. yaw speed [rad/s
%         fps = a number frames per second
%
%
%  A number of other paramters can be set via varargin. To dos so just
%  enter the name of the variable as string followed by the value you want
%  to set it to, e.g. 'arenaHeight',75;
%  Paramters are:
%    arenaHeight = height of the arena in mm | DEFAULT: 75
%    speedCutOff = velocity in mm/s below which an animal is thought to be
%                  resting | DEFAULT: 0.5
%
% RETURNS:
%           data = a mx6 data matrix, where m is the number of flies. The 
%                  rows are defined as:  
%                  1. did the animal reach the upper 10 mm (boolean) 
%                  2. did the animal cross the midline (boolean)
%                  3. the duration to reach the peak in s 
%                  4. median climbing speed (mm/s)
%                  5. overall activity (fraction)
%                  6. distance walked in mm
%
% SYNTAX: data =ivT_BenzerAnalysis(trace,pix2mm,fps,varargin);
%
% Author: B. Geurten 15.07.2014
%
% see also ivT_IO_readMultFullIVtrace, ivT_pixBoxGUI, norm,ivT_BenzerAnalysis






%%%%%%%%%%%%%%%%%%%
% standard values %
%%%%%%%%%%%%%%%%%%%

arenaHeight = 75;
speedCutOff = .5;

% check if varargin contains other options
for i =1:length(varargin),
    switch varargin{i},
        case 'arenaHeight',
            arenaHeight = varargin{i+1};
        case 'speedCutOff',
            speedCutOff = varargin{i+1};
        otherwise
            if isstr(varargin{i}),
                warning(['ivT_BenzerAnalysis:1 The vargargin argument ''' varargin{i} ''' is unknown!'])
            end
    end
end


% get Size
[frameNo,~,flyNo] = size(trace);



%%%%%%%%%%%%
% Analysis %
%%%%%%%%%%%%

% getting ascends and descends
ascends = sign(trace(:,5,:));
%descends = ascends == -1;
ascends = ascends == 1;

% now calculate time to top
zPos = trace(:,2,:) >= (arenaHeight-10);
time2peak = arrayfun(@(i) find(zPos(:,:,i),1,'first'),1:flyNo,'UniformOutput',false)';
notReachedID= cellfun(@isempty, time2peak);
time2peak(notReachedID) = {NaN};
time2peak = cell2mat(time2peak)./fps;

% reached top
reachedTop = ~isnan(time2peak);

%  crossed midline
zPos = trace(:,2,:) >= (arenaHeight/2);
crossedMidLine = sum(zPos,1)>0;
crossedMidLine = reshape(crossedMidLine,flyNo,1);

% median climbing speed
medClimbSpeed = arrayfun(@(i) median(trace(ascends(:,:,i),5,i)),1:flyNo)';

% climbed distance
distance = sum(sum(abs(trace(1:end-1,4:5,:)./fps),1),2);
distance = reshape(distance,flyNo,1);

% resting percentage
activity = sum(abs(trace(1:end-1,4:5,:)),2) > speedCutOff;
activity = sum(activity,1)./(frameNo-1);
activity = reshape(activity,flyNo,1);


%%%%%%%%%%
% export %
%%%%%%%%%%

data = [reachedTop crossedMidLine,time2peak,medClimbSpeed,activity,distance];
