function [hctPos,pixRatio,ellipse_t] = FILA_getMouthPos(image,boundary)
% This function from the fluorescent image larva analysis toolbox (FILA)
% detects the head and tail end of the larva. As both ends have different
% luminence values, because the tail is thicker and the head cotains the
% dark mouth hooks. Counting the white pixels in a BW version of both ends
% should give away the head position.
%
% GETS:
%          image = a matlab image variable, turned so that the larva is
%                  horizontally, as returned by FILA_turnImage2LarvaOrient
%       boundary = a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background, as produced by
%                  FILA_getLarvaPos
%
% RETURNS:
%         hctPos = a 3x2 vector where the columns contain the x and y
%                  position respectively. First row is the head position,
%                  2nd row contains the center of the ellipse and the last
%                  row contains the tail position.
%      ellipse_t = a fit struct containing all important information about
%                  the fitted ellipse as returned by fit_ellipse
%       pixRatio = a scalar 0->1 showing the difference of both pixel
%                  counts between the two search areas if it reaches more
%                  than 0.9 the detection mechanismn needs to be
%                  supervised.
%
% SYNTAX: [hctPos,pixRatio,ellipse_t,leftSearchArea,rightSearchArea] = ...
%                   FILA_getMouthPos(image,boundary);
%
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos -> 
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos -> 
%          FILA_imcrop2boundary->FILA_scaleDownBoundary -> FILA_getMouthPos
%
% Author: B. Geurten 22.01.2015
%
% see also imrot, FILA_getLarvaPos,fit_ellipse

% fit ellipse to the boundary
ellipse_t = fit_ellipse(boundary(:,1),boundary(:,2));

% take center of the ellipse
center = round([ ellipse_t.X0_in ellipse_t.Y0_in]);

%calculate point clossestto the intersection of the elipse long axis and
%the object boundary
extremes = [ellipse_t.X0_in + cos(ellipse_t.phi*-1)*(ellipse_t.long_axis/2)  ellipse_t.Y0_in + sin(ellipse_t.phi*-1)*(ellipse_t.long_axis/2);...
    ellipse_t.X0_in + cos(ellipse_t.phi*-1)*(ellipse_t.long_axis*-0.5)  ellipse_t.Y0_in + sin(ellipse_t.phi*-1)*(ellipse_t.long_axis*-0.5)];
distMat = Hungarian_getDistMat(boundary,extremes,'euclidean');
[~,i] =min(distMat);
extremes= boundary(i,:);

% search windows are 10% of the ellipses major axis horizontally
windowH = floor(ellipse_t.short_axis/2);

% getting searchAreas
searchAreas =cell(2,1);
for i =1:2,
temp =[extremes(i,:)-windowH; extremes(i,:)+windowH];
temp(temp<1) = 1;
temp(temp(:,1)>size(image,1),1) = size(image,1);
temp(temp(:,2)>size(image,2),2) = size(image,2);
searchAreas{i} = temp;
end


% getting binarising areas
%[level, ~] = graythresh(image);
level = 0.5;
binAreas =cell(2,1);
for i =1:2,
    binAreas{i} = im2bw(image(searchAreas{i}(1,1):searchAreas{i}(2,1),searchAreas{i}(1,2):searchAreas{i}(2,2)),level);
end

% fraction of white pixels
pixelSums = cellfun(@(x) sum(sum(x))/numel(x),binAreas);


% The head is smaller and has the dark mouth hooks inside. Therefore it
% should always produce a smaller pixel sum than the abdomen
if pixelSums(1) < pixelSums(2),
    % The ratio in a stretched animal is approx. 0.6 if this is far higher
    % the pixel sums are to identical to be sure what is tail and what is
    % abdomen
    pixRatio =  pixelSums(1)/pixelSums(2);
    if pixRatio >0.9,
        warning('FILA_getMouthPos:head-tail-differentiation is weak!')
    end
    hctPos = [extremes(2,:);  center; extremes(1,:)];
else
    % The ratio in a stretched animal is approx. 0.6 if this is far higher
    % the pixel sums are to identical to be sure what is tail and what is
    % abdomen
    pixRatio = pixelSums(2)/pixelSums(1);
    if  pixRatio>0.9,
        warning('FILA_getMouthPos:head-tail-differentiation is weak!')
    end
    hctPos = [extremes(1,:);  center; extremes(2,:)];
end