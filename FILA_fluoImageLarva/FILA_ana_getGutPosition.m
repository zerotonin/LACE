function gutCenter = FILA_ana_getGutPosition(cropImage,outterBoundary,hctPos,spline)
% This function from the fluorescent image larva analysis toolbox (FILA)
% crops the image to the larval body wall so that one can track the dark
% spots in close to the bodywall. This is done by using to
%
% GETS:
%      cropImage = the cropped larva image as returned by FILA_imcrop2boundary
% outterboundary = a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background.
%
% RETURNS:
%     gutCenters = mx2 matrix holding the coordinates of the gut
%                  center
%     gutBoudary =  mx2 matrix with coordinates of the gut boundary
%
% SYNTAX: [gutCenter,hgutBoundary] = FILA_ana_getGutPosition(cropImage,outterBoundary)
%
%
% EXAMPLE: ImageStack -> imread -> FILA_getLarvaPos ->
%          FILA_turnImage2LarvaOrient -> FILA_getLarvaPos ->
%          FILA_imcrop2boundary->FILA_ana_getGutPosition
%
% Author: B. Geurten 21.07.2015
%
% see also bwtraceboundary, sub2ind


% create empty logical Index for outterBoundary
logIDX = zeros(size(cropImage,1),size(cropImage,2));

%now set the boundary to be one
logIDX(sub2ind(size(cropImage),outterBoundary(:,1),outterBoundary(:,2)) ) = 1;

%than fillup the boundary and set everything to logical true that is a one
%in the picture
logIDX_iB = imfill(logIDX);


% now use the inverse logical index to set the background to zero
cropImage(~logIDX_iB) = 0;

%normalise the contrast
cropImage  = ET_im_normImage(cropImage);

%get the image brightness intesity along the spline
[siY,siX,splineIntensity] = improfile(cropImage,spline(:,2),spline(:,1));
%filter and flip (as we can only detect peaks not minima)
[B,A] =butter(2,0.025);
splineIntensityF= filtfilt(B,A,splineIntensity).*-1;

[minimaPeak,minimaOcc] = findpeaks(splineIntensityF);

bodyQuarter = round(length(splineIntensityF)/4);
logIDX = (minimaOcc>bodyQuarter & minimaOcc< bodyQuarter*2);
minimaPeak = minimaPeak(logIDX);
minimaOcc = minimaOcc(logIDX);
[~,logIDX] = max(minimaPeak);
% 
% figure(1),clf
% plot(splineIntensity)
% hold on
% plot(splineIntensityF.*-1,'g')
% plot(minimaOcc,minimaPeak.*-1,'go')
% plot(minimaOcc(logIDX),minimaPeak(logIDX).*-1,'rs')

gutCenter =[siX(minimaOcc(logIDX)),siY(minimaOcc(logIDX))];
% figure(1),clf
% imshow(cropImage)
% hold on; plot(spline(:,2),spline(:,1),'b')
% plot(gutCenter(:,2),gutCenter(:,1),'rp')
% filter to avoid noise at local minima

% %binarise at 35%
% bodyCenter = im2bw(cropImage,0.4);
% 
% %close image objects it up
% seD = strel('disk',4);
% %close fields
% bodyCenter = imerode(bodyCenter,seD);
% bodyCenter = imdilate(bodyCenter,seD);
% %inverse
% bodyCenter = ~bodyCenter;
% bodyCenter(~logIDX_iB) = 0;
% %delete hull
% seD = strel('disk',5);
% bodyCenter = imerode(bodyCenter,seD);
% bodyCenter = imdilate(bodyCenter,seD);
% %get bright objects
% boundary = bwboundaries(bodyCenter,'noholes');
% if ~isempty(boundary)
%     
%     bouLen = cellfun(@(x) size(x,1),boundary);
%     boundary = boundary(bouLen >10);
%     
%     bouCenters = cell2mat(cellfun(@(x) geomean(x),boundary,'UniformOutput',false));
%     distMat = Hungarian_getDistMat(bouCenters,hctPos(2,:),'euclidean');
%     [~,i] = min(distMat);
%     
%     
%     gutBoundary = boundary{i};
%     % calculate the  mean of the boundary to find the center
%     gutCenter = bouCenters(i,:);
% else
%     gutBoundary = NaN;
%     % calculate the  mean of the boundary to find the center
%     gutCenter = NaN;
% end
% 
% % get the objects inside the central part of the larva ...
% gutBoundary = bwboundaries(bodyCenter,'noholes');
% % ... and choose the biggest
% bsize = cellfun(@length,gutBoundary);
% gutBoundary = cell2mat(gutBoundary(bsize==max(bsize)));
% 
% 
% % calculate the  mean of the boundary to find the center
% gutCenter = geomean(gutBoundary,1);

