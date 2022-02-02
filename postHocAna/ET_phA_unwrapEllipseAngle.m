function yaw = ET_phA_unwrapEllipseAngle(yaw,cutoff)


if isempty(cutoff),
    cutoff = pi/2;
end

m = length(yaw);

% Unwrap phase angles.  Algorithm minimizes the incremental phase variation 
% by constraining it to the range [-pi,pi]
dp = diff(yaw,1,1);                % Incremental phase variations
dps = mod(dp+pi/2,pi) - pi/2;      % Equivalent phase variations in [-pi,pi)
dps(dps==-pi/2 & dp>0,:) = pi/2;     % Preserve variation sign for pi vs. -pi
dp_corr = dps - dp;              % Incremental phase corrections
dp_corr(abs(dp)<cutoff,:) = 0;   % Ignore correction when incr. variation is < CUTOFF

% figure(1),clf
% plot(yaw)
% hold on
% plot(dp,'g')
% plot(dps,'r')
% plot(dp_corr-pi*1.5,'m')

% Integrate corrections and add to P to produce smoothed phase values
yaw(2:m,:) = yaw(2:m,:) + cumsum(dp_corr,1);
% Integrate corrections and add to P to produce smoothed phase values
