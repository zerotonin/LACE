function yaw=ivT_correctForgottenYaw(yaw)
% Sometimes during the analysis a user might forget to adjust a manual the
% yaw. In those cases yaw is exactly zero. This zeros are overwritten by
% the closest yaw value.
%
%


%find all real zeros
zeroInd = find(yaw == 0);


for i=1:length(zeroInd);
    
    if zeroInd(i)-1 <0
        yaw(zeroInd(i)) = yaw(zeroInd(i)+1);
    elseif zeroInd(i)+1> length(yaw),
        yaw(zeroInd(i)) = yaw(zeroInd(i)-1);
    else
        yaw(zeroInd(i)) = yaw(zeroInd(i)-1);
    end
end