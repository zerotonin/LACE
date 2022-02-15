function headerInfo = ivT_norpix_getTimeStamps(fid,endianType,headerInfo)
% This function of the ivT norpix IO toolbox (ivT_norpix) updates the header
% info with the timestamp field.
%
% GETS:
%       fid = file dialogue identification object as returned by 
%             ivT_norpix_openFileDialogue
%endianType = the bit format of SEQ files for more informat
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
%
%
% RETURNS:
% headerInfo = same struct as before now the field timestamp is added which
%              is a cell array of so many entries as frames and holds two
%              values per row, 1) date as a string 2) date as a Matlab
%              number
%
% SYNTAX:[headerInfo,imgOut] = ivT_norpix_getTimeStamps(fid,endianType,headerInfo);
%
% EXAMPLES:
% 1st Step: test if the movie can be loaded in one go  
% 
% [fid,endianType] = ivT_norpix_openFileDialogue(fPos);
% headerInfo = ivT_norpix_getHeader(fid,endianType);
% verdict = ivT_norpix_1loadPossible(headerInfo);
%
% If verdict is 1 you can load the whole movie in one go and should preceed 
% with STEP A. If verdict is zero perceed with STEP B. 
% 
% STEP A: load all at once, as sometimes pre and post trigger can mess up
% the succession of frames the movie has to be sorted posthoc;
%
% [headerInfo,imgOut]=ivT_norpix_getFramesNSeq(fid,endianType,headerInfo);
% [headerInfo,IDX,imgOut]=ivT_norpix_sortSeq(headerInfo,imgOut);
%
% STEP B: load an image at the time. Also here the image succession can be
% missalligned and has to be sorted. This has to be done before the images
% are loaded to load them in the correct successsion.
%
% [headerInfo,IDX]=ivT_norpix_sortSeq(headerInfo);
% for  i=1:headerInfo.AllocatedFrames, 
%       image = ivT_norpix_loadSingleImage(fid,headerInfo,endianType...
%                                                      ,IDX,frameNumber); 
%       %do imageStuff%; 
% end
%
% Author: B. Geurten 20.10.15 based on a matlab scriptb ny Brett Shoelson, 
% PhD availabl@ https://www.norpix.com/support/Norpix2MATLAB.m
%
% see also ivT_norpix_loadSingleImage, ivT_norpix_sortSeq,ivT_norpix_getFramesNSeq

if nargout > 1
    
    % PREALLOCATION
    imSize = [headerInfo.ImageWidth,headerInfo.ImageHeight];
    imgOut = zeros(imSize(2),imSize(1),headerInfo.AllocatedFrames);
end

%check bitdepth
bitstr = '';
switch headerInfo.ImageBitDepthReal
    case 8
        bitstr = 'uint8';
    case {12,14,16}
        bitstr = 'uint16';
end
if isempty(bitstr)
    error('Unsupported bit depth');
end

%now read in
for  nread=1:headerInfo.AllocatedFrames
    
    % The 12 bit sequence is little endian, aligned on 16 bit.
    % The header of the sequence is 1024 bytes long.
    % After that you have the first image that has
    %
    % 640 x 480 = 307200 bytes for the 8 bit sequence:
    % or
    % 640 x 480 x 2 = 614400 bytes for the 12 bit sequence:
    %
    % After each image there are timestampBytes bytes that contain timestamp information.
    %
    % This image size, together with the timestampBytes bytes for the timestamp, are then aligned on 512 bytes.
    %
    % So the beginning of the second image will be at
    % 1024 + (307200 + timestampBytes + 506) for the 8 bit
    % or
    % 1024 + (614400 + timestampBytes + 506) for the 12 bit
    
    % go through the file
    %fileID, jump the appropreiate number of images in relation to bof (beginning of file)
    fseek(fid, 1024 + nread * (headerInfo.TrueImageSize), 'bof');
   
    % get timing information
    tmp = fread(fid, 1, 'int32', endianType);
    tmp2 = fread(fid,2,'uint16', endianType);
    tmp = tmp/86400 + datenum(1970,1,1);
    try
    headerInfo.timestamp(nread,1:2) = {[datestr(tmp) '.' num2str(tmp2(1)),num2str(tmp2(2))], datenum([datestr(tmp) '.' num2str(tmp2(1)),num2str(tmp2(2))])};
    catch
        disp('boom')
    end
    
end

