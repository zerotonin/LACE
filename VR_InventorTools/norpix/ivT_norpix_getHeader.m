function headerInfo = ivT_norpix_getHeader(fid,endianType)
% This function of the ivT norpix  IO toolbox (ivT_norpix) loads the header
% information of a norpix sequence file. To do so a file dialogue has to be
% established with for example ivT_norpix_openFileDialogue. The header
% includes sereveral need information which are returned in a struct format
% and needed for further image processing steps, see Examples.
%
% GETS:
%       fid = file dialogue identification object as returned by 
%             ivT_norpix_openFileDialogue
%endianType = the bit format of SEQ files for more information on Endianness
%             see https://en.wikipedia.org/wiki/Endianness
%
% RETURNS:
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
% SYNTAX:  headerInfo = ivT_norpix_getHeader(fid,endianType);
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




% Read header

OFB = {28,1,'long'};
fseek(fid,OFB{1}, 'bof');
headerInfo.Version = fread(fid, OFB{2}, OFB{3}, endianType);
% headerInfo.Version

%
OFB = {32,4/4,'long'};
fseek(fid,OFB{1}, 'bof');
headerInfo.HeaderSize = fread(fid,OFB{2},OFB{3}, endianType);
% headerInfo.HeaderSize

%
OFB = {592,1,'long'};
fseek(fid,OFB{1}, 'bof');
DescriptionFormat = fread(fid,OFB{2},OFB{3}, endianType)';
OFB = {36,512,'ushort'};
fseek(fid,OFB{1}, 'bof');
headerInfo.Description = fread(fid,OFB{2},OFB{3}, endianType)';
if DescriptionFormat == 0 %#ok Unicode
    headerInfo.Description = native2unicode(headerInfo.Description);
elseif DescriptionFormat == 1 %#ok ASCII
    headerInfo.Description = char(headerInfo.Description);
end
% headerInfo.Description

%
OFB = {548,24,'uint32'};
fseek(fid,OFB{1}, 'bof');
tmp = fread(fid,OFB{2},OFB{3}, 0, endianType);
headerInfo.ImageWidth = tmp(1);
headerInfo.ImageHeight = tmp(2);
headerInfo.ImageBitDepth = tmp(3);
headerInfo.ImageBitDepthReal = tmp(4);
headerInfo.ImageSizeBytes = tmp(5);
vals = [0,100,101,200:100:900];
fmts = {'Unknown','Monochrome','Raw Bayer','BGR','Planar','RGB',...
    'BGRx', 'YUV422', 'UVY422', 'UVY411', 'UVY444'};
try,
headerInfo.ImageFormat = fmts{vals == tmp(6)};
catch
   headerInfo.ImageFormat = 'Monochrome';
end
    

%
OFB = {572,1,'ulong'};
fseek(fid,OFB{1}, 'bof');
headerInfo.AllocatedFrames = fread(fid,OFB{2},OFB{3}, endianType);
% headerInfo.AllocatedFrames

%
OFB = {576,1,'ulong'};
fseek(fid,OFB{1}, 'bof');
headerInfo.Origin = fread(fid,OFB{2},OFB{3}, endianType);
% headerInfo.Origin

%
OFB = {580,1,'ulong'};
fseek(fid,OFB{1}, 'bof');
headerInfo.TrueImageSize = fread(fid,OFB{2},OFB{3}, endianType);
% headerInfo.TrueImageSize

%
OFB = {584,1,'double'};
fseek(fid,OFB{1}, 'bof');
headerInfo.FrameRate = fread(fid,OFB{2},OFB{3}, endianType);
% headerInfo.FrameRate