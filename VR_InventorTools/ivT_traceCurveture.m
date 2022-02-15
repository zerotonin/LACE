function angle = ivT_traceCurveture(tra,shift)

% shift the trace by 2 and by 1 frame and concatenate the 3 traces of
% length(tra)-2 into 1 3D-matrix
traAng = cat(3, tra(1:end-shift,1:2),tra(ceil(shift/2)+1:end-floor(shift/2),1:2),tra(shift+1:end,1:2));
% now calculate the vectors from timepoint t1 to t0 and t2
vAng = cat(3,bsxfun(@minus,traAng(:,:,1),traAng(:,:,2)), bsxfun(@minus,traAng(:,:,3),traAng(:,:,2)));
%normalise the vectors by calculating the norm...
vNorm = sqrt(sum(vAng.^2,2));
% ...amd dividing by it
vAngN = bsxfun(@rdivide,vAng,vNorm);
%now change into a cell format to avoid a for loop
vAngNC =  num2cell(vAngN);
% calculate for each vector pair the dot product-> arcus cosinus and shift
% from radians to degrees
angle =cellfun(@(x,y,x2,y2) rad2deg(acos(dot([x y ],[x2 y2]))),vAngNC(:,1,1),vAngNC(:,2,1),vAngNC(:,1,2),vAngNC(:,2,2));
