function theta = ivT_EE_centerTRA2theta(traceC)

[rows,~,flyNum] = size(traceC);
theta = NaN(rows,flyNum);

for i =1:flyNum,
    theta(:,i) = atan2(traceC(:,2,i),traceC(:,1,i));
end