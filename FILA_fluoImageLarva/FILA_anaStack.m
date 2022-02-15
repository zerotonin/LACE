function data = FILA_anaStack(filePos,ana_mode,scale)
% This function from the fluorescent image larva analysis toolbox (FILA)
% combines the whole toolbox functions and completely analysis a stack of images
% Basically it detects the larvae arranges it horizontally takes the
% boundary of the larva and calculates a the statistical values along the
% vertical axis inside the boundry
%
% GETS:
%        filePos = position of the file stack
%       ana_mode = analysis mode as string variable: 'light' makes the
%                  algorithmn run only the essentials and saves a reduced
%                  data file containig the ellipseFit, hctPos, pixRatio
%                  and longLum. 'full_none' same as 'light' but with the
%                  full number of struct fields. 'full_plot' same as full
%                  but plots a figure for each step. 'full_save' saves the
%                  plots in the current directory
%          scale = either a scalar <=1 which is applied to all directions
%                  or a two-element vector where each scalar as used for
%                  another dimension.%
%
% RETURNS
%         anaRes = a struct array containing the following fields
%          image : a cropped and turned version of the orignial image
%        longLum : 6xn matrix where n is the width of the image and the rows
%                  are as follows: 1) median 2) mean 3) variance 4)
%                  standard deviation 5) upper confidence interval 6)
%                  lower CI
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
%    searchAreas : image snippet on the caudal  and rostral extremes of the
%                  animal, which was used to find the mouth and abdomen of
%                  the animal.
%
% SYNTAX: anaRes =  data = FILA_anaStack(filePos,ana_mode,scale);
%
% Author: B. Geurten 23.01.2015
%
% see also FILA_getLarvaPos,  FILA_turnImage2LarvaOrient, FILA_getLarvaPos,
%          FILA_imcrop2boundary, FILA_scaleDownBoundary, FILA_getLongLum,
%          FILA_getMouthPos


% get stack information
stackInfo = imfinfo(filePos);

switch ana_mode,
    % full analysis without plotting
    case 'full_none',
        % variable preallocation
        data = struct('image',[],'outterBoundary',[],'centroid',[],...
            'innerBoundary',[],'ellipseFit',[],'hctPos',[],'pixRatio', [], ...
            'searchAreas',[],'longLum',[]);
        data = repmat(data,length(stackInfo),1);
        %load ana save
        for imageI =1: length(stackInfo),
            imageL = imread(filePos,imageI);
            data(imageI) =  FILA_fullImageAnalysis(imageL,scale);
        end
        %full analysis with plot
    case 'full_plot',
        h = figure();
        % variable preallocation
        data = struct('image',[],'outterBoundary',[],'centroid',[],...
            'innerBoundary',[],'ellipseFit',[],'hctPos',[],'pixRatio', [], ...
            'searchAreas',[],'longLum',[]);
        data = repmat(data,length(stackInfo),1);
        %load ana plot
        for imageI =1: length(stackInfo),
            imageL = imread(filePos,imageI);
            data(imageI) =  FILA_fullImageAnalysis(imageL,scale);
            figure(h),clf
            FILA_plot_fullAna(h,imageL,data(imageI))
        end
        %full analysis with plot
    case 'full_save',
        h = figure();
        % variable preallocation
        data = struct('image',[],'outterBoundary',[],'centroid',[],...
            'innerBoundary',[],'ellipseFit',[],'hctPos',[],'pixRatio', [], ...
            'searchAreas',[],'longLum',[]);
        data = repmat(data,length(stackInfo),1);
        %load ana plot save
        for imageI =1: length(stackInfo),
            imageL = imread(filePos,imageI);
            data(imageI) =  FILA_fullImageAnalysis(imageL,scale);
            figure(h),clf
            FILA_plot_fullAna(h,imageL,data(imageI))
            saveas(h,['./frame_' num2strleadingZero(imageI,5) '.jpg']);
        end
        %light analysis
    case 'light'
        % variable preallocation
        data = struct('ellipseFit',[],'hctPos',[],'pixRatio', [], 'longLum',[]);
        stackLen = length(stackInfo);
        data = repmat(data,stackLen,1);
        for imageI =1: stackLen,
            if rem(imageI,10) ==0,
                disp([' anaylsed: ' num2str(imageI) ' of ' num2str(stackLen) ' images'])
            end
            %load ana light
            imageL = imread(filePos,imageI);
            data(imageI) =  FILA_lightImageAnalysis(imageL,scale);
        end
    otherwise
        error('FILA_anaStack:Unknown analysis mode!')
end



end
% anaRes.searchAreas =[lSA,rSA];
% anaRes.longLum=longLum;