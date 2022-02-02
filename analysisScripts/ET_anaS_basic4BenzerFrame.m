function traceResult = ET_anaS_basic4BenzerFrame(fPos,IDX,frameNumber,angleCorrection,backGround,bgSubModus,contrastThresh,eroderR,...
ellipseParams,bestEllipsesN,prevDetection,expetedLength,expetedSize,voteWeights,...
expectedAnimals,multiDetectionPossible,maskIDX,useConFilter,distortParams)
% This function of the Ethotrack detection analysis script toolbox 
% (ET_anaS_) is a simple script to analyse single frames loaded from a
% norpix sequence file. The image is afterwards put through the following
% steps:
% STEP  1: load file from norpix sequence
% STEP  2: calculate difference to background
% STEP  3: rotate if need be
% STEP  4: binarise difference image
% STEP  5: erode difference image
% STEP  6: detect contours of objects
% STEP  7: split large image into small contour images 
% STEP  8: fit ellipses to contours in smaller images 
% STEP  9: recalculate original coordinates of contours 
% STEP 10: evaluate fits by surface area, contour length and consitency to 
%          previous detections
% STEP 11: test if the number of found animals is correct
% STEP 12: if STEP 11 is negative try to autocorrect
% 
% This can be easily employed in a for loop, look at examples!
%
% GETS:
%           fid = file dialogue identification object as returned by 
%                 ivT_norpix_openFileDialogue
%    headerInfo = a truct containing the following fields:
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
%    endianType = the bit format of SEQ files for more information on 
%                 Endianness see https://en.wikipedia.org/wiki/Endianness
%           IDX = the chornological succession of frames see ivT_norpix_sortSeq
%   frameNumber = the number of the frame that you want to load
%         angle = turning angle in degree
%            bg = a mxn uint8 background image (as derived from the ET_bg
%                 toolbox)
%         modus = string flag variable. 'absolute': difference of both
%                 images (brighter and darker); 'image-bg': everything
%                 brighter in the image is kept; 'bg-image': everything
%                 darker than in the image is kept
%contrastThresh = contrast threshold for binarisation between 0 and 1
%       eroderR = erosion radius in pixels
%        params = a structure containing fields with different constrains
%                 for the Hough transform fitting, fields are given below:
%   minMajorAxis: Minimal length of major axis accepted.
%   maxMajorAxis: Maximal length of major axis accepted.
%   rotation, rotationSpan: Specification of restriction on the angle of 
%                 the major axis in degrees. If rotationSpan is in (0,90), 
%                 only angles within [rotation-rotationSpan,rotation+
%                 rotationSpan] are accepted.
% minAspectRatio: Minimal aspect ratio of an ellipse (in (0,1))
%      randomize: Subsampling of all possible point pairs. Instead of 
%                 examining all N*N pairs, runs only on N*randomize pairs. 
%                 If 0, randomization is turned off.
%        numBest: Top numBest to return
% uniformWeights: Used to prefer some points over others. If false, 
%                 accumulator points are weighted by their grey intensity 
%                 in the image. If true, the input image is regarded as 
%                 binary.
%   smoothStddev: In order to provide more stability of the solution, the 
%                 accumulator is convolved with a gaussian kernel. This 
%                 parameter specifies its standard deviation in pixels.
% bestEllipsesN = best ellipsesN is the number of best fits you want to
%                 have returned
% prevDetection = a mx2 matrix with the previous detected fly positions in
%                 pixels for the whole imageound an animal at a
%                 similar position in the last frame. If left empty the
%                 result of this evaluation is set to 1.
%expectedLength = the length one animal should have if set to NaN the 
%                 median length of all contours is used
%  expectedSize = the size one animal should have if set to NaN the mean
%                 size of the ellipses is used
%   voteWeights = a four element vector holding the relative weights for
%                 the different test. (1) surface area test (2) contour 
%                 length test (3) previous position test (4) fit quality of
%                 the ellipse
%expectedAnimals= number of animals that should be visible in the footage
% multiDetectionPossible = boolean 1 if animals can be close together
%    headSize = size of the header information, this can be altered in
%               troublepix and therefore was has to take into account 
%               different header sizes. If not set it is 1024
%
% RETURNS:
%   traceResult = a mx13 result where m is the number of found animals,
%                 columns are defined as follows:
%                 col  1: x-position in pixel
%                 col  2: y-position in pixel
%                 col  3: major axis length of the fitted ellipse
%                 col  4: minor axis length of the fitted ellipse
%                 col  5: ellipse angle in degree
%                 col  6: quality of the fit
%                 col  7: number of animals believed in their after final
%                         evaluation
%                 col  8: number of animals in the ellipse according to
%                         surface area
%                 col  9: number of animals in the ellipse according to
%                         contour length
%                 col 10: is the animal close to an animal previously traced 
%                         (1 == yes)
%                 col 11: evaluation weighted mean
%                 col 12: detection quality [aU] if
%                 col 13: correction index, 1 if the area had to be
%                         corrected automatically
%
% SYNTAX: traceResult = ET_anaS_basic4singleFrame(fid,headerInfo,endianType,...
% IDX,frameNumber,angleCorrection,backGround,bgSubModus,contrastThresh,eroderR,...
% ellipseParams,bestEllipsesN,prevDetection,expetedLength,expetedSize,voteWeights,...
% expectedAnimals);
%
% Author: B. Geurten 11-29-15
%
% NOTE: this can be used for single frame loads of norpix sequences!
%
% EXAMPLE: Backlit Benzer with norpix seq file
% 
% readModus = 'onlyHeader'; % set read modus to only header
% sortModus = '';
% % open file dialogue
% [fid, endianType,headerInfo,~, IDX] = ivT_norpix_openSeq(fPos,readModus,sortModus);
% % read in background
% bgMax = ET_bg_calcForNorPixSeq(fid,headerInfo,endianType,IDX,'max',1);
% 
% % declare input variables
% backGround = double(bgMax); %make double out of background
% bgSubModus = 'bg-image'; % define background substraction direction
% contrastThresh =0.15; % define contrast threshold
% angleCorrection = -180; % turn image if nescessary
% eroderR = 1; % erosion radius on binarised image
% ellipseParams.minMajorAxis = 10; %ellipse parameter minimal major axis length
% ellipseParams.maxMajorAxis = 60; %ellipse parameter maximal major axis length
% ellipseParams.minAspectRatio = 0.2;%ellipse parameter minimal aspect ratio  
% ellipse.maxAspectRatio = 0.4; %ellipse parameter maximal aspect ratio  
% bestEllipsesN =10; % how many fits should be used!
% % evaluation routines
% prevDetection =[]; % for the first run there is no prev Detection
% expetedLength = NaN; % expected length defined as the mean of all found animals
% expetedSize = NaN; % expected size defined as the mean of all found animals
% voteWeights = [.5 .5 1 1]; % length and size are half (1,2) as important as
%                            % previous position (3), the quality (4)value is
%                            % as measured
% expectedAnimals = 15; % apriori knowledge about the number of animals in
%                       % footage


%read in data
 
frame = ET_SR_loadImage(fPos{IDX(frameNumber)});
% get difference image
diffImage = ET_im_diffImage(frame,backGround,bgSubModus);
% normalise differece image
diffImage = ET_im_normImage(diffImage);
% rotate image
diffImage = ET_im_rotate(diffImage,angleCorrection);
%
if sum(cell2mat(struct2cell(distortParams))) ~= 0,
    diffImage = ET_im_undistort(diffImage, distortParams);
end
% binarise image
imageBin = diffImage > contrastThresh;
% use ROI
if ~isempty(maskIDX),
    imageBin(maskIDX) = false;
end
% erode bin image
imageBin = ET_im_erode(imageBin,eroderR);
% detect object contours
objectContours = ET_HTD_detectObjectContours(imageBin);
%discard objects that are in fact lines
objectContours = ET_HTD_checkSpiltImageSize(objectContours);

if isempty(objectContours),
    % the detectioned failed return empty array
    traceResult = {[zeros(1,12) -1],...
        [],[], [] , [], []};
else
    % split image into n images of, where n is the number of objects found
    [~,splitterMin,splitterImagesC] = ET_HTD_splitImage2ellipseImages(imageBin,objectContours);
    % try to fit all objects with contours
    ellipseFits = ET_HTD_detectEllipses(splitterImagesC,ellipseParams,bestEllipsesN);
    % change ellipse coordinates from splitimages to complete image
    ellipseFits = ET_HTD_splitCoords2ImageCoords(ellipseFits,splitterMin);
    %evaluate ellipses
    [evaluation,animalNumber] = ET_eva_ellipseTests(ellipseFits,objectContours,...
        prevDetection,expetedLength,expetedSize,voteWeights);
    
    % check if the detection worked
    if max(animalNumber) == 1 && sum(animalNumber) == expectedAnimals,
        
        % assemble return variable
        logIDX = animalNumber == 1;
        % get central line and head position
        [hP,tP, bodyLine, contourLine] = ET_phA_findFlyHead(frame,angleCorrection,...
            splitterMin(logIDX),splitterImagesC(logIDX),...
            objectContours(logIDX),useConFilter);
        
        
        traceResult = cell2mat(cellfun(@(x) x(1,:),ellipseFits(logIDX),'UniformOutput',false));
        % corr IDX is zeros
        traceResult = {[traceResult  animalNumber(logIDX) evaluation(logIDX,[1:4 6]) zeros(size(traceResult,1),1)],...
            objectContours(logIDX), bodyLine, contourLine, hP, tP};
    else
        %%%%%%%%%%%%%%%%%%%
        % AUTO CORRECTION %
        %%%%%%%%%%%%%%%%%%%
        
        % classify problem
        [problemCase,animalNumber] = ET_ac_classifyProblem(animalNumber,expectedAnimals,multiDetectionPossible);
        
        % solve problem
        [corrIDX,evaluation,animalNumber,problemSolved] = ET_ac_solveStandardProblems(evaluation,problemCase,animalNumber,...
            expectedAnimals,multiDetectionPossible);
        % return stuff
        if problemSolved ==1,
            % assemble return variable
            logIDX = animalNumber == 1;
            % get central line and head position
            [hP,tP, bodyLine, contourLine] = ET_phA_findFlyHead(frame,angleCorrection,...
                splitterMin(logIDX),splitterImagesC(logIDX),...
                objectContours(logIDX));
            
            
            
            
            traceResult = cell2mat(cellfun(@(x) x(1,:),ellipseFits(logIDX),'UniformOutput',false));
            % corr IDX is updated with problem case numbers
            traceResult = {[traceResult animalNumber(logIDX) evaluation(logIDX,[1:4 6]) corrIDX(logIDX)],...
                objectContours(logIDX) ,bodyLine, contourLine, hP,tP};
        else
            % assemble return variable
            logIDX = animalNumber == 1;
            % get central line and head position
            [hP,tP, bodyLine, contourLine] = ET_phA_findFlyHead(frame,angleCorrection,...
                splitterMin(logIDX),splitterImagesC(logIDX),...
                objectContours(logIDX));
            
            
            traceResult = cell2mat(cellfun(@(x) x(1,:),ellipseFits(logIDX),'UniformOutput',false));
            % corr IDX is set to -1 for FAIL
            traceResult = {[traceResult animalNumber(logIDX) evaluation(logIDX,[1:4 6]) ones(size(traceResult,1),1).*-1],...
                objectContours(logIDX),bodyLine, contourLine , hP, tP};
            warning(['ET_anaS_basic4singleFrame:Unsolved detection problem @ frame ' num2str(frameNumber)])
        end
        
    end
end