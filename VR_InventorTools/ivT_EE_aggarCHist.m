function result = ivT_EE_aggarCHist(aggar,concentration,varargin)

for i =1:length(varargin),
    if strcmp(varargin{i},'standard')
        concentration = [0.2 5 1 3 1.5 0.5 2 0.7];
    elseif strcmp(varargin{i},'standard_mirrored')
        concentration = [0.7 2 0.5 1.5 3 1 5 0.2];
    elseif strcmp(varargin{i},'standard_180')
        concentration = [1.5 0.5 2 0.7 0.2 5 1 3];
    else
        warning('varargin not recognised')
    end
end

result = NaN(length(concentration),size(aggar,2));
for i =1:length(concentration),
    result(i,:) = sum(aggar == concentration(i),1);
end
result = result ./size(aggar,1);