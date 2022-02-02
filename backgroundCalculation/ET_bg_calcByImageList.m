function bg = ET_bg_calcByImageList(fList,progBar)
% This function of the Ethotrack background calculation toolbox (ET_bg_) 
% calculates the background image as the mean over all images in a list. 
% The list holds the absolute file positions of the images
%
% GETS:
%         fList = a string cell with the absolute file positions of the 
%                 images
%       progBar = boolean if set to one a progress bar appears during
%                 processing. In a test with 800 images with 1041x1448
%                 pixels it inceased the computation time from 12.86s to
%                 15.39 (roughly 20%)
%
% RETURNS:
%            bg = a mxn uint8 image matrix with the mean image of the
%                 images in fList
%
%
% SYNTAX: bg = ET_bg_calcByImageList(fList, progBar);
%
% Author: B.Geurten 09-25-2015
%
% see also imread, uint8

% read first image
image = double(imread(fList{1}));

%activate progress bar
if progBar,
    waitBarH = waitbar(0,'calculating mean background...');
end

%calculate list length
fLen = length(fList);

% decide for progress bar 
if progBar,    
    % main loop
    for i =2:fLen
        % load an image and add it's value to the image value
        image = bsxfun(@plus,image,double(imread(fList{i})));
        %update progress bar
        waitbar(i / fLen)
    end
else
    % main loop
    for i =2:fLen
        % load an image and add it's value to the image value
        image = bsxfun(@plus,image,double(imread(fList{i})));
    end
end

% devide by the number of images
image = image./length(fList);

%go back to old imageFormat
bg = uint8(image);

% try to close waitbar
if progBar,
    close(waitBarH)
end