function [fid, endianType,headerInfo,imgOut, IDX] = ivT_norpix_openSeq(fPos,readModus,sortModus)
% This function of the ivT norpix IO toolbox (ivT_norpix) updates the header
% info with the timestamp field.
%
% GETS:
%      fPos = a string containing the absolute position of the seq file
% readModus = 'onlyHeader' returns header information with an empty
%             timestamp field
%             'singleFrame' this only loads the header information and you 
%             load images via ivT_norpix_loadSingleImage , imgOut is than
%             [];
%             'all@once' loads all images into one mxnxp matrix see return
%             variables for more info.
%             'try' checks if it is possible to load all images memory
%             wise, if so it does this. Otherise only the header is loaded
% sortModus = 'sort' sorts frames according to their time stamps and
%              produces the IDX return variable
%
% RETURNS:
%       fid = file dialogue identification object as returned by 
%             ivT_norpix_openFileDialogue
%
%endianType = the bit format of SEQ files for more informat
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
%     imgOut = mxnxp matrix with the image data. m imageHeight,n
%              imageWidth, p number of frames | if readModus is set to try
%              or all@once
%
%       IDX =  the chornological succession of frames so that IDX(7) gives
%              you the index of the 7th image in chronological succession |
%              is sortModus is set to sort
%
% SYNTAX:[fid, endianType,headerInfo,imgOut, IDX] = ivT_norpix_openSeq(fPos,readModus,sortModus)
%
% Author: B. Geurten 29.11.15 based on a matlab scriptb ny Brett Shoelson,
% PhD availabl@ https://www.norpix.com/support/Norpix2MATLAB.m
%
% see also ivT_norpix_loadSingleImage, ivT_norpix_sortSeq,ivT_norpix_getFramesNSeq
%          ivT_norpix_getTimeStamps

% preallocate return variables
imgOut      = [];
IDX         = [];

% open file dialogue
[fid,endianType] = ivT_norpix_openFileDialogue(fPos);
% read out header
headerInfo = ivT_norpix_getHeader(fid,endianType);

% decide between the different image read modi
switch readModus
    case 'onlyHeader'
        headerInfo.timestamp = {};
        IDX =0:headerInfo.AllocatedFrames-1;
        % Load only header file and timestamps
    case 'singleFrame'
        headerInfo = ivT_norpix_getTimeStamps(fid,endianType,headerInfo);
        % sort if needed
        if strcmp(sortModus,'sort'),
            [headerInfo,IDX]=ivT_norpix_sortSeq(headerInfo);
        else
            IDX =0:headerInfo.AllocatedFrames-1;
        end
        % Load all images into one matrix
    case 'all@once'
        [headerInfo,imgOut]=ivT_norpix_getFramesNSeq(fid,endianType,headerInfo);
        % sort if needed
        if strcmp(sortModus,'sort'),
            [headerInfo,IDX,imgOut]=ivT_norpix_sortSeq(headerInfo,imgOut);
        else
            IDX =0:headerInfo.AllocatedFrames-1;
        end
        % try to load all at once
    case 'try'
        verdict = ivT_norpix_1loadPossible(headerInfo);
        if verdict == 1,
            [headerInfo,imgOut]=ivT_norpix_getFramesNSeq(fid,endianType,headerInfo);
            % sort if needed
            if strcmp(sortModus,'sort'),
                [headerInfo,IDX,imgOut]=ivT_norpix_sortSeq(headerInfo,imgOut);
            else
                IDX =0:headerInfo.AllocatedFrames-1;
            end
            % did not work out-> do it single framewise
        else
            % load only timestamps because the file is too big
            headerInfo = ivT_norpix_getTimeStamps(fid,endianType,headerInfo);
            % sort if needed
            if strcmp(sortModus,'sort'),
                [headerInfo,IDX]=ivT_norpix_sortSeq(headerInfo);
            else
                IDX =0:headerInfo.AllocatedFrames-1;
            end
        end
end