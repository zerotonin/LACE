function [headPosition,tailPosition, bodyLine, contourLine] ...
                            = ET_phA_findFlyHead(frame,angleCorrection,...
                              splitterMin,splitterImagesC,objectContours,useFilterFlag)
% This function of the Ethotrack posthoc analysis toolbox (ET_phA_) detects
% the head of Drosophila, by measuring the distance between the central 
% line of the inner body (darkest part) and the outter contour lighter
% part (including the wings). If the ends of both lines are far appart this
% indicates the abdomen, because of the wings.
%
% GETS:
%       objectContour = mx2 matrix including all coordinates of the object
%                       contour
%         centralLine = mx2 matrix of the centralline coordinates
%
%
% RETURNS:
%        headPosition = 2x2 vector with the head position
%        tailPosition = 2x2 vector with the tail position
%            bodyLine =
%         contourLine =
%
% SYNTAX: [headPosition,tailPosition] = ET_phA_findFishHead(objectContour,centralLine);
%
% Author: B.Geurten 1-2-2016
%
%
% see also FILA_ana_getSpine


if ~exist('useFilterFlag','var')
    useFilterFlag = 1;
end

% rotate image as the original frame is usually not rotated but the
% binarised one
frameR = ET_im_rotate(frame,angleCorrection);

%calculate filter for later use with contours
[B,A] = butter(2,0.05);


%preallocation
numObj = length(objectContours);
bodyLine = cell(numObj,1);
contourLine = cell(numObj,1);
headPosition = NaN(2,2,numObj);
tailPosition = NaN(2,2,numObj);

% go through all found animals
for i=1:numObj,
    % get the split image surrounding the fly, splitterImages only contain
    % binarised stuff
    rawImage = frameR(splitterMin{i}(1):splitterMin{i}(1)+size(splitterImagesC{i},1)-1,...
        splitterMin{i}(2):splitterMin{i}(2)+size(splitterImagesC{i},2)-1);
    % normalise the split imahge
    rawImage = ET_im_normImage(rawImage);
    % now binarise it including the wings
    imageBinA =  rawImage < median(rawImage(1:numel(rawImage)))/1.5;
    % detect the contour of wings+body
    body = ET_HTD_detectObjectContours(imageBinA);
    % pick the biggest area contour found
    [pixX,pixY] =find( ones(size(splitterImagesC{i})));
    abdArea = cellfun(@(x)sum(inpolygon(pixX,pixY,x(:,1),x(:,2))),body);
    idx = abdArea == max(abdArea);
    body = body{idx};
    
    % now reform contour to coordinates of the split image
    contour = [objectContours{i}([1:end 1],1)-splitterMin{i}(1), ...
        objectContours{i}([1:end 1],2)-splitterMin{i}(2)];
    
    % get the central lines from filtered contours
    try,
        if useFilterFlag ==1,
            
            contourLineTemp = FILA_ana_getSpine(filtfilt(B,A,contour));
            bodyLineTemp = FILA_ana_getSpine(filtfilt(B,A,body));
        else
            contourLineTemp = FILA_ana_getSpine(contour);
            bodyLineTemp = FILA_ana_getSpine(body);
        end
    catch
        warning('Error in ET_phA_findFlyHead (line 72): fly head detection failed')
        contourLineTemp = [];
        bodyLineTemp    = [];
    end
    
    
    if isempty(bodyLineTemp) && isempty(contourLineTemp),
    bodyLine{i}         = [];
    contourLine{i}      = [];
    headPosition(:,:,i) = NaN(2,2);
    tailPosition(:,:,i) = NaN(2,2);
        
    elseif isempty(bodyLineTemp),
    bodyLine{i}         = [];
    contourLine{i}      =  bsxfun(@plus,contourLineTemp,splitterMin{i});
    headPosition(:,:,i) = NaN(2,2);
    tailPosition(:,:,i) = NaN(2,2);
        
    elseif isempty(contourLineTemp),
    bodyLine{i}         = bsxfun(@plus,bodyLineTemp,splitterMin{i});
    contourLine{i}      = [];
    headPosition(:,:,i) = NaN(2,2);
    tailPosition(:,:,i) = NaN(2,2);
    else,
    % create a distance matrix between all ends of both lines
    distmat = Hungarian_getDistMat(bodyLineTemp([1 end],:),contourLineTemp([1 end],:),'euclidean');
    % the shortest distance between all points hsould be the one of the two
    % line ends at the head
    idx = sort(distmat(1:numel(distmat)));
    [bodyH, contourH] = find(distmat==idx(1));
    
    % now get the right coordinate for the body line...
    if bodyH ==1,
        bodyH = bodyLineTemp(1,:);
        bodyT = bodyLineTemp(end,:);
    else
        bodyH = bodyLineTemp(end,:);
        bodyT = bodyLineTemp(1,:);
    end
    % ...and the contour line
    if contourH ==1,
        contourH = contourLineTemp(1,:);
        contourT = contourLineTemp(end,:);
    else
        contourH = contourLineTemp(end,:);
        contourT = contourLineTemp(1,:);
    end
    
    % save head positions and add the splittermin value to calculate real image
    % coordinates
    headPosition(:,:,i) = bsxfun(@plus,[bodyH;contourH],splitterMin{i});
    tailPosition(:,:,i) = bsxfun(@plus,[bodyT;contourT],splitterMin{i});
    %save central lines and add the splittermin value to calculate real image
    bodyLine{i} = bsxfun(@plus,bodyLineTemp,splitterMin{i});
    contourLine{i} = bsxfun(@plus,contourLineTemp,splitterMin{i});
    end
end
