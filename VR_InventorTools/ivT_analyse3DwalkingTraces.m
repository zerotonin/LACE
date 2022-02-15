function new_traces = ivT_analyse3DwalkingTraces(traces,pixbox,mmbox,filtertype,framerate,yawCutOff,kill)
% This function analyses raw ivTrace traces as read in by
% ivT_IO_readIVTraceMult. Then several steps are used to analyse the data
% and transfer it from pixel coordinates and atan2 folded yaw. To easy
% acessible speeds.
% Step 1: Yaw Analysis
%        The yaw of each trajectory is corrected for user set yaws that
%        were not alligned with the animal. Often when ivTrace misses a
%        region the user adds the region but forgets to allign the yaw
%        properly. These yaws are set to exact zero. This part of the
%        analysis corrects those zeros.
%        Sometimes when the User incorrectly uses AutoCorrectDirs in
%        ivTools the yaw just flips by pi. The ivT_yawCorrectSinglePeaks
%        function corrects these mistakes.
%        The yaw in ivTrace is calculated with the atan2 which is defined
%        from -pi to pi (-180� to 180�). Whenever the region turns more
%        than pi or less then -pi one gets huge jumps that are then
%        manifested in the yaw velocity. These jumps are corrected by 
%        ivT_unwrapAtan2.
%        In the final step the function looks for velocities higher than
%        the user defined cut off (yawCutOff). If it finds such speeds they
%        might be artifacts.
% Step 2: Deciding if to proceed
%        If artifacts were found the function decides based on the flag
%        variable kill. If kill is set to one. It ignores this trajectory
%        and it won't be analysed. If kill is set to zero the trajectory
%        will be analysed but a warning will be printed on the command
%        line.
% Step 3: Tranfering pixel coordinates into mm coordinates
%        The ivTrace positions are in pixels. We use the ivT_pix2mm
%        function to transfer them into real world coordinates.
% Step 4: Filtering
%        The position and orientation gets filtered by filter3Dtrace.
% Step 5: Calculating Speeds
%        The translational speeds are calculated based on the filtered 
%        positions by IV_2Dtrace_calcAnimalSpeed. The rotational speed is
%        calculated based on the filtered yaw with diff
%
% GETS:
%       traces = mx3xp matrix; consiting of m frames with p trajectories.
%                The first column holds the x position in pixels the second
%                column is likewise for the y position. The third column
%                holds the yaw in radians. The traces can be read in by 
%                ivT_IO_readIVTraceMult
%       pixbox = Is the encircling pixel box of the arena see ivT_pixCircleGUI
%                or ivT_pixBoxGUI for more details
%        mmbox = Built in the same way holding the mm coordinates
%                corresponding to pixbox. Details are found in the same
%                functions. This is a 4x2 to matrix holding the x values in
%                the first and the y values in the second column. The
%                corners are defined as follows.
%                                         3-----2
% '                                       |     |
%                                         4-----1
%   filtertype = integer variable if set to one of the following numbers,
%                it will evoke the suggested filtering
%                1 = Savitzky-Golay (3,21)
%                2 = Savitzky-Golay (3,31)
%                3 = Butterworth (2,0,1)
%                4 = Butterworth (2,0.05)
%                5 = Butterworth (3,0.1)
%                6 = Gauss 50 frame window | 3 frame sigma
%                default and other values evoke no filtering
%    framerate = sample framerate of the trajectory in Hz
%    yawCutOff = speed in deg*s^-^1 above which a yaw movement is
%                regarded to be an artifact. Conservative guess is 1000
%         kill = if set to one, traces wqith artifacts will be ignored and
%                will not be in the return value new_traces. If set to zero
%                the traces are analysed and return, only a warning will be
%                displayed.
%
% RETURNS:
%
%   new_traces = a mx6xp matrix with m frames and p regions (traces, 
%                trajectories). Columns are defined as follows: 
%                Col(1): x coordinate   [mm]
%                Col(2): y coordinate   [mm]
%                Col(3): yaw coordinate [rad]
%                Col(4): thrust [mm*s-1]
%                Col(5): slip   [mm*s-1]
%                Col(6): yaw   [deg*s-1]
%
% SYNTAX: new_traces = ivT_analyse3DwalkingTraces(traces,pixbox,mmbox,...
%                      filtertype,framerate,yawCutOff,kill);
%
% Author: B. Geurten
%
% see also ivT_IO_readIVTraceMult, ivT_pixCircleGUI, ivT_pixBoxGUI, 
%          ivT_yawCorrectSinglePeaks, ivT_yawCorrectForgotten, ivT_unwrapAtan2
%          ivT_pix2mm, filter3Dtrace, IV_2Dtrace_calcAnimalSpeed


%size of main input
[frames,coords,traceno] = size(traces);
%pre allocation
new_traces= nan(frames,coords+3,traceno);
% delete list
delme = [];

%analyse each of the traces
for i =1:traceno
    
    %get yaw
    yaw = traces(:,3,i);
    
    %correct yaw values that were set by hand and not correctly alligned
    yaw=ivT_yawCorrectForgotten(yaw);
    
    %correct uncorrected jumps (see ivtrace sort directions)
    yaw=ivT_yawCorrectSinglePeaks(yaw);
    
    %unwrap the atan2 jumps
    yaw=ivT_unwrapAtan2(yaw);
    
    %calculate yaw velocity
    yawvel =  [diff(rad2deg(yaw)).*framerate ;nan];
    
    %check for artifcats
    ind = find(yawvel >yawCutOff, 1);
    
    
    
    if isempty(ind), % no artifacts
        
        %do the rest of the analysis get mm positions, filter trace,
        %calculate translational speeds and combine trace with speeds
        new_traces(:,:,i) = analyseTransAndCombineSpeeds(pixbox,mmbox,...
            traces(:,:,i),yaw,filtertype,framerate);
        
        
    else
        if kill,% ignore the data and clean the return variable see end of script
            
            % put trace in delete list
            delme = [delme;i];
            
            % display note
            disp([' note: trace no. ' num2str(i) ' has yaw artifacts and was ignored!'])
        else % keep the data in return variable and display a warning
            
            %do the rest of the analysis get mm positions, filter trace,
            %calculate translational speeds and combine trace with speeds
            new_traces(:,:,i) = analyseTransAndCombineSpeeds(pixbox,mmbox,...
                traces(:,:,i),yaw,filtertype,framerate);
            
            %display warining but keep the data
            warning('ivt_analyse3dwalkingtraces:yaw',['trace no. ' num2str(i) ' has yaw artifacts!'])
        end
        
    end
end

%delete empty traces in return value. Those are empty because they had a
%yaw artifact
new_traces(:,:,delme) = [];


function new_trace = analyseTransAndCombineSpeeds(pixbox,mmbox,trace,yaw,filtertype,framerate)
% This subfunction calls up several simple functions that have to be
% executed as soon as the rest of the trajectory has to be analysed. These 
% functions are combined here, because the main function checks for yaw 
% artifacts and then decides wether or not the rest of the analysis should 
% be undertaken.  Every function call is commented


%from pixel positions to mm positionn and add yaw
trace = [ivT_pix2mm(pixbox,mmbox,trace(:,1:2)) yaw];
%filter trace
trace=filter3DTrace(trace,filtertype);
%calculate translational speed
ts_speed = IV_2Dtrace_calcAnimalSpeed(trace).*framerate;
%calulate rotational speed
yaw_speed = [diff(rad2deg(trace(:,3))).*framerate;NaN];
%save to trace
new_trace =[trace ts_speed yaw_speed];