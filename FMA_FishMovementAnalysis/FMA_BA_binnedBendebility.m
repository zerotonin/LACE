function binnedBend = FMA_BA_binnedBendebility(bendability,edges)

% preallocate return variable
binnedBend = NaN(8,length(edges)-1);
% make one giant matrix out of the cells
bendabilityMat = cell2mat(bendability);

% now for every bin calculate minimal, median ,mean max, CI u, CI l,
% standard deviation, standard error of the mean of the bending angle
for i =1:length(edges)-1,
    % get the absolute bedning angle for all angles in this bin of the body
    temp = abs(bendabilityMat(bendabilityMat(:,1)>=edges(i) & bendabilityMat(:,1)<edges(i+1),2));
    if ~isempty(temp),
        
        % calculate confidence interval
        [ciU,ciL] = confintND(temp,1);
        % calculate rest and set to return variable
        binnedBend(:,i) = [min(temp); median(temp); mean(temp); max(temp) ;ciU ;ciL;std(temp);ste(temp,[],1)];
    end
end