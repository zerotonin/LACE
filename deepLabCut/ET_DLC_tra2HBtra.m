function hb_tra = ET_DLC_tra2HBtra(tra,qualCutOff)
% This function of the Ethotrack deepLabCut toolbox (ET_DLC_) is specific
% for multiple animale trajectories with heads and tails. This changes the
% normal tra format /(mx3xp) into a mx5xp value so that. head_x head_Y
% tail_x tail_y is followed by the mean of the quality
%
% GETS:
%         
%           tra = matrix of floats; mx3xp, where m is the number of frames
%                 analysed. n is 1) x-coordinate 2) y-coordinate 3) object
%                 recognition quality. p is number of different regions
%    
% RETURNS:
%        hb_tra = matrix of floats; mx5xp, where m is the number of frames
%                 analysed. n is 1) x-coordinate head 2) y-coordinate head 
%                 3) x-coordinate tail 4) y-coordinate tail 5) mean of
%                 object recognition quality. p is number of different 
%                 animals and half as long as p of tra.
%
% SYNTAX: hb_tra = ET_DLC_tra2HBtra(tra);
%
% Author: B. Geurten 09-19-19
%
% see also ET_DLC_openTra,ET_DLC_plausibilityCheckBodyLength,ET_dlc_HBtra2tra3
samples = size(tra,1);
hb_tra = NaN(samples,5,size(tra,3)/2);
c= 1;
for i = 1:2:size(tra,3)
    head = tra(:,:,i);
    tail = tra(:,:,i+1);
    qIDXBoth = head(:,3) >=qualCutOff & tail(:,3)>=qualCutOff;
    qIDXHead = head(:,3) >=qualCutOff & tail(:,3) <qualCutOff;
    qIDXTail = head(:,3) < qualCutOff & tail(:,3)>=qualCutOff;
    qIDXNone = head(:,3) < qualCutOff & tail(:,3) <qualCutOff;
    
    if sum(qIDXBoth) > 0
        hb_tra(qIDXBoth,:,c) = [head(qIDXBoth,1:2) tail(qIDXBoth,1:2) mean([head(qIDXBoth,3) tail(qIDXBoth,3)],2)];
    end
    if sum(qIDXHead) > 0
        hb_tra(qIDXHead,:,c) = [head(qIDXHead,1:2) NaN(sum(qIDXHead),2) head(qIDXHead,3)];
    end
    if sum(qIDXTail) > 0
    hb_tra(qIDXTail,:,c) = [NaN(sum(qIDXTail),2) tail(qIDXTail,1:2) tail(qIDXTail,3)];
    end
    if sum(qIDXNone) > 0
    hb_tra(qIDXNone,:,c) = [NaN(sum(qIDXNone),4)  mean([head(qIDXNone,3) tail(qIDXNone,3)],2)];
    end
 
    c = c+1;
end
