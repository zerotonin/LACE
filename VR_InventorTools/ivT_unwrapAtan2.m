function angle = ivT_unwrapAtan2(angle)
% This function unwraps atan2 angles. It detects jumps greater then pi/2
% and than uses an offset of pi to adjust the angles. It is similar to
% unwrap (MATLAB) or unwrap_head,unwrap_roll,unwrap_pitch,unwrap_yaw (B.
% Geurten). But this function works like the yaw modus of unwrap_head, but
% on radians instead of degrees.
% If you get bad results with animal trajectories from the ivTools set,
% this might be due to serveral user prone mistakes the functions
% ivT_yawCorrectForgotten and ivT_yawCorrectSinglePeaks deal with those.
%
% GETS:
%       angle = a vector containing angles in radians.
%
% RETURNS:
%   new_angle = continious angle values in radians .
%
% SYNTAX: new_angle = ivT_unwrapAtan2(angle);
%
% Author: B.Geurten Mid 2013
%
% see also ivT_analyse3DwalkingTraces, ivT_yawCorrectSinglePeaks,
%          ivT_yawCorrectForgotten, unwrap, unwrap_head



dangle = diff(angle);
% taking two measure with inverted signals is better than using absolute
% values as absolute values change the peak height
warning('off','signal:findpeaks:largeMinPeakHeight') % turn off warnings if no peaks were found
[~,locsPos]=findpeaks(dangle,'MinPeakHeight',.5);
[~,locsNeg]=findpeaks(dangle.*-1,'MinPeakHeight',.5);

atanJumps = sortrows([locsPos+1 ones(length(locsPos),1); locsNeg+1 ones(length(locsNeg),1).*-1]);
count = 0;
while ~isempty(atanJumps),
    for i =1:size(atanJumps,1)
        if atanJumps(i,2) == 1,
            angle(atanJumps(i,1):end) = angle(atanJumps(i,1):end) + (angle(atanJumps(i,1)-1) - angle(atanJumps(i,1)));
        else
            angle(atanJumps(i,1):end) = angle(atanJumps(i,1):end) + (angle(atanJumps(i,1)-1) - angle(atanJumps(i,1)));
        end
    end
    
    dangle = diff(angle);
    % taking two measure with inverted signals is better than using absolute
    % values as absolute values change the peak height
    [~,locsPos]=findpeaks(dangle,'MinPeakHeight',1);
    [~,locsNeg]=findpeaks(dangle.*-1,'MinPeakHeight',1);
    atanJumps = sortrows([locsPos+1 ones(length(locsPos),1); locsNeg+1 ones(length(locsNeg),1).*-1]);
    count = count+1;
    if count > 1000,
        atanJumps = [];
        warning(['ivT_unwrapAtan2: could not extract all errors trace length is ' num2str(length(angle)) ])
    end
end
 % turn on warnings if no peaks were found
warning('on','signal:findpeaks:largeMinPeakHeight')