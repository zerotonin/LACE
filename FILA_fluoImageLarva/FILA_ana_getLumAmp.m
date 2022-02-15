function  lumAmp = FILA_ana_getLumAmp(cLocs,sLocs,startsWith,lumMat,type)

if strcmp(startsWith,'compression'),
    lumAmp = NaN(length(cLocs)-1,1);
    for i =1:length(cLocs)-1,
        lumMin = mean(nanmin(lumMat(type,:,[cLocs(i) cLocs(i+1)])),3);
        lumMax = nanmax(lumMat(type,:,sLocs(i)));
        lumAmp(i) = lumMax /lumMin;
       % lumAmp(i) = (lumMax-lumMin) /lumMin;
    end
    
    
else
    
    lumAmp = NaN(length(sLocs)-1,1);
    for i =1:length(sLocs)-1,
        lumMin = mean(nanmin(lumMat(type,:,[sLocs(i) sLocs(i+1)])),3);
        lumMax = nanmax(lumMat(type,:,cLocs(i)));
        lumAmp(i) = lumMax /lumMin;
       % lumAmp(i) = (lumMax-lumMin) /lumMin;
    end
end