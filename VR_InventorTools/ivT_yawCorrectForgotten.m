function yaw=ivT_yawCorrectForgotten(yaw)
% Often when ivTrace misses a region the user adds the region but forgets 
% to allign the yaw properly. These yaws are set to exact zero. 
% ASSUMPTION! We assume that in a biological tracing the yaw is next to
% never exact zero. So this function looks for all exact zeros and
% overwrites them with an non zero adjcent yaw value. Thereby we accept
% false positives.
%
% GETS:
%       yaw = a vector containing yaw values.
%
% RETURNS:
%   new_yaw = a vector containing yaw values without exact zeros.
%
% SYNTAX: new_yaw=ivT_yawCorrectForgotten(yaw)
%
% see also ivT_analyse3DwalkingTraces, ivT_unwrapAtan2


%find all real zeros
zeroInd = find(yaw == 0);


for i=1:length(zeroInd);
    % check if the first zero is right at the beginning of the vector
    if zeroInd(i)-1 <=0
        yaw(zeroInd(i)) = yaw(zeroInd(i)+1);
    % check if a zero is right at the end of the vector    
    elseif zeroInd(i)+1 >= length(yaw),
        yaw(zeroInd(i)) = yaw(zeroInd(i)-1);
    % in all other cases use the yaw value before the zero
    else
        yaw(zeroInd(i)) = yaw(zeroInd(i)-1);
    end
end