function ivT_plot_2DtraHB(anaTRA,step,fps)


lollipopIndex = 1:step:size(anaTRA,1);
if lollipopIndex(end) ~= length(anaTRA), lollipopIndex = [lollipopIndex length(anaTRA)];end
% make collormap
cmap =colormap(darkgray(size(anaTRA,1)));
plot(anaTRA(:,1,2),anaTRA(:,2,2),'b')
hold on

for z = lollipopIndex,
    
    plot(anaTRA(z,1,2),anaTRA(z,2,2),'o','Color',cmap(z,:),'MarkerFaceColor',cmap(z,:))

    
        temp =[anaTRA(z,1:2,2); anaTRA(z,1:2,3)];
        h = line(temp(:,1),temp(:,2));
        set(h, 'Color',cmap(z,:));


end
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


