function meanDur =  FILA_ana_get_medianContractionDuration(contractions,minReps)
logIDX = cellfun(@length,contractions) >minReps;
meanDur = cell2mat(cellfun(@(x) mean(bsxfun(@minus,x(:,3),x(:,1)),1),contractions(logIDX),'UniformOutput',false));
if length(meanDur)< 3,
    meanDur =NaN
else
meanDur = nanmedian(meanDur( round(length(meanDur)/3) : round(length(meanDur)-length(meanDur)/3))     );
end
