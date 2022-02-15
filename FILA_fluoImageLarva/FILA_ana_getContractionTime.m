function contractions = FILA_ana_getContractionTime(lumSeq,base)
% This function of FILA toolboxe detects the starts and stops of the
% contraction per pixel. The luminence data is  low pass filtered.
% Afterwards the mean value of the luminence is substracted create negative
% and positive peaks that are afterwards detected with find peaks with a
% half maximal threshold.
%
% GETS:
%
%        lumSeq = mxnxp matrix, m = number of features, n is the maximal
%                 image width, p is the number of frames
%          base = feature nb (m in lumSeq)
%
% RETURNS:
%  contractions = cell array with m entries (where m is the number of 
%                 pixels), each entry holds a mx3 matrix wher m is the
%                 number of contractions and the clomuns are start peak
%                 stop.
%
% SYNTAX: contractions= FILA_ana_getContractionTime(lumSeq,base)
%
% Author: B. Geurten 26.2.15
%
% see also FILA_ana_turnHead2right,FILA_ana_getLumSeq,reshape_2Dto3D

 % reshape matrix
 lumSeq = reshape_2Dto3D(lumSeq(base,:,:));
 % filter 
[B,A] = butter(2,.1);
lumSeq =filtfilt(B,A,lumSeq);
 % get mean Luminence
 meanLuminence = nanmean(lumSeq,2);
 lumSeq =bsxfun(@minus,lumSeq,meanLuminence);
 %
 lumCell = mat2cell(lumSeq,size(lumSeq,1),ones(size(lumSeq,2),1));
 [~, locsP] = cellfun(@(x) findpeaks(x,'MinPeakHeight',max(x)/2), lumCell,'UniformOutput',false);
 [~, locsN] = cellfun(@(x) findpeaks(x.*-1,'MinPeakHeight',max(x.*-1)/3,'MinPeakDistance',30),lumCell,'UniformOutput',false);
 %
 contractions = cellfun(@(x,y) FILA_ana_getContractionTime_cleanUp(x,y),locsP,locsN,'UniformOutput',false);

end

function res = FILA_ana_getContractionTime_cleanUp(locP,locN)

res = [];
for i =1:length(locN)-1,
    list = find(locP<locN(i+1) & locP>locN(i));
    if numel(list) == 1,
        res = [res; locN(i) locP(list) locN(i+1)];
    end
        
end

end
