function ivT_plot_2Dtra(anaTRA,fps,lolliN,mapChoice,cBFlag,tailLength)
% This function plots a two dimensional trajectory consisting of the pixel
% coordinates and the rotational angle of the object. 
%
% GETS:
%    anaTRA = mx3xp where m is the number of frames | col(1) x-pixel-coords
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
%
% SYNTAX: ivT_plot_2Dtra(anaTRA,fps,lolliN,mapChoice,cBFlag,tailLength)
%
% Author: B. Geurten 25.7.15
%
% see also ivT_traj2movFrames,ivT_plot_2DtraEllipse

% make index
switch numel(lolliN)
    case 1
        lollipopIndex = unique(round(linspace(1,size(anaTRA,1),lolliN)));
        if lollipopIndex(end) ~= length(anaTRA), lollipopIndex = [lollipopIndex length(anaTRA)];end
        % make collormap
        switch mapChoice
            case 1                
        cmap =colormap(darkgray(size(anaTRA,1)));
            case 2                
        cmap =colormap(jet(size(anaTRA,1)));
            case 3                
        cmap =colormap(summer(size(anaTRA,1)));
        end
    case 2
        lollipopIndex = 1:lolliN(1):lolliN(2);
        lollipopIndex(lollipopIndex>size(anaTRA,1)) = [];
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

hold on

if exist('tailLength','var'),
    if ~isempty(tailLength),
        x= [tailLength 0 0]';
    else
        
        maxDist = max([ max(anaTRA(:,1))-min(anaTRA(:,1)) max(anaTRA(:,2))-min(anaTRA(:,2))]);
        x= [maxDist*0.05 0 0]';
    end
    
else
    maxDist = max([ max(anaTRA(:,1))-min(anaTRA(:,1)) max(anaTRA(:,2))-min(anaTRA(:,2))]);
    x= [maxDist*0.05 0 0]';
end


plot(anaTRA(:,1,1),anaTRA(:,2,1),'b','LineWidth',2)
for z = lollipopIndex,
    
    
    
    rot_mat = getFickmatrix(anaTRA(z,3),0,0,'p');
    x_temp = rot_mat * x;
    x_orient = bsxfun(@plus,x_temp(1:2)',anaTRA(z,1:2));
    plot([anaTRA(z,1) x_orient(1)],[anaTRA(z,2) x_orient(2)],'Color',cmap(z,:))
    plot(anaTRA(z,1),anaTRA(z,2),'o','Color',cmap(z,:),'MarkerFaceColor',cmap(z,:))
    
end
axis('equal')
hold off
grid on
set(gca,'xaxisLocation','top')

if cBFlag,
    ax=gca;
    pos=get(gca,'pos');
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