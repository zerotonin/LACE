function anaRes =  FILA_ImageSpineAnalysis4Stacks(fPos,saveImage,plotFlag)
% This function from the fluorescent image larva analysis toolbox (FILA) 
% combines the whole oolbox functions and completely analysis 1 frame.
% Basically it detects the larvae arranges it horizontally takes the 
%
% GETS:
%           fPos = a cellarray of file Positions to the single frames of
%                  the stack
%      saveImage = boolean if one the cropped image will be saved in the
%                  returning struct
%
% RETURNS  
%         anaRes = a struct array containing the following fields
%
% outterboundary : a mx2 matrix with the m 2D positions of the boundary
%                  between the larva and the background, as produced by
%                  FILA_getLarvaPos 
%  innerboundary : a scaled down version of the outterboundary to ignore
%                  autofluourescence from the body wall
%       centroid : a 2 element column vetcor holding the 2D position of the
%                  centroid or center of gravity of the boundary
%                  (mean(boundary,1))
%         hctPos : a 3x2 vector where the columns contain the x and y
%                  position respectively. First row is the head position,
%                  2nd row contains the center of the ellipse and the last
%                  row contains the tail position.
%     ellipseFit : a fit struct containing all important information about
%                  the fitted ellipse as returned by fit_ellipse
%       pixRatio : a scalar 0->1 showing the difference of both pixel
%                  counts between the two search areas if it reaches more
%                  than 0.9 the detection mechanismn needs to be
%                  supervised.
%         spline : a mx2 matrix with the central line of the polygon
%    splineCurvV : a 2 value vector holding the signed and unsigned
%                  integral of the spine
%    splineEdges : a 8x2 matrix with the coordinates of the bin edges
%    splineLength: length of the shortend spline
%     gutCenters : mx2 matrix holding the coordinates of the gut
%                  center
%     gutBoudary : mx2 matrix with coordinates of the gut boundary 
%          image : a cropped and turned version of the orignial image, if
%                  saveImage was set to 1
%
% SYNTAX: anaRes =  FILA_fullImageAnalysis(image);
%
% Author: B. Geurten 22.01.2015
%
% see also FILA_getLarvaPos,  FILA_turnImage2LarvaOrient, FILA_getMouthPos
%          FILA_imcrop2boundary, FILA_scaleDownBoundary, FILA_getLongLum,
%          FILA_ana_getSpine, FILA_binSpline,FILA_ana_getGutPosition,
%          FILA_SR_normImage, FILA_ana_curvIntegral

% make figure and axis
if plotFlag ==1,
    figure(),clf
    axH = gca;
end

% loop through all frames of the stacks
for i =1:length(fPos),
    
    %read image
    image = imread(fPos{i});
    
    %analyse image
    temp =  FILA_ImageSpineAnalysis(image,1);
    
    % kill image if desired
    if saveImage ~=1,
        anaRes(i) = rmfield(temp,'image');
    end
    
    %plot images
    if plotFlag ==1,
        cla(axH)
        FILA_plot_spineAnalysis(temp,axH,['frame No ' num2str(i) ' of ' ...
            num2str(length(fPos)) ' | curveture: ' num2str(temp.splineCurvV)])
        drawnow
    end
end

anaRes = anaRes';