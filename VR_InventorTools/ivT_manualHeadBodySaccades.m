function saccIndex = ivT_manualHeadBodySaccades(trajAll)

% prepare figure
h = figure();
saccIndex = cell(size(trajAll,1),1);

for i =1:size(trajAll,1),
    
    bodyIndex = trajAll{i,2}(:,1);
    headIndex = trajAll{i,1}(:,1);
    bodyYaw = trajAll{i,2}(:,5);
    headYaw = trajAll{i,1}(:,5);
    bodyYawVel = trajAll{i,2}(:,11);
    headYawVel = trajAll{i,1}(:,11);
    
    saccIndex{i} =   ivT_SR_getManualSaccadeIndex(h,bodyIndex,headIndex,bodyYaw,headYaw,bodyYawVel,headYawVel);
end

%close figure
close(h)
end

function saccIndex = ivT_SR_getManualSaccadeIndex(h,bodyIndex,headIndex,bodyYaw,headYaw,bodyYawVel,headYawVel)

goOn = 1;

saccIndex = [];

currentFrame = headIndex(25);

yawExtremes = [min([headYaw;bodyYaw]) max([headYaw;bodyYaw])];

headlen = length(headYaw)-25;
bodylen = length(bodyYaw)-25;

while goOn,
    
    
    currentHIDX = find(headIndex == currentFrame);
    currentBIDX = find(bodyIndex == currentFrame);
    figure(h),clf;
    subplot(2,3,[1:2 4:5])
    plot(headIndex,headYaw,'b')
    hold on
    plot(bodyIndex,bodyYaw,'g')
    for i =1:length(saccIndex)
        
        hl = line([saccIndex(i) saccIndex(i)],yawExtremes);
        set(hl,'color','k')
    end
    hl = line([currentFrame currentFrame],yawExtremes);
    set(hl,'color','r')
    if currentHIDX >25 && currentBIDX >25 && currentHIDX < headlen && currentBIDX < bodylen,
        subplot(2,3,3)
        plot(-50:2:50,bodyYawVel(currentBIDX-25:currentBIDX+25),'g')
        hold on
        plot(-50:2:50,headYawVel(currentBIDX-25:currentBIDX+25),'b')
        line([0 0],[min(headYawVel(currentBIDX-25:currentBIDX+25)) max(headYawVel(currentBIDX-25:currentBIDX+25))])
        hold off
        ylabel('yaw vel [deg*s^-^1]')
        subplot(2,3,6)
        plot(-50:2:50,bodyYaw(currentBIDX-25:currentBIDX+25),'g')
        hold on
        plot(-50:2:50,headYaw(currentBIDX-25:currentBIDX+25),'b')
        hold off
        ylabel('yaw angle [deg]')
        xlabel('time [ms]')
        
    end
    
    [~,~,button] = ginput(1);
    
    
    switch button,
        case 28,
            currentFrame = currentFrame -1;
        case 29,
            currentFrame = currentFrame +1;
        case 27,
            goOn = 0;
        case 32,
            saccIndex = [saccIndex; currentFrame];
        case 31;
            currentFrame = currentFrame -10;
        case 30,
            currentFrame = currentFrame +10;
            
    end
    
    if currentFrame < headIndex(1),
        currentFrame = headIndex(1);
    elseif currentFrame > headIndex(end),
        currentFrame = headIndex(end);
    end
    
end
end