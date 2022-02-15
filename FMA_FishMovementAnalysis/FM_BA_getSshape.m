function [bodyShapeS,bodyShapeSI,SshapeIDX] =FM_BA_getSshape(logIDX,analysedData,minBend)
% This function looks through a given trace result structure and extracts
% all frames which show the animal in a typical s-bend. Furthermore it
% flips all S-bends so that the animal is first bend to the left and then
% to the right. All those curves are than interpolated with a spline
% method.

% default minimal bending value
if isempty(minBend) || ~exist('minBend','var'),
    minBend = 0.01;
end

if sum(logIDX) ~=0
    % get body line
    % the following two lines might be superfluous
    headFlipIDX = cellfun(@(x,y) sum(bsxfun(@minus,x{1}(1,:),y)) ~=0,analysedData.traceResult(:,3),analysedData.traceResult(:,5));
    analysedData.traceResult(headFlipIDX,3) = cellfun(@(x,y) flipud(x{1}(1,:)),analysedData.traceResult(headFlipIDX,3),'UniformOutput',false);
    if sum(isnan(logIDX)) ==0,
        bodyShape = analysedData.traceResult(logIDX,3);
    else
        bodyShape = analysedData.traceResult(:,3);
    end
    bodyShape = [bodyShape{:}]';
    
    % set head to be at (0,0)
    bodyShape = cellfun(@(x) bsxfun(@minus,x,x(1,:)),bodyShape,'UniformOutput',false);
    
    %rotate tale to x = 0
    angle = cellfun(@(x) atan2(x(end,2),x(end,1)),bodyShape,'UniformOutput',false);
    rotMat = cellfun(@(x) getFickmatrix(x,0,0,'a'),angle,'UniformOutput',false);
    bodyShape = cellfun(@(x,y) [x zeros(size(x,1),1)]*y,bodyShape,rotMat,'UniformOutput',false);
    bodyShape = cellfun(@(x) x(:,1:2),bodyShape,'UniformOutput',false); % when rotating we have to go 2D->3D->2D
    
    %normalise the bodylength to a vector sum of 1
    fishLen = cellfun(@(x) norm(x(:,1:2)),bodyShape,'UniformOutput',false);
    bodyShape =cellfun(@(x,y) x(:,1:2)./y,bodyShape,fishLen,'UniformOutput',false);
    
    %find only S shaped bodies
    minBendIDX = cellfun(@(x) sum(abs(x(:,2))>minBend)>2,bodyShape); % at least two values are above the bending threshold
    SshapeIDX  = cellfun(@(x) sign(x(:,2)),bodyShape,'UniformOutput',false); % get bending direction
    SshapeIDX  = cellfun(@(x) (length(find(x == -1)) >2) & (length(find(x == 1))>2),SshapeIDX); % at least two values of directions
    SshapeIDX     = SshapeIDX & minBendIDX;
    
    %if nothing is found set to NaN
    if sum(SshapeIDX) == 0,
        bodyShapeS=NaN;
        bodyShapeSI=NaN;
        SshapeIDX =NaN;
    else
        bodyShapeS = bodyShape(SshapeIDX);
        % fishLen = fishLen(SshapeIDX);
        
        %swap s shape direction so that all s shapes begin with a minima
        [~,locs]  =  cellfun(@(x) findpeaks(x(:,2)),bodyShapeS,'UniformOutput',false );
        dirIDX = cellfun(@(x) x(1) <6,locs);
        bodyShapeS(dirIDX) = cellfun(@(x) [x(:,1) x(:,2).*-1],bodyShapeS(dirIDX),'UniformOutput',false );
        
        % spline interpolate
        XI = cellfun(@(x) linspace(x(1,1),x(end,1),20),bodyShapeS,'UniformOutput',false );
        bodyShapeSI = cellfun(@(x,xI) [xI' interp1(x(:,1),x(:,2),xI,'spline')'],bodyShapeS,XI,'UniformOutput',false );
        
    end
else
    bodyShapeS=NaN;
    bodyShapeSI=NaN;
    SshapeIDX =NaN;
    
end
