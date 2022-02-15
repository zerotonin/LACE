function [headerInfo,IDX,imgSort]=ivT_norpix_sortSeq(headerInfo,imgOut)
% This function of the ivT norpix  IO toolbox (ivT_norpix)  this function
% checks if the succession of frames is chronological. When pre/post
% triggers were yused a movie can start at a norpix index larger than 0 in
% this case the IDX value returned by this routine gives you the correct
% index for your chronological xth frame. This function not only creates
% this search index but also sorts the timestamps in the headerInfo struct
% and can sort your movie matrix as returned from ivT_norpix_getFramesNSeq.
%
% Note the origin value is quite often false so we check the timestamps and
% sort them.
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
%     imgOut = mxnxp matrix with the image data. m imageHeight,n
%              imageWidth, p number of frames, optional do not have to be
%              set
%
%
% RETURNS:
% headerInfo = same struct as before now the field timestamp is sorted
%              chronological
%    imgSort = same matrix as before now the field timestamp is sorted
%              chronological, can only be expected if also an imgOut is set
%       IDX =  the chornological succession of frames so that IDX(7) gives
%              you the index of the 7th image in chronological succession
%
% SYNTAX:
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
% PhD availabl @ https://www.norpix.com/support/Norpix2MATLAB.m
%
% see also ivT_norpix_getFramesNSeq

% check if output arguments and input arguments are similar
if nargin<nargout-1,
    error('ivT_norpix_sortSeq:line1:not enough input arguments');
elseif nargin>nargout-1,
    error('ivT_norpix_sortSeq:line1:not enough output arguments');
end

% get timestamps
timeNum = cell2mat(headerInfo.timestamp(:,2));
% sort those
[~,IDX]=sort(timeNum);

% sort timestamps
if isfield(headerInfo,'timestamp'),
    headerInfo.timestamp =  headerInfo.timestamp(IDX,:);
end

% if images should be sorted do so
if nargin >1,
    imgSort = imgOut(:,:,IDX);
end