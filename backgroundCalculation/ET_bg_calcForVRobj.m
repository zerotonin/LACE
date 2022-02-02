function [backGround,IDX,backGroundMax,backGroundMin] = ET_bg_calcForVRobj(movObj,IDX,modus,progBar)
% This function of the Ethotrack background calculation toolbox (ET_bg_)
% calculates the background image as the mean, min or max over all frames,
% pixelwise. This version is set to work for VideoReader objects.
%
% GETS:
%    movObj = the bit format of SEQ files for more informat
%       IDX = the chornological succession of frames so that IDX(7) gives
%             you the index of the 7th image in chronological succession |
%             is sortModus is set to sort f
%     modus = 'mean' = mean image | 'min' equals the minimal image | 'max'
%             the maximal projection
%   progBar = boolean if set to one a progress bar appears during
%             processing. In a test with 800 images with 1041x1448 pixels
%             it inceased the computation time from 12.86s to 15.39
%             (roughly 20%)
%
% RETURNS:
%    backGround = a mxn image matrix with the mean image of the
%                 images in fList
%    movObj = the bit format of SEQ files for more informat,m if not all
%             frames could be rate an updated version is returned
%
%
% SYNTAX: bg = ET_bg_calcForVRobj(fList, progBar);
%
% Author: B.Geurten 11-29-2015
%
% see also imread, uint8, VideoReader, ET_bg_calcForNorPixSeq

% read first image
backGround = ET_SR_rgb2gray(read(movObj,IDX(1)));

backGround = double(backGround);
backGroundMin = backGround;
backGroundMax = backGround;
%activate progress bar
if progBar,
    waitBarH = waitbar(0,['calculating ' modus ' background...']);
end
breakFlag = 0;
% decide for progress bar
if progBar,
    % main loop
    for frameNumber =1:length(IDX),
        try
            frame = double(ET_SR_rgb2gray(read(movObj,IDX(frameNumber))));
            
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
            waitbar(frameNumber / movObj.NumberOfFrames)
        catch
            warning(['The following movie ' movObj.Name ' could not be read completely we stopped at frame: ' num2str(frameNumber) ' the movObj was truncted at: ' num2str(frameNumber-1)])
            IDX=IDX(1:frameNumber-1);
            breakFlag =1;
        end
        if breakFlag ==1,
            break
        end
    end
    % sound alarm
    s =audioread('smw_1-up.wav');
    sound(s,22000);
else
    % main loop
    for frameNumber =1:length(IDX)
        try,
            frame = double(ET_SR_rgb2gray(read(movObj,IDX(frameNumber))));
            switch modus
                case 'mean'
                    backGround=bsxfun(@plus,backGround,double(frame));
                case 'min'
                    backGround=min(frame,backGround);
                case 'max'
                    backGround=max(frame,backGround);
                case 'max-min'
                    backGroundMax=max(frame,backGroundMax);
                    backGroundMin=min(frame,backGroundMin);
            end
            % load an image and add it's value to the image value
        catch
            warning(['The following movie ' movObj.Name ' could not be read completely we stopped at frame: ' num2str(frameNumber) ' the movObj was truncted at: ' num2str(frameNumber-1)])
            IDX=IDX(1:frameNumber-1);
            breakFlag =1;
        end
        if breakFlag ==1,
            break
        end
    end
end


switch modus
    case 'mean'
        backGround=backGround./headerInfo.AllocatedFrames;
    case 'max-min'
        backGround = ET_im_normImage(bsxfun(@minus,backGroundMax,backGroundMin));
        
end

% set back to image encoding and devide by number of allocated frames
switch movObj.BitsPerPixel,
    case 8
        backGround=uint8(backGround);
    case 16
        backGround=uint16(backGround);
    case 32
        backGround=uint32(backGround);
    case 64
        backGround=uint64(backGround);
    otherwise
        backGround=uint8(backGround);
end




% try to close waitbar
if progBar,
    close(waitBarH)
end