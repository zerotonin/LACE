function ivT_plot_2DtraEllipse(anaTRA,step,fps,centerFlag)

if exist('centerFlag','var')
    if centerFlag,
        anaTRA = [bsxfun(@minus,anaTRA(:,1:2,:),repmat(anaTRA(1,1:2,1),[1 1 3])),anaTRA(:,3:end,:)];
    end
end
% make index
lollipopIndex = 1:step:size(anaTRA,1);
if lollipopIndex(end) ~= length(anaTRA), lollipopIndex = [lollipopIndex length(anaTRA)];end
% make collormap
cmap =colormap(darkgray(size(anaTRA,1)));
hold on

for z = lollipopIndex,
    
    plot(anaTRA(z,1,2),anaTRA(z,2,2),'o','Color',cmap(z,:),'MarkerFaceColor',cmap(z,:))
    
    
    
    x1 = anaTRA(z,1,2);
    x2 = anaTRA(z,1,3);
    y1 = anaTRA(z,2,2);
    y2 = anaTRA(z,2,3);
    e = anaTRA(z,5,1);
    
    a = 1/2*sqrt((x2-x1)^2+(y2-y1)^2);
    b = a*sqrt(1-e^2);
    t = linspace(0,2*pi);
    X = a*cos(t);
    Y = b*sin(t);
    w = atan2(y2-y1,x2-x1);
    x = (x1+x2)/2 + X*cos(w) - Y*sin(w);
    y = (y1+y2)/2 + X*sin(w) + Y*cos(w);
    plot(x,y,'Color',cmap(z,:))
    axis equal
    
    
end
plot(anaTRA(:,1,1),anaTRA(:,2,1),'b','LineWidth',2)
xlabel('x [mm]')
ylabel('y [mm]')
axis('equal')
hold off
grid on


h = colorbar;
YTicklabel = get(h,'YTickLabel');
newYTL = NaN(size(YTicklabel,1),1);
for i =1:size(YTicklabel,1),
    newYTL(i) =str2double(YTicklabel(i,:))./fps;
end
set(h,'YTickLabel',newYTL)
set(get(h,'YLabel'),'String','time [s]')
