function h=ET_plot_animals2subplots(frame,frameNumber,traceResult,Nb,figureH,centralLines,headPos)
% This function of the Ethotrack plot toolbox (ET_plot_) plots animal close
% ups in seperate subplots.
%
% GETS:
%         frame = the orignial image used for detection as a mxn matrix
%   frameNumber = the index of the frame in the movie
%   traceResult = a mx13 matrix where m is the number of found animals,
%                 columns are defined as follows:
%                 col  1: x-position in pixel
%                 col  2: y-position in pixel
%                 col  3: major axis length of the fitted ellipse
%                 col  4: minor axis length of the fitted ellipse
%                 col  5: ellipse angle in degree
%                 col  6: quality of the fit
%                 col  7: number of animals believed in their after final
%                         evaluation
%                 col  8: number of animals in the ellipse according to
%                         surface area
%                 col  9: number of animals in the ellipse according to
%                         contour length
%                 col 10: is the animal close to an animal previously traced 
%                         (1 == yes)
%                 col 11: evaluation weighted mean
%                 col 12: detection quality [aU] if
%                 col 13: correction index, 1 if the area had to be
%                         corrected automatically
%            Nb = number of points drawn in ellipse
%       figureH = parent figure handle
%
% RETURNS:
%            hL = handle of subplots
%
% SYNTAX: h=ET_plot_animals2subplots(frame,frameNumber,traceResult,Nb,figureH)
%
% Author: B. Geurten 11-30-15
%
% NOTE:
%
%
% see also  ET_plot_frameNellipses, ET_plot_addEllipse

%get figure handle
if isempty(figureH),
    figureH = figure();
end
clf(figureH)

% convert to single mat mx13
if iscell(traceResult),
    singleResult = traceResult{frameNumber};
else
    singleResult = traceResult(:,:,frameNumber);
end

%make colormap
qual = round(singleResult(:,12).*100)+1;
colorMap = spring(max(qual));

% get subplot rows cols
[r,c]=subplot_getNum(size(singleResult,1));

for i =1:size(singleResult,1)-1,
    % clear axis
    h(i) = subaxis(r,c,i,'SpacingVert',0.01,'SpacingHoriz',0.01);
    cla(gca)
    % plot image
    imagesc(frame,'Parent',gca)
    % set axis
    axis(gca,'image')
    % set colormap
    colormap(gca,gray)
    % add ellipses
    ET_plot_addEllipse(singleResult(i,:),colorMap,Nb,gca,0,0);
    axis([singleResult(i,1)-(singleResult(i,3)+2) singleResult(i,1)+(singleResult(i,3)+2)...
        singleResult(i,2)-(singleResult(i,3)+2) singleResult(i,2)+(singleResult(i,3)+2)]);
    freezeColors
    hold on
    if ~isempty(centralLines)
        cellfun(@(x) plot(x(:,2),x(:,1),'b','LineWidth',2),centralLines);
    end
    if ~isempty(headPos)
        for k =1:size(headPos,1)
            plot(headPos(k,2),headPos(k,1),'bo','MarkerSize',5,'LineWidth',2)
        end
    end
    hold off
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
    title(['animal: ' num2str(i)])
end
% axis
i =i+1;
h(i) = subaxis(r,c,i,'SpacingVert',0.01,'SpacingHoriz',0.01);
cla(gca)
% plot image
imagesc(frame,'Parent',gca)
% set axis
axis(gca,'image')
% set colormap
colormap(gca,gray)
% add ellipses
ET_plot_addEllipse(singleResult(i,:),colorMap,Nb,gca,1,0);
axis([singleResult(i,1)-singleResult(i,3) singleResult(i,1)+singleResult(i,3)...
    singleResult(i,2)-singleResult(i,3) singleResult(i,2)+singleResult(i,3)]);

hold on
if ~isempty(centralLines)
    cellfun(@(x) plot(x(:,2),x(:,1),'b','LineWidth',2),centralLines);
end
if ~isempty(headPos)
    for k =1:size(headPos,1)
        plot(headPos(k,2),headPos(k,1),'bo','MarkerSize',5,'LineWidth',2)
    end
end
hold off
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
title(['animal: ' num2str(i)])