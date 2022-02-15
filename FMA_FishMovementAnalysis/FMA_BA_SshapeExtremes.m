function [maxima,minima,steepness] = FMA_BA_SshapeExtremes(bodyShapeS)


% find maxima
[maxima,locMax]  =  cellfun(@(x) findpeaks(x(:,2)),bodyShapeS,'UniformOutput',false );
[~,maxIDX]       =  cellfun(@(x) max(x),maxima,'UniformOutput',false);
maxima = cellfun(@(x,y) x(y),maxima,maxIDX);
locMax = cellfun(@(x,y,z) norm(z(1:x(y),:)),locMax,maxIDX,bodyShapeS);

%find minima
[minima,locMin]  =  cellfun(@(x) findpeaks(x(:,2).*-1),bodyShapeS,'UniformOutput',false );
[~,minIDX]       =  cellfun(@(x) max(x),minima,'UniformOutput',false);
minima = cellfun(@(x,y) x(y),minima,minIDX).*-1;
locMin = cellfun(@(x,y,z) norm(z(1:x(y),:)),locMin,minIDX,bodyShapeS);

%calculate steepness
steepness = bsxfun(@rdivide,bsxfun(@minus,maxima,minima),bsxfun(@minus,locMax,locMin));
maxima = [locMax maxima];
minima = [locMin minima];