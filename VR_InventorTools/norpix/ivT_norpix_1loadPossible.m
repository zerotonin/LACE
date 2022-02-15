function verdict = ivT_norpix_1loadPossible(headerInfo)
% This function of the ivT norpix  IO toolbox (ivT_norpix) asesses if the
% movie can be loaded as whole into the machines memory. 
%
% GETS:
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
% RETURNS:
%   verdict = boolean if set to 1 the movie can be loaded directly into the
%             machines memory, if zero a image by image approach should be
%             taken. see Examples STEP B
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
% PhD availabl@ https://www.norpix.com/support/Norpix2MATLAB.m
%
% see also ivT_norpix_openFileDialogue

verdict = 1;

% PREALLOCATION
imSize = [headerInfo.ImageWidth,headerInfo.ImageHeight];
try,
    imgOut = zeros(imSize(2),imSize(1),headerInfo.AllocatedFrames);
catch
    verdict = 0;
    warning('ivT_norpix_1loadPossible:line7:the movie you try to load in one go is to large for the systems memory')
end