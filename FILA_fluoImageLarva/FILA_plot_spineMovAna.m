function FILA_plot_spineMovAna(anaRes,frame,fps,fPos,figProps,fH,tString)
%
%
% GETS
%         anaRes = a struct array containing the following fields
%
%     waveFinder : the combined and filtered mean of the long axis
%                  (elipsefit),eccentricity, spline length, length of the
%                  inner spline [aU]
% outterboundary : a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background, as produced by
%                  FILA_getLarvaPos  [pix]
%  innerboundary : a scaled down version of the outterboundary to ignore
%                  autofluourescence from the body wall [pix]
%       centroid : a 2 element column vetcor holding the 2D position of the
%                  centroid or center of gravity of the boundary [pix]
%                  (mean(boundary,1))
%         hctPos : a 3x2 vector where the columns contain the x and y
%                  position respectively. First row is the head position,
%                  2nd row contains the center of the ellipse and the last
%                  row contains the tail position. [pix]
%     ellipseFit : a fit struct containing all important information about
%                  the fitted ellipse as returned by fit_ellipse
%   eccentricity : 3 value vector, with the entries: eccentricity,length of
%                  the long axis (pixels) and length of the short axis
%                  (pixels)
%       pixRatio : a scalar 0->1 showing the difference of both pixel
%                  counts between the two search areas if it reaches more
%                  than 0.9 the detection mechanismn needs to be
%                  supervised.
%      pixRatioF : the filtered version of pixRatio
%         spline : a mx2 matrix with the central line of the polygon
%    splineCurvV : a 2 value vector holding the signed and unsigned
%                  integral of the spine [pix]
%    splineCurvF : the filtered and normalised version of splineCurveV
%                  after splineLength the following field was inserted
%    splineEdges : a 8x2 matrix with the coordinates of the bin edges [pix]
% splineInnerLen : the length of the spline inside the innerboundary, this
%                  gets rid of mouth and abdominal movement noise [mm]
%splineInnerLenF : the filtered version of splineInnerLen [mm]
%    splineLength: length of the shortend spline [mm]
%     splineLenF : the filtered version of splineLength [mm]
%     gutCenters : mx2 matrix holding the coordinates of the gut
%                  center [pix]
%     gutBoudary : mx2 matrix with coordinates of the gut boundary [pix]
%          image : a cropped and turned version of the orignial image
%                  optional!
%
% RETURNS
%
%
% SYNTAX: anaRes = FILA_ana_postAnalysis(anaRes);
%
% Author: B. Geurten Octobre 2015
%
% see also FILA_ImageSpineAnalysis,FILA_ana_postEcc,FILA_ana_postPixRatio,
%          FILA_ana_postSpline, FILA_ana_postInnerSpline

% get data from struct
anaMat = FILA_ana_struct2mat(anaRes);
% get regions of disinterest
turnSeq = FILA_ana_getROD(anaMat);

% Ylabels for the data plots
ylabels = {'waveFinder [au]','curveture [au]','eccentricity','inner length [mm]'};

% get the maximal values of the crop images
temp  = struct2cell(anaRes);
oB = cell2mat(temp(2,:)');
imExt = max(oB);
clear temp oB

% get the data subtypes
dataN = [1 5 6 3];
% define the axis on which this is plotted
subPlotN = 2:2:8;
% total length of the movie
frameN = size(anaMat,1);
% create x-Axis for data plots
xAx = linspace(0,frameN/fps,frameN);

% image operations 
image = imread(fPos{frame});
image = FILA_SR_normImage(image);
%find larva
[outterBoundary,~,thresh] = FILA_getLarvaPos(image,-1);
%rotate image
[imageRot,~] = FILA_turnImage2LarvaOrient(image,outterBoundary);
%find larva again
[outterBoundary,~,~] = FILA_getLarvaPos(imageRot,thresh);
%crop image
[cropImage,~] = FILA_imcrop2boundary(imageRot,outterBoundary);
%now add cropped image to the largest possible image 
bg = NaN(imExt(1),imExt(2));
bg(1:size(cropImage,1),1:size(cropImage,2)) = cropImage;

% create one struct that can be read by FILA_plot_spineAnalysis
temp = anaRes(frame);
temp.image = bg;

%clear figure
figure(fH),clf
% set figure to preset size
ivT_movie_setSize(fH,figProps)
% build subaxis system
subaxis(4,2,[1 3 5 7],'SpacingVert',0,'SpacingHoriz',0)
% plot the image and detection borders
FILA_plot_spineAnalysis(temp,gca,tString,'WestOutside')
% go through all subplots
for j =1:4,
    % set subaxis
    subaxis(4,2,subPlotN(j));
    
    % get extremes of the whole data set
    dataExt = [min(anaMat(:,dataN(j))) max(anaMat(:,dataN(j))) ];
    % get the RODs in this frame
    IDXt = turnSeq<=frame;
    IDXt = turnSeq(IDXt);
    if ~isempty(IDXt),
        %make sequence of the temporary IDX
        temp = zeros(frameN,1);
        temp(IDXt) =1;
        ind_diff   = diff(temp);
        ind_diff   = find(ind_diff);
        
        if temp(1) == 1,
            ind_diff=[1;ind_diff];
        end
        if temp(end) == 1,
            ind_diff=[ind_diff; length(temp)];
        end
       starts = ind_diff(1:2:end);
       stops = ind_diff(2:2:end);
       %find starts and stops of the RODS
       %draw a grey rectangle for every ROD
       hold on
       for k=1:length(starts)
           patch(xAx([starts(k) stops(k) stops(k) starts(k)]),[dataExt(1) dataExt(1) dataExt(2) dataExt(2)],[.75 .75 .75])
       end
       hold off
    end
       
       
    % plot data
    hold on
    plot(xAx(1:frame),anaMat(1:frame,dataN(j)),'Color',paletteKeiIto(j),'LineWidth',2)
    hold off
    
    % set axis tick labels etc accordingly
    xlim( xAx([1 end]))
    ylim(dataExt)
    ylabel(ylabels{j})
    % jump every second y-axis to the right
    if mod(j,2) == 0
        set(gca,'YAxisLocation','right')
    end
    % kill all x tick labels except the last
    if j <4
        set(gca,'XTickLabel',[])
    end
end
xlabel('time [s]')
tightfig;
drawnow;


