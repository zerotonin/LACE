 function [headPosition,tailPosition] = ET_phA_findFishHead(objectContour,centralLine)
% This function of the Ethotrack posthoc analysis toolbox (ET_phA_) detects
% the fish head of zebra fishes, by measuring the distance between the
% central line of the object and the object contour. Zebrafishes have
% larger heads so the minimal distance to a point in the contour is usually
% smaller at the tail than at the head.
%
% GETS:
%       objectContour = mx2 matrix including all coordinates of the object
%                       contour
%         centralLine = mx2 matrix of the centralline coordinates
%
%
% RETURNS:
%        headPosition = 1x2 vector with the head position
%        tailPosition = 1x2 vector with the tail position
%
% SYNTAX: [headPosition,tailPosition] = ET_phA_findFishHead(objectContour,centralLine); 
%
% Author: B.Geurten 21-01-2016
% 
% Notes:
% This might only work for Zebrafishes!
%
% see also FILA_ana_getSpine


if length(centralLine) < 4
    tailPosition = NaN;
    headPosition = NaN;
else
    
    minD = NaN(size(centralLine,1),1);

    for i =1:size(centralLine,1),
        minD(i) = min(sum(abs(bsxfun(@minus,objectContour,centralLine(i,:))),2));
    end

    terminal1 = sum(minD(1:3));
    terminal2 = sum(minD(end-2:end));

    if terminal1 > terminal2,
        headPosition = centralLine(1,:);
        tailPosition = centralLine(end,:);
    else
        headPosition = centralLine(end,:);
        tailPosition = centralLine(1,:);
    end
end