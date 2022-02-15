function [h1,h2] = FMA_plot_reconBinnedBend(axH,centralVal,upperErr,lowerErr,bodyBinLength,alphaF,areaColor,lineColor)

% preallocation
coords = zeros(length(centralVal),2,3);

% if lowerErr is empty, this means that the central value is a mean plus a
% symetrical error value such as standard deviation or errror, otherwise it
% is median and confidence interval
if isempty(lowerErr),
   upperErr = bsxfun(@plus,centralVal,upperErr);
   lowerErr = bsxfun(@minus,centralVal,upperErr);
end

% build coordinates 
mul = fliplr([centralVal;upperErr;lowerErr]);
for i=2:size(coords,1);
    for j =1:size(coords,3),
    coords(i,1,j) = coords(i-1,1,j) - cos(deg2rad(mul(j,i-1))) * bodyBinLength;
    coords(i,2,j) = coords(i-1,2,j) + sin(deg2rad(mul(j,i-1))) * bodyBinLength;
    end
end

%now arrange coordinates for polygon
x = cat(1,coords(:,1,2),flipud(coords(:,1,3)));
y = cat(1,coords(:,2,2),flipud(coords(:,2,3)));

% start plotting
h2 = fill(x,y,areaColor,'LineStyle','none','facealpha',alphaF,'Parent',axH); 
hold(axH,'on');
h1 = plot(axH,coords(:,1,1),coords(:,2,1),'o-','Color',lineColor,'MarkerFaceColor',[0.99 0.99 0.99],'MarkerEdgecolor',lineColor);
hold(axH,'off');