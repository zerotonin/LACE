function medShape = FMA_BA_medianSshape(bodyShapeSI)

% get median x-Values and confindence interval
xValues = cell2mat(cellfun(@(x) x(:,1)',bodyShapeSI,'UniformOutput',false));
xValMed = median(xValues,1);
[xValUp,xValLow] =confintND(xValues,1);

% get median y-Values and confindence interval
yValues = cell2mat(cellfun(@(x) x(:,2)',bodyShapeSI,'UniformOutput',false));
yValMed = median(yValues,1);
[yValUp,yValLow] =confintND(yValues,1);

%combine to return variable
medShape =cat(3,[xValMed' yValMed'],[xValUp',yValUp'],[xValLow',yValLow']); 