function step_IDX = ET_DLC_plausibilityCheckstepSize(tra,fps,p2mmF)
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
% SYNTAX: step_len = ET_DLC_plausibilityCheckstepSize(tra);
%
% Author: B. Geurten 09-19-19
%
% see also ET_DLC_openTra, ET_DLC_tra2HBtra
[samples,~,flyNum] = size(tra);
stepLen = diff(tra,1);
stepLen = sqrt(sum(stepLen.^2,2)).*p2mmF;
stepThresh = 20/fps; % 20mm*s⁻¹ is top speed
stepThresh = stepThresh;
step_IDX = NaN(samples-1,flyNum);
for flyI = 1:flyNum
    step_IDX(:,flyI) = stepLen(:,:,flyI) > stepThresh;
end
step_IDX = [zeros(1,flyNum);step_IDX];
