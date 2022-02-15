function ts_speed = IV_2Dtrace_calcAnimalSpeed(trace)

trace_len = size(trace,1)-1;

xy_speed = [diff(trace(:,1:2)) zeros(trace_len,1)];
ts_speed = NaN(trace_len,3);

for i =1:trace_len,
    fM = getFickmatrix(trace(i,3)*-1,0,0,'a');
    ts_speed(i,:) = xy_speed(i,:)*fM;
end

ts_speed(:,3) = [];
ts_speed(end+1,:)= NaN;


