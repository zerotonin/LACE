function track_filt = filter2DTrace(track,filter)
% GETS:
% 1. 2D Track
% 2. Filter type
%    1 = Savitzky-Golay (3,21)
%    2 = Savitzky-Golay (3,31)
%    3 = Butterworth (2,0.1)
%    4 = Butterworth (2,0.05)
%    5 = Butterworth (3,0.1)
%    6 = Gauss 50 frame window | 3 frame sigma
%    default and other values evoke no filtering
%
%RETURNS 
% filtered 2D track
%
% SYNTAX filtered_track = filter2DTrace(track,filter) 
%
switch filter
    case {1}
        track_filt = [sgolayfilt(track(:,1),3,21) sgolayfilt(track(:,2),3,21)];
    case {2}
        track_filt = [sgolayfilt(track(:,1),3,31) sgolayfilt(track(:,2),3,31)];    
    case {3}
        [B,A] = butter(2,0.1);
        track_filt = [filtfilt(B,A,track(:,1)) filtfilt(B,A,track(:,2))];
    case {4}
        [B,A] = butter(2,0.05);
        track_filt = [filtfilt(B,A,track(:,1)) filtfilt(B,A,track(:,2))];
    case {5}
        [B,A] = butter(3,0.1);
        track_filt = [filtfilt(B,A,track(:,1)) filtfilt(B,A,track(:,2))];
    case {6}
        w = normpdf(0,-25:25,3);
        track_filt = [filtfilt(w,1,track(:,1)) filtfilt(w,1,track(:,2))];
    case {7}
        w = normpdf(0,-6:6,3);
        track_filt = [filtfilt(w,1,track(:,1)) filtfilt(w,1,track(:,2))];
    otherwise
        disp('No filter used')
        track_filt = track;
end