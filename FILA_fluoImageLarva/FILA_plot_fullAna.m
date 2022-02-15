function FILA_plot_fullAna(h,imageL,anaRes)
% This function from the fluorescent image larva analysis toolbox (FILA) 
% combines the whole toolbox functions and completely analysis 1 frame.
% Basically it detects the larvae arranges it horizontally takes the 
%
% GETS:
%              h = figure handle
%          image = a matlab image variable
%         anaRes = a struct containing the full analysis as returned by
%                  FILA_fullImageAnalysis
%
% SYNTAX: FILA_plot_fullAna(h,imageL,anaRes);
%
% Author: B. Geurten 22.01.2015
%
% see also FILA_fullImageAnalysis,subaxis

%clear figure
figure(h),clf

% plot the ellipse fit
subaxis(3,2,1)
imagesc(anaRes.image);
colormap gray
axis image
hold on
ellipse_t = anaRes.ellipseFit;
% rotation matrix to rotate the axes with respect to an angle phi
R = [ cos(ellipse_t.phi) sin(ellipse_t.phi); sin(ellipse_t.phi)*-1 cos(ellipse_t.phi) ];

% the axes
ver_line        = [ [ellipse_t.X0 ellipse_t.X0]; ellipse_t.Y0+ellipse_t.b*[-1 1] ];
horz_line       = [ ellipse_t.X0+ellipse_t.a*[-1 1]; [ellipse_t.Y0 ellipse_t.Y0] ];
new_ver_line    = R*ver_line;
new_horz_line   = R*horz_line;

% the ellipse
theta_r         = linspace(0,2*pi);
ellipse_x_r     = ellipse_t.X0 + ellipse_t.a*cos( theta_r );
ellipse_y_r     = ellipse_t.Y0 + ellipse_t.b*sin( theta_r );
rotated_ellipse = R * [ellipse_x_r;ellipse_y_r];

% draw
plot( new_ver_line(2,:),new_ver_line(1,:),'r' );
plot( new_horz_line(2,:),new_horz_line(1,:),'r' );
plot( rotated_ellipse(2,:),rotated_ellipse(1,:),'r' );
set(gca,'YTick',[])
set(gca,'XTick',[])

% plot boundaries
subaxis(3,2,3)
imagesc(anaRes.image);
colormap gray
axis image
hold on
plot(anaRes.outterBoundary(:,2),anaRes.outterBoundary(:,1),'g','LineWidth',2);
plot(anaRes.centroid(:,2),anaRes.centroid(:,1),'go');
plot(anaRes.innerBoundary(:,2),anaRes.innerBoundary(:,1),'b','LineWidth',2);
set(gca,'YTick',[])
xlabel('pixel')

% plot original image

subaxis(3,2,[2 4])
imagesc(imageL)
colormap gray
axis image
set(gca,'YTick',[])
set(gca,'XTick',[])
title('original image')


% plot data
subaxis(3,2,5)
plot(1:length(anaRes.longLum),bsxfun(@plus,anaRes.longLum(1,:),anaRes.longLum(5,:)),'Color',[.25 .25 .25])
hold on
plot(1:length(anaRes.longLum),bsxfun(@plus,anaRes.longLum(1,:),anaRes.longLum(6,:)),'Color',[.25 .25 .25])
plot(1:length(anaRes.longLum),anaRes.longLum(1,:),'k','LineWidth',2)
hold off
legend('95% uCI','95% lCI','median')
xlabel('pixel')
ylabel('median luminence [aU]')
%ylim([0 5000])


%plot luminence
subaxis(3,2,6)
imagesc(anaRes.searchAreas)
title(['head tail discrimination | pix-ratio: ' num2str(anaRes.pixRatio)])
colormap gray
axis image
hold on
plot([ size(anaRes.searchAreas,2)/2 size(anaRes.searchAreas,2)/2], [ 0 size(anaRes.searchAreas,1)],'g','LineWidth',2)
set(gca,'YTick',[])
set(gca,'XTick',[])
if anaRes.hctPos(1,2) > anaRes.hctPos(3,2)
    xlabel ('tail                  head')
else
    xlabel ('head                  tail')
end