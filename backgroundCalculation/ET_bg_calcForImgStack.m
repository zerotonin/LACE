function [backGround,backGroundMax,backGroundMin] = ET_bg_calcForImgStack...
                              (fPos,IDX,modus,progBar) 
% This function of the Ethotrack background calculation toolbox (ET_bg_)
% calculates the background image as the mean, min or max over all frames,
% pixelwise. This version is set to work for norpix sequence files.
%
% GETS: fid = file dialogue identification object as returned by
%             ivT_norpix_openFileDialogue
%
%headerInfo = a truct containing the following fields:
%           Version: version of the file format
%        HeaderSize: size of the header should be 1024
%      Descripition: user discriptiom
%        ImageWidth: image width in pixel
%       ImageHeight: image height in pixel
%     ImageBitDepth: image depth in bits  8,16,24,32
% ImageBitDepthReal: precise image depth in bits
%    ImageSizeBytes: size used to store one image
%       ImageFormat: there is a long list of formats that norpix can use,
%                    see the "sequence format.pdf" in your norpix tools
%                    folder
%   AllocatedFrames: frames in the movie
%            Origin: position of first frame normally zero, when pre or
%                    post trigger is used this value changes accordingly
%     TrueImageSize: Number of bytes between the first pixel of each
%                    successive image
%         FrameRate: recording framerate
%         timestamp: is a cell array of so many entries as frames and holds two
%                    values per row, 1) date as a string 2) date as a Matlab
%                    number
%
%endianType = the bit format of SEQ files for more informat
%
%       IDX = the chornological succession of frames so that IDX(7) gives
%             you the index of the 7th image in chronological succession |
%             is sortModus is set to sort
%
%     modus = 'mean' = mean image | 'min' equals the minimal image | 'max'
%             the maximal projection
%
%   progBar = boolean if set to one a progress bar appears during
%             processing. In a test with 800 images with 1041x1448 pixels
%             it inceased the computation time from 12.86s to 15.39
%             (roughly 20%)
%  headSize = size of the header information, this can be altered in
%             troublepix and therefore was has to take into account 
%             different header sizes. If not set it is 1024
%
% RETURNS:
%    backGround = a mxn image matrix with the mean image of the
%                 images in fList
%
%
% SYNTAX: bg = ET_bg_calcByImageList(fList, progBar);
%
% Author: B.Geurten 11-29-2015
%
% see also imread, uint8, ET_bg_calcForVRobj

if ~exist('headSize','var'),
    headSize = 1024;
end

% read first image
ImageInfo = imfinfo(fPos{IDX(1)});
backGround = ET_SR_loadImage(fPos{IDX(1)});
backGround = double(backGround);
backGroundMax = backGround;
backGroundMin = backGround;


%activate progress bar
if progBar,
    waitBarH = waitbar(0,['calculating ' modus ' background...']);
end

frames2analyse = length(IDX);
% decide for progress bar
if progBar,
    % main loop
    for frameNumber =1:frames2analyse,
        frame = ET_SR_loadImage(fPos{IDX(frameNumber)});
        switch modus
            case 'mean'
                backGround= bsxfun(@plus,backGround,double(frame));
            case 'min'
                backGround=min(frame,backGround);
            case 'max'
                backGround=max(frame,backGround);
            case 'max-min'
                backGroundMax=max(frame,backGroundMax);
                backGroundMin=min(frame,backGroundMin);
        end
        % load an image and add it's value to the image value
        %update progress bar
        waitbar(frameNumber / frames2analyse)
    end
    % sound alarm
    s =wavread('smw_1-up.wav');
    sound(s,22000);
else
    % main loop
    for frameNumber =1:frames2analyse,
        frame =ET_SR_loadImage(fPos{IDX(frameNumber)});;
        switch modus
            case 'mean'
                backGround= bsxfun(@plus,backGround,double(frame));
            case 'min'
                backGround=min(frame,backGround);
            case 'max'
                backGround=max(frame,backGround);
            case 'max-min'
                backGroundMax=max(frame,backGroundMax);
                backGroundMin=min(frame,backGroundMin);
        end
        % load an image and add it's value to the image value
    end
end

% post hoc stuff
switch modus,
    case 'mean',
        backGround = backGround./frames2analyse;
    case 'max-min',
        backGround = bsxfun(@minus,backGroundMax,backGroundMin);
end

% set back to image encoding and devide by number of allocated frames
switch ImageInfo.BitDepth,
    case 8
        backGround=uint8(backGround);
    case 16
        backGround=uint16(backGround);
    case 32
        backGround=uint32(backGround);
    case 64
        backGround=uint64(backGround);
end




% try to close waitbar
if progBar,
    close(waitBarH)
end