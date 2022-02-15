function FMA_plot_manCatBendingHist(figH,bodyPos,cumSumAngle,percentage)



clf(figH);
% barplot
h = subplot(1,4,1);
bar(percentage);
labels = {'during saccades','during thrust','during neither'};
set(gca,'XTickLabel', labels)
ylabel('data percentage')
rotateticklabel(h,60);

% plot histograms
subplot(1,4,[2:4])
hold on
for i =1:3,
    stairs(bodyPos,cumSumAngle(i,:),'Color',paletteKeiIto(i+1))
end
hold off
xlabel('cumulative bending angle [deg]')
ylabel('fraction of the data')    
legend(labels)