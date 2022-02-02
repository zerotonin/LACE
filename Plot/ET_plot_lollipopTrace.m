function ET_plot_lollipopTrace(trace,fps,lolliN,mapChoice,cBFlag,tailLength,axisH)
% This function plots a two dimensional trajectory consisting of the pixel
% coordinates and the rotational angle of the object. 
%
% GETS:
%     trace = mx3xp where m is the number of frames | col(1) x-pixel-coords
%             | col(2) y-pixel-coords | col(3) yaw in radians and unwrapped
%             with ivT_unwrapYaw
%       fps = scalar frames per second
%    lolliN = if set to be a scalar it shows you how many lollipops will be
%             spaced over the trajectory. If set to be 2 element array the
%             first number tells you distance between two lollipops the
%             second number the position of the last lollipop
% mapChoice = if set to 1 the lollipos will be color coded in darkgray | 2)
%             jet | 3) summer
%    cBFlag = if set to 1 a colorbar will be plotted at the southern
%             position
%tailLength = how long the stick of the lollipop should be, if empty or not
%             set it is set to 5% of the maximal distance in the
%             trajectory
%     axisH = handle of the axis object
%
% SYNTAX: ET_plot_lollipopTrace(trace,fps,lolliN,mapChoice,cBFlag,tailLength)
%
% Author: B. Geurten 25.7.15
%
% see also ivT_traj2movFrames,ivT_plot_2DtraEllipse

% make index
switch numel(lolliN)
    case 1
        lollipopIndex = unique(round(linspace(1,size(trace,1),lolliN)));
        if lollipopIndex(end) ~= size(trace,1), lollipopIndex = [lollipopIndex size(trace,1)];end
        % make collormap
        switch mapChoice
            case 1                
        cmap =colormap(darkgray(size(trace,1)));
            case 2                
        cmap =colormap(jet(size(trace,1)));
            case 3                
        cmap =colormap(summer(size(trace,1)));
        end
    case 2
        lollipopIndex = 1:lolliN(1):lolliN(2);
        lollipopIndex(lollipopIndex>size(trace,1)) = [];
        % make collormap
        switch mapChoice
            case 1                
        cmap =colormap(darkgray(lolliN(2)));
            case 2                
        cmap =colormap(jet(lolliN(2)));
            case 3                
        cmap =colormap(summer(lolliN(2)));
        end
    otherwise
        error('ivT_plot_2Dtra: the lolliN matrix should have 1 or 2 elements');
end


if exist('tailLength','var'),
    if isempty(tailLength),
        maxDist = max([ max(trace(:,1))-min(trace(:,1)) max(trace(:,2))-min(trace(:,2))]);
        tailLength = maxDist*0.1;
    end
    
else
    maxDist = max([ max(trace(:,1))-min(trace(:,1)) max(trace(:,2))-min(trace(:,2))]);
    tailLength = maxDist*0.1 ;
end


hold on
for animalNumber = 1:size(trace,3),
    plot(axisH, trace(:,1,animalNumber),trace(:,2,animalNumber),'b','LineWidth',2)
    for z = lollipopIndex,
        h = ET_plot_lollipop(trace(z,1,animalNumber),trace(z,2,animalNumber),trace(z,3,animalNumber),tailLength,cmap(z,:),axisH);
    end
end
axis(axisH, 'equal')
grid(axisH, 'on')
hold(axisH, 'off')
set(axisH,'YDir','reverse')
axis(axisH, 'tight')
if cBFlag,
    set(axisH, 'xaxisLocation','top')
    pos=get(axisH,'pos');
    %set(gca,'pos',[pos(1) pos(2)+pos(4)*0.05 pos(3) pos(4)*0.95]);
    
    h=colorbar('location','southoutside','position',[pos(1) pos(2)-pos(4)*0.05  pos(3) pos(4)*0.05 ]);
    set(get(h,'XLabel'),'String','time [s]')
    
    % h = colorbar('Location','SouthOutside');
    XTicklabel = get(h,'XTickLabel');
    newXTL = NaN(size(XTicklabel,1),1);
    for i =1:size(XTicklabel,1),
        newXTL(i) =str2double(XTicklabel(i,:))./fps;
    end
    set(h,'XTickLabel',newXTL)
    set(get(h,'XLabel'),'String','time [s]')
end