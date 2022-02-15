function coords = FILA_ana_getSpine2(boundary,hctPos)
% This function from the fluorescent image larva analysis toolbox (FILA)
% calculates the spine of a polygon in our case the larva. This done by
% using a subset of the boundary coordinates of the larva body as centers
% for a voronoi cell. The resultingcells have a midline border which is an
% approxyimation of the center line of the larva. Unluckily some cells will
% have borders closser to the boundary. We take all points inside the
% polygon using the inpolygon function and filter them heavily with a 3rd
% degree butterworth with cutoff frequency of 0.05.
%
% GETS:
%       boundary = a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background.
%
% RETURNS
%         spline = a mx2 matrix with the central line of the polygon
%
% SYNTAX: spline = FILA_ana_getSpine(boundary)
%
%
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos ->
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos ->
%          FILA_imcrop2boundary->FILA_scaleDownBoundary -> FILA_ana_getSpine
%
% Author: B. Geurten 20.07.2015
%
% see also bwtraceboundary, inpolygon, voronoi, FILA_getLarvaPos

% at maximum we use a polygon with 100 vertices This results on an i7
% processor in a computation time of less 0.1 sec
usedBoundaryPoints = boundary(unique(round(linspace(1,length(boundary),100))),:);
usedBoundaryPoints = filter2DTrace(usedBoundaryPoints,3);

% if fewer points than 400 are found warn the user
% if length(usedBoundaryPoints) < 50,
%     warning(['FILA_ana_getSpine: low number of hull points for spline detection: ' num2str(length(usedBoundaryPoints))])
% end

%voronoi cell detection
warning ('off','all');
[vx,vy] = voronoi(usedBoundaryPoints(:,2),usedBoundaryPoints(:,1));
warning ('on','all');

% now reshape the point from voronoi edges to just a list of points
pointsY = reshape(vx,size(vx,2)*2,1);
pointsX = reshape(vy,size(vy,2)*2,1);

% check if the points are inside the polygon
[in,~]=inpolygon(pointsX,pointsY,boundary(:,1),boundary(:,2));
pointsX = pointsX(in);
pointsY = pointsY(in);
% plot(pointsY,pointsX,'r.')
% plot(boundary(:,2),boundary(:,1),'r')
if ~isempty(pointsX)
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FINDING A DIJKSTRA PATH THROUGH THE SPINE COORDINATES %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % now delete all Duplicates
    coords = unique([pointsX,pointsY],'rows');
    % create a full distance matrix between all coordínates and set the self
    % distance to inifinit
    distMat = Hungarian_getDistMat(coords,coords,'euclidean');
    distMat =bsxfun(@plus,distMat,diag(ones(size(coords,1),1).*inf,0));
    % reduce that full graph by taking the 20% nearset nodes to each node hoping
    % this creates a full path from head to tail
    reducedNeighbourNum = ceil(size(coords,1)*0.2);
    % adj List consists of an ID row and the two rows for the joined nodes
    adjList = [(1:size(coords,1)*reducedNeighbourNum)' zeros(size(coords,1)*reducedNeighbourNum,2)];
    c = 0;
    % now create list with paths
    for i=1:size(coords,1),
        % now sort the distances from node i to all other nodes
        dtemp=sort(distMat(:,i));
        % now reduce the full set of connections to the 20% closest
        for j = 1:reducedNeighbourNum
            c=c+1;
            tIDX = find(distMat(:,i)==dtemp(j));
            adjList(c,2:3) = [i tIDX(1)];
        end
    end
    % The resulting ajList now contains for each node the closest 20% of its
    % connections
    
    % Now we have to define a start point and finish for our dijkstra path. 
    % We tried many things the easiest and most reliable way is to take the
    % longest distance along the spline
    
    %  make copy without infinity values
    distMat2= distMat;
    distMat2(distMat2== inf) = 0;
    %find maximum distance
    distMax = max(max(distMat2));
    % as each value appears 2 times in a full distance matrix it will
    % appear in both points, so we only need the row vector
    [r,~] = find(distMat2 == distMax);
    
    
    
    %Now we calculate the Dijkstra path using an imlementation of Joseph Kirk
    [~,path] = dijkstra2([(1:size(coords,1))' coords],adjList,r(1),r(2));

    coords = coords(path,:);
else
    coords = [];
end