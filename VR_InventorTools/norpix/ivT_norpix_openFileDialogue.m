function [fid,endianType] = ivT_norpix_openFileDialogue(fPos)
% This function of the ivT norpix  IO toolbox (ivT_norpix) open a file
% dialogue to a norpix SEQ file. This is the needed first step to load data
% from such a file.
%
% GETS:
%      fPos = the absolute position of the file
%
%
% RETURNS:
%       fid = file dialogue identification object
%endianType = the bit format of SEQ files for more information on Endianness
%             see https://en.wikipedia.org/wiki/Endianness
%
% SYNTAX: [fid,endianType] = ivT_norpix_openFileDialogue(fPos);
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
% see also ivT_norpix_getHeader

fid = fopen(fPos,'r','b');
endianType = 'ieee-le';