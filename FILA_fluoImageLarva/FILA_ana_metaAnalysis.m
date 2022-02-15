function [medianDur,meanContractLum,bodyLen] = FILA_ana_metaAnalysis(data,base,minReps)
%mat2cell
dataC = struct2cell(data);

%turn the head
dataC =FILA_ana_turnHead2right(dataC);
%get body length
bodyLen = cellfun(@(x) size(x,2) - sum(isnan(x(base,:))),dataC(4,:) );cellfun(@(x) max(x(:,2)) - min(x(:,2)),dataC(2,:));
f0 = prctile(bodyLen,25,2);
bodyLen = bsxfun(@rdivide,bsxfun(@minus,bodyLen,f0),f0);
[pks,locs]=findpeaks(bodyLen,'MinPeakHeight',0.04,'MinPeakDistance',30);
bodyLen=[nanmean(diff(locs)) nanmean(pks)];
% get LumSeq
lumSeq = FILA_ana_getLumSeq(dataC);
% get contraction duration
contractions = FILA_ana_getContractionTime(lumSeq,base);
% lumSeq 2 deltaF
deltaFbyF =  FILA_ana_lumSeq2deltaFbyF(lumSeq,base);
%calculate pixelwise duration and luminence
medianDur =  FILA_ana_get_medianContractionDuration(contractions,minReps);
meanContractLum =  FILA_ana_get_meanDeltaFbyFamp(deltaFbyF,contractions,minReps);

