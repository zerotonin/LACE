function md_len = ET_DLC_plausibilityCheckBodyLength(hb_tra)
% This function of the Ethotrack deepLabCut toolbox (ET_DLC_) is specific
% for multiple animale trajectories with heads and tails. By analysing the
% euclidean distance between head and tail one can detected artifacts where
% the animal suddenly gets twice as large as the median bodylength during
% the movie. If this happens the 
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
[samples,~,flyNum] = size(hb_tra);
bodyLen = bsxfun(@minus,hb_tra(:,1:2,:),hb_tra(:,3:4,:));
bodyLen = sqrt(sum(bodyLen.^2,2));
bodyThresh = median(bodyLen,1);
bodyThresh = bodyThresh.*2;
md_len = NaN(samples,flyNum);
for flyI = 1:flyNum
    md_len(:,flyI) = bodyLen(:,:,flyI) > bodyThresh(:,:,flyI);
end
