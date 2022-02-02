function qIDX = ET_DLC_makeQualIDX(tra, cutOff)
% This function of the Ethotrack deepLabCut toolbox (ET_DLC_)
% GETS:
%        hb_tra = matrix of floats; mx5xp, where m is the number of frames
%                 analysed. n is 1) x-coordinate head 2) y-coordinate head
%                 3) x-coordinate tail 4) y-coordinate tail 5) mean of
%                 object recognition quality.
%
% RETURNS:
%        md_len = mxp matrix of bools. where m is the number of frames and
%                 p is the number of animals. The value is true if the
%                 animal is twice as long as its bodylength median
%                 throughout the movie
%
% SYNTAX: md_len = ET_DLC_plausibilityCheckBodyLength(hb_tra);
%
% Author: B. Geurten 09-19-19
%
% see also ET_DLC_openTra, ET_DLC_tra2HBtra

[samples,~,flyNum] = size(tra);
qIDX = NaN(samples,flyNum);
for flyI = 1:flyNum
    qIDX(:,flyI) = tra(:,end,flyI) < cutOff;
end


