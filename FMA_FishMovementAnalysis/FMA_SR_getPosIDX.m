function logIDX = FMA_SR_getPosIDX(ROI,analysedData)

[in,on] = inpolygon(analysedData.trace(:,2),analysedData.trace(:,1),ROI(:,1),ROI(:,2));
logIDX = in | on;