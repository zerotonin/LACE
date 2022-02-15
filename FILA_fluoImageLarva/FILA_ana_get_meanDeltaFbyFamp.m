function contractLum =  FILA_ana_get_meanDeltaFbyFamp(deltaFbyF,contractions,minReps)

dFbF_cell = mat2cell(deltaFbyF,size(deltaFbyF,1),ones(size(deltaFbyF,2),1));
logIDX = cellfun(@length,contractions) >minReps;
contractLum=cell2mat(cellfun(@(x,y) mean(x(y(:,2))),dFbF_cell(logIDX),contractions(logIDX),'UniformOutput',false));
if length(contractLum)< 3,
    contractLum = NaN;
else
contractLum = nanmedian(contractLum( round(length(contractLum)/3) : round(length(contractLum)-length(contractLum)/3))     );
end