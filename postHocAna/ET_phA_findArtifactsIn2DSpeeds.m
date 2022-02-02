function [start,stop,artIDX] = ET_phA_findArtifactsIn2DSpeeds(tra,threshold,halfWidth)


speed = abs(sum(diff(tra(:,1:2),1),2));
artIDX = speed > threshold;
artIDX2 = artIDX;
for i = 2:halfWidth,
    artIDX2 = [artIDX2 artIDX([ones(1,i) 1:end-i]) artIDX([i:end ones(1,i-1).*length(artIDX)])  ];
end
artIDX = sum(artIDX2,2) ~=0;
[start,stop] = getSigStartsEnds(artIDX);