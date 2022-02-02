function tra3 = ET_dlc_HBtra2tra3(hb_tra)
% This function of the Ethotrack deepLabCut toolbox (ET_DLC_) is specific
% for multiple animale trajectories with heads and tails. The routine
% changes the coordinates from x,y head and x,y tail to x,y and yaw.
% GETS:
%        hb_tra = matrix of floats; mx5xp, where m is the number of frames
%                 analysed. n is 1) x-coordinate head 2) y-coordinate head 
%                 3) x-coordinate tail 4) y-coordinate tail 5) mean of
%                 object recognition quality. 
%
% RETURNS:
%           tra = matrix of floats; mx4xp where m is the number of frames p 
%                is the number of animals and the 4 columns are x-coordinate
%                y-coordinate, yaw in radians (atan2) and score of the
%                object recognition
%
% SYNTAX:  tra3 = ET_dlc_HBtra2tra3(hb_tra);
%
% Author: B. Geurten 09-19-19
%
% see also ET_DLC_openTra, ET_DLC_tra2HBtra
 Y = bsxfun(@minus,hb_tra(:,4,:),hb_tra(:,2,:));
 X = bsxfun(@minus,hb_tra(:,3,:),hb_tra(:,1,:));
 yaw = arrayfun(@(a,b) atan2(b,a),X,Y);
 tra3 =  [nanmean(hb_tra(:,[1 3],:),2) nanmean(hb_tra(:,[2 4],:),2) yaw hb_tra(:,5,:)];