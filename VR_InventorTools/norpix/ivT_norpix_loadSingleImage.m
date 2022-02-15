function image = ivT_norpix_loadSingleImage(fid,headerInfo,endianType,IDX,frameNumber,headSize)
% This function of the ivT norpix  IO toolbox (ivT_norpix) loads a single
% image  matrix (image). headerInfo will be updated with
% the timestamp field at the position of the frameNumber.
%
% GETS:
%       fid = file dialogue identification object as returned by 
%             ivT_norpix_openFileDialogue
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
%                    post trigger is used this value changes accordingly.
%     TrueImageSize: Number of bytes between the first pixel of each
%                    successive image
%         FrameRate: recording framerate
%endianType = the bit format of SEQ files for more information on Endianness
%             see https://en.wikipedia.org/wiki/Endianness
%       IDX =  the chornological succession of frames see ivT_norpix_sortSeq
% frameNumber = the number of the frame that you want to load
%    headSize = size of the header information, this can be altered in
%               troublepix and therefore was has to take into account 
%               different header sizes. If not set it is 1024
%
% RETURNS:
%      image = mxn matrix with the image data. m imageHeight,n
%              imageWidth
%
% SYNTAX: image =ivT_norpix_loadSingleImage(fid,headerInfo,endianType,IDX,frameNumber);
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
% see also ivT_norpix_sortSeq, ivT_norpix_getFramesNSeq

if ~exist('headSize','var')
    headSize = 1024;
elseif isempty(headSize),
    
    headSize = 1024;
end

imSize = [headerInfo.ImageWidth,headerInfo.ImageHeight];

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


% go through the file
%fileID, jump the appropreiate number of images* in relation to bof (beginning of file)
%*as sometimes with pre and post triggers the frame count might look like
%this  7 8 9 10 1 2 3 4 5 6 7 8, the frame number is first shifted to its
%wright position;
fseek(fid, headSize + IDX(frameNumber) * headerInfo.TrueImageSize, 'bof');
tmp = fread(fid, headerInfo.ImageWidth * headerInfo.ImageHeight, bitstr, endianType);
image = permute(reshape(tmp,imSize(1),imSize(2),[]),[2,1,3]);



