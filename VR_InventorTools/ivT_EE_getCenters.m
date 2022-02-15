function centers = ivT_EE_getCenters(bgPic,animalNo)


goOn = 1;

while goOn,
    figure(1),clf
    imshow(bgPic)
    [x,y] = ginput(animalNo);
    hold on
    plot(x,y,'bo')
    for i=1:animalNo,
        text(x(i)+10,y(i)+10, num2str(i-1));
    end
    
    centers = [x,y];
    
    
    % Construct a questdlg with three options
    choice = questdlg('Are you satisfied with these centers?', ...
        'Go on ?', ...
        'Yes','Retry','Abort','Yes');
    % Handle response
    switch choice
        case 'Yes'
            goOn = 0;
        case 'Retry'
            goOn = 1;
        case 'Abort'
            centers = [];
            goOn = 0;
    end
end