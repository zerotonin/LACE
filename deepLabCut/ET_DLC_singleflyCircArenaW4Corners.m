function traF = ET_DLC_singleflyCircArenaW4Corners(fPosFly,fPosArena,mmDiameter)

% get trajectories
traF = ET_DLC_openTra(fPosFly);
traA = ET_DLC_openTra(fPosArena);

%get center of arena
centerPoint = median(mean(traA(:,1:2,:),3),1);

% set center to (0,0)
traF(:,1:2,:) = bsxfun(@minus,traF(:,1:2,:),centerPoint);
traA(:,1:2,:) = bsxfun(@minus,traA(:,1:2,:),centerPoint);

% calculate pix 2mm factor

% get corners 
corners = reshape_2Dto3D(median(traA,1));
%get vector norm
normVertical = sqrt(sum(bsxfun(@minus,corners(3,1:2),corners(1,1:2)).^2));
normHorizontal = sqrt(sum(bsxfun(@minus,corners(2,1:2),corners(4,1:2)).^2));
%get factor
pix2mm = mmDiameter/(mean([normHorizontal normVertical]));

traF(:,1:2) = traF(:,1:2).*pix2mm;