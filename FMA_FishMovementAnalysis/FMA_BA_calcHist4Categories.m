function [cumSumAngle,bodyPos]= FMA_BA_calcHist4Categories(bendability,idx,edges)

%make the cumulative sum per cell entry for the three different categories
bendT = cellfun(@(x) sum((x(:,2).*-1)+180),bendability(idx == 2));
bendNotT = cellfun(@(x) sum((x(:,2).*-1)+180),bendability(idx == 3));
bendS = cellfun(@(x) sum((x(:,2).*-1)+180),bendability(idx == 1));

%preallocate
cumSumAngle = NaN(3,length(edges));
% make histograms
[cumSumAngle(1,:),bodyPos] = hist(bendT,edges);
[cumSumAngle(2,:),~] = hist(bendS,edges);
[cumSumAngle(3,:),~] = hist(bendNotT,edges);

% normalise by number of cases
nSum = sum(cumSumAngle,2);
cumSumAngle = bsxfun(@rdivide,cumSumAngle,nSum);